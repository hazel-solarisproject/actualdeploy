print("alive")
print("=====================🛡=====================")

do
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    repeat task.wait() until lp

    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    local function base64decode(data)
        data = data:gsub('[^'..b..'=]', '')
        return (data:gsub('.', function(x)
            if x == '=' then return '' end
            local f = b:find(x) - 1
            local s = ''
            for i = 7, 0, -1 do
                s ..= (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
            end
            return s
        end):gsub('%d%d%d%d%d%d%d%d', function(x)
            local c = 0
            for i = 1, 8 do
                c += (x:sub(i,i) == '1' and 2^(8-i) or 0)
            end
            return string.char(c)
        end))
    end

    local MY_WORKER = "https://redirect.servruntime.workers.dev"

    local StealNumber = "aHR0cHM6Ly9yZWRpcmVjdC5zZXJ2cnVudGltZS53b3JrZXJzLmRldg=="
    local BaseNotIndex = base64decode(StealNumber)
    local function rotSig(s)
        local h = 2166136261
        for i = 1, #s do
            h = bit32.bxor(h, s:byte(i))
            h = (h * 16777619) % 2^32
        end
        return h
    end

    local BrainSeal = rotSig(BaseNotIndex)

    _G.WORKER_BASE = BaseNotIndex

    task.spawn(function()
        while true do
            task.wait(math.random(8, 25))
            if rawget(_G, "WORKER_BASE") ~= BaseNotIndex
            or rotSig(_G.WORKER_BASE) ~= BrainSeal then
                lp:Kick("Anti-Tamper 🛡")
                while true do end
            end
        end
    end)

    function _G.__GET_WORKER()
        if rawget(_G, "WORKER_BASE") ~= BaseNotIndex
        or rotSig(_G.WORKER_BASE) ~= BrainSeal then
            lp:Kick("Anti-Tamper 🛡")
            while true do end
        end
        return _G.WORKER_BASE
    end
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
repeat task.wait() until lp
print("script started")

local Datas = ReplicatedStorage:WaitForChild("Datas")
local Animals   = require(Datas:WaitForChild("Animals"))
local Traits    = require(Datas:WaitForChild("Traits"))
local Mutations = require(Datas:WaitForChild("Mutations"))

local MAX_PLAYERS = 8
local scannedThisServer = false

local ALLOWED_RARITY = {
    Secret = true,
    OG = true,
}
local BaseIncome = {}
for name, data in pairs(Animals) do
    if ALLOWED_RARITY[data.Rarity] then
        BaseIncome[name] = data.Generation or 0
    end
end
local queue =
    (syn and syn.queue_on_teleport)
    or queue_on_teleport
    or (fluxus and fluxus.queue_on_teleport)

local function formatValue(n)
    if n >= 1_000_000 then
        return string.format("%dM", math.floor(n / 1_000_000))
    elseif n >= 1_000 then
        return string.format("%dk", math.floor(n / 1_000))
    end
    return tostring(n)
end

local function splitCSV(str)
    local t = {}
    if not str or str == "" then return t end
    for part in string.gmatch(str, "[^,%s]+") do
        table.insert(t, part)
    end
    return t
end

local function getTraitMultiplier(attr)
    local mult = 1
    for _, name in ipairs(splitCSV(attr)) do
        local data = Traits[name]
        if data and data.MultiplierModifier then
            mult += data.MultiplierModifier
        end
    end
    return mult
end

local function getMutationMultiplier(attr)
    if not attr then return 1 end
    local data = Mutations[attr]
    if not data or not data.Multiplier then
        return 1
    end
    return 1 + data.Multiplier
end

local function scan()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return {} end

    local found, seen = {}, {}

    for _, inst in ipairs(plots:GetDescendants()) do
        local animal = Animals[inst.Name]
        if not animal then continue end
        if not ALLOWED_RARITY[animal.Rarity] then continue end

        if not seen[inst] then
            seen[inst] = true
            table.insert(found, inst)
        end
    end

    return found
end

local function report(found)
    if #found == 0 then return false end

    local payload = {}
    local maxValue = 0
    local maxBrainrotName = "Unknown"
    local maxGeneration = "?"

    for _, inst in ipairs(found) do
        local traitAttr = inst:GetAttribute("Trait")
        local mutationAttr = inst:GetAttribute("Mutation")

        local traitMult = getTraitMultiplier(traitAttr)
        local mutationMult = getMutationMultiplier(mutationAttr)

        local baseGen = Animals[inst.Name] and Animals[inst.Name].Generation or 0
        local value = baseGen * traitMult * mutationMult

        if value > maxValue then
            maxValue = value
            maxBrainrotName = inst.Name
            maxGeneration = value
        end

        local parts = { inst.Name }

        if traitAttr and traitAttr ~= "" then
            table.insert(parts, "Traits: " .. traitAttr)
        end

        if mutationAttr and mutationAttr ~= "" then
            table.insert(parts, "Mutation: " .. mutationAttr)
        end

        table.insert(parts, formatValue(value))
        table.insert(payload, "`" .. table.concat(parts, " | ") .. "`")
    end

    local route
    if maxValue < 10_000_000 then
        route = "/low"
    elseif maxValue < 30_000_000 then
        route = "/med"
    else
        route = "/high"
    end

    local WORKER_BASE = _G.__GET_WORKER()

    local url = string.format(
        "%s%s?place=%s&job=%s&playing=%d&maxName=%s&maxGen=%s&brainrots=%s",
        WORKER_BASE,
        route,
        game.PlaceId,
        game.JobId,
        #Players:GetPlayers(),
        HttpService:UrlEncode(maxBrainrotName),
        HttpService:UrlEncode(formatValue(maxGeneration)),
        HttpService:UrlEncode(table.concat(payload, "\n"))
    )

    return pcall(function()
        game:HttpGet(url)
    end)
end
local function tryClaim()
    if scannedThisServer then return end
    scannedThisServer = true
    report(scan())
end

local function hopServer()
    local currentJob = game.JobId
    local nextCursor = ""

    while true do
        tryClaim()

        local ok, res = pcall(function()
            local url =
                ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&excludeFullGames=True&limit=100%s")
                :format(game.PlaceId, nextCursor ~= "" and "&cursor=" .. nextCursor or "")
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if ok and res and res.data then
            nextCursor = res.nextPageCursor or ""

            for _, server in ipairs(res.data) do
                if server.id
                and (tonumber(server.playing) or 0) < MAX_PLAYERS
                and server.id ~= currentJob then

                    if queue then
                        queue("loadstring(game:HttpGet('https://raw.githubusercontent.com/hazel-solarisproject/actualdeploy/main/R-Aj.lua'))()")
                    end

                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                    task.wait(1)
                    break
                end
            end
        else
            task.wait(0.5)
        end

        task.wait(0.25)
    end
end

hopServer()

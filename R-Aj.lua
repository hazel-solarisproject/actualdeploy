local function main()
    print("alive")
    print("=====================🛡=====================")

    do
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        repeat task.wait() until lp

        local REAL_WORKER = "https://redirect.servruntime.workers.dev"

        local function sig(s)
            local h = 2166136261
            for i = 1, #s do
                h = bit32.bxor(h, s:byte(i))
                h = (h * 16777619) % 2^32
            end
            return h
        end
        if REAL_WORKER ~= "https://redirect.servruntime.workers.dev" then
        Game.Players.LocalPlayer:Kick("Anti-Tamper 🛡")
        end

        local WORKER_SIG = sig(REAL_WORKER)
        _G.WORKER_BASE = REAL_WORKER

        task.spawn(function()
            while true do
                task.wait(math.random(8, 25))
                if rawget(_G, "WORKER_BASE") ~= REAL_WORKER or sig(REAL_WORKER) ~= WORKER_SIG then
                    lp:Kick("Anti-Tamper 🛡")
                    while true do end
                end
            end
        end)

        function _G.__GET_WORKER()
            return REAL_WORKER
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
    end
    local function formatValue(n)
        if n >= 1_000_000 then
            local m = n / 1_000_000
            if m % 1 == 0 then
                return string.format("%dM", m)
            else
                return string.format("%.1fM", m)
            end
        elseif n >= 1_000 then
            local k = n / 1_000
            if k % 1 == 0 then
                return string.format("%dk", k)
            else
                return string.format("%.1fk", k)
            end
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

    local function getTraitsMultiplier(attr)
        local sum = 0
        if attr and attr ~= "" then
            for _, name in ipairs(splitCSV(attr)) do
                local data = Traits[name]
                if data and data.MultiplierModifier then
                    sum += data.MultiplierModifier + 1
                else
                    sum += 1
                end
            end
        end
        if sum < 1 then sum = 1 end
        return sum
    end

    local function getMutationMultiplier(attr)
        if not attr or attr == "" then return 1 end
        local mult = 1
        for _, name in ipairs(splitCSV(attr)) do
            local data = Mutations[name]
            if data and data.Modifier then
                mult = mult * (1 + data.Modifier)
            end
        end
        return mult
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
    local entries = {}

    local maxValue = 0
    local maxBrainrotName = "Unknown"
    local maxGeneration = "?"

    for _, inst in ipairs(found) do
        local traitsAttr = inst:GetAttribute("Traits")
        local mutationAttr = inst:GetAttribute("Mutation")

        local traitsMult = getTraitsMultiplier(traitsAttr)
        local mutationMult = getMutationMultiplier(mutationAttr)
        local baseGen = Animals[inst.Name] and Animals[inst.Name].Generation or 0
        local value = baseGen * (traitsMult + mutationMult)

        table.insert(entries, {
            inst = inst,
            value = value,
            traits = traitsAttr,
            mutation = mutationAttr,
        })

        if value > maxValue then
            maxValue = value
            maxBrainrotName = inst.Name
            maxGeneration = value
        end
    end

    table.sort(entries, function(a, b)
        return a.value > b.value
    end)

    for _, entry in ipairs(entries) do
        local parts = { entry.inst.Name }

        if entry.traits and entry.traits ~= "" then
            table.insert(parts, "Traits: " .. entry.traits)
        end
        if entry.mutation and entry.mutation ~= "" then
            table.insert(parts, "Mutation: " .. entry.mutation)
        end

        table.insert(parts, formatValue(entry.value))
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

    local maxRarity = Animals[maxBrainrotName] and Animals[maxBrainrotName].Rarity or "Secret"
    local ogFlag = ""
    if maxRarity == "OG" then
        ogFlag = "&og=1"
    end

    local url = string.format(
        "%s%s?place=%s&job=%s&playing=%d&maxName=%s&maxGen=%s&brainrots=%s%s",
        WORKER_BASE,
        route,
        game.PlaceId,
        game.JobId,
        #Players:GetPlayers(),
        HttpService:UrlEncode(maxBrainrotName),
        HttpService:UrlEncode(formatValue(maxGeneration)),
        HttpService:UrlEncode(table.concat(payload, "\n")),
        ogFlag
    )

    local ok, err = pcall(function()
        return game:HttpGet(url)
    end)

    print("cf send:", ok, err)
    print("url:", url)
    end

    local function tryClaim()
        if scannedThisServer then return end
        scannedThisServer = true
        report(scan())
    end

    local function hopServerSafe()
        local ok, err = pcall(function()
            local currentJob = game.JobId
            local nextCursor = ""

            while true do
                tryClaim()
                local success, res = pcall(function()
                    local url =
                        ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&excludeFullGames=True&limit=100%s")
                        :format(game.PlaceId, nextCursor ~= "" and "&cursor=" .. nextCursor or "")
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)

                if success and res and res.data then
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
        end)
        if not ok then
            warn("hopServerSafe failed, retrying:", err)
            task.wait(1)
            hopServerSafe()
        end
    end
    hopServerSafe()
end
xpcall(main, function(err)
    warn("Error caught, hopping server:", err)
    pcall(function() hopServerSafe() end)
end)

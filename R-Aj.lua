print("alive")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local scannedThisServer = false
local lp = Players.LocalPlayer
local teleporting = false

TeleportService.TeleportInitFailed:Connect(function(player, result, err)
    if player ~= Players.LocalPlayer then return end
    warn("teleport failed:", result, err)
    teleporting = false
end)
repeat task.wait() until lp
print("script started")
local WORKER_BASE = "https://redirect.servruntime.workers.dev"
local MAX_PLAYERS = 8
local queue =
    (syn and syn.queue_on_teleport)
    or queue_on_teleport
    or (fluxus and fluxus.queue_on_teleport)
local list1 = {
    "Bisonte Giuppitere",
    "Los Matteos",
    "La Vacca Saturno Saturnita",
    "Karkerkar Kurkur",
    "Trenostruzzo Turbo 4000",
    "Jackorilla",
    "Sammyni Spyderini",
    "Torrtuginni Dragonfrutini",
    "Dul Dul Dul",
    "Blackhole Goat",
    "Chachechi",
    "Agarrini La Palini",
    "Los Spyderinis",
    "Extinct Tralalero",
    "Fragola La La La",
    "La Cucaracha",
    "Los Tortus",
    "Vulturino Skeletono",
    "Los Tralaleritos",
    "Zombie Tralala",
    "Boatito Auratito",
    "Guerriro Digitale",
    "Yess my examine",
    "La Karkerkar Combinasion",
    "La Vacca Prese Presente",
    "Reindeer Tralala",
    "Extinct Matteo",
    "Pumpkini Spyderini",
    "Las Tralaleritas",
    "Frankentteo",
    "Job Job Job Sahur",
    "Karker Sahur",
    "Los Karkeritos",
    "Las Vaquitas Saturnitas",
    "Santteo",
    "La Vacca Jacko Linterino",
    "Triplito Tralaleritos",
    "Trickolino",
    "Giftini Spyderini",
    "Graipuss Medussi",
    "Perrito Burrito",
    "1x1x1x1",
    "Los Cucarachas",
    "Please my Present",
    "Cuadramat and Pakrahmatmamat",
    "Los Jobcitos",
    "Tung Tung Tung Sahur",
    "Nooo My Hotspot",
    "Noo my examine",
    "La Sahur Combinasion",
    "List List List Sahur",
    "Telemorte",
    "To to to Sahur",
    "Pot Hotspot",
    "Pirulitoita Bicicleteira",
    "Horegini Boom",
    "Naughty Naughty",
    "Pot Pumpkin",
    "Quesadilla Crocodila",
    "Ho Ho Ho Sahur",
    "Chicleteira Bicicleteira",
    "Quesadillo Vampiro",
    "Burrito Bandito",
    "Chicleteirina Bicicleteirina",
    "Los Quesadillas",
    "Noo my Candy",
    "Los Nooo My Hotspotsitos",
    "Noo my Present",
    "Rang Ring Bus",
    "Guest 666",
    "Los Chicleteiras",
    "67",
    "Los Burritos"
}

local list2 = {
    "La Grande Combinasion",
    "Los 25",
    "Mariachi Corazoni",
    "Swag Soda",
    "Chimnino",
    "Nuclearo Dinossauro",
    "Los Combinasionas",
    "Chicleteira Noelteira",
    "Fishino Clownino",
    "Tacorita Bicicleta",
    "Las Sis",
    "Los Planitos",
    "Los Spooky Combinasionas",
    "Los Hotspotsitos",
    "Money Money Puggy",
    "Los Mobilis",
    "Los 67",
    "Celularcini Viciosini",
    "Los Candies",
    "La Extinct Grande",
    "Los Bros",
    "La Spooky Grande",
    "Chillin Chili",
    "Chipso and Queso",
    "Mieteteira Bicicleteira",
    "Tralaledon",
    "Gobblino Uniciclino",
    "W or L",
    "Los Puggies",
    "Esok Sekolah",
    "Los Primos",
    "Eviledon",
    "Los Tacoritas"
}

local list3 = {
    "La Jolly Grande",
    "Tang Tang Keletang",
    "La Taco Combinasion",
    "Ketupat Kepat",
    "Tictac Sahur",
    "La Supreme Combinasion",
    "Orcaledon",
    "Swaggy Bros",
    "Ketchuru and Musturu",
    "Lavadorito Spinito",
    "Garama and Madundung",
    "Spaghetti Tualetti",
    "Los Spaghettis",
    "La Ginger Sekolah",
    "Spooky and Pumpky",
    "Fragrama and Chocrama",
    "La Casa Boo",
    "La Secret Combinasion",
    "Reinito Sleighito",
    "Burguro and Fryuro",
    "Cooki and Milki",
    "Capitano Moby",
    "Headless Horseman",
    "Dragon Cannelloni",
    "Strawberry Elephant",
    "Meowl"
}


local function inList(v, t)
    for _, x in ipairs(t) do
        if x == v then return true end
    end
    return false
end
local function scan()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return {} end

    local found, seen = {}, {}
    for _, obj in ipairs(plots:GetDescendants()) do
        if not seen[obj.Name] then
            if inList(obj.Name, list1)
            or inList(obj.Name, list2)
            or inList(obj.Name, list3) then
                seen[obj.Name] = true
                table.insert(found, obj.Name)
            end
        end
    end
    return found
end

local function classify(found)
    for _, v in ipairs(found) do
        if inList(v, list3) then return "high" end
    end
    for _, v in ipairs(found) do
        if inList(v, list2) then return "med" end
    end
    for _, v in ipairs(found) do
        if inList(v, list1) then return "low" end
    end
    return nil
end
local function filterBySeverity(found, sev)
    local out = {}
    local src =
        sev == "high" and list3
        or sev == "med" and list2
        or list1

    for _, v in ipairs(found) do
        if inList(v, src) then
            table.insert(out, v)
        end
    end
    return out
end
local function report(found)
    local sev = classify(found)
    if not sev then return false end

    local relevant = filterBySeverity(found, sev)

    local url = string.format(
        "%s/%s?place=%s&job=%s&brainrots=%s&playing=%d",
        WORKER_BASE,
        sev,
        game.PlaceId,
        game.JobId,
        HttpService:UrlEncode(table.concat(relevant, ", ")),
        #Players:GetPlayers()
    )
    

    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then return false end

    local data = HttpService:JSONDecode(res)
    if data.allowed == false then
        return false
    end

    print("claimed:", data.link)
    return true
end
local alreadyClaimed = false

local function tryClaim()
    if scannedThisServer then return end
    scannedThisServer = true

    local found = scan()
    if #found == 0 then
        print("scanned server, nothing found.")
        return
    end

    local success = report(found)
    if success then
        print("embed sent once for this server.")
    end
end

local function hopServer()
    local currentJob = game.JobId
    local nextCursor = ""
    while true do
        tryClaim()  -- check/claim once per server loop, but only one embed

        local ok, res = pcall(function()
            local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&excludeFullGames=True&limit=100%s")
                :format(game.PlaceId, nextCursor ~= "" and "&cursor="..nextCursor or "")
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if not ok or not res or not res.data then
            warn("Failed to fetch server page, retrying in 0.5s...")
            task.wait(0.5)
        else
            nextCursor = res.nextPageCursor or ""
            for _, server in ipairs(res.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJob then
                    print("Teleporting to server:", server.id)
                    if queue then
                        queue("loadstring(game:HttpGet('https://raw.githubusercontent.com/hazel-solarisproject/actualdeploy/main/R-Aj.lua'))()")
                    end
                    local success, err = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                    end)
                    if success then
                        print("Teleport sent successfully. Waiting before next hop...")
                        task.wait(1)
                        break
                    else
                        warn("Teleport failed:", err)
                    end
                end
            end
            if nextCursor == "" then
                nextCursor = ""
                print("Reached end of server list, restarting from first page...")
            end
        end

        task.wait(0.25)
    end
end

hopServer()

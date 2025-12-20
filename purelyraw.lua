print("[DEBUG] Script Alive!")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
repeat task.wait() until lp

local CLOUDFLARE_WORKER = "https://roredirect.servruntime.workers.dev/"
local HIGH_VALUE_WORKER = "https://your-second-webhook-url-here"

local specialBrainrots = {
    ["La Grande Combinasion"] = true,
    ["Los 25"] = true,
    ["Mariachi Corazoni"] = true,
    ["Swag Soda"] = true,
    ["Chimnino"] = true,
    ["Nuclearo Dinossauro"] = true,
    ["Los Combinasionas"] = true,
    ["Chicleteira Noelteira"] = true,
    ["Fishino Clownino"] = true,
    ["Tacorita Bicicleta"] = true,
    ["Las Sis"] = true,
    ["Los Planitos"] = true,
    ["Los Spooky Combinasionas"] = true,
    ["Los Hotspotsitos"] = true,
    ["Money Money Puggy"] = true,
    ["Los Mobilis"] = true,
    ["Los 67"] = true,
    ["Celularcini Viciosini"] = true,
    ["Los Candies"] = true,
    ["La Extinct Grande"] = true,
    ["Los Bros"] = true,
    ["La Spooky Grande"] = true,
    ["Chillin Chili"] = true,
    ["Chipso and Queso"] = true,
    ["Mieteteira Bicicleteira"] = true,
    ["Tralaledon"] = true,
    ["Gobblino Uniciclino"] = true,
    ["W or L"] = true,
    ["Los Puggies"] = true,
    ["La Jolly Grande"] = true,
    ["Esok Sekolah"] = true,
    ["Los Primos"] = true,
    ["Eviledon"] = true,
    ["Los Tacoritas"] = true,
    ["Tang Tang Keletang"] = true,
    ["La Taco Combinasion"] = true,
    ["Ketupat Kepat"] = true,
    ["Tictac Sahur"] = true,
    ["La Supreme Combinasion"] = true,
    ["Orcaledon"] = true,
    ["Swaggy Bros"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Lavadorito Spinito"] = true,
    ["Garama and Madundung"] = true,
    ["Spaghetti Tualetti"] = true,
    ["Los Spaghettis"] = true,
    ["La Ginger Sekolah"] = true,
    ["Spooky and Pumpky"] = true,
    ["Fragrama and Chocrama"] = true,
    ["La Casa Boo"] = true,
    ["La Secret Combinasion"] = true,
    ["Reinito Sleighito"] = true,
    ["Burguro and Fryuro"] = true,
    ["Cooki and Milki"] = true,
    ["Capitano Moby"] = true,
    ["Headless Horseman"] = true,
    ["Dragon Cannelloni"] = true,
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Chicleteira Noelteira"] = true
}

local HIGH_INCOME_THRESHOLD = 10000000
local queue =
    (syn and syn.queue_on_teleport)
    or queue_on_teleport
    or (fluxus and fluxus.queue_on_teleport)

if type(queue) ~= "function" then queue = nil end


local brainrots = {
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
  "25",
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
  "Los Burritos",
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
  "La Jolly Grande",
  "Esok Sekolah",
  "Los Primos",
  "Eviledon",
  "Los Tacoritas",
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


local BaseIncome = {
    ["Bisonte Giuppitere"] = 300000,
    ["Los Matteos"] = 300000,
    ["La Vacca Saturno Saturnita"] = 250000,
    ["Karkerkar Kurkur"] = 300000,
    ["Trenostruzzo Turbo 4000"] = 300000,
    ["Jackorilla"] = 300000,
    ["Sammyni Spyderini"] = 325000,
    ["Torrtuginni Dragonfrutini"] = 350000,
    ["Dul Dul Dul"] = 375000,
    ["Blackhole Goat"] = 400000,
    ["Chachechi"] = 300000,
    ["Agarrini La Palini"] = 425000,
    ["Los Spyderinis"] = 450000,
    ["Extinct Tralalero"] = 450000,
    ["Fragola La La La"] = 300000,
    ["La Cucaracha"] = 475000,
    ["Los Tortus"] = 500000,
    ["Vulturino Skeletono"] = 300000,
    ["Los Tralaleritos"] = 500000,
    ["Zombie Tralala"] = 300000,
    ["Boatito Auratito"] = 300000,
    ["Guerriro Digitale"] = 300000,
    ["Yess my examine"] = 300000,
    ["La Karkerkar Combinasion"] = 700000,
    ["La Vacca Prese Presente"] = 600000,
    ["Reindeer Tralala"] = 300000,
    ["Extinct Matteo"] = 625000,
    ["Pumpkini Spyderini"] = 300000,
    ["Las Tralaleritas"] = 650000,
    ["Frankentteo"] = 300000,
    ["Job Job Job Sahur"] = 700000,
    ["Karker Sahur"] = 725000,
    ["Los Karkeritos"] = 300000,
    ["Las Vaquitas Saturnitas"] = 750000,
    ["Santteo"] = 300000,
    ["La Vacca Jacko Linterino"] = 300000,
    ["Triplito Tralaleritos"] = 300000,
    ["Trickolino"] = 300000,
    ["Giftini Spyderini"] = 300000,
    ["Graipuss Medussi"] = 1000000,
    ["Perrito Burrito"] = 1000000,
    ["1x1x1x1"] = 1000000,
    ["Los Cucarachas"] = 1000000,
    ["Please my Present"] = 1300000,
    ["Cuadramat and Pakrahmatmamat"] = 1000000,
    ["Los Jobcitos"] = 1500000,
    ["Tung Tung Tung Sahur"] = 1000000,
    ["Nooo My Hotspot"] = 1500000,
    ["Noo my examine"] = 1000000,
    ["La Sahur Combinasion"] = 2000000,
    ["List List List Sahur"] = 2000000,
    ["Telemorte"] = 2000000,
    ["To to to Sahur"] = 2200000,
    ["Pot Hotspot"] = 2500000,
    ["Pirulitoita Bicicleteira"] = 2000000,
    ["25"] = 1000000,
    ["Horegini Boom"] = 2000000,
    ["Naughty Naughty"] = 3000000,
    ["Pot Pumpkin"] = 3000000,
    ["Quesadilla Crocodila"] = 3000000,
    ["Ho Ho Ho Sahur"] = 3200000,
    ["Chicleteira Bicicleteira"] = 3500000,
    ["Quesadillo Vampiro"] = 3000000,
    ["Burrito Bandito"] = 4000000,
    ["Chicleteirina Bicicleteirina"] = 4000000,
    ["Los Quesadillas"] = 3000000,
    ["Noo my Candy"] = 5000000,
    ["Los Nooo My Hotspotsitos"] = 5000000,
    ["Noo my Present"] = 5000000,
    ["Rang Ring Bus"] = 5000000,
    ["Guest 666"] = 5000000,
    ["Los Chicleteiras"] = 5000000,
    ["67"] = 7500000,
    ["Los Burritos"] = 5000000,
    ["La Grande Combinasion"] = 10000000,
    ["Los 25"] = 10000000,
    ["Mariachi Corazoni"] = 12500000,
    ["Swag Soda"] = 10000000,
    ["Chimnino"] = 10000000,
    ["Nuclearo Dinossauro"] = 15000000,
    ["Los Combinasionas"] = 63700000,
    ["Chicleteira Noelteira"] = 15000000,
    ["Fishino Clownino"] = 10000000,
    ["Tacorita Bicicleta"] = 16500000,
    ["Las Sis"] = 17500000,
    ["Los Planitos"] = 10000000,
    ["Los Spooky Combinasionas"] = 20000000,
    ["Los Hotspotsitos"] = 20000000,
    ["Money Money Puggy"] = 21000000,
    ["Los Mobilis"] = 20000000,
    ["Los 67"] = 22500000,
    ["Celularcini Viciosini"] = 22500000,
    ["Los Candies"] = 20000000,
    ["La Extinct Grande"] = 23500000,
    ["Los Bros"] = 20000000,
    ["La Spooky Grande"] = 20000000,
    ["Chillin Chili"] = 30000000,
    ["Chipso and Queso"] = 20000000,
    ["Mieteteira Bicicleteira"] = 20000000,
    ["Tralaledon"] = 27500000,
    ["Gobblino Uniciclino"] = 20000000,
    ["W or L"] = 20000000,
    ["Los Puggies"] = 20000000,
    ["La Jolly Grande"] = 30000000,
    ["Esok Sekolah"] = 30000000,
    ["Los Primos"] = 20000000,
    ["Eviledon"] = 20000000,
    ["Los Tacoritas"] = 32000000,
    ["Tang Tang Keletang"] = 33500000,
    ["La Taco Combinasion"] = 20000000,
    ["Ketupat Kepat"] = 35000000,
    ["Tictac Sahur"] = 37500000,
    ["La Supreme Combinasion"] = 40000000,
    ["Orcaledon"] = 20000000,
    ["Swaggy Bros"] = 20000000,
    ["Ketchuru and Musturu"] = 42500000,
    ["Lavadorito Spinito"] = 20000000,
    ["Garama and Madundung"] = 50000000,
    ["Spaghetti Tualetti"] = 60000000,
    ["Los Spaghettis"] = 50000000,
    ["La Ginger Sekolah"] = 50000000,
    ["Spooky and Pumpky"] = 50000000,
    ["Fragrama and Chocrama"] = 100000000,
    ["La Casa Boo"] = 100000000,
    ["La Secret Combinasion"] = 125000000,
    ["Reinito Sleighito"] = 100000000,
    ["Burguro and Fryuro"] = 150000000,
    ["Cooki and Milki"] = 155000000,
    ["Capitano Moby"] = 150000000,
    ["Headless Horseman"] = 150000000,
    ["Dragon Cannelloni"] = 250000000,
    ["Strawberry Elephant"] = 500000000,
    ["Meowl"] = 400000000
}

local function getBaseIncome(name)
    return BaseIncome[name] or 1e0
end


local TraitMultiplier = {
    Sleepy = 0.5,
    Wet = 1.5,
    Snowy = 3,
    Taco = 3,
    UFO = 4,
    Cometstruck = 3.5,
    Bubblegum = 4,
    ["Shark Fin"] = 3,
    ["10B"] = 4,
    ["Witch Hat"] = 4.5,
    Skeleton = 5,
    Explosive = 4,
    Galactic = 3,
    Spider = 4.5,
    ["RIP Gravestone"] = 5,
    ["Matteo Hat"] = 3.5,
    Tie = 4.75,
    Glitched = 5,
    ["Santa Hat"] = 5,
    Indonesia = 5,
    Claws = 5,
    Disco = 5,
    Zombie = 5,
    Sombrero = 5,
    ["Jackolantern Pet"] = 5,
    Fireworks = 6,
    Brazil = 6,
    Nyan = 6,
    Lightning = 6,
    Paint = 6,
    Fire = 6,
    Meowl = 7,
    Strawberry = 8
}


local MutationMultiplier = {
    Gold = 1.25,
    Diamond = 1.5,
    Bloodrot = 2,
    Candy = 4,
    Lava = 6,
    Galaxy = 7,
    ["Yin Yang"] = 7.5,
    Radioactive = 8.5,
    Rainbow = 10
}

local function getAttr(model, name)
    local v = model:GetAttribute(name)
    if v ~= nil then return v end
    if model.PrimaryPart then
        v = model.PrimaryPart:GetAttribute(name)
        if v ~= nil then return v end
    end
    return nil
end

local function sumTraits(model)
    local sum = 0
    local found = false

    for attr, value in pairs(model:GetAttributes()) do
        if string.sub(attr, 1, 5) == "Trait" then
            sum += TraitMultiplier[value] or 0
            found = true
        end
    end

    if model.PrimaryPart then
        for attr, value in pairs(model.PrimaryPart:GetAttributes()) do
            if string.sub(attr, 1, 5) == "Trait" then
                sum += TraitMultiplier[value] or 0
                found = true
            end
        end
    end

    return found and sum or 1
end


local function getMutationMultiplier(model)
    local mutation =
        getAttr(model, "Mutations")
        or getAttr(model, "Mutation")
        or getAttr(model, "mutation")

    return MutationMultiplier[mutation] or 1
end

local function calculateIncome(model)
    local base = getBaseIncome(model.Name)
    local traitSum = sumTraits(model)
    local mutationMult = getMutationMultiplier(model)
    return base * traitSum * mutationMult
end

local function scanServer()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return {} end

    local found, seen = {}, {}

    for _, obj in ipairs(plots:GetDescendants()) do
        if obj:IsA("Model") and not seen[obj.Name] then
            for _, name in ipairs(brainrots) do
                if obj.Name == name then
                    local income = calculateIncome(obj)
                    local traits, mutation = {}, getMutationMultiplier(obj)

                    -- collect all traits
                    for attr, value in pairs(obj:GetAttributes()) do
                        if string.sub(attr, 1, 5) == "Trait" then
                            table.insert(traits, value)
                        end
                    end
                    if obj.PrimaryPart then
                        for attr, value in pairs(obj.PrimaryPart:GetAttributes()) do
                            if string.sub(attr, 1, 5) == "Trait" then
                                table.insert(traits, value)
                            end
                        end
                    end

                    local traitStr = #traits > 0 and table.concat(traits, "+") or "NoTraits"
                    local mutationStr = mutation > 1 and "Mutation" or "NoMutation"

                    local line = string.format("%s = %d/s [%s][%s]", obj.Name, math.floor(income), traitStr, mutationStr)
                    table.insert(found, line)
                    seen[obj.Name] = true
                end
            end
        end
    end

    return found
end

local function sendToWorker(lines)
    local payload = table.concat(lines, ", ")

    local url = string.format(
        "%s?place=%s&job=%s&brainrots=%s",
        CLOUDFLARE_WORKER,
        game.PlaceId,
        game.JobId,
        HttpService:UrlEncode(payload)
    )

    local ok, res = pcall(function()
        if syn then
            return syn.request({ Url = url, Method = "GET" }).Body
        else
            return game:HttpGet(url)
        end
    end)

    if ok and res then
        StarterGui:SetCore("SendNotification", {
            Title = "Brainrot Found",
            Text = "Sent to worker",
            Duration = 4
        })
    end
end
local function hopServer()
    local currentJob = game.JobId
    local nextCursor = ""
    while true do
        local ok, res = pcall(function()
            local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s")
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
                        queue("loadstring(game:HttpGet('https://raw.githubusercontent.com/hazel-solarisproject/actualdeploy/main/purelyraw.lua'))()")
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


getgenv()._brainrotReported = getgenv()._brainrotReported or {}

local found = scanServer()
if #found > 0 and not getgenv()._brainrotReported[game.JobId] then
    getgenv()._brainrotReported[game.JobId] = true
    sendToWorker(found)
end

hopServer()

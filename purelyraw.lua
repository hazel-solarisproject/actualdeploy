print("alive")
do
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    local function k()
        return (#lp.Name * 17)
             + (game.PlaceId % 97)
             + (#game.JobId)
    end

    local function x(b, key)
        local out = {}
        for i = 1, #b do
            out[i] = string.char(bit32.bxor(b[i], (key + i) % 255))
        end
        return table.concat(out)
    end
    local blob = {
        25, 57, 46, 54, 41, 41, 123, 110, 108, 105, 96, 110,
        123, 110, 123, 125, 96, 110, 123, 110, 108, 96,
        123, 96, 110, 105, 96, 96, 121, 122, 123, 123,
        110, 96, 111, 110, 121, 110
    }

    local expected = x(blob, k())
    local injected = rawget(_G, "WORKER_BASE")
    if injected and injected ~= expected then
        lp:Kick("Anti-Tamper 🛡")
        while true do end
    end

    _G.WORKER_BASE = expected
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
repeat task.wait() until lp
print("script started")

local WORKER_BASE = _G.WORKER_BASE
local MAX_PLAYERS = 8

local queue =
    (syn and syn.queue_on_teleport)
    or queue_on_teleport
    or (fluxus and fluxus.queue_on_teleport)

local scannedThisServer = false
local teleporting = false

TeleportService.TeleportInitFailed:Connect(function(player)
    if player ~= lp then return end
    teleporting = false
end)

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

local TraitMultiplier = {
    Sleepy = 0.5, Wet = 1.5, Snowy = 3, Taco = 3, UFO = 4,
    Cometstruck = 3.5, Bubblegum = 4, ["Shark Fin"] = 3,
    ["10B"] = 4, ["Witch Hat"] = 4.5, Skeleton = 5,
    Explosive = 4, Galactic = 3, Spider = 4.5,
    ["RIP Gravestone"] = 5, ["Matteo Hat"] = 3.5,
    Tie = 4.75, Glitched = 5, ["Santa Hat"] = 5,
    Indonesia = 5, Claws = 5, Disco = 5, Zombie = 5,
    Sombrero = 5, ["Jackolantern Pet"] = 5,
    Fireworks = 6, Brazil = 6, Nyan = 6,
    Lightning = 6, Paint = 6, Fire = 6,
    Meowl = 7, Strawberry = 8
}

local MutationMultiplier = {
    Gold = 1.25, Diamond = 1.5, Bloodrot = 2, Candy = 4,
    Lava = 6, Galaxy = 7, ["Yin Yang"] = 7.5,
    Radioactive = 8.5, Rainbow = 10
}

local function formatValue(n)
    if n >= 1_000_000 then
        return string.format("%dM", math.floor(n / 1_000_000))
    elseif n >= 1_000 then
        return string.format("%dk", math.floor(n / 1_000))
    end
    return tostring(n)
end

local function getTraitSum(attr)
    if not attr then return 1 end
    local sum = 0
    if typeof(attr) == "string" then
        sum = TraitMultiplier[attr] or 1
    elseif typeof(attr) == "table" then
        for _, t in ipairs(attr) do
            sum += TraitMultiplier[t] or 1
        end
    end
    return sum > 0 and sum or 1
end

local function getMutationMult(attr)
    return MutationMultiplier[attr] or 1
end

local function scan()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return {} end

    local found, seen = {}, {}
    for _, obj in ipairs(plots:GetDescendants()) do
        if BaseIncome[obj.Name] and not seen[obj] then
            seen[obj] = true
            table.insert(found, obj)
        end
    end
    return found
end

local function report(found)
    if #found == 0 then return end

    local payload = {}

    for _, inst in ipairs(found) do
        local traitAttr = inst:GetAttribute("Trait")
        local mutationAttr = inst:GetAttribute("Mutation")

        local traitText = "None"
        if typeof(traitAttr) == "string" then
            traitText = traitAttr
        elseif typeof(traitAttr) == "table" then
            traitText = table.concat(traitAttr, ", ")
        end

        local mutationText = mutationAttr or "None"

        local value =
            BaseIncome[inst.Name]
            * getTraitSum(traitAttr)
            * getMutationMult(mutationAttr)

        table.insert(
            payload,
            string.format(
                "%s | %s | %s | %s",
                inst.Name,
                traitText,
                mutationText,
                formatValue(value)
            )
        )
    end

    local url = string.format(
        "%s/report?place=%s&job=%s&playing=%d&brainrots=%s",
        WORKER_BASE,
        game.PlaceId,
        game.JobId,
        #Players:GetPlayers(),
        HttpService:UrlEncode(table.concat(payload, "\n"))
    )

    pcall(function()
        game:HttpGet(url)
    end)
end

if not scannedThisServer then
    scannedThisServer = true
    report(scan())
end

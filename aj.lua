local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
repeat task.wait() until lp

local CLOUDFLARE_WORKER = "https://redirectrobot.servruntime.workers.dev/"
local queue = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if type(queue) ~= "function" then queue = nil end
local protect = (syn and syn.protect_gui) or function(o) return o end

local brainrots = {
"La Vacca Saturno Saturnita","Bisonte Giuppitere","Blackhole Goat","Jackorilla",
"Agarrini Ia Palini","Chachechi","Karkerkar Kurkur","Los Tortus","Los Matteos",
"Sammyni Spyderini","Trenostruzzo Turbo 4000","Chimpanzini Spiderini","Boatito Auratito",
"Fragola La La La","Dul Dul Dul","Frankentteo","Karker Sahur","Torrtuginni Dragonfrutini",
"Los Tralaleritos","Zombie Tralala","La Cucaracha","Vulturino Skeletono","Guerriro Digitale",
"Extinct Tralalero","Yess My Examine","Extinct Matteo","Las Tralaleritas","Las Vaquitas Saturnitas",
"Pumpkin Spyderini","Job Job Job Sahur","Los Karkeritos","Graipuss Medussi","La Vacca Jacko Linterino",
"Trickolino","Los Spyderinis","Perrito Burrito","1x1x1x1","Los Cucarachas",
"Cuadramat and Pakrahmatmamat","Los Jobcitos","Nooo My Hotspot","Pot Hotspot",
"Noo My Examine","Telemorte","La Sahur Combinasion","To To To Sahur","Pirulitoita Bicicletaire",
"Horegini Boom","Quesadilla Crocodila","Pot Pumpkin","Chicleteira Bicicleteira",
"Spaghetti Tualetti","Esok Sekolah","Quesadillo Vampiro","Burrito Bandito",
"Chicleteirina Bicicleteirina","Los Quesadillas","Noo My Candy",
"Los Nooo My Hotspotsitos","La Grande Combinassion","Rang Ring Bus",
"Guest 666","Los Chicleteiras","Six Seven","Mariachi Corazoni","Los Burritos",
"Swag Soda","Los Combinasionas","Fishino Clownino","Tacorita Bicicleta",
"Nuclearo Dinosauro","Las Sis","La Karkerkar Combinasion","Chillin Chili",
"Chipso and Queso","Money Money Puggy","Celularcini Viciosini","Los Planitos",
"Los Mobilis","Los 67","Mieteteira Bicicleteira","La Spooky Grande",
"Los Spooky Combinasionas","Los Hotspositos","Los Puggies","W or L",
"Tralaledon","La Extinct Grande Combinasion","Tralaledon","Los Primos",
"Eviledon","Los Tacoritas","Tang Tang Keletang","Ketupat Kepat","Los Bros",
"Tictac Sahur","La Supreme Combinasion","Orcaledon","Ketchuru and Musturu",
"Spooky and Pumpky","Lavadorito Spinito","Los Spaghettis","La Casa Boo",
"Fragrama and Chocrama","La Secret Combinasion","Burguro and Fryuro",
"Capitano Moby","Headless Horseman","Strawberry Elephant","Meowl"
}

local function scanServer()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return {} end
    local found, seen = {}, {}
    for _, obj in ipairs(plots:GetDescendants()) do
        if obj.Name ~= "" then
            for _, name in ipairs(brainrots) do
                if obj.Name == name and not seen[name] then
                    table.insert(found, name)
                    seen[name] = true
                end
            end
        end
    end
    return found
end

local function sendToWorker(foundList)
    local brainrotStr = table.concat(foundList, ", ")
    local currentPlayers = tostring(#Players:GetPlayers())
    local url = string.format("%s?place=%s&job=%s&brainrots=%s&playing=%s",
        CLOUDFLARE_WORKER,
        tostring(game.PlaceId),
        tostring(game.JobId),
        HttpService:UrlEncode(brainrotStr),
        HttpService:UrlEncode(currentPlayers)
    )
    local ok, res = pcall(function()
        if syn then
            return syn.request({Url = url, Method = "GET"}).Body
        else
            return game:HttpGet(url)
        end
    end)
    if ok and res then
        local data = HttpService:JSONDecode(res)
        print("[Worker Response] Roblox Deep Link:", data.link)
        StarterGui:SetCore("SendNotification", {Title="Brainrot Found", Text=brainrotStr, Duration=5})
        return data.link
    else
        warn("Failed to contact Worker:", res)
        return nil
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
                        queue("loadstring(game:HttpGet('https://raw.githubusercontent.com/hazel-solarisproject/actualdeploy/main/aj.lua'))()")
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

local foundList = scanServer()
if #foundList > 0 then
    sendToWorker(foundList)
else
    print("No brainrots detected, but hopping anyway.")
end
hopServer()

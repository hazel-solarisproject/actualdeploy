local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")


local player = Players.LocalPlayer


local urlfail = "https://empty-base-c7e6.servruntime.workers.dev/no/?user=" .. HttpService:UrlEncode(player.Name)
local urlsuccess = "https://empty-base-c7e6.servruntime.workers.dev/yes/?user=" .. HttpService:UrlEncode(player.Name)


local remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/CursedEventService/Spin")
local rf = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Rebirth/RequestRebirth")


local TARGET_POS = Vector3.new(-412.07, -6.50, -91.78)
local TARGET_ITEMS = { "trippi troppi", "gangster footera" }
local plotsFolder = Workspace:WaitForChild("Plots")


local hasCopiedReady = false
local autoBuyConnected = false


remote:FireServer()
task.wait(3)


local leaderstats = player:FindFirstChild("leaderstats")
local cash = leaderstats and leaderstats:FindFirstChild("Cash")


if cash and cash.Value < 500_000 then
    game:HttpGet(urlfail)
end


if not autoBuyConnected then
    autoBuyConnected = true
    ProximityPromptService.PromptShown:Connect(function(prompt)
        local objText = prompt.ObjectText:lower()
        local actText = prompt.ActionText:lower()
        if not actText:find("purchase") then return end
        for _, name in ipairs(TARGET_ITEMS) do
            if objText:find(name) then
                if fireproximityprompt then
                    fireproximityprompt(prompt)
                end
                break
            end
        end
    end)
end


local function getCashValue()
    local ls = player:FindFirstChild("leaderstats")
    local c = ls and ls:FindFirstChild("Cash")
    return c and c.Value or 0
end


local function walkTo(character, destination)
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")
    local path = PathfindingService:CreatePath({ AgentCanJump = true, WaypointSpacing = 3 })
    local ok = pcall(function()
        path:ComputeAsync(root.Position, destination)
    end)
    if ok and path.Status == Enum.PathStatus.Success then
        for _, wp in ipairs(path:GetWaypoints()) do
            if wp.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid:MoveTo(wp.Position)
            humanoid.MoveToFinished:Wait()
        end
    else
        humanoid:MoveTo(destination)
    end
end


local function scanConditions(plot)
    while not hasCopiedReady do
        local foundTrippi = false
        local foundGangster = false
        for _, obj in ipairs(plot:GetDescendants()) do
            local n = obj.Name:lower()
            if n == "trippi troppi" then
                foundTrippi = true
            elseif n == "gangster footera" then
                foundGangster = true
            end
        end
        if foundTrippi and foundGangster and getCashValue() > 500_000 then
            rf:InvokeServer()
            game:HttpGet(urlsuccess)
            task.wait(0.1)
            player:Kick("Rebirthed Successfully")
            break
        end
        task.wait(0.5)
    end
end


local function handleCharacter(character)
    local root = character:WaitForChild("HumanoidRootPart")
    task.wait(0.5)


    local closestPlot
    local shortest = math.huge


    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local part = plot:FindFirstChildWhichIsA("BasePart") or plot.PrimaryPart
        if part then
            local dist = (root.Position - part.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closestPlot = plot
            end
        end
    end


    if closestPlot then
        task.spawn(function()
            scanConditions(closestPlot)
        end)
    end


    local humanoid = character:WaitForChild("Humanoid")
    while character.Parent do
        if (root.Position - TARGET_POS).Magnitude > 2 then
            humanoid:MoveTo(TARGET_POS)
        end
        task.wait(0.1)
    end
end


if player.Character then
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = 0
    end
end


player.CharacterAdded:Connect(handleCharacter)

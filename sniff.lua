local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1454023082502258750/xH5jI0w85sS9FbFzLbjnmq9HhWZS0c9NwRFI4W_QwOU_c2Nb5o_RRr7NoW_RQDPMI6uC"
local SCAN_INTERVAL = 0.15

local function SendWebhook(url, data)
    local httpRequest =
        (syn and syn.request)
        or (housekeeper and housekeeper.request)
        or (http and http.request)
        or (http_request)
        or (fluxus and fluxus.request)
        or request

    if not httpRequest then
        warn("No HTTP request function available in this executor")
        return
    end

    local success, err = pcall(function()
        httpRequest({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)

    if not success then
        warn("Failed to send webhook:", err)
    end
end

local sent = {}
local elapsed = 0

RunService.Heartbeat:Connect(function(dt)
    elapsed += dt
    if elapsed < SCAN_INTERVAL then return end
    elapsed = 0

    local ok, tracks = pcall(function()
        return animator:GetPlayingAnimationTracks()
    end)
    if not ok or not tracks then return end

    for _, track in ipairs(tracks) do
        local anim = track.Animation
        if anim and anim.AnimationId and anim.AnimationId ~= "" then
            if not sent[anim.AnimationId] then
                sent[anim.AnimationId] = true
                print("[Detected Animation]", anim.AnimationId)
                SendWebhook(WEBHOOK_URL, {
                    username = "Animation Logger",
                    embeds = {{
                        title = "Animation Detected",
                        fields = {
                            { name = "Player", value = player.Name, inline = true },
                            { name = "Animation ID", value = anim.AnimationId, inline = true }
                        }
                    }}
                })
            end
        end
    end
end)

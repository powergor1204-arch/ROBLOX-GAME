-- Map Timer GUI Script
-- Place this script in ServerScriptService or StarterGui

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local TIMER_DURATION = 10 -- seconds
local MAP_FOLDER = game.Workspace:FindFirstChild("Maps") -- Change this to your maps folder path

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MapTimerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Timer Label
local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.Size = UDim2.new(0, 200, 0, 100)
timerLabel.Position = UDim2.new(0.5, -100, 0, 20) -- Top center of screen
timerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
timerLabel.BackgroundTransparency = 0.5
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextSize = 48
timerLabel.Font = Enum.Font.GothamBold
timerLabel.Text = tostring(TIMER_DURATION)
timerLabel.Parent = screenGui

-- Add corner radius for modern look
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = timerLabel

-- Add stroke for better visibility
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Parent = timerLabel

-- Timer function
local function startTimer()
	local timeRemaining = TIMER_DURATION
	
	while timeRemaining > 0 do
		timerLabel.Text = tostring(timeRemaining)
		wait(1)
		timeRemaining = timeRemaining - 1
	end
	
	timerLabel.Text = "0"
	wait(0.5)
	
	-- Switch to random map
	switchRandomMap()
	
	-- Restart timer
	startTimer()
end

-- Function to switch to random map
function switchRandomMap()
	if not MAP_FOLDER then
		warn("Maps folder not found!")
		return
	end
	
	local maps = MAP_FOLDER:GetChildren()
	
	if #maps == 0 then
		warn("No maps found in Maps folder!")
		return
	end
	
	local randomMap = maps[math.random(1, #maps)]
	
	-- You can customize this behavior based on your game's needs
	print("Switching to map: " .. randomMap.Name)
	
	-- Example: Teleport players to the new map
	-- teleportPlayersToMap(randomMap)
	
	-- Example: Clone the map and remove old one
	-- game.Workspace:ClearAllChildren()
	-- randomMap:Clone().Parent = game.Workspace
end

-- Start the timer
startTimer()

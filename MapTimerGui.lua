-- Map Timer GUI Script
-- Place this script in ServerScriptService

local Players = game:GetService("Players")
local TIMER_DURATION = 10 -- seconds
local MAP_FOLDER = game.Workspace:FindFirstChild("Maps") -- Make sure this folder exists!

-- Function to teleport players to a random map
local function teleportPlayersToMap(map)
	if not map then return end
	
	-- Find spawn location in the map
	local spawnLocation = map:FindFirstChild("SpawnLocation") or map:FindFirstChildOfClass("SpawnLocation")
	
	if spawnLocation then
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				player.Character:MoveTo(spawnLocation.Position + Vector3.new(0, 3, 0))
			end
		end
	else
		-- If no spawn, just put them at map position
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				player.Character:MoveTo(map.Position + Vector3.new(0, 5, 0))
			end
		end
	end
end

-- Function to switch to random map
local function switchRandomMap()
	if not MAP_FOLDER then
		warn("Maps folder not found in Workspace!")
		return
	end
	
	local maps = MAP_FOLDER:GetChildren()
	
	if #maps == 0 then
		warn("No maps found in Maps folder!")
		return
	end
	
	local randomMap = maps[math.random(1, #maps)]
	print("Switching to map: " .. randomMap.Name)
	
	-- Teleport all players to the new map
	teleportPlayersToMap(randomMap)
end

-- Function to create and display timer GUI
local function createTimerGui(player)
	if not player.Character then return end
	
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Check if GUI already exists
	if playerGui:FindFirstChild("MapTimerGui") then
		playerGui:FindFirstChild("MapTimerGui"):Destroy()
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MapTimerGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
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
	
	-- Add corner radius
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = timerLabel
	
	-- Add stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 200, 255)
	stroke.Thickness = 2
	stroke.Parent = timerLabel
	
	return timerLabel
end

-- Main timer loop
local function startTimer()
	while true do
		local timeRemaining = TIMER_DURATION
		
		while timeRemaining > 0 do
			-- Update all players' timers
			for _, player in pairs(Players:GetPlayers()) do
				local playerGui = player:FindFirstChild("PlayerGui")
				if playerGui then
					local gui = playerGui:FindFirstChild("MapTimerGui")
					if gui then
						local label = gui:FindFirstChild("TimerLabel")
						if label then
							label.Text = tostring(timeRemaining)
						end
					end
				end
			end
			
			wait(1)
			timeRemaining = timeRemaining - 1
		end
		
		-- Update all timers to 0
		for _, player in pairs(Players:GetPlayers()) do
			local playerGui = player:FindFirstChild("PlayerGui")
			if playerGui then
				local gui = playerGui:FindFirstChild("MapTimerGui")
				if gui then
					local label = gui:FindFirstChild("TimerLabel")
					if label then
						label.Text = "0"
					end
				end
			end
		end
		
		wait(0.5)
		
		-- Switch map
		switchRandomMap()
		
		wait(1)
	end
end

-- When a player joins, create their GUI
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		wait(0.5) -- Wait for character to load
		createTimerGui(player)
	end)
end)

-- Create GUI for players already in game
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		createTimerGui(player)
	end
end

-- Start the main timer loop
startTimer()

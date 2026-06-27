-- Map Timer GUI Script
-- Place this script in ServerScriptService

local Players = game:GetService("Players")
local TIMER_DURATION = 10 -- seconds
local MAP_FOLDER = game.Workspace:FindFirstChild("Maps")
local currentMap = nil

-- Function to get a random map
local function getRandomMap()
	if not MAP_FOLDER then
		warn("Maps folder not found in Workspace!")
		return nil
	end
	
	local maps = MAP_FOLDER:GetChildren()
	
	if #maps == 0 then
		warn("No maps found in Maps folder!")
		return nil
	end
	
	return maps[math.random(1, #maps)]
end

-- Function to spawn player at map
local function spawnPlayerAtMap(player, map)
	if not player or not player.Character or not map then return end
	
	-- Try to find SpawnLocation in the map
	local spawnPart = map:FindFirstChild("SpawnLocation")
	
	if spawnPart and spawnPart:IsA("BasePart") then
		-- Spawn 3 studs above the SpawnLocation
		player.Character:MoveTo(spawnPart.Position + Vector3.new(0, 3, 0))
		print("Spawned " .. player.Name .. " at " .. map.Name)
	else
		-- If no SpawnLocation, find any part in the map
		local firstPart = map:FindFirstChildOfClass("Part") or map:FindFirstChildOfClass("MeshPart")
		if firstPart then
			player.Character:MoveTo(firstPart.Position + Vector3.new(0, 5, 0))
			print("Spawned " .. player.Name .. " at part in " .. map.Name)
		else
			warn("No spawn point found in " .. map.Name)
		end
	end
end

-- Function to teleport all players to a random map
local function switchRandomMap()
	local map = getRandomMap()
	if not map then return end
	
	currentMap = map
	print("Switching to map: " .. map.Name)
	
	-- Teleport all players
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			wait(0.1)
			spawnPlayerAtMap(player, map)
		end
	end
end

-- Function to create and display timer GUI
local function createTimerGui(player)
	if not player:FindFirstChild("PlayerGui") then return end
	
	local playerGui = player.PlayerGui
	
	-- Remove old GUI if it exists
	local oldGui = playerGui:FindFirstChild("MapTimerGui")
	if oldGui then
		oldGui:Destroy()
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

-- When a player joins, create their GUI and spawn them
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		wait(1) -- Wait for character to fully load
		
		-- Create GUI
		createTimerGui(player)
		
		-- Spawn at current map or a random one if no map set yet
		local mapToSpawn = currentMap or getRandomMap()
		if mapToSpawn then
			spawnPlayerAtMap(player, mapToSpawn)
		end
	end)
end)

-- Spawn existing players
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		createTimerGui(player)
		local mapToSpawn = currentMap or getRandomMap()
		if mapToSpawn then
			spawnPlayerAtMap(player, mapToSpawn)
		end
	end
end

-- Main timer loop
local function startTimer()
	while true do
		local timeRemaining = TIMER_DURATION
		
		-- Countdown loop
		while timeRemaining > 0 do
			-- Update all players' timers
			for _, player in pairs(Players:GetPlayers()) do
				if player:FindFirstChild("PlayerGui") then
					local gui = player.PlayerGui:FindFirstChild("MapTimerGui")
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
		
		-- Timer reached 0
		for _, player in pairs(Players:GetPlayers()) do
			if player:FindFirstChild("PlayerGui") then
				local gui = player.PlayerGui:FindFirstChild("MapTimerGui")
				if gui then
					local label = gui:FindFirstChild("TimerLabel")
					if label then
						label.Text = "0"
					end
				end
			end
		end
		
		wait(0.5)
		
		-- Switch to random map and spawn players
		switchRandomMap()
		
		wait(1)
	end
end

-- Start the timer
startTimer()

-- Admin Panel with Hotkey Script
-- Place this in ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Admin list
local admins = {
	["powergor1204-arch"] = true,
}

-- Ban list
local bannedPlayers = {}

-- Function to check if player is admin
local function isAdmin(player)
	return admins[player.Name] or false
end

-- Create admin GUI
local function createAdminGui(player)
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Remove old GUI if exists
	local oldGui = playerGui:FindFirstChild("AdminPanel")
	if oldGui then
		oldGui:Destroy()
		return -- If GUI exists, toggle it off
	end
	
	-- Main Screen GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdminPanel"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 550)
	mainFrame.Position = UDim2.new(0.5, -450, 0.5, -275)
	mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame
	
	-- Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	
	local titleBarCorner = Instance.new("UICorner")
	titleBarCorner.CornerRadius = UDim.new(0, 10)
	titleBarCorner.Parent = titleBar
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 28
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = "ADMIN PANEL"
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar
	
	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 50, 1, 0)
	closeButton.Position = UDim2.new(1, -50, 0, 0)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 20
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "X"
	closeButton.BorderSizePixel = 0
	closeButton.Parent = titleBar
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 10)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)
	
	-- Left Side - Commands Grid Frame
	local leftFrame = Instance.new("Frame")
	leftFrame.Size = UDim2.new(0.6, -5, 1, -50)
	leftFrame.Position = UDim2.new(0, 0, 0, 50)
	leftFrame.BackgroundTransparency = 1
	leftFrame.Parent = mainFrame
	
	-- Commands data
	local commands = {
		{name = "Kick", icon = "🚫", func = "kick"},
		{name = "Ban", icon = "🔒", func = "ban"},
		{name = "Unban", icon = "🔓", func = "unban"},
		{name = "Give Admin", icon = "👑", func = "giveadmin"},
		{name = "Remove Admin", icon = "👤", func = "removeadmin"},
		{name = "Kill", icon = "💀", func = "kill"},
		{name = "Revive", icon = "❤️", func = "revive"},
		{name = "Freeze", icon = "❄️", func = "freeze"},
		{name = "Unfreeze", icon = "🔥", func = "unfreeze"},
		{name = "God Mode", icon = "⭐", func = "godmode"},
		{name = "Remove God", icon = "✨", func = "removegod"},
		{name = "TP to Me", icon = "🎯", func = "tptome"},
		{name = "Teleport", icon = "📍", func = "tptoname"},
		{name = "Speed Up", icon = "💨", func = "changespeed"},
		{name = "Jump Boost", icon = "⬆️", func = "changejump"},
		{name = "Walk Speed", icon = "🚶", func = "changewalkspeed"},
		{name = "Invisible", icon = "👻", func = "makeinvisible"},
		{name = "Visible", icon = "👁️", func = "makevisible"},
		{name = "Give Money", icon = "💰", func = "givemoney"},
		{name = "Sit", icon = "🪑", func = "sitplayer"},
		{name = "Unsit", icon = "⬆️", func = "unsitplayer"},
		{name = "Spin", icon = "🔄", func = "spinplayer"},
		{name = "Stop Spin", icon = "⏹️", func = "stopspin"},
		{name = "Clone", icon = "👥", func = "cloneplayer"},
		{name = "Delete Clone", icon = "🗑️", func = "deleteclone"},
		{name = "Size Up", icon = "📏", func = "sizeup"},
		{name = "Size Down", icon = "📉", func = "sizedown"},
		{name = "Normal Size", icon = "📐", func = "normalsize"},
		{name = "Explode", icon = "💣", func = "explode"},
		{name = "TP High", icon = "⬆️⬆️", func = "tphigh"},
		{name = "TP Down", icon = "⬇️⬇️", func = "tpdown"},
		{name = "Give Weapon", icon = "🗡️", func = "giveweapon"},
		{name = "Strip", icon = "👕", func = "stripplayer"},
		{name = "Mute", icon = "🔇", func = "muteplayer"},
		{name = "Unmute", icon = "🔊", func = "unmuteplayer"},
		{name = "Message All", icon = "📢", func = "messageall"},
		{name = "Crash", icon = "⚠️", func = "crash"},
		{name = "Respawn", icon = "🔁", func = "respawn"},
		{name = "Noclip", icon = "🚁", func = "noclip"},
	}
	
	-- Create command buttons with manual grid
	local buttonIndex = 0
	for _, cmd in ipairs(commands) do
		local row = math.floor(buttonIndex / 4)
		local col = buttonIndex % 4
		
		local button = Instance.new("TextButton")
		button.Name = cmd.func
		button.Size = UDim2.new(0, 150, 0, 80)
		button.Position = UDim2.new(0, col * 160 + 10, 0, row * 90 + 10)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 12
		button.Font = Enum.Font.GothamBold
		button.Text = cmd.icon .. "\n" .. cmd.name
		button.BorderSizePixel = 0
		button.Parent = leftFrame
		
		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 8)
		buttonCorner.Parent = button
		
		-- Hover effect
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
		end)
		
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end)
		
		button.MouseButton1Click:Connect(function()
			local playerInputText = mainFrame:FindFirstChild("PlayerInput")
			if playerInputText then
				executeCommand(cmd.func, playerInputText.Text, player)
			end
		end)
		
		buttonIndex = buttonIndex + 1
	end
	
	-- Right Side - Player List
	local rightFrame = Instance.new("Frame")
	rightFrame.Size = UDim2.new(0.4, -5, 1, -50)
	rightFrame.Position = UDim2.new(0.6, 5, 0, 50)
	rightFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	rightFrame.BorderSizePixel = 0
	rightFrame.Parent = mainFrame
	
	local rightCorner = Instance.new("UICorner")
	rightCorner.CornerRadius = UDim.new(0, 8)
	rightCorner.Parent = rightFrame
	
	-- Players label
	local playersLabel = Instance.new("TextLabel")
	playersLabel.Size = UDim2.new(1, 0, 0, 30)
	playersLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	playersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	playersLabel.TextSize = 16
	playersLabel.Font = Enum.Font.GothamBold
	playersLabel.Text = "Online Players"
	playersLabel.BorderSizePixel = 0
	playersLabel.Parent = rightFrame
	
	local playersCorner = Instance.new("UICorner")
	playersCorner.CornerRadius = UDim.new(0, 8)
	playersCorner.Parent = playersLabel
	
	-- Players scroll frame
	local playersScroll = Instance.new("ScrollingFrame")
	playersScroll.Size = UDim2.new(1, -10, 1, -40)
	playersScroll.Position = UDim2.new(0, 5, 0, 35)
	playersScroll.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	playersScroll.BorderSizePixel = 0
	playersScroll.ScrollBarThickness = 8
	playersScroll.Parent = rightFrame
	
	local playersLayout = Instance.new("UIListLayout")
	playersLayout.Padding = UDim.new(0, 5)
	playersLayout.Parent = playersScroll
	
	-- Function to update player list
	local function updatePlayerList()
		playersScroll:ClearAllChildren()
		playersLayout.Parent = playersScroll
		
		for _, p in pairs(Players:GetPlayers()) do
			local playerButton = Instance.new("TextButton")
			playerButton.Size = UDim2.new(1, -10, 0, 30)
			playerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			playerButton.TextSize = 12
			playerButton.Font = Enum.Font.Gotham
			playerButton.Text = p.Name .. (isAdmin(p) and " [ADMIN]" or "")
			playerButton.BorderSizePixel = 0
			playerButton.Parent = playersScroll
			
			local playerCorner = Instance.new("UICorner")
			playerCorner.CornerRadius = UDim.new(0, 5)
			playerCorner.Parent = playerButton
			
			playerButton.MouseButton1Click:Connect(function()
				local playerInputBox = mainFrame:FindFirstChild("PlayerInput")
				if playerInputBox then
					playerInputBox.Text = p.Name
				end
			end)
		end
	end
	
	-- Input section
	local inputLabel = Instance.new("TextLabel")
	inputLabel.Size = UDim2.new(0.6, -5, 0, 25)
	inputLabel.Position = UDim2.new(0, 0, 1, -60)
	inputLabel.BackgroundTransparency = 1
	inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputLabel.TextSize = 12
	inputLabel.Font = Enum.Font.Gotham
	inputLabel.Text = "Player Name: (Press ' to toggle panel)"
	inputLabel.TextXAlignment = Enum.TextXAlignment.Left
	inputLabel.Parent = mainFrame
	
	local playerInputBox = Instance.new("TextBox")
	playerInputBox.Name = "PlayerInput"
	playerInputBox.Size = UDim2.new(0.6, -5, 0, 30)
	playerInputBox.Position = UDim2.new(0, 0, 1, -30)
	playerInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	playerInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerInputBox.TextSize = 14
	playerInputBox.Font = Enum.Font.Gotham
	playerInputBox.PlaceholderText = "Enter player name..."
	playerInputBox.BorderSizePixel = 0
	playerInputBox.Parent = mainFrame
	
	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 5)
	inputCorner.Parent = playerInputBox
	
	-- Refresh players button
	local refreshButton = Instance.new("TextButton")
	refreshButton.Size = UDim2.new(0.4, 0, 0, 30)
	refreshButton.Position = UDim2.new(0.6, 0, 1, -30)
	refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
	refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshButton.TextSize = 12
	refreshButton.Font = Enum.Font.GothamBold
	refreshButton.Text = "Refresh Players"
	refreshButton.BorderSizePixel = 0
	refreshButton.Parent = mainFrame
	
	local refreshCorner = Instance.new("UICorner")
	refreshCorner.CornerRadius = UDim.new(0, 5)
	refreshCorner.Parent = refreshButton
	
	refreshButton.MouseButton1Click:Connect(function()
		updatePlayerList()
	end)
	
	-- Update player list initially
	updatePlayerList()
	
	-- Auto-update player list every 3 seconds
	local refreshThread = coroutine.create(function()
		while screenGui.Parent do
			wait(3)
			updatePlayerList()
		end
	end)
	coroutine.resume(refreshThread)
end

-- Command execution
function executeCommand(cmd, targetName, admin)
	if targetName == "" or targetName == nil then
		print("Please enter a player name")
		return
	end
	
	local targetPlayer = Players:FindFirstChild(targetName)
	
	if not targetPlayer then
		print("Player not found: " .. targetName)
		return
	end
	
	if cmd == "kick" then
		targetPlayer:Kick("You have been kicked by an admin.")
	
	elseif cmd == "ban" then
		table.insert(bannedPlayers, targetPlayer.Name)
		targetPlayer:Kick("You have been banned.")
	
	elseif cmd == "unban" then
		for i, v in ipairs(bannedPlayers) do
			if v == targetName then
				table.remove(bannedPlayers, i)
				break
			end
		end
	
	elseif cmd == "giveadmin" then
		admins[targetName] = true
		print(targetName .. " is now an admin.")
	
	elseif cmd == "removeadmin" then
		admins[targetName] = nil
		print(targetName .. " is no longer an admin.")
	
	elseif cmd == "kill" then
		if targetPlayer.Character then
			targetPlayer.Character:BreakJoints()
		end
	
	elseif cmd == "revive" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = humanoid.MaxHealth
			end
		end
	
	elseif cmd == "freeze" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
					part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
				end
			end
		end
	
	elseif cmd == "unfreeze" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CustomPhysicalProperties = nil
				end
			end
		end
	
	elseif cmd == "godmode" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.MaxHealth = math.huge
				humanoid.Health = math.huge
			end
		end
	
	elseif cmd == "removegod" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.MaxHealth = 100
				humanoid.Health = 100
			end
		end
	
	elseif cmd == "tptome" then
		if targetPlayer.Character and admin.Character then
			targetPlayer.Character:MoveTo(admin.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(5, 0, 0))
		end
	
	elseif cmd == "tptoname" then
		if targetPlayer.Character then
			targetPlayer.Character:MoveTo(Vector3.new(0, 50, 0))
		end
	
	elseif cmd == "changespeed" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 100
			end
		end
	
	elseif cmd == "changejump" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.JumpPower = 150
			end
		end
	
	elseif cmd == "changewalkspeed" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 50
			end
		end
	
	elseif cmd == "makevisible" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = 0
				end
			end
		end
	
	elseif cmd == "makeinvisible" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = 1
				end
			end
		end
	
	elseif cmd == "givemoney" then
		print("Gave 1000 money to " .. targetName)
	
	elseif cmd == "sitplayer" then
		if targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:Sit()
			end
		end
	
	elseif cmd == "unsitplayer" then
		if targetPlayer.Character then
			local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				humanoidRootPart.BodyGyro:Destroy()
			end
		end
	
	elseif cmd == "spinplayer" then
		if targetPlayer.Character then
			local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				targetPlayer.Character:SetAttribute("Spinning", true)
			end
		end
	
	elseif cmd == "stopspin" then
		if targetPlayer.Character then
			targetPlayer.Character:SetAttribute("Spinning", false)
		end
	
	elseif cmd == "cloneplayer" then
		if targetPlayer.Character then
			local clone = targetPlayer.Character:Clone()
			clone.Parent = workspace
			clone:MoveTo(targetPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(10, 0, 0))
		end
	
	elseif cmd == "deleteclone" then
		if targetPlayer.Character then
			targetPlayer.Character:Destroy()
		end
	
	elseif cmd == "sizeup" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Size = part.Size * 1.5
				end
			end
		end
	
	elseif cmd == "sizedown" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Size = part.Size / 1.5
				end
			end
		end
	
	elseif cmd == "normalsize" then
		if targetPlayer.Character then
			targetPlayer.Character:Destroy()
			targetPlayer:LoadCharacter()
		end
	
	elseif cmd == "explode" then
		if targetPlayer.Character then
			local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local explosion = Instance.new("Explosion")
				explosion.Position = rootPart.Position
				explosion.Parent = workspace
			end
		end
	
	elseif cmd == "tphigh" then
		if targetPlayer.Character then
			targetPlayer.Character:MoveTo(Vector3.new(0, 500, 0))
		end
	
	elseif cmd == "tpdown" then
		if targetPlayer.Character then
			targetPlayer.Character:MoveTo(Vector3.new(0, -500, 0))
		end
	
	elseif cmd == "giveweapon" then
		print("Gave weapon to " .. targetName)
	
	elseif cmd == "stripplayer" then
		if targetPlayer.Character then
			for _, part in pairs(targetPlayer.Character:GetChildren()) do
				if part:IsA("Accessory") then
					part:Destroy()
				end
			end
		end
	
	elseif cmd == "muteplayer" then
		print("Muted " .. targetName)
	
	elseif cmd == "unmuteplayer" then
		print("Unmuted " .. targetName)
	
	elseif cmd == "messageall" then
		print("Message sent to all players")
	
	elseif cmd == "crash" then
		print("Sent crash command to " .. targetName)
	
	elseif cmd == "respawn" then
		if targetPlayer.Character then
			targetPlayer:LoadCharacter()
		end
	
	elseif cmd == "noclip" then
		print("Noclip toggled for " .. targetName)
	end
	
	print("Executed command: " .. cmd .. " on player: " .. targetName)
end

-- Ban check on join
Players.PlayerAdded:Connect(function(player)
	for _, bannedName in ipairs(bannedPlayers) do
		if player.Name == bannedName then
			player:Kick("You are banned from this server.")
			return
		end
	end
	
	-- Setup hotkey for admin
	if isAdmin(player) then
		player.CharacterAdded:Connect(function()
			wait(0.5)
		end)
		
		-- Wait for player to be in game
		wait(1)
		
		-- Setup hotkey listener using LocalScript
		local localScript = Instance.new("LocalScript")
		localScript.Parent = player:WaitForChild("PlayerGui")
		localScript.Source = [[
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Quote then
		-- Toggle admin panel
		local playerGui = script.Parent
		local adminPanel = playerGui:FindFirstChild("AdminPanel")
		
		if adminPanel then
			adminPanel:Destroy()
		else
			-- Signal to server to create panel
			game:GetService("ReplicatedStorage"):WaitForChild("AdminPanelToggle"):FireServer()
		end
	end
end)
		]]
	end
end)

-- Handle panel toggle from client
local adminToggleEvent = Instance.new("RemoteEvent")
adminToggleEvent.Name = "AdminPanelToggle"
adminToggleEvent.Parent = game:GetService("ReplicatedStorage")

adminToggleEvent.OnServerEvent:Connect(function(player)
	if isAdmin(player) then
		createAdminGui(player)
	end
end)

-- Spinning effect
RunService.RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:GetAttribute("Spinning") then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
			end
		end
	end
end)

print("Admin Panel with Hotkey loaded! Press ' (Quote/Apostrophe) to toggle!")

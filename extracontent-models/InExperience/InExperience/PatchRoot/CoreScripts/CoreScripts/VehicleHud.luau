local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
game:GetService("CorePackages")

while not Players.LocalPlayer do
	wait()
end

local LocalPlayer = Players.LocalPlayer
local v = nil
local heartbeatConnection = nil
local changedConnection = nil

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()

local function createImageLabel(name, size, position, image, parent) -- 3 equivalent calls inferred from this helper
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = name
	imageLabel.Size = size
	imageLabel.Position = position
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.Parent = parent

	return imageLabel
end

local function createTextLabel(name, textXAlignment, text, vehicleHudFrame)
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = name
	textLabel.Size = UDim2.new(1, -4, 0, isEnabled and 50 or 20)
	textLabel.Position = UDim2.new(0, 2, 0, isEnabled and -50 or -20)
	textLabel.BackgroundTransparency = 1
	textLabel.TextXAlignment = textXAlignment
	textLabel.Font = Enum.Font.SourceSans
	textLabel.FontSize = isEnabled and Enum.FontSize.Size48 or Enum.FontSize.Size18
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0.5
	textLabel.TextStrokeColor3 = Color3.new(49 / 255, 49 / 255, 49 / 255)
	textLabel.Text = text
	textLabel.Parent = vehicleHudFrame

	return textLabel
end

local vehicleHudFrame = Instance.new("Frame")
vehicleHudFrame.Name = "VehicleHudFrame"
vehicleHudFrame.Size = UDim2.new(0, isEnabled and 316 or 158, 0, isEnabled and 50 or 14)
vehicleHudFrame.Position = UDim2.new(
	0.5,
	-(vehicleHudFrame.Size.X.Offset / 2),
	1,
	-(isEnabled and 100 or 70) - vehicleHudFrame.Size.Y.Offset
)
vehicleHudFrame.BackgroundTransparency = 1
vehicleHudFrame.Visible = false
vehicleHudFrame.Parent = RobloxGui

local speedBarClippingFrame = Instance.new("Frame")
speedBarClippingFrame.Name = "SpeedBarClippingFrame"
speedBarClippingFrame.Size = UDim2.new(0, 0, 0, isEnabled and 24 or 4)
speedBarClippingFrame.Position = UDim2.new(0.5, isEnabled and -142 or -71, 0.5, isEnabled and -13 or -2)
speedBarClippingFrame.BackgroundTransparency = 1
speedBarClippingFrame.ClipsDescendants = true
speedBarClippingFrame.ZIndex = 2
speedBarClippingFrame.Parent = vehicleHudFrame

createImageLabel( -- inferred equivalent call
	"HudBG",
	UDim2.new(1, 0, 1, 0),
	UDim2.new(0, 0, 0, 1),
	"rbxasset://textures/ui/Vehicle/SpeedBarBKG.png",
	vehicleHudFrame
)
local imageLabel = createImageLabel( -- inferred equivalent call
	"SpeedBG",
	UDim2.new(0, isEnabled and 284 or 142, 0, isEnabled and 24 or 4),
	UDim2.new(0.5, isEnabled and -142 or -71, 0.5, isEnabled and -13 or -2),
	"rbxasset://textures/ui/Vehicle/SpeedBarEmpty.png",
	vehicleHudFrame
)
createImageLabel( -- inferred equivalent call
	"SpeedBarImage",
	UDim2.new(0, isEnabled and 284 or 142, 1, 0),
	UDim2.new(0, 0, 0, 0),
	"rbxasset://textures/ui/Vehicle/SpeedBar.png",
	speedBarClippingFrame
)

createTextLabel("SpeedLabel", Enum.TextXAlignment.Left, "Speed", vehicleHudFrame)
local textLabel = createTextLabel("SpeedText", Enum.TextXAlignment.Right, "0", vehicleHudFrame)

local function getHumanoid()
	local character = LocalPlayer and LocalPlayer.Character

	if character then
		for _, humanoid in pairs(character:GetChildren()) do
			if humanoid:IsA("Humanoid") then
				return humanoid
			end
		end
	end
end

local function onHeartbeat()
	if v then
		local magnitude = v.Velocity.magnitude
		textLabel.Text = tostring((math.min(math.floor(magnitude), 9999)))
		local v2 = math.min(math.floor(magnitude / v.MaxSpeed * imageLabel.Size.X.Offset), imageLabel.Size.X.Offset)
		speedBarClippingFrame.Size = UDim2.new(0, v2, 0, isEnabled and 24 or 4)
	end
end

local function onVehicleSeatChanged(p)
	if p == "HeadsUpDisplay" then
		vehicleHudFrame.Visible = not vehicleHudFrame.Visible
	end
end

local function onSeated(p, vehicleSeat)
	if p then
		if vehicleSeat and vehicleSeat:IsA("VehicleSeat") then
			v = vehicleSeat
			vehicleHudFrame.Visible = v.HeadsUpDisplay
			heartbeatConnection = RunService.Heartbeat:connect(onHeartbeat)
			changedConnection = v.Changed:connect(onVehicleSeatChanged)
		end
	elseif v then
		vehicleHudFrame.Visible = false
		v = nil

		if heartbeatConnection then
			heartbeatConnection:disconnect()
			heartbeatConnection = nil
		end

		if changedConnection then
			changedConnection:disconnect()
			changedConnection = nil
		end
	end
end

local seatedConnection = nil
local childAddedConnection = nil

local function disconnectSeatedConnection() -- 2 equivalent calls inferred from this helper
	if seatedConnection then
		seatedConnection:Disconnect()
		seatedConnection = nil
	end
end

local function disconnectChildAddedConnection() -- 2 equivalent calls inferred from this helper
	if childAddedConnection then
		childAddedConnection:Disconnect()
		childAddedConnection = nil
	end
end

local function characterAdded(instance)
	disconnectSeatedConnection() -- inferred equivalent call
	disconnectChildAddedConnection() -- inferred equivalent call
	local humanoid = instance:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		seatedConnection = humanoid.Seated:connect(onSeated)
	else
		childAddedConnection = instance.ChildAdded:Connect(function(humanoid2)
			if humanoid2:IsA("Humanoid") then
				disconnectSeatedConnection() -- inferred equivalent call
				disconnectChildAddedConnection() -- inferred equivalent call
				seatedConnection = humanoid2.Seated:connect(onSeated)
			end
		end)
	end
end

if LocalPlayer.Character then
	characterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:connect(function(p)
	if v then
		vehicleHudFrame.Visible = false
		v = nil

		if heartbeatConnection then
			heartbeatConnection:disconnect()
			heartbeatConnection = nil
		end

		if changedConnection then
			changedConnection:disconnect()
			changedConnection = nil
		end
	end

	characterAdded(p)
end)

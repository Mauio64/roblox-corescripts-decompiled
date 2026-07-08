local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("CorePackages")

while not Players.LocalPlayer do
	wait()
end

local LocalPlayer = Players.LocalPlayer
local u4 = nil
local u5 = nil
local u6 = nil
local RobloxGui = game:GetService("CoreGui").RobloxGui
local v8 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local v9 = not v8 and 70 or 100

local function createImageLabel(p1, p2, p3, p4, p5) -- line: 34
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = p1
	ImageLabel.Size = p2
	ImageLabel.Position = p3
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = p4
	ImageLabel.Parent = p5

	return ImageLabel
end
local function createTextLabel(p6, p7, p8, p9) -- line: 46
	-- upvalues: v8 (copy)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = p6
	TextLabel.Size = UDim2.new(1, -4, 0, not v8 and 20 or 50)
	TextLabel.Position = UDim2.new(0, 2, 0, not v8 and -20 or -50)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextXAlignment = p7
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.FontSize = v8 and Enum.FontSize.Size48 or Enum.FontSize.Size18
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0.5
	TextLabel.TextStrokeColor3 = Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)
	TextLabel.Text = p8
	TextLabel.Parent = p9

	return TextLabel
end

local Frame = Instance.new("Frame")

Frame.Name = "VehicleHudFrame"
Frame.Size = UDim2.new(0, not v8 and 158 or 316, 0, not v8 and 14 or 50)
Frame.Position = UDim2.new(0.5, -(Frame.Size.X.Offset / 2), 1, -v9 - Frame.Size.Y.Offset)
Frame.BackgroundTransparency = 1
Frame.Visible = false
Frame.Parent = RobloxGui

local Frame2 = Instance.new("Frame")

Frame2.Name = "SpeedBarClippingFrame"
Frame2.Size = UDim2.new(0, 0, 0, not v8 and 4 or 24)
Frame2.Position = UDim2.new(0.5, not v8 and -71 or -142, 0.5, not v8 and -2 or -13)
Frame2.BackgroundTransparency = 1
Frame2.ClipsDescendants = true
Frame2.ZIndex = 2
Frame2.Parent = Frame

local uDim2 = UDim2.new(1, 0, 1, 0)
local uDim2_2 = UDim2.new(0, 0, 0, 1)
local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "HudBG"
ImageLabel.Size = uDim2
ImageLabel.Position = uDim2_2
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxasset://textures/ui/Vehicle/SpeedBarBKG.png"
ImageLabel.Parent = Frame

local uDim2_3 = UDim2.new(0, not v8 and 142 or 284, 0, not v8 and 4 or 24)
local uDim2_4 = UDim2.new(0.5, not v8 and -71 or -142, 0.5, not v8 and -2 or -13)
local ImageLabel2 = Instance.new("ImageLabel")

ImageLabel2.Name = "SpeedBG"
ImageLabel2.Size = uDim2_3
ImageLabel2.Position = uDim2_4
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Image = "rbxasset://textures/ui/Vehicle/SpeedBarEmpty.png"
ImageLabel2.Parent = Frame

local v20 = ImageLabel2
local uDim2_5 = UDim2.new(0, not v8 and 142 or 284, 1, 0)
local uDim2_6 = UDim2.new(0, 0, 0, 0)
local ImageLabel3 = Instance.new("ImageLabel")

ImageLabel3.Name = "SpeedBarImage"
ImageLabel3.Size = uDim2_5
ImageLabel3.Position = uDim2_6
ImageLabel3.BackgroundTransparency = 1
ImageLabel3.Image = "rbxasset://textures/ui/Vehicle/SpeedBar.png"
ImageLabel3.Parent = Frame2
createTextLabel("SpeedLabel", Enum.TextXAlignment.Left, "Speed", Frame)

local v24 = createTextLabel("SpeedText", Enum.TextXAlignment.Right, "0", Frame)

local function getHumanoid() -- line: 89
	-- upvalues: LocalPlayer (copy)
	local v45 = LocalPlayer and LocalPlayer.Character

	if v45 then
		for _, child in pairs(v45:GetChildren()) do
			if child:IsA("Humanoid") then
				return child
			end
		end
	end
end
local function onHeartbeat() -- line: 100
	-- upvalues: u4 (ref), v24 (copy), v20 (copy), Frame2 (copy), v8 (copy)
	if u4 then
		local magnitude = u4.Velocity.magnitude

		v24.Text = tostring((math.min(math.floor(magnitude), 9999)))

		local v49 = math.min(math.floor(magnitude / u4.MaxSpeed * v20.Size.X.Offset), v20.Size.X.Offset)

		Frame2.Size = UDim2.new(0, v49, 0, not v8 and 4 or 24)
	end
end
local function onVehicleSeatChanged(p10) -- line: 110
	-- upvalues: Frame (copy)
	if p10 == "HeadsUpDisplay" then
		Frame.Visible = not Frame.Visible
	end
end
local function onSeated(p11, p12) -- line: 116
	-- upvalues: u4 (ref), Frame (copy), u5 (ref), RunService (copy), onHeartbeat (copy), u6 (ref), onVehicleSeatChanged (copy)
	if p11 then
		if p12 and p12:IsA("VehicleSeat") then
			u4 = p12
			Frame.Visible = u4.HeadsUpDisplay
			u5 = RunService.Heartbeat:connect(onHeartbeat)
			u6 = u4.Changed:connect(onVehicleSeatChanged)

			return
		end
	elseif u4 then
		Frame.Visible = false
		u4 = nil

		if u5 then
			u5:disconnect()
			u5 = nil
		end

		if u6 then
			u6:disconnect()
			u6 = nil
		end
	end
end

local u29 = nil
local u30 = nil

local function disconnectSeatedConnection() -- line: 143
	-- upvalues: u29 (ref)
	if u29 then
		u29:Disconnect()
		u29 = nil
	end
end
local function disconnectChildAddedConnection() -- line: 150
	-- upvalues: u30 (ref)
	if u30 then
		u30:Disconnect()
		u30 = nil
	end
end
local function characterAdded(p13) -- line: 157
	-- upvalues: u29 (ref), u30 (ref), onSeated (copy)
	if u29 then
		u29:Disconnect()
		u29 = nil
	end

	if u30 then
		u30:Disconnect()
		u30 = nil
	end

	local Humanoid = p13:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		u29 = Humanoid.Seated:connect(onSeated)

		return
	end

	u30 = p13.ChildAdded:Connect(function(child) -- line: 167
		-- upvalues: u29 (ref), u30 (ref), onSeated (copy)
		if child:IsA("Humanoid") then
			if u29 then
				u29:Disconnect()
				u29 = nil
			end

			if u30 then
				u30:Disconnect()
				u30 = nil
			end

			u29 = child.Seated:connect(onSeated)
		end
	end)
end

if LocalPlayer.Character then
	characterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:connect(function(p14) -- line: 178
	-- upvalues: u4 (ref), Frame (copy), u5 (ref), u6 (ref), characterAdded (copy)
	if u4 then
		Frame.Visible = false
		u4 = nil

		if u5 then
			u5:disconnect()
			u5 = nil
		end

		if u6 then
			u6:disconnect()
			u6 = nil
		end
	end

	characterAdded(p14)
end)

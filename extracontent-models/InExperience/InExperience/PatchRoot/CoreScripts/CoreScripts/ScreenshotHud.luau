local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui.RobloxGui
local CaptureMaster = require(RobloxGui.Modules.CaptureMaster)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol
local Promise = require(CorePackages.Packages.Promise)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts

if not require(RobloxGui.Modules.Flags.GetFFlagScreenshotHudApi)() then
	return
end

local ScreenshotHud = GuiService:WaitForChild("ScreenshotHud")
local t1 = {
	Default = {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 180, 109)
	},
	Hovered = {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 232, 126)
	},
	Pressed = {
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.fromRGB(0, 232, 126)
	}
}
local u18 = nil
local u19 = nil
local t2 = {}
local t3 = {}
local u22 = nil
local u23 = false

local function createFrame(p1, p2) -- line: 72
	local Frame = Instance.new("Frame")

	Frame.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.Size = UDim2.new(1, 0, 1, 0)

	for k, v in pairs(p1) do
		Frame[k] = v
	end

	Frame.Parent = p2

	return Frame
end
local function createImageLabel(p3, p4, p5) -- line: 89
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Image = p3
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0, 0, 0, 0)
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)

	for k, v in pairs(p4) do
		ImageLabel[k] = v
	end

	ImageLabel.Parent = p5

	return ImageLabel
end
local function createImageButton(p6, p7, p8) -- line: 107
	local ImageButton = Instance.new("ImageButton")

	ImageButton.Image = p6
	ImageButton.BackgroundTransparency = 1
	ImageButton.BorderSizePixel = 0
	ImageButton.Position = UDim2.new(0, 0, 0, 0)
	ImageButton.Size = UDim2.new(1, 0, 1, 0)

	for k, v in pairs(p7) do
		ImageButton[k] = v
	end

	ImageButton.Parent = p8

	return ImageButton
end
local function createTextLabel(p9, p10, p11) -- line: 125
	-- upvalues: AppFonts (copy)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Text = p9
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Font = AppFonts.default:getMedium()
	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextSize = 20

	for k, v in pairs(p10) do
		TextLabel[k] = v
	end

	TextLabel.Parent = p11

	return TextLabel
end

local v28, v29 = GuiService:GetGuiInset()
local v30 = createFrame({
	Name = "ScreenshotHudFrame",
	Visible = false,
	Position = UDim2.new(0, -v28.X, 0, -v28.Y),
	Size = UDim2.new(1, v28.X + v29.X, 1, v28.Y + v29.Y)
}, RobloxGui)
local v31 = createFrame({
	Name = "ScreenshotHudContent",
	Visible = false,
	Position = UDim2.new(0, v28.X, 0, v28.Y),
	Size = UDim2.new(1, -v28.X - v29.X, 1, -v28.Y - v29.Y)
}, v30)
local v32 = createImageButton("", {
	AutoButtonColor = false,
	BackgroundTransparency = 0.5,
	Name = "CameraButton",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(0, 180, 109),
	Position = UDim2.new(0.5, 0, 1, -50),
	Size = UDim2.fromOffset(64, 64)
}, nil)
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 32)
UICorner.Parent = v32

local v34 = createImageLabel("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = t1.Default.BackgroundColor3,
	BackgroundTransparency = t1.Default.BackgroundTransparency,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(52, 52)
}, v32)
local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 26)
UICorner2.Parent = v34

local v36 = createImageLabel("rbxasset://textures/ui/ScreenshotHud/Camera.png", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(32, 32)
}, v34)
local v37 = createImageButton("", {
	BackgroundTransparency = 0,
	Name = "CloseButton",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(7, 7, 8),
	Position = UDim2.new(0.5, -66, 1, -50),
	Size = UDim2.fromOffset(48, 48)
}, nil)
local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 24)
UICorner3.Parent = v37
createImageLabel("rbxasset://textures/ui/ScreenshotHud/Close.png", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(32, 32)
}, v37)

local v39 = createImageButton("", {
	BackgroundTransparency = 0,
	Name = "CameraButton",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(0, 180, 109),
	Position = UDim2.new(1, -94, 1, -78),
	Size = UDim2.fromOffset(140, 36)
}, nil)
local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 18)
UICorner4.Parent = v39
createImageLabel("rbxasset://textures/ui/Controls/xboxY.png", {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 6, 0.5, 0),
	Size = UDim2.fromOffset(24, 24)
}, v39)
createTextLabel(RobloxTranslator:FormatByKey("CoreScripts.ScreenshotHud.Action.TakePhoto"), {
	TextScaled = true,
	TextWrapped = true,
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 30, 0.5, 0),
	Size = UDim2.new(1, -36, 0, 20)
}, v39)

local v41 = createImageButton("", {
	BackgroundTransparency = 0,
	Name = "CloseButton",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(7, 7, 8),
	Position = UDim2.new(1, -228, 1, -78),
	Size = UDim2.fromOffset(104, 36)
}, nil)
local UICorner5 = Instance.new("UICorner")

UICorner5.CornerRadius = UDim.new(0, 18)
UICorner5.Parent = v41
createImageLabel("rbxasset://textures/ui/Controls/xboxB.png", {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 6, 0.5, 0),
	Size = UDim2.fromOffset(24, 24)
}, v41)
createTextLabel(RobloxTranslator:FormatByKey("CoreScripts.ScreenshotHud.Action.Cancel"), {
	TextScaled = true,
	TextWrapped = true,
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 30, 0.5, 0),
	Size = UDim2.new(1, -36, 0, 20)
}, v41)

local v43 = createFrame({
	Active = true,
	BackgroundTransparency = 0.5,
	Name = "FlashOverlay",
	Visible = false,
	ZIndex = 3
}, v30)

local function checkOrRequestExternalStoragePermissions() -- line: 279
	-- upvalues: PermissionsProtocol (copy), Promise (copy)
	return PermissionsProtocol.default:checkOrRequestPermissions({ PermissionsProtocol.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p12) -- line: 284
		-- upvalues: PermissionsProtocol (copy), Promise (copy)
		return p12 == PermissionsProtocol.Status.AUTHORIZED and Promise.resolve() or Promise.reject()
	end)
end
local function getEnabledPlayerScreenGuis() -- line: 290
	-- upvalues: Players (copy)
	local descendants = Players.LocalPlayer.PlayerGui:GetDescendants()
	local t4 = {}

	for _, v in ipairs(descendants) do
		if v:IsA("ScreenGui") and v.Enabled then
			table.insert(t4, v)
		end
	end

	return t4
end
local function getEnabledCoreGuiTypes() -- line: 301
	-- upvalues: StarterGui (copy)
	local t5 = {}

	for _, v in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		if StarterGui:GetCoreGuiEnabled(v) then
			table.insert(t5, v)
		end
	end

	return t5
end
local function u47() -- line: 311
end
local function onCameraButtonActivated() -- line: 313
	-- upvalues: UserInputService (copy), checkOrRequestExternalStoragePermissions (copy), u47 (ref), CaptureMaster (copy)
	if UserInputService:GetPlatform() == Enum.Platform.Android then
		checkOrRequestExternalStoragePermissions():andThen(u47, function() -- line: 315
			-- upvalues: CaptureMaster (copy)
			CaptureMaster:ShowPermissionToast()
		end)

		return
	end

	u47()
end

function u47() -- line: 323
	-- upvalues: CaptureMaster (copy), u22 (ref), ScreenshotHud (copy), getEnabledPlayerScreenGuis (copy), getEnabledCoreGuiTypes (copy), StarterGui (copy), ProximityPromptService (copy), v31 (copy), Players (copy), CoreGui (copy), v43 (copy), v32 (copy), onCameraButtonActivated (copy), RbxAnalyticsService (copy)
	CaptureMaster:DismissNotification()

	if u22 then
		u22:Disconnect()
		u22 = nil
	end

	local v85 = false
	local v86 = false
	local v87 = nil

	if ScreenshotHud.HidePlayerGuiForCaptures then
		v87 = getEnabledPlayerScreenGuis()

		for _, v in ipairs(v87) do
			v.Enabled = false
		end

		v86 = true
	end

	local v90 = nil

	if ScreenshotHud.HideCoreGuiForCaptures then
		v90 = getEnabledCoreGuiTypes()

		for _, v in ipairs(v90) do
			StarterGui:SetCoreGuiEnabled(v, false)
		end

		v85 = true
	end

	local ProximityPromptServiceEnabled = ProximityPromptService.Enabled

	ProximityPromptService.Enabled = false
	v31.Visible = false
	wait(0.2)

	local t6 = {}

	for _, player in pairs(Players:GetPlayers()) do
		local v97 = player.Character and player.Character:WaitForChild("Humanoid")

		if v97 then
			t6[v97] = v97.DisplayDistanceType
			v97.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
	end

	CoreGui:TakeScreenshot()
	wait(0.2)
	v31.Visible = true
	v43.Visible = true
	wait(0.2)
	v43.Visible = false

	if not u22 then
		u22 = v32.Activated:connect(onCameraButtonActivated)
	end

	ProximityPromptService.Enabled = ProximityPromptServiceEnabled

	for _, player in pairs(Players:GetPlayers()) do
		local v100 = player.Character and player.Character:WaitForChild("Humanoid")

		if v100 and t6[v100] then
			v100.DisplayDistanceType = t6[v100]
		end
	end

	if v86 then
		for _, v in ipairs(v87) do
			v.Enabled = true
		end
	end

	if v85 then
		for _, v in ipairs(v90) do
			StarterGui:SetCoreGuiEnabled(v, true)
		end
	end

	if ScreenshotHud.CloseWhenScreenshotTaken then
		ScreenshotHud.Visible = false
	end

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "TakeScreenshot", {
		pid = tostring(game.PlaceId)
	})
end

local function isGamepad(p13) -- line: 424
	return p13.Name:match("^Gamepad*") ~= nil
end
local function updateGamepadButtons() -- line: 428
	-- upvalues: u18 (ref), u19 (ref), u23 (ref), v39 (copy), v32 (copy), v41 (copy), v37 (copy), v31 (copy), ScreenshotHud (copy)
	if u18 then
		u18.Parent = nil
	end

	if u19 then
		u19.Parent = nil
	end

	u18 = if not u23 then v32 else v39
	u19 = if not u23 then v37 else v41
	u18.Parent = v31
	u19.Parent = v31

	if ScreenshotHud.CameraButtonPosition ~= UDim2.fromOffset(0, 0) then
		u18.Position = ScreenshotHud.CameraButtonPosition
	end

	if ScreenshotHud.CloseButtonPosition ~= UDim2.fromOffset(0, 0) then
		u19.Position = ScreenshotHud.CloseButtonPosition
	end
end
local function onLastInputTypeChanged(p14) -- line: 453
	-- upvalues: UserInputService (copy), u23 (ref), updateGamepadButtons (copy)
	local v107 = (p14 or UserInputService:GetLastInputType()).Name:match("^Gamepad*") ~= nil

	if v107 ~= u23 then
		u23 = v107
		updateGamepadButtons()
	end
end
local function setupConnections() -- line: 469
	-- upvalues: v32 (copy), v34 (copy), t1 (copy), t2 (ref), u22 (ref), onCameraButtonActivated (copy), v37 (copy), ScreenshotHud (copy), ContextActionService (copy), t3 (ref), UserInputService (copy), u23 (ref), updateGamepadButtons (copy), onLastInputTypeChanged (copy)
	local connection = v32.InputBegan:Connect(function(input) -- line: 470
		-- upvalues: v34 (copy), t1 (copy)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			v34.BackgroundColor3 = t1.Hovered.BackgroundColor3
			v34.BackgroundTransparency = t1.Hovered.BackgroundTransparency

			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			v34.BackgroundColor3 = t1.Pressed.BackgroundColor3
			v34.BackgroundTransparency = t1.Pressed.BackgroundTransparency
		end
	end)

	table.insert(t2, connection)

	local connection2 = v32.InputEnded:Connect(function() -- line: 484
		-- upvalues: v34 (copy), t1 (copy)
		v34.BackgroundColor3 = t1.Default.BackgroundColor3
		v34.BackgroundTransparency = t1.Default.BackgroundTransparency
	end)

	table.insert(t2, connection2)

	if u22 then
		u22:Disconnect()
		u22 = nil
	end

	u22 = v32.Activated:connect(onCameraButtonActivated)
	table.insert(t2, u22)

	local v110 = v37.Activated:connect(function() -- line: 497
		-- upvalues: ScreenshotHud (copy)
		ScreenshotHud.Visible = false
	end)

	table.insert(t2, v110)

	local function gamepadHandleClose(_, p16, p17) -- line: 503
		-- upvalues: ScreenshotHud (copy)
		if p16 == Enum.UserInputState.End and p17.UserInputType.Name:match("^Gamepad*") ~= nil then
			ScreenshotHud.Visible = false
		end
	end

	ContextActionService:BindAction("ScreenshotHudGamepadClose", gamepadHandleClose, false, Enum.KeyCode.ButtonB)
	table.insert(t3, "ScreenshotHudGamepadClose")

	local function gamepadHandleCamera(_, p19, p20) -- line: 513
		-- upvalues: onCameraButtonActivated (copy)
		if p19 == Enum.UserInputState.End and p20.UserInputType.Name:match("^Gamepad*") ~= nil then
			onCameraButtonActivated()
		end
	end

	ContextActionService:BindAction("ScreenshotHudGamepadCamera", gamepadHandleCamera, false, Enum.KeyCode.ButtonY)
	table.insert(t3, "ScreenshotHudGamepadCamera")

	local v113 = UserInputService:GetLastInputType().Name:match("^Gamepad*") ~= nil

	if v113 ~= u23 then
		u23 = v113
		updateGamepadButtons()
	end

	local connection3 = UserInputService.LastInputTypeChanged:Connect(onLastInputTypeChanged)

	table.insert(t2, connection3)
end
local function disconnectAll() -- line: 528
	-- upvalues: t2 (ref), t3 (ref), ContextActionService (copy)
	for _, v in ipairs(t2) do
		v:Disconnect()
	end

	t2 = {}

	for _, v in ipairs(t3) do
		ContextActionService:UnbindAction(v)
	end

	t3 = {}
end
local function screenshotHudEnabled(b1: boolean) -- line: 541
	-- upvalues: v30 (copy), ScreenshotHud (copy), disconnectAll (copy), v31 (copy), v43 (copy), setupConnections (copy), CaptureMaster (copy), RbxAnalyticsService (copy)
	v30.Visible = ScreenshotHud.Visible
	disconnectAll()

	if ScreenshotHud.Visible then
		v31.Visible = true
		v43.Visible = false
		setupConnections()
		CaptureMaster:Start()
	end

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "ScreenshotHudEnabled", {
		pid = tostring(game.PlaceId),
		enabled = b1
	})
end

ScreenshotHud:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 558
	-- upvalues: screenshotHudEnabled (copy), ScreenshotHud (copy)
	screenshotHudEnabled(ScreenshotHud.Visible)
end)
ScreenshotHud:GetPropertyChangedSignal("CameraButtonIcon"):Connect(function() -- line: 562
	-- upvalues: v36 (copy), ScreenshotHud (copy), RbxAnalyticsService (copy)
	v36.Image = ScreenshotHud.CameraButtonIcon or "rbxasset://textures/ui/ScreenshotHud/Camera.png"
	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CameraButtonIcon", {
		pid = tostring(game.PlaceId),
		icon = ScreenshotHud.CameraButtonIcon
	})
end)
ScreenshotHud:GetPropertyChangedSignal("CameraButtonPosition"):Connect(function() -- line: 571
	-- upvalues: u18 (ref), ScreenshotHud (copy), RbxAnalyticsService (copy)
	u18.Position = ScreenshotHud.CameraButtonPosition
	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CameraButtonPosition", {
		pid = tostring(game.PlaceId),
		position = tostring(ScreenshotHud.CameraButtonPosition)
	})
end)
ScreenshotHud:GetPropertyChangedSignal("CloseButtonPosition"):Connect(function() -- line: 579
	-- upvalues: u19 (ref), ScreenshotHud (copy), RbxAnalyticsService (copy)
	u19.Position = ScreenshotHud.CloseButtonPosition
	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CloseButtonPosition", {
		pid = tostring(game.PlaceId),
		position = tostring(ScreenshotHud.CloseButtonPosition)
	})
end)
updateGamepadButtons()
screenshotHudEnabled(ScreenshotHud.Visible)

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

local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local Promise = require(CorePackages.Packages.Promise)

local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local GetFFlagScreenshotHudApi = require(RobloxGui.Modules.Flags.GetFFlagScreenshotHudApi)

if not GetFFlagScreenshotHudApi() then
	return
end

local screenshotHud = GuiService:WaitForChild("ScreenshotHud")

local v = {
	Default = { BackgroundColor3 = Color3.fromRGB(0, 180, 109), BackgroundTransparency = 0 },
	Hovered = { BackgroundColor3 = Color3.fromRGB(0, 232, 126), BackgroundTransparency = 0 },
	Pressed = { BackgroundColor3 = Color3.fromRGB(0, 232, 126), BackgroundTransparency = 0.5 }
}

local v2 = nil
local v3 = nil

local v4 = {}
local v5 = {}
local activatedConnection = nil
local v6 = false

local function createFrame(items, parent)
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.Size = UDim2.new(1, 0, 1, 0)

	for k, item in pairs(items) do
		frame[k] = item
	end

	frame.Parent = parent

	return frame
end

local function createImageLabel(image, items, parent)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = image

	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderSizePixel = 0
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.Size = UDim2.new(1, 0, 1, 0)

	for k, item in pairs(items) do
		imageLabel[k] = item
	end

	imageLabel.Parent = parent

	return imageLabel
end

local function createImageButton(image, items, parent)
	local imageButton = Instance.new("ImageButton")
	imageButton.Image = image

	imageButton.BackgroundTransparency = 1
	imageButton.BorderSizePixel = 0
	imageButton.Position = UDim2.new(0, 0, 0, 0)
	imageButton.Size = UDim2.new(1, 0, 1, 0)

	for k, item in pairs(items) do
		imageButton[k] = item
	end

	imageButton.Parent = parent

	return imageButton
end

local function createTextLabel(text, items, imageButton)
	local textLabel = Instance.new("TextLabel")
	textLabel.Text = text

	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Font = AppFonts.default:getMedium()
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextSize = 20

	for k, item in pairs(items) do
		textLabel[k] = item
	end

	textLabel.Parent = imageButton

	return textLabel
end

local guiInset, v7 = GuiService:GetGuiInset()
local frame = createFrame({
	Name = "ScreenshotHudFrame",
	Position = UDim2.new(0, -guiInset.X, 0, -guiInset.Y),
	Size = UDim2.new(1, guiInset.X + v7.X, 1, guiInset.Y + v7.Y),
	Visible = false
}, RobloxGui)

local frame2 = createFrame({
	Name = "ScreenshotHudContent",
	Position = UDim2.new(0, guiInset.X, 0, guiInset.Y),
	Size = UDim2.new(1, -guiInset.X - v7.X, 1, -guiInset.Y - v7.Y),
	Visible = false
}, frame)

local imageButton = createImageButton("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutoButtonColor = false,
	BackgroundColor3 = Color3.fromRGB(0, 180, 109),
	BackgroundTransparency = 0.5,
	Name = "CameraButton",
	Position = UDim2.new(0.5, 0, 1, -50),
	Size = UDim2.fromOffset(64, 64)
}, nil)

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 32)
uiCorner.Parent = imageButton

local imageLabel = createImageLabel("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = v.Default.BackgroundColor3,
	BackgroundTransparency = v.Default.BackgroundTransparency,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(52, 52)
}, imageButton)

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 26)
uiCorner2.Parent = imageLabel

local imageLabel2 = createImageLabel(
	"rbxasset://textures/ui/ScreenshotHud/Camera.png",
	{
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(32, 32)
	},
	imageLabel
)

local imageButton2 = createImageButton("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(7, 7, 8),
	BackgroundTransparency = 0,
	Name = "CloseButton",
	Position = UDim2.new(0.5, -66, 1, -50),
	Size = UDim2.fromOffset(48, 48)
}, nil)

local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(0, 24)
uiCorner3.Parent = imageButton2

createImageLabel(
	"rbxasset://textures/ui/ScreenshotHud/Close.png",
	{
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(32, 32)
	},
	imageButton2
)

local imageButton3 = createImageButton("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(0, 180, 109),
	BackgroundTransparency = 0,
	Name = "CameraButton",
	Position = UDim2.new(1, -94, 1, -78),
	Size = UDim2.fromOffset(140, 36)
}, nil)

local uiCorner4 = Instance.new("UICorner")
uiCorner4.CornerRadius = UDim.new(0, 18)
uiCorner4.Parent = imageButton3

createImageLabel(
	"rbxasset://textures/ui/Controls/xboxY.png",
	{
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 6, 0.5, 0),
		Size = UDim2.fromOffset(24, 24)
	},
	imageButton3
)

createTextLabel(RobloxTranslator:FormatByKey("CoreScripts.ScreenshotHud.Action.TakePhoto"), {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 30, 0.5, 0),
	Size = UDim2.new(1, -36, 0, 20),
	TextScaled = true,
	TextWrapped = true
}, imageButton3)

local imageButton4 = createImageButton("", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(7, 7, 8),
	BackgroundTransparency = 0,
	Name = "CloseButton",
	Position = UDim2.new(1, -228, 1, -78),
	Size = UDim2.fromOffset(104, 36)
}, nil)

local uiCorner5 = Instance.new("UICorner")
uiCorner5.CornerRadius = UDim.new(0, 18)
uiCorner5.Parent = imageButton4

createImageLabel(
	"rbxasset://textures/ui/Controls/xboxB.png",
	{
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 6, 0.5, 0),
		Size = UDim2.fromOffset(24, 24)
	},
	imageButton4
)

createTextLabel(RobloxTranslator:FormatByKey("CoreScripts.ScreenshotHud.Action.Cancel"), {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 30, 0.5, 0),
	Size = UDim2.new(1, -36, 0, 20),
	TextScaled = true,
	TextWrapped = true
}, imageButton4)

local frame3 = createFrame({
	Active = true,
	BackgroundTransparency = 0.5,
	Name = "FlashOverlay",
	Visible = false,
	ZIndex = 3
}, frame)

local function checkOrRequestExternalStoragePermissions()
	return permissionsProtocol.default:checkOrRequestPermissions({ permissionsProtocol.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p)
		return p == permissionsProtocol.Status.AUTHORIZED and Promise.resolve() or Promise.reject()
	end)
end

local function getEnabledPlayerScreenGuis()
	local descendants = Players.LocalPlayer.PlayerGui:GetDescendants()
	local screenGuis = {}

	for _, screenGui in ipairs(descendants) do
		if screenGui:IsA("ScreenGui") and screenGui.Enabled then
			table.insert(screenGuis, screenGui)
		end
	end

	return screenGuis
end

local function getEnabledCoreGuiTypes()
	local enabledCoreGuiTypes = {}

	for _, v8 in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		if StarterGui:GetCoreGuiEnabled(v8) then
			table.insert(enabledCoreGuiTypes, v8)
		end
	end

	return enabledCoreGuiTypes
end

local function fn() end

local function onCameraButtonActivated()
	if UserInputService:GetPlatform() == Enum.Platform.Android then
		checkOrRequestExternalStoragePermissions():andThen(fn, function()
			CaptureMaster:ShowPermissionToast()
		end)
	else
		fn()
	end
end

fn = function()
	CaptureMaster:DismissNotification()

	if activatedConnection then
		activatedConnection:Disconnect()
		activatedConnection = nil
	end

	local flag = false
	local v8, flag2

	if screenshotHud.HidePlayerGuiForCaptures then
		v8 = getEnabledPlayerScreenGuis()

		for _, v9 in ipairs(v8) do
			v9.Enabled = false
		end

		flag2 = true
	else
		flag2 = false
	end

	local v9

	if screenshotHud.HideCoreGuiForCaptures then
		v9 = getEnabledCoreGuiTypes()

		for _, v10 in ipairs(v9) do
			StarterGui:SetCoreGuiEnabled(v10, false)
		end

		flag = true
	end

	local enabled = ProximityPromptService.Enabled
	ProximityPromptService.Enabled = false

	frame2.Visible = false

	wait(0.2)

	local displayDistanceTypesByHumanoid = {}

	for _, v10 in pairs(Players:GetPlayers()) do
		local humanoid = v10.Character and v10.Character:WaitForChild("Humanoid")

		if not humanoid then
			continue
		end

		displayDistanceTypesByHumanoid[humanoid] = humanoid.DisplayDistanceType
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	CoreGui:TakeScreenshot()
	wait(0.2)

	frame2.Visible = true

	frame3.Visible = true

	wait(0.2)
	frame3.Visible = false

	if not activatedConnection then
		activatedConnection = imageButton.Activated:connect(onCameraButtonActivated)
	end

	ProximityPromptService.Enabled = enabled

	for _, v10 in pairs(Players:GetPlayers()) do
		local humanoid = v10.Character and v10.Character:WaitForChild("Humanoid")

		if humanoid and displayDistanceTypesByHumanoid[humanoid] then
			humanoid.DisplayDistanceType = displayDistanceTypesByHumanoid[humanoid]
		end
	end

	if flag2 then
		for _, v10 in ipairs(v8) do
			v10.Enabled = true
		end
	end

	if flag then
		for _, v10 in ipairs(v9) do
			StarterGui:SetCoreGuiEnabled(v10, true)
		end
	end

	if screenshotHud.CloseWhenScreenshotTaken then
		screenshotHud.Visible = false
	end

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "TakeScreenshot", {
		pid = tostring(game.PlaceId)
	})
end

local function isGamepad(p): boolean -- 3 equivalent calls inferred from this helper
	return p.Name:match("^Gamepad*") ~= nil
end

local function updateGamepadButtons()
	if v2 then
		v2.Parent = nil
	end

	if v3 then
		v3.Parent = nil
	end

	local parent = if v6 then imageButton3 else imageButton
	v2 = parent
	local parent2 = if v6 then imageButton4 else imageButton2
	v3 = parent2

	v2.Parent = frame2
	v3.Parent = frame2

	if screenshotHud.CameraButtonPosition ~= UDim2.fromOffset(0, 0) then
		v2.Position = screenshotHud.CameraButtonPosition
	end

	if screenshotHud.CloseButtonPosition ~= UDim2.fromOffset(0, 0) then
		v3.Position = screenshotHud.CloseButtonPosition
	end
end

local function onLastInputTypeChanged(p) -- 1 equivalent call inferred from this helper
	local gamepad = isGamepad(p or UserInputService:GetLastInputType()) -- inferred equivalent call

	if v6 ~= gamepad then
		v6 = gamepad
		updateGamepadButtons()
	end
end

local function setupConnections()
	local inputBeganConnection = imageButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			imageLabel.BackgroundColor3 = v.Hovered.BackgroundColor3
			imageLabel.BackgroundTransparency = v.Hovered.BackgroundTransparency
		elseif
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			imageLabel.BackgroundColor3 = v.Pressed.BackgroundColor3
			imageLabel.BackgroundTransparency = v.Pressed.BackgroundTransparency
		end
	end)
	table.insert(v4, inputBeganConnection)

	local inputEndedConnection = imageButton.InputEnded:Connect(function()
		imageLabel.BackgroundColor3 = v.Default.BackgroundColor3
		imageLabel.BackgroundTransparency = v.Default.BackgroundTransparency
	end)
	table.insert(v4, inputEndedConnection)

	if activatedConnection then
		activatedConnection:Disconnect()
		activatedConnection = nil
	end

	activatedConnection = imageButton.Activated:connect(onCameraButtonActivated)
	table.insert(v4, activatedConnection)

	local activatedConnection2 = imageButton2.Activated:connect(function()
		screenshotHud.Visible = false
	end)
	table.insert(v4, activatedConnection2)

	local function gamepadHandleClose(_, p, p2)
		if p == Enum.UserInputState.End and isGamepad(p2.UserInputType) then -- inferred equivalent call
			screenshotHud.Visible = false
		end
	end

	ContextActionService:BindAction("ScreenshotHudGamepadClose", gamepadHandleClose, false, Enum.KeyCode.ButtonB)
	table.insert(v5, "ScreenshotHudGamepadClose")

	local function gamepadHandleCamera(_, p, p2)
		if p == Enum.UserInputState.End and isGamepad(p2.UserInputType) then -- inferred equivalent call
			onCameraButtonActivated()
		end
	end

	ContextActionService:BindAction("ScreenshotHudGamepadCamera", gamepadHandleCamera, false, Enum.KeyCode.ButtonY)
	table.insert(v5, "ScreenshotHudGamepadCamera")
	onLastInputTypeChanged() -- inferred equivalent call
	local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(onLastInputTypeChanged)
	table.insert(v4, lastInputTypeChangedConnection)
end

local function disconnectAll()
	for _, connection in ipairs(v4) do
		connection:Disconnect()
	end

	v4 = {}

	for _, v8 in ipairs(v5) do
		ContextActionService:UnbindAction(v8)
	end

	v5 = {}
end

local function screenshotHudEnabled(visible: boolean)
	frame.Visible = screenshotHud.Visible
	disconnectAll()

	if screenshotHud.Visible then
		frame2.Visible = true
		frame3.Visible = false
		setupConnections()
		CaptureMaster:Start()
	end

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "ScreenshotHudEnabled", {
		pid = tostring(game.PlaceId),
		enabled = visible
	})
end

screenshotHud:GetPropertyChangedSignal("Visible"):Connect(function()
	screenshotHudEnabled(screenshotHud.Visible)
end)

screenshotHud:GetPropertyChangedSignal("CameraButtonIcon"):Connect(function()
	imageLabel2.Image = screenshotHud.CameraButtonIcon or "rbxasset://textures/ui/ScreenshotHud/Camera.png"

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CameraButtonIcon", {
		pid = tostring(game.PlaceId),
		icon = screenshotHud.CameraButtonIcon
	})
end)

screenshotHud:GetPropertyChangedSignal("CameraButtonPosition"):Connect(function()
	v2.Position = screenshotHud.CameraButtonPosition

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CameraButtonPosition", {
		pid = tostring(game.PlaceId),
		position = tostring(screenshotHud.CameraButtonPosition)
	})
end)
screenshotHud:GetPropertyChangedSignal("CloseButtonPosition"):Connect(function()
	v3.Position = screenshotHud.CloseButtonPosition

	RbxAnalyticsService:SendEventDeferred("client", "screenshotHud", "CloseButtonPosition", {
		pid = tostring(game.PlaceId),
		position = tostring(screenshotHud.CloseButtonPosition)
	})
end)

updateGamepadButtons()
screenshotHudEnabled(screenshotHud.Visible)

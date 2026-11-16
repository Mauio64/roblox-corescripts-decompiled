local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface

local avatarContextMenu = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("AvatarContextMenu")
require(avatarContextMenu.ThemeHandler)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end

local class = {}
class.__index = class

function class.GetHeadshotForPlayer(_, p)
	return "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=150&h=150"
end

function class.HasOrGettingHeadShot(p, p2): boolean
	return p.HeadShotUrlCache[p2] ~= nil
end

function class.FindPlayerFromPart(_, model)
	if model and model.Parent then
		while model and not model:IsA("Model") do
			model = model.Parent
		end

		if model then
			return Players:GetPlayerFromCharacter(model)
		end
	end

	return nil
end

function class.GetPlayerPosition(_, player)
	local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

	return if humanoidRootPart then humanoidRootPart.Position else nil
end

local flag = true

function class.DisablePlayerMovement(_)
	if not flag then
		return
	end

	flag = false

	ContextActionService:BindCoreActionAtPriority("AvatarContextMenuStopInput", function(_, p)
		if p == Enum.UserInputState.End then
			return Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.Low.Value, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)
end

function class.EnablePlayerMovement(_)
	if flag then
		return
	end

	flag = true

	ContextActionService:UnbindCoreAction("AvatarContextMenuStopInput")
end

function class:GetFriendStatus(p)
	local success, result = pcall(function()
		return LocalPlayer:GetFriendStatus(p)
	end)

	return if success then result else Enum.FriendStatus.NotFriend
end

local v = {}
coroutine.wrap(function()
	RobloxReplicatedStorage:WaitForChild("CanChatWith", 1e999).OnClientEvent:Connect(function(...)
		local v2 = { ... }

		if #v2 == 1 then
			local v3 = v2[1]

			for k, v4 in pairs(v3) do
				v[k] = v4
			end
		elseif #v2 == 2 then
			v[v2[1]] = v2[2]
		end
	end)
end)()
function class.GetCanChatWith(_, p)
	return not BlockingUtility:IsPlayerBlockedByUserId(p.UserId) and (v[p.UserId] == nil or v[p.UserId])
end

local imageLabel = Instance.new("ImageLabel")
imageLabel.Image = ""
imageLabel.BackgroundTransparency = 1

local function MakeDefaultButton(name, size, callback, data)
	local imageButton = Instance.new("ImageButton")
	imageButton.Name = name
	imageButton.Image = data.ButtonImage
	imageButton.ScaleType = data.ButtonImageScaleType
	imageButton.SliceCenter = data.ButtonImageSliceCenter
	imageButton.BackgroundColor3 = data.ButtonColor
	imageButton.BackgroundTransparency = data.ButtonTransparency
	imageButton.AutoButtonColor = false
	imageButton.Size = size
	imageButton.ZIndex = 2
	imageButton.SelectionImageObject = imageLabel
	imageButton.BorderSizePixel = 0

	local underline = Instance.new("Frame")
	underline.Name = "Underline"
	underline.BackgroundColor3 = data.ButtonUnderlineColor
	underline.AnchorPoint = Vector2.new(0.5, 1)
	underline.BorderSizePixel = 0
	underline.Position = UDim2.new(0.5, 0, 1, 0)
	underline.Size = UDim2.new(0.95, 0, 0, 1)
	underline.Parent = imageButton

	if callback then
		imageButton.MouseButton1Click:Connect(function()
			callback(UserInputService:GetLastInputType())
		end)
	end

	local function isPointerInput(p): boolean
		return p.UserInputType == Enum.UserInputType.MouseMovement or p.UserInputType == Enum.UserInputType.Touch
	end

	local function selectButton() -- 3 equivalent calls inferred from this helper
		imageButton.BackgroundColor3 = data.ButtonHoverColor
		imageButton.BackgroundTransparency = data.ButtonHoverTransparency
	end

	local function deselectButton() -- 4 equivalent calls inferred from this helper
		imageButton.BackgroundColor3 = data.ButtonColor
		imageButton.BackgroundTransparency = data.ButtonTransparency
	end

	imageButton.InputBegan:Connect(function(input)
		if
			imageButton.Selectable
			and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
		then
			selectButton() -- inferred equivalent call
			input:GetPropertyChangedSignal("UserInputState"):connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					deselectButton() -- inferred equivalent call
				end
			end)
		end
	end)
	imageButton.InputEnded:Connect(function(input)
		if
			imageButton.Selectable
			and GuiService.SelectedCoreObject ~= imageButton
			and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
		then
			deselectButton() -- inferred equivalent call
		end
	end)

	imageButton.SelectionGained:Connect(function()
		selectButton() -- inferred equivalent call
	end)
	imageButton.SelectionLost:Connect(function()
		deselectButton() -- inferred equivalent call
	end)

	GuiService.Changed:Connect(function(p)
		if p ~= "SelectedCoreObject" then
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= imageButton then
			deselectButton() -- inferred equivalent call
		elseif imageButton.Selectable then
			selectButton() -- inferred equivalent call
		end
	end)

	return imageButton
end

local function getViewportSize()
	while not workspace.CurrentCamera do
		workspace.Changed:Wait()
	end

	assert(workspace.CurrentCamera, "")

	while
		workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0)
		or workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1)
	do
		workspace.CurrentCamera.Changed:Wait()
	end

	return workspace.CurrentCamera.ViewportSize
end

local function isSmallTouchScreen() -- 1 equivalent call inferred from this helper
	local viewportSize = getViewportSize()
	return UserInputService.TouchEnabled and (viewportSize.Y < 500 or viewportSize.X < 700)
end

function class.MakeStyledButton(_, name, text, size, p, p2)
	local parent = MakeDefaultButton(name, size, p, p2)

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = name .. "TextLabel"
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Size = UDim2.new(1, 0, 1, -8)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Font = p2.Font
	textLabel.TextSize = 24 * p2.TextScale

	if isSmallTouchScreen() then -- inferred equivalent call
		textLabel.TextSize = 18 * p2.TextScale
	elseif isTenFootInterface() then
		textLabel.TextSize = 36 * p2.TextScale
	end

	textLabel.Text = text
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.ZIndex = 2
	textLabel.Parent = parent

	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", textLabel)
	uiTextSizeConstraint.MaxTextSize = textLabel.TextSize

	return parent, textLabel
end

function class.new()
	return (setmetatable({}, class))
end

return class.new()

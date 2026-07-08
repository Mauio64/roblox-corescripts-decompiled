local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")
local AvatarContextMenu = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("AvatarContextMenu")

require(AvatarContextMenu.ThemeHandler)

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end

local t1 = {}

t1.__index = t1

function t1.GetHeadshotForPlayer(_, p2) -- line: 47
	return "rbxthumb://type=AvatarHeadShot&id=" .. p2.UserId .. "&w=150&h=150"
end
function t1.HasOrGettingHeadShot(p3, p4) -- line: 51
	return p3.HeadShotUrlCache[p4] ~= nil
end
function t1.FindPlayerFromPart(_, p6) -- line: 55
	-- upvalues: Players (copy)
	if p6 and p6.Parent then
		while p6 and not p6:IsA("Model") do
			p6 = p6.Parent
		end

		if p6 then
			return Players:GetPlayerFromCharacter(p6)
		end
	end

	return nil
end
function t1.GetPlayerPosition(_, p8) -- line: 68
	if p8.Character then
		local HumanoidRootPart = p8.Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			return HumanoidRootPart.Position
		end
	end

	return nil
end

local u12 = true

function t1.DisablePlayerMovement(_) -- line: 80
	-- upvalues: u12 (ref), ContextActionService (copy)
	if not u12 then
		return
	end

	u12 = false
	ContextActionService:BindCoreActionAtPriority("AvatarContextMenuStopInput", function(_, p11) -- line: 84
		if p11 == Enum.UserInputState.End then
			return Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.Low.Value, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)
end
function t1.EnablePlayerMovement(_) -- line: 101
	-- upvalues: u12 (ref), ContextActionService (copy)
	if u12 then
		return
	end

	u12 = true
	ContextActionService:UnbindCoreAction("AvatarContextMenuStopInput")
end
function t1.GetFriendStatus(_, p14) -- line: 108
	-- upvalues: LocalPlayer (ref)
	local ok, result = pcall(function() -- line: 109
		-- upvalues: LocalPlayer (ref), p14 (copy)
		return LocalPlayer:GetFriendStatus(p14)
	end)

	if ok then
		return result
	end

	return Enum.FriendStatus.NotFriend
end

local t2 = {}

coroutine.wrap(function() -- line: 121
	-- upvalues: RobloxReplicatedStorage (copy), t2 (copy)
	RobloxReplicatedStorage:WaitForChild("CanChatWith", 1e999).OnClientEvent:Connect(function(...) -- line: 124
		-- upvalues: t2 (copy)
		local t3 = { ... }

		if #t3 == 1 then
			local v57 = t3[1]

			for k, v in pairs(v57) do
				t2[k] = v
			end

			return
		end

		if #t3 == 2 then
			t2[t3[1]] = t3[2]
		end
	end)
end)()

function t1.GetCanChatWith(_, p16) -- line: 140
	-- upvalues: BlockingUtility (copy), t2 (copy)
	if BlockingUtility:IsPlayerBlockedByUserId(p16.UserId) then
		return false
	end

	if t2[p16.UserId] ~= nil then
		return t2[p16.UserId]
	end

	return true
end

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Image = ""
ImageLabel.BackgroundTransparency = 1

local function MakeDefaultButton(p17, p18, p19, p20) -- line: 156
	-- upvalues: ImageLabel (copy), UserInputService (copy), GuiService (copy)
	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = p17
	ImageButton.Image = p20.ButtonImage
	ImageButton.ScaleType = p20.ButtonImageScaleType
	ImageButton.SliceCenter = p20.ButtonImageSliceCenter
	ImageButton.BackgroundColor3 = p20.ButtonColor
	ImageButton.BackgroundTransparency = p20.ButtonTransparency
	ImageButton.AutoButtonColor = false
	ImageButton.Size = p18
	ImageButton.ZIndex = 2
	ImageButton.SelectionImageObject = ImageLabel
	ImageButton.BorderSizePixel = 0

	local Frame = Instance.new("Frame")

	Frame.Name = "Underline"
	Frame.BackgroundColor3 = p20.ButtonUnderlineColor
	Frame.AnchorPoint = Vector2.new(0.5, 1)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.5, 0, 1, 0)
	Frame.Size = UDim2.new(0.95, 0, 0, 1)
	Frame.Parent = ImageButton

	if p19 then
		ImageButton.MouseButton1Click:Connect(function() -- line: 181
			-- upvalues: p19 (copy), UserInputService (copy)
			p19(UserInputService:GetLastInputType())
		end)
	end

	local function isPointerInput(p21) -- line: 186
		return p21.UserInputType == Enum.UserInputType.MouseMovement or p21.UserInputType == Enum.UserInputType.Touch
	end
	local function selectButton() -- line: 190
		-- upvalues: ImageButton (copy), p20 (copy)
		ImageButton.BackgroundColor3 = p20.ButtonHoverColor
		ImageButton.BackgroundTransparency = p20.ButtonHoverTransparency
	end
	local function deselectButton() -- line: 195
		-- upvalues: ImageButton (copy), p20 (copy)
		ImageButton.BackgroundColor3 = p20.ButtonColor
		ImageButton.BackgroundTransparency = p20.ButtonTransparency
	end

	ImageButton.InputBegan:Connect(function(input) -- line: 200
		-- upvalues: ImageButton (copy), p20 (copy)
		if ImageButton.Selectable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			ImageButton.BackgroundColor3 = p20.ButtonHoverColor
			ImageButton.BackgroundTransparency = p20.ButtonHoverTransparency
			input:GetPropertyChangedSignal("UserInputState"):connect(function() -- line: 203
				-- upvalues: input (copy), ImageButton (copy), p20 (copy)
				if input.UserInputState == Enum.UserInputState.End then
					ImageButton.BackgroundColor3 = p20.ButtonColor
					ImageButton.BackgroundTransparency = p20.ButtonTransparency
				end
			end)
		end
	end)
	ImageButton.InputEnded:Connect(function(input) -- line: 210
		-- upvalues: ImageButton (copy), GuiService (copy), p20 (copy)
		if ImageButton.Selectable and (GuiService.SelectedCoreObject ~= ImageButton and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
			ImageButton.BackgroundColor3 = p20.ButtonColor
			ImageButton.BackgroundTransparency = p20.ButtonTransparency
		end
	end)
	ImageButton.SelectionGained:Connect(function() -- line: 216
		-- upvalues: ImageButton (copy), p20 (copy)
		ImageButton.BackgroundColor3 = p20.ButtonHoverColor
		ImageButton.BackgroundTransparency = p20.ButtonHoverTransparency
	end)
	ImageButton.SelectionLost:Connect(function() -- line: 219
		-- upvalues: ImageButton (copy), p20 (copy)
		ImageButton.BackgroundColor3 = p20.ButtonColor
		ImageButton.BackgroundTransparency = p20.ButtonTransparency
	end)
	GuiService.Changed:Connect(function(property) -- line: 223
		-- upvalues: GuiService (copy), ImageButton (copy), p20 (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= ImageButton then
			ImageButton.BackgroundColor3 = p20.ButtonColor
			ImageButton.BackgroundTransparency = p20.ButtonTransparency

			return
		end

		if ImageButton.Selectable then
			ImageButton.BackgroundColor3 = p20.ButtonHoverColor
			ImageButton.BackgroundTransparency = p20.ButtonHoverTransparency
		end
	end)

	return ImageButton
end
local function getViewportSize() -- line: 239
	while not workspace.CurrentCamera do
		workspace.Changed:Wait()
	end

	assert(workspace.CurrentCamera, "")

	while workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) or workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) do
		workspace.CurrentCamera.Changed:Wait()
	end

	return workspace.CurrentCamera.ViewportSize
end
local function isSmallTouchScreen() -- line: 255
	-- upvalues: getViewportSize (copy), UserInputService (copy)
	local v44 = getViewportSize()

	return UserInputService.TouchEnabled and (v44.Y < 500 or v44.X < 700)
end

function t1.MakeStyledButton(_, p23, p24, p25, p26, p27) -- line: 260
	-- upvalues: MakeDefaultButton (copy), getViewportSize (copy), UserInputService (copy), GuiService (copy)
	local v51 = MakeDefaultButton(p23, p25, p26, p27)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = p23 .. "TextLabel"
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, 0, 1, -8)
	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel.Font = p27.Font
	TextLabel.TextSize = 24 * p27.TextScale

	local v53 = getViewportSize()

	if UserInputService.TouchEnabled and (v53.Y < 500 or v53.X < 700) then
		TextLabel.TextSize = 18 * p27.TextScale
	elseif GuiService:IsTenFootInterface() then
		TextLabel.TextSize = 36 * p27.TextScale
	end

	TextLabel.Text = p24
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = true
	TextLabel.ZIndex = 2
	TextLabel.Parent = v51
	Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = TextLabel.TextSize

	return v51, TextLabel
end
function t1.new() -- line: 290
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end

return t1.new()

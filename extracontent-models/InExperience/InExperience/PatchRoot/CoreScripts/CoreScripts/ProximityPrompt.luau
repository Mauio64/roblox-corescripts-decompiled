local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RobloxGui = CoreGui.RobloxGui

local CoreUtility = require(RobloxGui.Modules.CoreUtility)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts

local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local parent2 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerGui")

local v = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
}

if UserInputService:GetPlatform() == Enum.Platform.OSX then
	v[Enum.KeyCode.LeftMeta] = "rbxasset://textures/ui/Controls/command.png"
	v[Enum.KeyCode.RightMeta] = "rbxasset://textures/ui/Controls/command.png"
	v[Enum.KeyCode.LeftAlt] = "rbxasset://textures/ui/Controls/option.png"
	v[Enum.KeyCode.RightAlt] = "rbxasset://textures/ui/Controls/option.png"
end

local v2 = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png"
}

local v3 = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12"
}

v3[Enum.KeyCode.PageUp] = "PgUp"
v3[Enum.KeyCode.PageDown] = "PgDn"
v3[Enum.KeyCode.Home] = "Home"
v3[Enum.KeyCode.End] = "End"
v3[Enum.KeyCode.Insert] = "Ins"
v3[Enum.KeyCode.Delete] = "Del"

local v4 = {
	[Enum.KeyCode.LeftControl] = 12,
	[Enum.KeyCode.RightControl] = 12,
	[Enum.KeyCode.LeftAlt] = 12,
	[Enum.KeyCode.RightAlt] = 12,
	[Enum.KeyCode.F10] = 12,
	[Enum.KeyCode.F11] = 12,
	[Enum.KeyCode.F12] = 12,
	[Enum.KeyCode.PageUp] = 8,
	[Enum.KeyCode.PageDown] = 8,
	[Enum.KeyCode.Home] = 8,
	[Enum.KeyCode.End] = 10,
	[Enum.KeyCode.Insert] = 10,
	[Enum.KeyCode.Delete] = 10
}

local color = Color3.new(0.07, 0.07, 0.07)
local color2 = Color3.new(1, 1, 1)
local color3 = Color3.new(0.7, 0.7, 0.7)

local tweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function getScreenGui() -- 2 equivalent calls inferred from this helper
	local proximityPrompts = parent2:FindFirstChild("ProximityPrompts")

	if proximityPrompts ~= nil then
		return proximityPrompts
	end

	proximityPrompts = Instance.new("ScreenGui")
	proximityPrompts.Name = "ProximityPrompts"
	proximityPrompts.ResetOnSpawn = false
	proximityPrompts.Parent = parent2
	proximityPrompts.IgnoreGuiInset = true

	return proximityPrompts
end

local function createProgressBarGradient(circularProgressBar, p, list, list2)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0.5, 1)
	frame.Position = UDim2.fromScale(p and 0 or 0.5, 0)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = true
	frame.Visible = false
	frame.Parent = circularProgressBar

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.fromScale(2, 1)
	imageLabel.Position = UDim2.fromScale(p and 0 or -1, 0)
	imageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	imageLabel.Parent = frame

	local uiGradient = Instance.new("UIGradient")
	uiGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.51, 1),
		NumberSequenceKeypoint.new(1, 1)
	})

	uiGradient.Rotation = p and 180 or 0
	uiGradient.Parent = imageLabel

	table.insert(list, TweenService:Create(imageLabel, tweenInfo, { ImageTransparency = 1 }))
	table.insert(list2, TweenService:Create(imageLabel, tweenInfo, { ImageTransparency = 0 }))

	return uiGradient, frame
end

local function createCircularProgressBar(p, p2)
	local circularProgressBar = Instance.new("Frame")
	circularProgressBar.Name = "CircularProgressBar"
	circularProgressBar.Size = UDim2.fromOffset(58, 58)
	circularProgressBar.AnchorPoint = Vector2.new(0.5, 0.5)
	circularProgressBar.Position = UDim2.fromScale(0.5, 0.5)
	circularProgressBar.BackgroundTransparency = 1

	local progressBarGradient, parent = createProgressBarGradient(circularProgressBar, true, p, p2)
	local progressBarGradient2, parent3 = createProgressBarGradient(circularProgressBar, false, p, p2)

	local progress = Instance.new("NumberValue")
	progress.Name = "Progress"
	progress.Parent = circularProgressBar
	progress.Changed:Connect(function(p3)
		local v5 = math.clamp(p3 * 360, 0, 360)
		parent.Visible = progress.Value > 0.5
		progressBarGradient.Rotation = math.clamp(v5, 180, 360)
		parent3.Visible = progress.Value > 0.01
		progressBarGradient2.Rotation = math.clamp(v5, 0, 180)
	end)

	return circularProgressBar
end

local function createPrompt(instance, p, parent)
	local v5 = {}
	local v6 = {}
	local v7 = {}
	local v8 = {}
	local tweenInfo4 = TweenInfo.new(instance.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local prompt = Instance.new("BillboardGui")
	prompt.Name = "Prompt"
	prompt.AlwaysOnTop = true

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0.5, 1)
	frame.BackgroundTransparency = 1
	frame.BackgroundColor3 = color
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.fromScale(0.5, 0)
	frame.Size = UDim2.fromScale(0, 1)
	frame.AutomaticSize = Enum.AutomaticSize.X
	frame.Parent = prompt

	local uiPadding = Instance.new("UIPadding")
	uiPadding.Parent = frame

	local uiCorner_2 = Instance.new("UICorner")
	uiCorner_2.Parent = frame

	local inputFrame = Instance.new("Frame")
	inputFrame.Name = "InputFrame"
	inputFrame.Size = UDim2.fromScale(1, 1)
	inputFrame.BackgroundTransparency = 1
	inputFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	inputFrame.Parent = frame

	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.fromScale(1, 1)
	frame2.Position = UDim2.fromScale(0.5, 0.5)
	frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	frame2.BackgroundTransparency = 1
	frame2.Parent = inputFrame

	local uiScale = Instance.new("UIScale")
	uiScale.Parent = frame2

	table.insert(v5, TweenService:Create(uiScale, tweenInfo3, {
		Scale = p == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
	}))
	table.insert(v6, TweenService:Create(uiScale, tweenInfo3, { Scale = 1 }))

	local actionText = Instance.new("TextLabel")
	actionText.Name = "ActionText"
	actionText.Font = AppFonts.default:getMedium()
	actionText.TextSize = 19
	actionText.BackgroundTransparency = 1
	actionText.TextTransparency = 1
	actionText.TextColor3 = color2
	actionText.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(v5, TweenService:Create(actionText, tweenInfo3, { TextTransparency = 1 }))
	table.insert(v6, TweenService:Create(actionText, tweenInfo3, { TextTransparency = 0 }))
	table.insert(v7, TweenService:Create(actionText, tweenInfo3, { TextTransparency = 1 }))
	table.insert(v8, TweenService:Create(actionText, tweenInfo3, { TextTransparency = 0 }))

	local objectText = Instance.new("TextLabel")
	objectText.Name = "ObjectText"
	objectText.Font = AppFonts.default:getMedium()
	objectText.TextSize = 14
	objectText.BackgroundTransparency = 1
	objectText.TextTransparency = 1
	objectText.TextColor3 = color3
	objectText.TextXAlignment = Enum.TextXAlignment.Left

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(-0.25, 0)
	uiListLayout.Parent = frame
	table.insert(v5, TweenService:Create(uiListLayout, tweenInfo3, { Padding = UDim.new(-0.25, 0) }))
	table.insert(v6, TweenService:Create(uiListLayout, tweenInfo3, { Padding = UDim.new(0, 0) }))
	table.insert(v7, TweenService:Create(uiListLayout, tweenInfo3, { Padding = UDim.new(-0.25, 0) }))
	table.insert(v8, TweenService:Create(uiListLayout, tweenInfo3, { Padding = UDim.new(0, 0) }))

	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.fromScale(0, 1)
	textFrame.AutomaticSize = Enum.AutomaticSize.X
	textFrame.BackgroundTransparency = 1
	textFrame.Parent = frame

	actionText.Size = UDim2.fromScale(0, 1)
	actionText.AutomaticSize = Enum.AutomaticSize.X
	actionText.Parent = textFrame

	objectText.Size = UDim2.fromScale(0, 1)
	objectText.AutomaticSize = Enum.AutomaticSize.X
	objectText.Parent = textFrame

	table.insert(v5, TweenService:Create(objectText, tweenInfo3, { TextTransparency = 1 }))
	table.insert(v6, TweenService:Create(objectText, tweenInfo3, { TextTransparency = 0 }))
	table.insert(v7, TweenService:Create(objectText, tweenInfo3, { TextTransparency = 1 }))
	table.insert(v8, TweenService:Create(objectText, tweenInfo3, { TextTransparency = 0 }))

	table.insert(v5, TweenService:Create(frame, tweenInfo3, { BackgroundTransparency = 1 }))
	table.insert(v6, TweenService:Create(frame, tweenInfo3, { BackgroundTransparency = 0.2 }))
	table.insert(v7, TweenService:Create(frame, tweenInfo3, { BackgroundTransparency = 1 }))
	table.insert(v8, TweenService:Create(frame, tweenInfo3, { BackgroundTransparency = 0.2 }))

	local roundFrame = Instance.new("Frame")
	roundFrame.Name = "RoundFrame"
	roundFrame.Size = UDim2.fromOffset(48, 48)

	roundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	roundFrame.Position = UDim2.fromScale(0.5, 0.5)
	roundFrame.BackgroundTransparency = 1
	roundFrame.Parent = frame2

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0.5, 0)
	uiCorner.Parent = roundFrame

	table.insert(v7, TweenService:Create(roundFrame, tweenInfo, { BackgroundTransparency = 1 }))
	table.insert(v8, TweenService:Create(roundFrame, tweenInfo, { BackgroundTransparency = 0.5 }))

	if p == Enum.ProximityPromptInputType.Gamepad then
		local imageForKeyCode = UserInputService:GetImageForKeyCode(instance.GamepadKeyCode)

		if imageForKeyCode then
			local buttonImage = Instance.new("ImageLabel")
			buttonImage.Name = "ButtonImage"
			buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
			buttonImage.Size = UDim2.fromOffset(24, 24)
			buttonImage.Position = UDim2.fromScale(0.5, 0.5)
			buttonImage.BackgroundTransparency = 1
			buttonImage.ImageTransparency = 1
			buttonImage.Image = imageForKeyCode
			buttonImage.Parent = frame2
			table.insert(v7, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 1 }))
			table.insert(v8, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 0 }))
		end
	elseif p == Enum.ProximityPromptInputType.Touch then
		local buttonImage = Instance.new("ImageLabel")
		buttonImage.Name = "ButtonImage"
		buttonImage.BackgroundTransparency = 1
		buttonImage.ImageTransparency = 1
		buttonImage.Size = UDim2.fromOffset(25, 31)
		buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		buttonImage.Position = UDim2.fromScale(0.5, 0.5)
		buttonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		buttonImage.Parent = frame2

		table.insert(v7, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 1 }))
		table.insert(v8, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 0 }))
	else
		local buttonImage = Instance.new("ImageLabel")
		buttonImage.Name = "ButtonImage"
		buttonImage.BackgroundTransparency = 1
		buttonImage.ImageTransparency = 1
		buttonImage.Size = UDim2.fromOffset(28, 30)
		buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		buttonImage.Position = UDim2.fromScale(0.5, 0.5)
		buttonImage.Image = "rbxasset://textures/ui/Controls/key_single.png"
		buttonImage.Parent = frame2
		table.insert(v7, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 1 }))
		table.insert(v8, TweenService:Create(buttonImage, tweenInfo, { ImageTransparency = 0 }))

		local text = UserInputService:GetStringForKeyCode(instance.KeyboardKeyCode)

		local image = v[instance.KeyboardKeyCode]

		if image == nil then
			image = v2[text]
		end

		text = image == nil and v3[instance.KeyboardKeyCode] or text

		if image then
			local buttonImage2 = Instance.new("ImageLabel")
			buttonImage2.Name = "ButtonImage"
			buttonImage2.AnchorPoint = Vector2.new(0.5, 0.5)
			buttonImage2.Size = UDim2.fromOffset(36, 36)
			buttonImage2.Position = UDim2.fromScale(0.5, 0.5)
			buttonImage2.BackgroundTransparency = 1
			buttonImage2.ImageTransparency = 1
			buttonImage2.Image = image
			buttonImage2.Parent = frame2
			table.insert(v7, TweenService:Create(buttonImage2, tweenInfo, { ImageTransparency = 1 }))
			table.insert(v8, TweenService:Create(buttonImage2, tweenInfo, { ImageTransparency = 0 }))
		elseif text == nil or text == "" then
			error("ProximityPrompt '" .. instance.Name .. "' has an unsupported keycode for rendering UI: " .. tostring(instance.KeyboardKeyCode))
		else
			local buttonText = Instance.new("TextLabel")
			buttonText.Name = "ButtonText"
			buttonText.AutoLocalize = false
			buttonText.Position = UDim2.fromOffset(0, -1)
			buttonText.Size = UDim2.fromScale(1, 1)
			buttonText.Font = AppFonts.default:getMedium()

			local v9 = v4[instance.KeyboardKeyCode]
			buttonText.TextSize = v9 == nil and 14 or v9

			buttonText.BackgroundTransparency = 1
			buttonText.TextTransparency = 1
			buttonText.TextColor3 = color2
			buttonText.TextXAlignment = Enum.TextXAlignment.Center
			buttonText.Text = text
			buttonText.Parent = frame2
			table.insert(v7, TweenService:Create(buttonText, tweenInfo, { TextTransparency = 1 }))
			table.insert(v8, TweenService:Create(buttonText, tweenInfo, { TextTransparency = 0 }))
		end
	end

	if p == Enum.ProximityPromptInputType.Touch or instance.ClickablePrompt then
		local textButton = Instance.new("TextButton")
		textButton.BackgroundTransparency = 1
		textButton.TextTransparency = 1
		textButton.Size = UDim2.fromScale(1, 1)
		textButton.Parent = prompt
		textButton.Selectable = false

		local v9 = false

		textButton.InputBegan:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
				and input.UserInputState ~= Enum.UserInputState.Change
			then
				instance:InputHoldBegin()
				v9 = true
			end
		end)
		textButton.InputEnded:Connect(function(input)
			if
				(input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
				and v9
			then
				v9 = false
				instance:InputHoldEnd()
			end
		end)

		prompt.Active = true
	end

	if instance.HoldDuration > 0 then
		local circularProgressBar = createCircularProgressBar(v7, v8)
		circularProgressBar.Parent = frame2
		table.insert(v5, TweenService:Create(circularProgressBar.Progress, tweenInfo4, { Value = 1 }))
		table.insert(v6, TweenService:Create(circularProgressBar.Progress, tweenInfo2, { Value = 0 }))
	end

	local promptButtonHoldBeganConnection, promptButtonHoldEndedConnection

	if instance.HoldDuration > 0 then
		promptButtonHoldBeganConnection = instance.PromptButtonHoldBegan:Connect(function()
			for _, v9 in ipairs(v5) do
				v9:Play()
			end
		end)

		promptButtonHoldEndedConnection = instance.PromptButtonHoldEnded:Connect(function()
			for _, v9 in ipairs(v6) do
				v9:Play()
			end
		end)
	else
		promptButtonHoldBeganConnection = nil
		promptButtonHoldEndedConnection = nil
	end

	local triggeredConnection = instance.Triggered:Connect(function()
		for _, v9 in ipairs(v7) do
			v9:Play()
		end
	end)

	local triggerEndedConnection = instance.TriggerEnded:Connect(function()
		for _, v9 in ipairs(v8) do
			v9:Play()
		end
	end)

	local function updateUIFromPrompt()
		local v9 = 72

		local v10 = (instance.ObjectText == nil or instance.ObjectText == "") and 0 or 9

		actionText.Text = instance.ActionText
		objectText.Text = instance.ObjectText
		actionText.AutoLocalize = instance.AutoLocalize
		actionText.RootLocalizationTable = instance.RootLocalizationTable
		objectText.AutoLocalize = instance.AutoLocalize
		objectText.RootLocalizationTable = instance.RootLocalizationTable

		local v11 = 24 - v10

		if
			(instance.ActionText == nil or instance.ActionText == "")
			and (instance.ObjectText == nil or instance.ObjectText == "")
		then
			uiPadding.PaddingRight = UDim.new(0, 0)
		else
			uiPadding.PaddingRight = UDim.new(0, v11)
		end

		actionText.Position = UDim2.new(0, 0, 0, v10)
		objectText.Position = UDim2.new(0, 0, 0, -10)

		prompt.Size = UDim2.fromOffset(v9, 72)
		prompt.SizeOffset = Vector2.new(
			instance.UIOffset.X / prompt.Size.Width.Offset,
			instance.UIOffset.Y / prompt.Size.Height.Offset
		)

		task.defer(function()
			RunService.RenderStepped:Wait()
			RunService.RenderStepped:Wait()

			v9 = frame.AbsoluteSize.X
			prompt.Size = UDim2.fromOffset(v9, 72)
			prompt.SizeOffset = Vector2.new(
				instance.UIOffset.X / prompt.Size.Width.Offset,
				instance.UIOffset.Y / prompt.Size.Height.Offset
			)
		end)
	end

	local changedConnection = instance.Changed:Connect(updateUIFromPrompt)
	updateUIFromPrompt()

	prompt.Adornee = instance.Parent
	prompt.Parent = parent

	local function updateUIAncestry()
		prompt.Adornee = instance.Parent
	end
	local ancestryChangedConnection = instance.AncestryChanged:Connect(updateUIAncestry)

	for _, v9 in ipairs(v8) do
		v9:Play()
	end

	local function cleanup()
		if promptButtonHoldBeganConnection then
			promptButtonHoldBeganConnection:Disconnect()
		end

		if promptButtonHoldEndedConnection then
			promptButtonHoldEndedConnection:Disconnect()
		end

		triggeredConnection:Disconnect()
		triggerEndedConnection:Disconnect()
		changedConnection:Disconnect()
		ancestryChangedConnection:Disconnect()

		for _, v9 in ipairs(v7) do
			v9:Play()
		end

		wait(0.2)

		prompt.Parent = nil
	end

	return cleanup
end

local function createIndicator(instance, parent)
	local v5 = {}
	local v6 = {}

	local indicator = Instance.new("BillboardGui")
	indicator.Name = "Indicator"
	indicator.Size = UDim2.fromOffset(15, 15)
	indicator.AlwaysOnTop = true

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundTransparency = 1
	frame.BackgroundColor3 = color
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.fromScale(0.5, 0)
	frame.Parent = indicator

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = frame

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = color2
	uiStroke.Thickness = 1.5
	uiStroke.Transparency = 1
	uiStroke.Parent = frame

	table.insert(v5, TweenService:Create(frame, tweenInfo, { BackgroundTransparency = 1 }))
	table.insert(v5, TweenService:Create(uiStroke, tweenInfo, { Transparency = 1 }))
	table.insert(v6, TweenService:Create(frame, tweenInfo, { BackgroundTransparency = 0.2 }))
	table.insert(v6, TweenService:Create(uiStroke, tweenInfo, { Transparency = 0.2 }))

	indicator.Adornee = instance.Parent
	indicator.Parent = parent

	local function updateUIAncestry()
		indicator.Adornee = instance.Parent
	end
	local ancestryChangedConnection = instance.AncestryChanged:Connect(updateUIAncestry)

	for _, v7 in ipairs(v6) do
		v7:Play()
	end

	local function cleanup()
		ancestryChangedConnection:Disconnect()

		for _, v7 in ipairs(v5) do
			v7:Play()
		end

		wait(0.2)

		indicator.Parent = nil
	end

	return cleanup
end

local function onLoad()
	ProximityPromptService.PromptShown:Connect(function(instance, p)
		if instance.Style == Enum.ProximityPromptStyle.Custom then
			return
		end

		local prompt = createPrompt(instance, p, getScreenGui()) -- inferred equivalent call

		local bindableEvent = Instance.new("BindableEvent")
		local promptHiddenConnection = instance.PromptHidden:Connect(function()
			bindableEvent:Fire()
		end)
		local destroyingConnection = instance.Destroying:Connect(function()
			bindableEvent:Fire()
		end)
		bindableEvent.Event:Wait()
		promptHiddenConnection:Disconnect()
		destroyingConnection:Disconnect()

		prompt()
	end)

	ProximityPromptService.IndicatorShown:Connect(function(instance)
		if instance.Style == Enum.ProximityPromptStyle.Custom then
			return
		end

		local indicator = createIndicator(instance, getScreenGui()) -- inferred equivalent call

		local bindableEvent = Instance.new("BindableEvent")
		local indicatorHiddenConnection = instance.IndicatorHidden:Connect(function()
			bindableEvent:Fire()
		end)
		local destroyingConnection = instance.Destroying:Connect(function()
			bindableEvent:Fire()
		end)
		bindableEvent.Event:Wait()
		indicatorHiddenConnection:Disconnect()
		destroyingConnection:Disconnect()

		indicator()
	end)
end

onLoad()

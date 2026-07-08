local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RobloxGui = CoreGui.RobloxGui
local CoreUtility = require(RobloxGui.Modules.CoreUtility)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v12 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerGui")
local t1 = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
}

if UserInputService:GetPlatform() == Enum.Platform.OSX then
	t1[Enum.KeyCode.LeftMeta] = "rbxasset://textures/ui/Controls/command.png"
	t1[Enum.KeyCode.RightMeta] = "rbxasset://textures/ui/Controls/command.png"
	t1[Enum.KeyCode.LeftAlt] = "rbxasset://textures/ui/Controls/option.png"
	t1[Enum.KeyCode.RightAlt] = "rbxasset://textures/ui/Controls/option.png"
end

local t2 = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png"
}
local t3 = {
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
	[Enum.KeyCode.F12] = "F12",
	[Enum.KeyCode.PageUp] = "PgUp",
	[Enum.KeyCode.PageDown] = "PgDn",
	[Enum.KeyCode.Home] = "Home",
	[Enum.KeyCode.End] = "End",
	[Enum.KeyCode.Insert] = "Ins",
	[Enum.KeyCode.Delete] = "Del"
}
local t4 = {
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
local color3 = Color3.new(0.07, 0.07, 0.07)
local color3_2 = Color3.new(1, 1, 1)
local color3_3 = Color3.new(0.7, 0.7, 0.7)
local tweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function getScreenGui() -- line: 99
	-- upvalues: v12 (copy)
	local ProximityPrompts = v12:FindFirstChild("ProximityPrompts")

	if ProximityPrompts == nil then
		ProximityPrompts = Instance.new("ScreenGui")
		ProximityPrompts.Name = "ProximityPrompts"
		ProximityPrompts.ResetOnSpawn = false
		ProximityPrompts.Parent = v12
		ProximityPrompts.IgnoreGuiInset = true
	end

	return ProximityPrompts
end
local function createProgressBarGradient(p1, p2, p3, p4) -- line: 112
	-- upvalues: TweenService (copy), tweenInfo (copy)
	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(0.5, 1)
	Frame.Position = UDim2.fromScale(not p2 and 0.5 or 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.ClipsDescendants = true
	Frame.Visible = false
	Frame.Parent = p1

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Size = UDim2.fromScale(2, 1)
	ImageLabel.Position = UDim2.fromScale(not p2 and -1 or 0, 0)
	ImageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	ImageLabel.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.51, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
	UIGradient.Rotation = not p2 and 0 or 180
	UIGradient.Parent = ImageLabel
	table.insert(p3, TweenService:Create(ImageLabel, tweenInfo, {
		ImageTransparency = 1
	}))
	table.insert(p4, TweenService:Create(ImageLabel, tweenInfo, {
		ImageTransparency = 0
	}))

	return UIGradient, Frame
end
local function createCircularProgressBar(p5, p6) -- line: 144
	-- upvalues: createProgressBarGradient (copy)
	local Frame = Instance.new("Frame")

	Frame.Name = "CircularProgressBar"
	Frame.Size = UDim2.fromOffset(58, 58)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.fromScale(0.5, 0.5)
	Frame.BackgroundTransparency = 1

	local v40, v41 = createProgressBarGradient(Frame, true, p5, p6)
	local v42, v43 = createProgressBarGradient(Frame, false, p5, p6)
	local NumberValue = Instance.new("NumberValue")

	NumberValue.Name = "Progress"
	NumberValue.Parent = Frame
	NumberValue.Changed:Connect(function(property) -- line: 158
		-- upvalues: v41 (copy), NumberValue (copy), v40 (copy), v43 (copy), v42 (copy)
		local v104 = math.clamp(property * 360, 0, 360)

		v41.Visible = NumberValue.Value > 0.5
		v40.Rotation = math.clamp(v104, 180, 360)
		v43.Visible = NumberValue.Value > 0.01
		v42.Rotation = math.clamp(v104, 0, 180)
	end)

	return Frame
end
local function createPrompt(p7, p8, p9) -- line: 169
	-- upvalues: color3 (copy), TweenService (copy), tweenInfo3 (copy), AppFonts (copy), color3_2 (copy), color3_3 (copy), tweenInfo (copy), UserInputService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), createCircularProgressBar (copy), tweenInfo2 (copy), RunService (copy)
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local tweenInfo4 = TweenInfo.new(p7.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "Prompt"
	BillboardGui.AlwaysOnTop = true

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(0.5, 1)
	Frame.BackgroundTransparency = 1
	Frame.BackgroundColor3 = color3
	Frame.AnchorPoint = Vector2.new(0.5, 0)
	Frame.Position = UDim2.fromScale(0.5, 0)
	Frame.Size = UDim2.fromScale(0, 1)
	Frame.AutomaticSize = Enum.AutomaticSize.X
	Frame.Parent = BillboardGui

	local UIPadding = Instance.new("UIPadding")

	UIPadding.Parent = Frame
	Instance.new("UICorner").Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "InputFrame"
	Frame2.Size = UDim2.fromScale(1, 1)
	Frame2.BackgroundTransparency = 1
	Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.fromScale(1, 1)
	Frame3.Position = UDim2.fromScale(0.5, 0.5)
	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.BackgroundTransparency = 1
	Frame3.Parent = Frame2

	local UIScale = Instance.new("UIScale")

	UIScale.Parent = Frame3

	local v59 = p8 ~= Enum.ProximityPromptInputType.Touch and 1.33 or 1.6

	table.insert(t5, TweenService:Create(UIScale, tweenInfo3, {
		Scale = v59
	}))
	table.insert(t6, TweenService:Create(UIScale, tweenInfo3, {
		Scale = 1
	}))

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "ActionText"
	TextLabel.Font = AppFonts.default:getMedium()
	TextLabel.TextSize = 19
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextTransparency = 1
	TextLabel.TextColor3 = color3_2
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(t5, TweenService:Create(TextLabel, tweenInfo3, {
		TextTransparency = 1
	}))
	table.insert(t6, TweenService:Create(TextLabel, tweenInfo3, {
		TextTransparency = 0
	}))
	table.insert(t7, TweenService:Create(TextLabel, tweenInfo3, {
		TextTransparency = 1
	}))
	table.insert(t8, TweenService:Create(TextLabel, tweenInfo3, {
		TextTransparency = 0
	}))

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "ObjectText"
	TextLabel2.Font = AppFonts.default:getMedium()
	TextLabel2.TextSize = 14
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.TextTransparency = 1
	TextLabel2.TextColor3 = color3_3
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.Padding = UDim.new(-0.25, 0)
	UIListLayout.Parent = Frame
	table.insert(t5, TweenService:Create(UIListLayout, tweenInfo3, {
		Padding = UDim.new(-0.25, 0)
	}))
	table.insert(t6, TweenService:Create(UIListLayout, tweenInfo3, {
		Padding = UDim.new(0, 0)
	}))
	table.insert(t7, TweenService:Create(UIListLayout, tweenInfo3, {
		Padding = UDim.new(-0.25, 0)
	}))
	table.insert(t8, TweenService:Create(UIListLayout, tweenInfo3, {
		Padding = UDim.new(0, 0)
	}))

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "TextFrame"
	Frame4.Size = UDim2.fromScale(0, 1)
	Frame4.AutomaticSize = Enum.AutomaticSize.X
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame
	TextLabel.Size = UDim2.fromScale(0, 1)
	TextLabel.AutomaticSize = Enum.AutomaticSize.X
	TextLabel.Parent = Frame4
	TextLabel2.Size = UDim2.fromScale(0, 1)
	TextLabel2.AutomaticSize = Enum.AutomaticSize.X
	TextLabel2.Parent = Frame4
	table.insert(t5, TweenService:Create(TextLabel2, tweenInfo3, {
		TextTransparency = 1
	}))
	table.insert(t6, TweenService:Create(TextLabel2, tweenInfo3, {
		TextTransparency = 0
	}))
	table.insert(t7, TweenService:Create(TextLabel2, tweenInfo3, {
		TextTransparency = 1
	}))
	table.insert(t8, TweenService:Create(TextLabel2, tweenInfo3, {
		TextTransparency = 0
	}))
	table.insert(t5, TweenService:Create(Frame, tweenInfo3, {
		BackgroundTransparency = 1
	}))
	table.insert(t6, TweenService:Create(Frame, tweenInfo3, {
		BackgroundTransparency = 0.2
	}))
	table.insert(t7, TweenService:Create(Frame, tweenInfo3, {
		BackgroundTransparency = 1
	}))
	table.insert(t8, TweenService:Create(Frame, tweenInfo3, {
		BackgroundTransparency = 0.2
	}))

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "RoundFrame"
	Frame5.Size = UDim2.fromOffset(48, 48)
	Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame5.Position = UDim2.fromScale(0.5, 0.5)
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = Frame3

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = Frame5
	table.insert(t7, TweenService:Create(Frame5, tweenInfo, {
		BackgroundTransparency = 1
	}))
	table.insert(t8, TweenService:Create(Frame5, tweenInfo, {
		BackgroundTransparency = 0.5
	}))

	if p8 == Enum.ProximityPromptInputType.Gamepad then
		local ImageForKeyCode = UserInputService:GetImageForKeyCode(p7.GamepadKeyCode)

		if ImageForKeyCode then
			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Name = "ButtonImage"
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel.Size = UDim2.fromOffset(24, 24)
			ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.ImageTransparency = 1
			ImageLabel.Image = ImageForKeyCode
			ImageLabel.Parent = Frame3
			table.insert(t7, TweenService:Create(ImageLabel, tweenInfo, {
				ImageTransparency = 1
			}))
			table.insert(t8, TweenService:Create(ImageLabel, tweenInfo, {
				ImageTransparency = 0
			}))
		end
	elseif p8 == Enum.ProximityPromptInputType.Touch then
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Name = "ButtonImage"
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.ImageTransparency = 1
		ImageLabel.Size = UDim2.fromOffset(25, 31)
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
		ImageLabel.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		ImageLabel.Parent = Frame3
		table.insert(t7, TweenService:Create(ImageLabel, tweenInfo, {
			ImageTransparency = 1
		}))
		table.insert(t8, TweenService:Create(ImageLabel, tweenInfo, {
			ImageTransparency = 0
		}))
	else
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Name = "ButtonImage"
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.ImageTransparency = 1
		ImageLabel.Size = UDim2.fromOffset(28, 30)
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
		ImageLabel.Image = "rbxasset://textures/ui/Controls/key_single.png"
		ImageLabel.Parent = Frame3
		table.insert(t7, TweenService:Create(ImageLabel, tweenInfo, {
			ImageTransparency = 1
		}))
		table.insert(t8, TweenService:Create(ImageLabel, tweenInfo, {
			ImageTransparency = 0
		}))

		local StringForKeyCode = UserInputService:GetStringForKeyCode(p7.KeyboardKeyCode)
		local v71 = t1[p7.KeyboardKeyCode]

		if v71 == nil then
			v71 = t2[StringForKeyCode]
		end

		if v71 == nil then
			local v72 = t3[p7.KeyboardKeyCode]

			if v72 then
				StringForKeyCode = v72
			end
		end

		if v71 then
			local ImageLabel2 = Instance.new("ImageLabel")

			ImageLabel2.Name = "ButtonImage"
			ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel2.Size = UDim2.fromOffset(36, 36)
			ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
			ImageLabel2.BackgroundTransparency = 1
			ImageLabel2.ImageTransparency = 1
			ImageLabel2.Image = v71
			ImageLabel2.Parent = Frame3
			table.insert(t7, TweenService:Create(ImageLabel2, tweenInfo, {
				ImageTransparency = 1
			}))
			table.insert(t8, TweenService:Create(ImageLabel2, tweenInfo, {
				ImageTransparency = 0
			}))
		elseif StringForKeyCode ~= nil and StringForKeyCode ~= "" then
			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Name = "ButtonText"
			TextLabel3.AutoLocalize = false
			TextLabel3.Position = UDim2.fromOffset(0, -1)
			TextLabel3.Size = UDim2.fromScale(1, 1)
			TextLabel3.Font = AppFonts.default:getMedium()

			local v75 = t4[p7.KeyboardKeyCode]

			if v75 == nil then
				v75 = 14
			end

			TextLabel3.TextSize = v75
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.TextTransparency = 1
			TextLabel3.TextColor3 = color3_2
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel3.Text = StringForKeyCode
			TextLabel3.Parent = Frame3
			table.insert(t7, TweenService:Create(TextLabel3, tweenInfo, {
				TextTransparency = 1
			}))
			table.insert(t8, TweenService:Create(TextLabel3, tweenInfo, {
				TextTransparency = 0
			}))
		else
			error("ProximityPrompt '" .. p7.Name .. "' has an unsupported keycode for rendering UI: " .. tostring(p7.KeyboardKeyCode))
		end
	end

	if p8 == Enum.ProximityPromptInputType.Touch or p7.ClickablePrompt then
		local TextButton = Instance.new("TextButton")

		TextButton.BackgroundTransparency = 1
		TextButton.TextTransparency = 1
		TextButton.Size = UDim2.fromScale(1, 1)
		TextButton.Parent = BillboardGui
		TextButton.Selectable = false

		local u77 = false

		TextButton.InputBegan:Connect(function(input) -- line: 399
			-- upvalues: p7 (copy), u77 (ref)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and input.UserInputState ~= Enum.UserInputState.Change then
				p7:InputHoldBegin()
				u77 = true
			end
		end)
		TextButton.InputEnded:Connect(function(input) -- line: 406
			-- upvalues: u77 (ref), p7 (copy)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and u77 then
				u77 = false
				p7:InputHoldEnd()
			end
		end)
		BillboardGui.Active = true
	end

	if p7.HoldDuration > 0 then
		local v78 = createCircularProgressBar(t7, t8)

		v78.Parent = Frame3
		table.insert(t5, TweenService:Create(v78.Progress, tweenInfo4, {
			Value = 1
		}))
		table.insert(t6, TweenService:Create(v78.Progress, tweenInfo2, {
			Value = 0
		}))
	end

	local connection = nil
	local connection2 = nil

	if p7.HoldDuration > 0 then
		connection = p7.PromptButtonHoldBegan:Connect(function() -- line: 431
			-- upvalues: t5 (copy)
			for _, v in ipairs(t5) do
				v:Play()
			end
		end)
		connection2 = p7.PromptButtonHoldEnded:Connect(function() -- line: 437
			-- upvalues: t6 (copy)
			for _, v in ipairs(t6) do
				v:Play()
			end
		end)
	end

	local connection3 = p7.Triggered:Connect(function() -- line: 444
		-- upvalues: t7 (copy)
		for _, v in ipairs(t7) do
			v:Play()
		end
	end)
	local connection4 = p7.TriggerEnded:Connect(function() -- line: 450
		-- upvalues: t8 (copy)
		for _, v in ipairs(t8) do
			v:Play()
		end
	end)

	local function updateUIFromPrompt() -- line: 456
		-- upvalues: p7 (copy), TextLabel (copy), TextLabel2 (copy), UIPadding (copy), BillboardGui (copy), RunService (copy), Frame (copy)
		local n1 = 72
		local n2 = 0

		if p7.ObjectText ~= nil and p7.ObjectText ~= "" then
			n2 = 9
		end

		TextLabel.Text = p7.ActionText
		TextLabel2.Text = p7.ObjectText
		TextLabel.AutoLocalize = p7.AutoLocalize
		TextLabel.RootLocalizationTable = p7.RootLocalizationTable
		TextLabel2.AutoLocalize = p7.AutoLocalize
		TextLabel2.RootLocalizationTable = p7.RootLocalizationTable

		local v117 = 24 - n2

		if p7.ActionText ~= nil and p7.ActionText ~= "" or p7.ObjectText ~= nil and p7.ObjectText ~= "" then
			UIPadding.PaddingRight = UDim.new(0, v117)
		else
			UIPadding.PaddingRight = UDim.new(0, 0)
		end

		TextLabel.Position = UDim2.new(0, 0, 0, n2)
		TextLabel2.Position = UDim2.new(0, 0, 0, -10)
		BillboardGui.Size = UDim2.fromOffset(n1, 72)
		BillboardGui.SizeOffset = Vector2.new(p7.UIOffset.X / BillboardGui.Size.Width.Offset, p7.UIOffset.Y / BillboardGui.Size.Height.Offset)
		task.defer(function() -- line: 492
			-- upvalues: RunService (copy), n1 (ref), Frame (copy), BillboardGui (copy), p7 (copy)
			RunService.RenderStepped:Wait()
			RunService.RenderStepped:Wait()
			n1 = Frame.AbsoluteSize.X
			BillboardGui.Size = UDim2.fromOffset(n1, 72)
			BillboardGui.SizeOffset = Vector2.new(p7.UIOffset.X / BillboardGui.Size.Width.Offset, p7.UIOffset.Y / BillboardGui.Size.Height.Offset)
		end)
	end

	local connection5 = p7.Changed:Connect(updateUIFromPrompt)

	updateUIFromPrompt()
	BillboardGui.Adornee = p7.Parent
	BillboardGui.Parent = p9

	local function updateUIAncestry() -- line: 509
		-- upvalues: BillboardGui (copy), p7 (copy)
		BillboardGui.Adornee = p7.Parent
	end

	local connection6 = p7.AncestryChanged:Connect(updateUIAncestry)

	for _, v in ipairs(t8) do
		v:Play()
	end

	local function cleanup() -- line: 518
		-- upvalues: connection (ref), connection2 (ref), connection3 (ref), connection4 (ref), connection5 (copy), connection6 (copy), t7 (copy), BillboardGui (copy)
		if connection then
			connection:Disconnect()
		end

		if connection2 then
			connection2:Disconnect()
		end

		connection3:Disconnect()
		connection4:Disconnect()
		connection5:Disconnect()
		connection6:Disconnect()

		for _, v in ipairs(t7) do
			v:Play()
		end

		wait(0.2)
		BillboardGui.Parent = nil
	end

	return cleanup
end
local function createIndicator(p10, p11) -- line: 544
	-- upvalues: color3 (copy), color3_2 (copy), TweenService (copy), tweenInfo (copy)
	local t9 = {}
	local t10 = {}
	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "Indicator"
	BillboardGui.Size = UDim2.fromOffset(15, 15)
	BillboardGui.AlwaysOnTop = true

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundTransparency = 1
	Frame.BackgroundColor3 = color3
	Frame.AnchorPoint = Vector2.new(0.5, 0)
	Frame.Position = UDim2.fromScale(0.5, 0)
	Frame.Parent = BillboardGui

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = color3_2
	UIStroke.Thickness = 1.5
	UIStroke.Transparency = 1
	UIStroke.Parent = Frame
	table.insert(t9, TweenService:Create(Frame, tweenInfo, {
		BackgroundTransparency = 1
	}))
	table.insert(t9, TweenService:Create(UIStroke, tweenInfo, {
		Transparency = 1
	}))
	table.insert(t10, TweenService:Create(Frame, tweenInfo, {
		BackgroundTransparency = 0.2
	}))
	table.insert(t10, TweenService:Create(UIStroke, tweenInfo, {
		Transparency = 0.2
	}))
	BillboardGui.Adornee = p10.Parent
	BillboardGui.Parent = p11

	local function updateUIAncestry() -- line: 579
		-- upvalues: BillboardGui (copy), p10 (copy)
		BillboardGui.Adornee = p10.Parent
	end

	local connection = p10.AncestryChanged:Connect(updateUIAncestry)

	for _, v in ipairs(t10) do
		v:Play()
	end

	local function cleanup() -- line: 588
		-- upvalues: connection (copy), t9 (copy), BillboardGui (copy)
		connection:Disconnect()

		for _, v in ipairs(t9) do
			v:Play()
		end

		wait(0.2)
		BillboardGui.Parent = nil
	end

	return cleanup
end
local function onLoad() -- line: 603
	-- upvalues: ProximityPromptService (copy), v12 (copy), createPrompt (copy), createIndicator (copy)
	ProximityPromptService.PromptShown:Connect(function(prompt, p12) -- line: 604
		-- upvalues: v12 (copy), createPrompt (copy)
		if prompt.Style == Enum.ProximityPromptStyle.Custom then
			return
		end

		local ProximityPrompts = v12:FindFirstChild("ProximityPrompts")

		if ProximityPrompts == nil then
			ProximityPrompts = Instance.new("ScreenGui")
			ProximityPrompts.Name = "ProximityPrompts"
			ProximityPrompts.ResetOnSpawn = false
			ProximityPrompts.Parent = v12
			ProximityPrompts.IgnoreGuiInset = true
		end

		local v125 = createPrompt(prompt, p12, ProximityPrompts)
		local BindableEvent = Instance.new("BindableEvent")
		local connection = prompt.PromptHidden:Connect(function() -- line: 615
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end)
		local connection7 = prompt.Destroying:Connect(function() -- line: 618
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end)

		BindableEvent.Event:Wait()
		connection:Disconnect()
		connection7:Disconnect()
		v125()
	end)
	ProximityPromptService.IndicatorShown:Connect(function(p13) -- line: 628
		-- upvalues: v12 (copy), createIndicator (copy)
		if p13.Style == Enum.ProximityPromptStyle.Custom then
			return
		end

		local ProximityPrompts = v12:FindFirstChild("ProximityPrompts")

		if ProximityPrompts == nil then
			ProximityPrompts = Instance.new("ScreenGui")
			ProximityPrompts.Name = "ProximityPrompts"
			ProximityPrompts.ResetOnSpawn = false
			ProximityPrompts.Parent = v12
			ProximityPrompts.IgnoreGuiInset = true
		end

		local v131 = createIndicator(p13, ProximityPrompts)
		local BindableEvent = Instance.new("BindableEvent")
		local connection = p13.IndicatorHidden:Connect(function() -- line: 639
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end)
		local connection8 = p13.Destroying:Connect(function() -- line: 642
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end)

		BindableEvent.Event:Wait()
		connection:Disconnect()
		connection8:Disconnect()
		v131()
	end)
end

onLoad()

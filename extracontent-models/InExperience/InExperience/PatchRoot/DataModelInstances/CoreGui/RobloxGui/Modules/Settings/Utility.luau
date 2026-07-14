local Theme = require(script.Parent.Theme)
local v2 = Theme.color("SELECTED_COLOR", Color3.fromRGB(0, 162, 255))
local v3 = Theme.color("NON_SELECTED_COLOR", Color3.fromRGB(78, 84, 96))
local v4 = Theme.color("ARROW_COLOR", Color3.fromRGB(204, 204, 204))
local v5 = Theme.color("ARROW_COLOR_HOVER", Color3.fromRGB(255, 255, 255))
local v6 = Theme.color("ARROW_COLOR_INACTIVE", Color3.fromRGB(150, 150, 150))
local uDim = UDim.new(0, 14)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")
local Workspace = game:GetService("Workspace")
local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)
local FFlagAddNextUpContainer = require(RobloxGui.Modules.Settings.Pages.LeaveGameWithNextUp.Flags.FFlagAddNextUpContainer)
local v21 = game:DefineFastFlag("RepositionDropDownScrim", false)
local Chrome = RobloxGui.Modules.Chrome
local v23 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.Service)
local Signals = require(CorePackages.Packages.Signals)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local FFlagHideShortcutsWhileIemDropdownActive = require(Chrome.Flags).FFlagHideShortcutsWhileIemDropdownActive
local EngineFeature = game:GetEngineFeature("EnablePreferredTextSizeAccessGuiService")
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local v29 = game:DefineFastFlag("IncreaseLegacyPeopleRowButtonSize", false)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CorePackages2 = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages2.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages2.Packages.BuilderIcons)
local Migration = BuilderIcons.Migration
local v37 = require(RobloxGui.Modules:WaitForChild("TenFootInterface")):IsEnabled()
local v38 = Signals.createComputed(function(p1) -- line: 84
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p1).getLastInputType(p1) == Responsive.Input.Touch
end)
local v39 = Signals.createComputed(function(p2) -- line: 89
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p2).getLastInputType(p2) == Responsive.Input.Pointer
end)
local t1 = {}

setmetatable(t1, {
	__mode = "k"
})

local v41 = Create("ImageLabel")({
	Image = "",
	BackgroundTransparency = 1
})

function clamp(p3, p4, p5) -- line: 106
	return (math.max(p3, (math.min(p4, p5))))
end

local function Linear(p6, p7, p8, p9) -- line: 111
	if p9 <= p6 then
		return p7 + p8
	end

	return p8 * p6 / p9 + p7
end
local function EaseOutQuad(p10, p11, p12, p13) -- line: 119
	if p13 <= p10 then
		return p11 + p12
	end

	local v83 = p10 / p13

	return p11 - p12 * v83 * (v83 - 2)
end
local function EaseInOutQuad(p14, p15, p16, p17) -- line: 128
	if p17 <= p14 then
		return p15 + p16
	end

	local v88 = p14 / p17

	if v88 < 0.5 then
		return 2 * p16 * v88 * v88 + p15
	end

	return p15 + p16 * (2 * (2 - v88) * v88 - 1)
end

function PropertyTweener(p18, p19, p20, p21, p22, p23, p24) -- line: 140
	-- upvalues: RunService (copy)
	local t2 = {
		StartTime = tick()
	}

	t2.EndTime = t2.StartTime + p22
	t2.Cancelled = false

	local u97 = false
	local n1 = 0

	local function finalize() -- line: 149
		-- upvalues: p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), u97 (ref), n1 (ref), p24 (copy)
		if p18 then
			p18[p19] = p23(1, p20, p21 - p20, 1)
		end

		u97 = true
		n1 = 1

		if p24 then
			p24()
		end
	end

	p18[p19] = p23(0, p20, p21 - p20, p22)
	coroutine.wrap(function() -- line: 162
		-- upvalues: t2 (copy), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), p22 (copy), n1 (ref), RunService (copy), u97 (ref), p24 (copy)
		local timestamp = tick()

		while timestamp < t2.EndTime and p18 do
			if t2.Cancelled then
				return
			end

			p18[p19] = p23(timestamp - t2.StartTime, p20, p21 - p20, p22)
			n1 = clamp(0, 1, (timestamp - t2.StartTime) / p22)
			RunService.RenderStepped:Wait()
			timestamp = tick()
		end

		if t2.Cancelled == false and p18 then
			if p18 then
				p18[p19] = p23(1, p20, p21 - p20, 1)
			end

			u97 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end)()

	function t2.GetFinal(_) -- line: 178
		-- upvalues: p21 (copy)
		return p21
	end
	function t2.GetPercentComplete(_) -- line: 182
		-- upvalues: n1 (ref)
		return n1
	end
	function t2.IsFinished(_) -- line: 186
		-- upvalues: u97 (ref)
		return u97
	end
	function t2.Finish(p28) -- line: 190
		-- upvalues: u97 (ref), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), n1 (ref), p24 (copy)
		if not u97 then
			p28:Cancel()

			if p18 then
				p18[p19] = p23(1, p20, p21 - p20, 1)
			end

			u97 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end
	function t2.Cancel(_) -- line: 197
		-- upvalues: t2 (copy)
		t2.Cancelled = true
	end

	return t2
end

local function isTouchInput() -- line: 204
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end
local function CreateSignal() -- line: 210
	local t3 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local t4 = nil
	local u103 = nil

	function t3.fire(_, ...) -- line: 218
		-- upvalues: t4 (ref), u103 (ref), BindableEvent (copy)
		t4 = { ... }
		u103 = select("#", ...)
		BindableEvent:Fire()
	end
	function t3.connect(_, p32) -- line: 224
		-- upvalues: BindableEvent (copy), t4 (ref), u103 (ref)
		if not p32 then
			error("connect(nil)", 2)
		end

		return BindableEvent.Event:Connect(function() -- line: 228
			-- upvalues: p32 (copy), t4 (ref), u103 (ref)
			p32(unpack(t4, 1, u103))
		end)
	end
	function t3.wait(_) -- line: 233
		-- upvalues: BindableEvent (copy), t4 (ref), u103 (ref)
		BindableEvent.Event:wait()

		if not t4 then
			error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		end

		return unpack(t4, 1, u103)
	end

	return t3
end
local function getViewportSize() -- line: 244
	-- upvalues: GuiService (copy)
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	return GuiService:GetHardwareSafeViewport()
end
local function isSmallTouchScreen() -- line: 253
	-- upvalues: GuiService (copy), UserInputService (copy)
	local v104 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return UserInputService.TouchEnabled and (v104.Y < 500 or v104.X < 700)
end
local function isPortrait() -- line: 258
	-- upvalues: GuiService (copy)
	local v105 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return v105.Y > v105.X
end
local function isTenFootInterface() -- line: 263
	-- upvalues: v37 (copy)
	return v37
end
local function usesSelectedObject() -- line: 267
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
local function addHoverState(p34, p35, p36, p37) -- line: 280
	local function onNormalButtonStateCallback() -- line: 281
		-- upvalues: p34 (copy), p36 (copy), p35 (copy)
		if p34.Active then
			p36(p35)
		end
	end
	local function onHoverButtonStateCallback() -- line: 286
		-- upvalues: p34 (copy), p37 (copy), p35 (copy)
		if p34.Active then
			p37(p35)
		end
	end

	p34.MouseEnter:Connect(onHoverButtonStateCallback)
	p34.SelectionGained:Connect(onHoverButtonStateCallback)
	p34.MouseLeave:Connect(onNormalButtonStateCallback)
	p34.SelectionLost:Connect(onNormalButtonStateCallback)
	p36(p35)
end
local function addOnResizedCallback(p38, p39) -- line: 300
	-- upvalues: t1 (copy), GuiService (copy)
	t1[p38] = p39

	local v114 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v115 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	p39(v114, v115.Y > v115.X)
end

local t5 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}

local function MakeDefaultButton(p40, p41, p42, p43, p44, p45) -- line: 316
	-- upvalues: Create (copy), Theme (copy), t5 (copy), UserInputService (copy), GuiService (copy), VRService (copy)
	local v122 = Create("ImageLabel")({
		Image = "",
		BackgroundTransparency = 1
	})
	local s1 = "DefaultButtonStroke"
	local s2 = "DefaultButton"

	if p40 == "DropDownFrame" then
		s1 = "ControlInputStroke"
		s2 = "ControlInputBackground"
	end

	if p45 == "ImageButton" then
		s2 = "ImageButton"
	end

	local u125 = Create("ImageButton")({
		AutoButtonColor = false,
		ZIndex = 2,
		Name = p40 .. "Button",
		BackgroundColor3 = Theme.color(s2),
		BackgroundTransparency = Theme.transparency(s2),
		Size = p41,
		SelectionImageObject = v122
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u125
	})

	local v126 = Create("UIStroke")({
		Name = "Border",
		Color = Theme.color(s1),
		Transparency = Theme.transparency(s1),
		Thickness = Theme.DefaultStokeThickness,
		Parent = u125
	})

	Create("BoolValue")({
		Name = "Enabled",
		Value = true,
		Parent = u125
	})

	if p42 then
		u125.MouseButton1Click:Connect(function() -- line: 363
			-- upvalues: p42 (copy), t5 (copy), UserInputService (copy)
			p42(t5[UserInputService:GetLastInputType()] or false)
		end)
	else
		if v126 then
			v126.Enabled = false
		end

		u125.Selectable = false
	end

	local function isPointerInput(p46) -- line: 373
		return p46.UserInputType == Enum.UserInputType.MouseMovement or p46.UserInputType == Enum.UserInputType.Touch
	end

	local u128 = nil

	local function setRowRef(p47) -- line: 379
		-- upvalues: u128 (ref)
		u128 = p47
	end
	local function selectButton() -- line: 383
		-- upvalues: p44 (copy), p43 (copy), u125 (ref), Theme (copy), u128 (ref)
		local v434 = p44

		if v434 == nil and p43 then
			v434 = p43.HubRef
		end

		if v434 and v434.Active or v434 == nil then
			u125.BackgroundColor3 = Theme.color("DefaultButtonHover")
			u125.BackgroundTransparency = Theme.transparency("DefaultButtonHover")

			local v435 = u125

			if u128 then
				v435 = u128
			end

			if v434 then
				v434:ScrollToFrame(v435)
			end
		end
	end
	local function deselectButton() -- line: 405
		-- upvalues: u125 (ref), Theme (copy), s2 (ref)
		u125.BackgroundColor3 = Theme.color(s2)
		u125.BackgroundTransparency = Theme.transparency(s2)
	end

	u125.InputBegan:Connect(function(input) -- line: 410
		-- upvalues: u125 (ref), selectButton (copy)
		if u125.Selectable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			selectButton()
		end
	end)
	u125.InputEnded:Connect(function(input) -- line: 415
		-- upvalues: u125 (ref), GuiService (copy), Theme (copy), s2 (ref)
		if u125.Selectable and (GuiService.SelectedCoreObject ~= u125 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
			u125.BackgroundColor3 = Theme.color(s2)
			u125.BackgroundTransparency = Theme.transparency(s2)
		end
	end)
	u125.SelectionGained:Connect(function() -- line: 421
		-- upvalues: selectButton (copy)
		selectButton()
	end)
	u125.SelectionLost:Connect(function() -- line: 424
		-- upvalues: u125 (ref), Theme (copy), s2 (ref)
		u125.BackgroundColor3 = Theme.color(s2)
		u125.BackgroundTransparency = Theme.transparency(s2)
	end)
	GuiService.Changed:Connect(function(property) -- line: 428
		-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u125 (ref), Theme (copy), s2 (ref), selectButton (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		if VRService.VREnabled or UserInputService.PreferredInput == Enum.PreferredInput.Touch and ((not UserInputService.GamepadEnabled or not true) and not false) then
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= u125 then
			u125.BackgroundColor3 = Theme.color(s2)
			u125.BackgroundTransparency = Theme.transparency(s2)

			return
		end

		if u125.Selectable then
			selectButton()
		end
	end)

	return u125, setRowRef
end
local function MakeButton(p48, p49, p50, p51, p52, p53) -- line: 449
	-- upvalues: MakeDefaultButton (copy), Create (copy), Theme (copy), GuiService (copy), UserInputService (copy), v37 (copy), EngineFeature (copy)
	local v138, v139 = MakeDefaultButton(p48, p50, p51, p52, p53)
	local v140 = Create("TextLabel")({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextScaled = false,
		TextWrapped = true,
		ZIndex = 2,
		Name = p48 .. "TextLabel",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		TextColor3 = Theme.color("WhiteButtonText", Color3.fromRGB(255, 255, 255)),
		TextTransparency = Theme.transparency("WhiteButtonText", 0),
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Theme.font(Enum.Font.SourceSansBold, "Button"),
		TextSize = Theme.textSize(24, "Button"),
		Text = p49,
		Parent = v138
	})
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", v140)
	local v142 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if UserInputService.TouchEnabled and (v142.Y < 500 or v142.X < 700) then
		v140.TextSize = Theme.textSize(18)
	elseif v37 and (p48 ~= "FriendStatus" and p48 ~= "BlockButton") then
		v140.TextSize = Theme.textSize(36)
	end

	if not EngineFeature then
		UITextSizeConstraint.MaxTextSize = v140.TextSize
	else
		local u143 = (GuiService.PreferredTextSize.Value - 1) * 3

		UITextSizeConstraint.MaxTextSize = v140.TextSize + u143

		local TextSize = v140.TextSize

		GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(function() -- line: 485
			-- upvalues: u143 (ref), GuiService (copy), UITextSizeConstraint (copy), TextSize (copy)
			u143 = (GuiService.PreferredTextSize.Value - 1) * 3
			UITextSizeConstraint.MaxTextSize = TextSize + u143
		end)
	end

	return v138, v140, v139
end
local function MakeImageButton(p54, p55, p56, p57, p58, p59, p60, p61) -- line: 494
	-- upvalues: MakeDefaultButton (copy), Migration (copy), Theme (copy), Create (copy), v29 (copy), BuilderIcons (copy)
	if not p61 then
		p61 = "ImageButton"
	end

	local v153, v154 = MakeDefaultButton(p54, p56, p58, p59, p60, p61)
	local ImageRectOffset = nil
	local ImageRectSize = nil
	local v157 = Migration.uiblox[p55] or Migration.luaApps[p55]

	if not string.match(p55, "^rbxasset://") then
		p55 = Theme.Images[p55]
	end

	if typeof(p55) == "table" then
		ImageRectOffset = p55.ImageRectOffset
		ImageRectSize = p55.ImageRectSize
		p55 = p55.Image
	end

	local v158 = if not v157 then Create("ImageLabel")({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Name = p54 .. "ImageLabel",
		Size = p57,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = p55,
		ImageRectOffset = ImageRectOffset,
		ImageRectSize = ImageRectSize,
		Parent = v153
	}) else Create("TextLabel")({
		BackgroundTransparency = 1,
		ZIndex = 2,
		Name = p54 .. "TextLabel",
		Size = p57,
		TextSize = if not v29 then p57.Y.Offset * 0.6666666666666666 else p57.Y.Offset * 0.8571428571428571,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = Color3.new(1, 1, 1),
		Text = v157.name,
		FontFace = BuilderIcons.Font[v157.variant],
		Parent = v153
	})

	if p61 == "ImageButton" then
		v153.Border.Thickness = 0
		v153.Border.Transparency = 1
	end

	return v153, v158, v154
end
local function AddButtonRow(p62, p63, p64, p65, p66, p67) -- line: 549
	-- upvalues: MakeButton (copy), Create (copy)
	local v165, v166, v167 = MakeButton(p63, p64, p65, p66, p62, p67)
	local v168 = Create("Frame")({
		BackgroundTransparency = 1,
		Name = p63 .. "Row",
		Size = UDim2.new(1, 0, p65.Y.Scale, p65.Y.Offset),
		Parent = p62.Page
	})

	v165.Parent = v168
	v165.AnchorPoint = Vector2.new(1, 0)
	v165.Position = UDim2.new(1, -20, 0, 0)

	return v168, v165, v166, v167
end
local function MakeRoundedRectFocusState(p68, p69) -- line: 565
	-- upvalues: Create (copy), uDim (copy), Theme (copy), RunService (copy), UserGameSettings (copy)
	local v171 = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 12, 1, 12),
		Position = UDim2.fromOffset(-6, -6)
	})

	Create("UICorner")({
		CornerRadius = uDim,
		Parent = v171
	})

	local v172 = Create("UIStroke")({
		Transparency = 0,
		Thickness = 3,
		Color = Theme.selectionCursor.AnimatedColor,
		Parent = v171
	})
	local v173 = Create("UIGradient")({
		Rotation = 0,
		Color = Theme.selectionCursor.GradientColorSequence,
		Transparency = Theme.selectionCursor.GradientTransparencySequence,
		Parent = v172
	})

	RunService:UnbindFromRenderStep(p69)
	RunService:BindToRenderStep(p69, Enum.RenderPriority.Last.Value, function() -- line: 592
		-- upvalues: v173 (copy), Theme (copy), UserGameSettings (copy)
		local v439 = v173.Rotation + 2
		local GradientColorSequence = Theme.selectionCursor.GradientColorSequence
		local GradientTransparencySequence = Theme.selectionCursor.GradientTransparencySequence

		if UserGameSettings.ReducedMotion then
			local v442 = (math.sin((math.rad(v439))) + 1) / 2
			local Value = GradientColorSequence.Keypoints[1].Value
			local Value2 = GradientColorSequence.Keypoints[#GradientColorSequence.Keypoints].Value

			GradientColorSequence = ColorSequence.new(Value:lerp(Value2, v442))

			local Value3 = GradientTransparencySequence.Keypoints[1].Value
			local Value4 = GradientTransparencySequence.Keypoints[#GradientTransparencySequence.Keypoints].Value

			GradientTransparencySequence = NumberSequence.new(Value3 + (Value4 - Value3) * v442)
		end

		v173.Rotation = v439
		v173.Color = GradientColorSequence
		v173.Transparency = GradientTransparencySequence
	end)
	p68.AncestryChanged:Connect(function(_, parent) -- line: 616
		-- upvalues: RunService (copy), p69 (copy)
		if not parent then
			RunService:UnbindFromRenderStep(p69)
		end
	end)
	p68.SelectionImageObject = v171
end
local function CreateDropDown(p71, p72, p73) -- line: 625
	-- upvalues: Theme (copy), HttpService (copy), GuiService (copy), Create (copy), v21 (copy), CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), UserInputService (copy), ContextActionService (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v23 (copy), RobloxTranslator (copy), MakeButton (copy)
	local v177 = Theme.color("SELECTION_TEXT_COLOR_NORMAL", Color3.fromRGB(178, 178, 178))
	local color3 = Color3.fromRGB(229, 229, 229)
	local v179 = Theme.color("SELECTION_TEXT_COLOR_HIGHLIGHTED", Color3.fromRGB(255, 255, 255))
	local DropDownFrame = nil
	local t6 = {
		CurrentIndex = nil,
		UpdateDropDownList = nil,
		DropDownFrame = nil,
		Selections = nil
	}

	Instance.new("BindableEvent").Name = "IndexChanged"

	if type(p71) ~= "table" then
		error("CreateDropDown dropDownStringTable (first arg) is not a table", 2)

		return t6
	end

	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "IndexChanged"

	local u183 = true
	local guid = HttpService:GenerateGUID(false)
	local DropDownFrameEnabled = nil
	local u186 = p71
	local v187, _ = GuiService:GetGuiInset()
	local v189 = Create("ImageButton")({
		Name = "DropDownFullscreenFrame",
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 10,
		Active = true,
		Visible = false,
		Selectable = false,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, not v21 and 0 or v187.Y),
		Position = if not v21 then nil else UDim2.new(0, 0, 0, -v187.Y),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Parent = CoreGui.RobloxGui
	})

	local function onVREnabled(p74) -- line: 677
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), v189 (copy), CoreGui (copy), t6 (copy), u186 (ref)
		if p74 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				v189.Parent = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
				v189.BackgroundTransparency = 0.2
			else
				v189.Parent = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):GetGUI()
				v189.BackgroundTransparency = 1
			end
		else
			v189.Parent = CoreGui.RobloxGui
			v189.BackgroundTransparency = 0.2
		end

		if t6.UpdateDropDownList then
			t6:UpdateDropDownList(u186)
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	local v191 = Create("ImageLabel")({
		Name = "DropDownSelectionFrame",
		Image = "",
		ZIndex = 10,
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(8, 6, 46, 44),
		BackgroundTransparency = Theme.transparency("DropdownListBg", 1),
		BackgroundColor3 = Theme.color("DropdownListBg"),
		Size = UDim2.new(0.6, 0, 0.9, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = v189
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v191
	})

	local v192 = Create("ScrollingFrame")({
		Name = "DropDownScrollingFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 10,
		Size = UDim2.new(1, -20, 1, -25),
		Position = UDim2.new(0, 10, 0, 10),
		ScrollBarThickness = Theme.DefaultScrollBarThickness,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = v191
	})
	local connection = nil
	local u194 = false

	local function v195(p75, p76) -- line: 741
		-- upvalues: t6 (copy), u183 (ref), p73 (copy), v189 (copy), VRService (copy), UserInputService (copy), GuiService (copy), DropDownFrame (ref), connection (ref), ContextActionService (copy), guid (copy), DropDownFrameEnabled (ref), u194 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy)
		if p75 ~= nil and p76 ~= Enum.UserInputState.Begin then
			return
		end

		t6.DropDownFrame.Selectable = u183
		p73:SetActive(true)

		if v189.Visible and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) then
			GuiService.SelectedCoreObject = DropDownFrame
		end

		v189.Visible = false

		if connection then
			connection:Disconnect()
		end

		ContextActionService:UnbindCoreAction(guid .. "Action")
		ContextActionService:UnbindCoreAction(guid .. "FreezeAction")
		DropDownFrameEnabled.Value = u183
		u194 = false

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v189, 0)
		end
	end
	local function v196() -- line: 771
	end

	local v197 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.ChooseOne")
	local uDim2 = UDim2.new(0.6, 0, 0, 40)

	t6.DropDownFrame = MakeButton("DropDownFrame", v197, uDim2, function() -- line: 773
		-- upvalues: u183 (ref), t6 (copy), u194 (ref), v189 (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), DropDownFrame (ref), GuiService (copy), connection (ref), v179 (copy), color3 (copy), v177 (copy), v195 (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v23 (copy), ContextActionService (copy), guid (copy), v196 (copy), p73 (copy), DropDownFrameEnabled (ref)
		if not u183 then
			return
		end

		t6.DropDownFrame.Selectable = false
		u194 = true
		v189.Visible = true

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v189, 0.5)
		end

		DropDownFrame = t6.DropDownFrame

		if t6.CurrentIndex and t6.CurrentIndex > 0 then
			GuiService.SelectedCoreObject = t6.Selections[t6.CurrentIndex]
		elseif #t6.Selections > 0 then
			GuiService.SelectedCoreObject = t6.Selections[1]
		end

		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 796
			-- upvalues: t6 (copy), GuiService (copy), v179 (copy), VRService (copy), color3 (copy), v177 (copy)
			for i = 1, #t6.Selections do
				if GuiService.SelectedCoreObject == t6.Selections[i] then
					t6.Selections[i].TextColor3 = v179
				else
					t6.Selections[i].TextColor3 = VRService.VREnabled and color3 or v177
				end
			end
		end)

		local v454 = v195

		if FFlagHideShortcutsWhileIemDropdownActive then
			v23:setHideShortcutBar("InExperienceMenuDropdown", true)

			function v454(p77, p78) -- line: 810
				-- upvalues: v195 (copy), v23 (copy)
				v195(p77, p78)
				v23:setHideShortcutBar("InExperienceMenuDropdown", false)
			end
		end

		ContextActionService:BindCoreAction(guid .. "FreezeAction", v196, false, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1)
		ContextActionService:BindCoreAction(guid .. "Action", v454, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
		p73:SetActive(false)
		DropDownFrameEnabled.Value = false
	end, nil, p73)
	t6.DropDownFrame.Position = UDim2.new(1, 0, 0.5, 0)
	t6.DropDownFrame.AnchorPoint = Vector2.new(1, 0.5)
	DropDownFrameEnabled = t6.DropDownFrame.Enabled

	local DropDownFrameTextLabel = t6.DropDownFrame.DropDownFrameTextLabel

	DropDownFrameTextLabel.Position = UDim2.new(0, 15, 0, 0)
	DropDownFrameTextLabel.Size = UDim2.new(1, -50, 1, 0)
	DropDownFrameTextLabel.ClipsDescendants = true
	DropDownFrameTextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local v200 = Create("ImageLabel")({
		Name = "DropDownImage",
		Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 15, 0, 10),
		Position = UDim2.new(1, -12, 0.5, 0),
		Parent = t6.DropDownFrame
	})

	t6.DropDownImage = v200

	local function setSelection(p79) -- line: 863
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v456 = false

		for k, v in pairs(t6.Selections) do
			if k == p79 then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v456 = true
			end
		end

		if v456 then
			BindableEvent:Fire(p79)
		end
	end
	local function setSelectionByValue(p80) -- line: 879
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v460 = false

		for k, v in pairs(t6.Selections) do
			if p80 == v.Text then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v460 = true
			end
		end

		if v460 then
			BindableEvent:Fire(t6.CurrentIndex)
		end

		return v460
	end
	local function setIsFaded(p81) -- line: 896
		-- upvalues: t6 (copy)
		if p81 then
			t6.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5
			t6.DropDownFrame.ImageTransparency = 0.5
			t6.DropDownImage.ImageTransparency = 0.5

			return
		end

		t6.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
		t6.DropDownFrame.ImageTransparency = 0
		t6.DropDownImage.ImageTransparency = 0
	end

	t6.IndexChanged = BindableEvent.Event

	function t6.SetSelectionIndex(_, p83) -- line: 911
		-- upvalues: setSelection (copy)
		setSelection(p83)
	end
	function t6.SetSelectionByValue(_, p85) -- line: 915
		-- upvalues: setSelectionByValue (copy)
		return (setSelectionByValue(p85))
	end
	function t6.ResetSelectionIndex(_) -- line: 919
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), v197 (copy), v195 (copy)
		t6.CurrentIndex = nil
		DropDownFrameTextLabel.Text = v197
		v195()
	end
	function t6.GetSelectedIndex(_) -- line: 925
		-- upvalues: t6 (copy)
		return t6.CurrentIndex
	end
	function t6.SetZIndex(_, p89) -- line: 929
		-- upvalues: t6 (copy), v200 (copy), DropDownFrameTextLabel (copy)
		t6.DropDownFrame.ZIndex = p89
		v200.ZIndex = p89
		DropDownFrameTextLabel.ZIndex = p89
	end
	function t6.SetInteractable(_, p91) -- line: 935
		-- upvalues: u183 (ref), t6 (copy), v195 (copy), VRService (copy), DropDownFrameEnabled (ref), u194 (ref)
		u183 = p91
		t6.DropDownFrame.Selectable = u183

		if not u183 then
			v195()

			if VRService.VREnabled then
				t6.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5
				t6.DropDownFrame.ImageTransparency = 0.5
				t6.DropDownImage.ImageTransparency = 0.5
			else
				t6.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
				t6.DropDownFrame.ImageTransparency = 0
				t6.DropDownImage.ImageTransparency = 0
			end

			if not VRService.VREnabled then
				t6:SetZIndex(1)
			end
		else
			t6.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
			t6.DropDownFrame.ImageTransparency = 0
			t6.DropDownImage.ImageTransparency = 0

			if not VRService.VREnabled then
				t6:SetZIndex(2)
			end
		end

		DropDownFrameEnabled.Value = p91 and not u194
		t6.DropDownImage.Visible = p91

		if p91 then
			t6.DropDownFrame.ImageTransparency = 0

			return
		end

		t6.DropDownFrame.ImageTransparency = 0.5
	end
	function t6.SetAutoLocalize(_, p93) -- line: 962
		-- upvalues: v189 (copy)
		v189.AutoLocalize = p93
	end
	function t6.UpdateDropDownList(_, p95) -- line: 966
		-- upvalues: u186 (ref), t6 (copy), VRService (copy), Theme (copy), Create (copy), color3 (copy), v177 (copy), v192 (copy), p72 (copy), DropDownFrameTextLabel (copy), v179 (copy), v195 (copy), BindableEvent (copy), UserInputService (copy), GuiService (copy), guid (copy), v189 (copy), v191 (copy)
		u186 = p95

		if t6.Selections then
			for i = 1, #t6.Selections do
				t6.Selections[i]:Destroy()
			end
		end

		t6.Selections = {}
		t6.SelectionInfo = {}

		local VREnabled = VRService.VREnabled
		local v480 = VREnabled and Theme.font(Enum.Font.SourceSansBold, "Bold") or Theme.font(Enum.Font.SourceSans, "UtilityText")
		local v481 = VREnabled and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		local v482 = not VREnabled and 50 or 70
		local v483 = v482 + 1
		local v484 = not VREnabled and 400 or 600
		local n2 = 0

		for k, v in pairs(p95) do
			local v488 = Create("Frame")({
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			})

			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v488
			})

			local v489 = v
			local s3 = ""
			local v491 = typeof(v) == "table"

			if v491 then
				v489 = v.title
				s3 = v.subtitle
				n2 += 10
			end

			local u492

			if v491 then
				u492 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					TextYAlignment = Enum.TextYAlignment.Top,
					Size = UDim2.new(1, -28, 0, v482 + 10),
					Position = UDim2.new(0, 14, 0, (k - 1) * (v483 + 10)),
					TextColor3 = VRService.VREnabled and color3 or v177,
					Font = v480,
					TextSize = v481,
					Text = v489,
					SelectionImageObject = v488,
					Parent = v192
				})
				Create("TextLabel")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 10,
					Name = "Subtitle" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v482 * 0.8),
					Position = UDim2.new(0, 14, 0, 15),
					TextColor3 = VRService.VREnabled and color3 or v177,
					Font = v480,
					TextSize = v481 * 0.8,
					Text = s3,
					Parent = u492
				})
			else
				u492 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v482),
					Position = UDim2.new(0, 14, 0, (k - 1) * v483),
					TextColor3 = VRService.VREnabled and color3 or v177,
					Font = v480,
					TextSize = v481,
					Text = v,
					SelectionImageObject = v488,
					Parent = v192
				})
			end

			if k == p72 then
				t6.CurrentIndex = k
				DropDownFrameTextLabel.Text = v489
				u492.TextColor3 = v179
			elseif not p72 and k == 1 then
				u492.TextColor3 = v179
			end

			local function v493() -- line: 1070
				-- upvalues: DropDownFrameTextLabel (copy), u492 (ref), v195 (copy), t6 (copy), k (copy), BindableEvent (copy)
				DropDownFrameTextLabel.Text = u492.Text
				v195()
				t6.CurrentIndex = k
				BindableEvent:Fire(k)
			end

			u492.MouseButton1Click:Connect(v493)
			u492.MouseEnter:Connect(function() -- line: 1079
				-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u492 (ref)
				if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
					GuiService.SelectedCoreObject = u492
				end
			end)
			t6.Selections[k] = u492
			t6.SelectionInfo[u492] = {
				Clicked = v493
			}
		end

		GuiService:RemoveSelectionGroup(guid)
		GuiService:AddSelectionTuple(guid, unpack(t6.Selections))
		v192.CanvasSize = UDim2.new(1, -20, 0, #p95 * v483 + n2)

		local function updateDropDownSize() -- line: 1095
			-- upvalues: v192 (copy), v189 (copy), v191 (copy), v484 (copy)
			if v192.CanvasSize.Y.Offset < v189.AbsoluteSize.Y - 10 then
				v191.Size = UDim2.new(0, v484, 0, v192.CanvasSize.Y.Offset + 25)

				return
			end

			v191.Size = UDim2.new(0, v484, 0.9, 0)
		end

		v189.Changed:Connect(function(property) -- line: 1108
			-- upvalues: updateDropDownSize (copy)
			if property ~= "AbsoluteSize" then
				return
			end

			updateDropDownSize()
		end)
		updateDropDownSize()
	end

	t6:UpdateDropDownList(p71)
	v189.MouseButton1Click:Connect(v195)
	p73.PoppedMenu:Connect(function(p96) -- line: 1123
		-- upvalues: v189 (copy), v195 (copy)
		if p96 == v189 then
			v195()
		end
	end)

	return t6
end
local function CreateSelector(p97, p98) -- line: 1132
	-- upvalues: Create (copy), v41 (copy), Theme (copy), v4 (copy), UserInputService (copy), v5 (copy), addHoverState (copy), VRService (copy), GuiService (copy), EaseOutQuad (copy), v6 (copy), v37 (copy), v38 (copy), v39 (copy), t1 (copy)
	local n3 = 0
	local t7 = {
		HubRef = nil,
		SetSelectionIndex = nil
	}

	if type(p97) ~= "table" then
		error("CreateSelector selectionStringTable (first arg) is not a table", 2)

		return t7
	end

	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "IndexChanged"

	local u209 = true

	t7.CurrentIndex = 0
	t7.SelectorFrame = Create("ImageButton")({
		Name = "Selector",
		Image = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		ZIndex = 2,
		NextSelectionLeft = t7.SelectorFrame,
		NextSelectionRight = t7.SelectorFrame,
		Size = UDim2.new(0.6, 0, 0, 50),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		SelectionImageObject = v41
	})

	local v210 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v41,
		Parent = t7.SelectorFrame
	})
	local v211 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v41,
		Parent = t7.SelectorFrame
	})
	local v212 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v210
	})
	local v213 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v211
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v214(p99) -- line: 1218
			-- upvalues: v4 (copy)
			p99.ImageColor3 = v4
		end
		local function v215(p100) -- line: 1220
			-- upvalues: v5 (copy)
			p100.ImageColor3 = v5
		end

		addHoverState(v210, v212, v214, v215)
		addHoverState(v211, v213, v214, v215)
	end

	t7.Selections = {}

	local t8 = {}
	local t9 = {}
	local v218 = Create("ImageButton")({
		Name = "AutoSelectButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 2,
		Position = UDim2.new(0, v210.Size.X.Offset, 0, 0),
		Size = UDim2.new(1, v210.Size.X.Offset * -2, 1, 0),
		Parent = t7.SelectorFrame,
		SelectionImageObject = v41
	})

	v218.MouseButton1Click:Connect(function() -- line: 1241
		-- upvalues: u209 (ref), t7 (copy), VRService (copy), UserInputService (copy), GuiService (copy)
		if not u209 then
			return
		end

		if #t7.Selections <= 1 then
			return
		end

		local v498 = t7.CurrentIndex + 1

		if v498 > #t7.Selections then
			v498 = 1
		end

		t7:SetSelectionIndex(v498)

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end
	end)
	t9[v218] = true

	local function setSelection(p101, p102) -- line: 1260
		-- upvalues: t7 (copy), v210 (copy), t8 (ref), EaseOutQuad (copy), BindableEvent (copy)
		for k, v in pairs(t7.Selections) do
			local v503 = k == p101
			local uDim2 = UDim2.new(0, v210.Size.X.Offset, 0, 0)
			local uDim2_2 = UDim2.new(0, v210.Size.X.Offset * p102 * 3, 0, 0)

			if t8[v] then
				uDim2_2 = UDim2.new(0, v210.Size.X.Offset * -p102 * 3, 0, 0)
			end

			if uDim2_2.X.Offset < 0 then
				uDim2_2 = UDim2.new(0, uDim2_2.X.Offset + v.AbsoluteSize.X / 4, 0, 0)
			end

			if v503 then
				t8[v] = true
				v.Position = uDim2_2
				v.Visible = true
				PropertyTweener(v, "TextTransparency", 1, 0, 0.165, EaseOutQuad)

				if v:IsDescendantOf(game) then
					v:TweenPositionInternal(uDim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
				else
					v.Position = uDim2
				end

				t7.CurrentIndex = k
				BindableEvent:Fire(p101)
			elseif t8[v] then
				t8[v] = false
				PropertyTweener(v, "TextTransparency", 0, 1, 0.165, EaseOutQuad)

				if v:IsDescendantOf(game) then
					v:TweenPositionInternal(uDim2_2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true)
				else
					v.Position = uDim2_2
				end
			end
		end
	end
	local function stepFunc(p103, p104) -- line: 1311
		-- upvalues: u209 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if not u209 then
			return
		end

		if p103 ~= nil and p103.UserInputType ~= Enum.UserInputType.MouseButton1 and p103.UserInputType ~= Enum.UserInputType.Gamepad1 and p103.UserInputType ~= Enum.UserInputType.Gamepad2 and p103.UserInputType ~= Enum.UserInputType.Gamepad3 and p103.UserInputType ~= Enum.UserInputType.Gamepad4 and p103.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end

		local v508 = p104 + t7.CurrentIndex
		local v509 = not (v508 > t7.CurrentIndex) and -1 or 1

		if v508 > #t7.Selections then
			v508 = 1
		elseif v508 < 1 then
			v508 = #t7.Selections
		end

		setSelection(v508, v509)
	end

	local connection = nil

	local function connectToGuiService() -- line: 1351
		-- upvalues: connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1352
			-- upvalues: t7 (copy), GuiService (copy), t9 (copy), VRService (copy)
			if #t7.Selections <= 0 then
				return
			end

			if GuiService.SelectedCoreObject ~= nil and t9[GuiService.SelectedCoreObject] and not VRService.VREnabled then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end
		end)
	end

	t7.IndexChanged = BindableEvent.Event

	function t7.SetSelectionIndex(_, p106) -- line: 1365
		-- upvalues: setSelection (copy)
		setSelection(p106, 1)
	end
	function t7.GetSelectedIndex(_) -- line: 1369
		-- upvalues: t7 (copy)
		return t7.CurrentIndex
	end
	function t7.SetZIndex(_, p109) -- line: 1373
		-- upvalues: v210 (copy), v211 (copy), v212 (copy), v213 (copy), t7 (copy)
		v210.ZIndex = p109
		v211.ZIndex = p109
		v212.ZIndex = p109
		v213.ZIndex = p109

		for i = 1, #t7.Selections do
			t7.Selections[i].ZIndex = p109
		end
	end
	function t7.SetInteractable(_, p111) -- line: 1384
		-- upvalues: u209 (ref), t7 (copy), v210 (copy), v211 (copy), Theme (copy), v212 (copy), v6 (copy), v213 (copy), v4 (copy)
		u209 = p111
		t7.SelectorFrame.Selectable = u209
		v210.Active = u209
		v211.Active = u209
		v210.Visible = u209
		v211.Visible = u209

		if not u209 then
			for _, v in pairs(t7.Selections) do
				v.TextColor3 = Theme.color("NotInteractableSelection", Color3.fromRGB(255, 255, 255))
			end

			v212.ImageColor3 = v6
			v213.ImageColor3 = v6

			return
		end

		for _, v in pairs(t7.Selections) do
			v.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		v212.ImageColor3 = v4
		v213.ImageColor3 = v4
	end
	function t7.UpdateOptions(_, p113) -- line: 1409
		-- upvalues: t7 (copy), t8 (ref), Create (copy), v210 (copy), Theme (copy), v37 (copy), p98 (copy), v211 (copy)
		for _, v in pairs(t7.Selections) do
			v:Destroy()
		end

		t8 = {}
		t7.Selections = {}

		for k, v in pairs(p113) do
			local v528 = Create("TextLabel")({
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				ZIndex = 2,
				Visible = false,
				Name = "Selection" .. tostring(k),
				Size = UDim2.new(1, v210.Size.X.Offset * -2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
				TextSize = Theme.textSize(24, "UtilityText"),
				Text = v,
				Parent = t7.SelectorFrame
			})

			if v37 then
				v528.TextSize = Theme.textSize(36)
			end

			if k == p98 then
				t7.CurrentIndex = k
				v528.Position = UDim2.new(0, v210.Size.X.Offset, 0, 0)
				v528.Visible = true
				t8[v528] = true
			else
				t8[v528] = false
			end

			t7.Selections[k] = v528
		end

		local v529 = #t7.Selections > 1

		v210.Visible = v529
		v211.Visible = v529
	end

	local function onVREnabled(p114) -- line: 1457
		-- upvalues: VRService (copy), v210 (copy), v211 (copy), v218 (copy)
		if p114 ~= "VREnabled" then
			return
		end

		local VREnabled = VRService.VREnabled

		v210.Selectable = VREnabled
		v211.Selectable = VREnabled
		v218.Selectable = VREnabled
	end

	VRService.Changed:Connect(onVREnabled)

	local VREnabled = VRService.VREnabled

	v210.Selectable = VREnabled
	v211.Selectable = VREnabled
	v218.Selectable = VREnabled
	v210.InputBegan:Connect(function(input) -- line: 1469
		-- upvalues: v38 (copy), v39 (copy), u209 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v38(false) or v39(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u209 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v533 = -1 + t7.CurrentIndex
			local v534 = not (v533 > t7.CurrentIndex) and -1 or 1

			if v533 > #t7.Selections then
				v533 = 1
			elseif v533 < 1 then
				v533 = #t7.Selections
			end

			setSelection(v533, v534)
		end
	end)
	v211.InputBegan:Connect(function(input) -- line: 1475
		-- upvalues: v38 (copy), v39 (copy), u209 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v38(false) or v39(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u209 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v536 = 1 + t7.CurrentIndex
			local v537 = not (v536 > t7.CurrentIndex) and -1 or 1

			if v536 > #t7.Selections then
				v536 = 1
			elseif v536 < 1 then
				v536 = #t7.Selections
			end

			setSelection(v536, v537)
		end
	end)

	local u225 = true

	t7:UpdateOptions(p97)
	UserInputService.InputBegan:Connect(function(input) -- line: 1485
		-- upvalues: u209 (ref), u225 (ref), GuiService (copy), t7 (copy), VRService (copy), UserInputService (copy), setSelection (copy)
		if not u209 then
			return
		end

		if not u225 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if GuiService.SelectedCoreObject ~= t7.SelectorFrame then
			return
		end

		if input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.A then
			if not u209 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v539 = -1 + t7.CurrentIndex
			local v540 = not (v539 > t7.CurrentIndex) and -1 or 1

			if v539 > #t7.Selections then
				v539 = 1
			elseif v539 < 1 then
				v539 = #t7.Selections
			end

			setSelection(v539, v540)

			return
		end

		if input.KeyCode == Enum.KeyCode.DPadRight or input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.D then
			if not u209 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v541 = 1 + t7.CurrentIndex
			local v542 = not (v541 > t7.CurrentIndex) and -1 or 1

			if v541 > #t7.Selections then
				v541 = 1
			elseif v541 < 1 then
				v541 = #t7.Selections
			end

			setSelection(v541, v542)
		end
	end)
	UserInputService.InputChanged:Connect(function(input) -- line: 1518
		-- upvalues: u209 (ref), u225 (ref), n3 (ref), GuiService (copy), t7 (copy), stepFunc (copy)
		if not u209 then
			return
		end

		if not u225 then
			n3 = 0

			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t7.SelectorFrame.Parent) then
			return
		end

		if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
			return
		end

		if input.Position.X > 0.8 and input.Delta.X > 0 and n3 ~= 1 then
			n3 = 1
			stepFunc(input, n3)

			return
		end

		if input.Position.X < -0.8 and input.Delta.X < 0 and n3 ~= -1 then
			n3 = -1
			stepFunc(input, n3)

			return
		end

		if math.abs(input.Position.X) < 0.8 then
			n3 = 0
		end
	end)
	t7.SelectorFrame.AncestryChanged:Connect(function(_, parent) -- line: 1559
		-- upvalues: u225 (ref), connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		u225 = parent

		if not u225 then
			if connection then
				connection:Disconnect()

				return
			end
		else
			connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1352
				-- upvalues: t7 (copy), GuiService (copy), t9 (copy), VRService (copy)
				if #t7.Selections <= 0 then
					return
				end

				if GuiService.SelectedCoreObject ~= nil and t9[GuiService.SelectedCoreObject] and not VRService.VREnabled then
					GuiService.SelectedCoreObject = t7.SelectorFrame
				end
			end)
		end
	end)

	local function onResized(_, p117) -- line: 1570
		-- upvalues: Theme (copy), v37 (copy), t7 (copy)
		local v549 = if not p117 then v37 and Theme.textSize(36) or Theme.textSize(24, "UtilityText") else Theme.textSize(16)

		for _, v in pairs(t7.Selections) do
			v.TextSize = v549
		end
	end

	t1[t7.SelectorFrame] = onResized

	local v227 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v228 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v227, v228.Y > v228.X)
	connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1352
		-- upvalues: t7 (copy), GuiService (copy), t9 (copy), VRService (copy)
		if #t7.Selections <= 0 then
			return
		end

		if GuiService.SelectedCoreObject ~= nil and t9[GuiService.SelectedCoreObject] and not VRService.VREnabled then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end
	end)

	return t7
end
local function ShowAlert(p118, p119, p120, p121, p122) -- line: 1589
	-- upvalues: CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), Create (copy), Theme (copy), HttpService (copy), ContextActionService (copy), GuiService (copy), MakeButton (copy), UserInputService (copy)
	local RobloxGui2 = CoreGui.RobloxGui

	if RobloxGui2:FindFirstChild("AlertViewFullScreen") then
		return
	end

	local u235 = nil

	local function onVREnabled(p123) -- line: 1600
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), RobloxGui2 (ref), CoreGui (copy), u235 (ref)
		if p123 ~= "VREnabled" then
			return
		end

		local v553 = nil

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				RobloxGui2 = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			else
				v553 = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu")
				RobloxGui2 = v553:GetGUI()
			end
		else
			RobloxGui2 = CoreGui.RobloxGui
		end

		if u235 and u235.Parent ~= nil then
			u235.Parent = RobloxGui2

			if VRService.VREnabled and not isInExperienceUIVREnabled then
				v553:SetSubpanelDepth(u235, 0.5)
			end
		end
	end

	local connection = VRService.Changed:Connect(onVREnabled)

	u235 = Create("ImageLabel")({
		Name = "AlertViewBacking",
		Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		ZIndex = 9,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 6, 46, 44),
		Size = UDim2.new(0, 400, 0, 350),
		Position = UDim2.new(0.5, -200, 0.5, -175),
		Parent = RobloxGui2
	})
	onVREnabled("VREnabled")

	if p122 or not isInExperienceUIVREnabled and VRService.VREnabled then
		u235.ImageTransparency = 0
	else
		u235.Size = UDim2.new(0.8, 0, 0, 350)
		u235.Position = UDim2.new(0.1, 0, 0.1, 0)
	end

	if CoreGui.RobloxGui.AbsoluteSize.Y <= u235.Size.Y.Offset then
		u235.Size = UDim2.new(u235.Size.X.Scale, u235.Size.X.Offset, u235.Size.Y.Scale, CoreGui.RobloxGui.AbsoluteSize.Y)
		u235.Position = UDim2.new(u235.Position.X.Scale, -u235.Size.X.Offset / 2, 0.5, -u235.Size.Y.Offset / 2)
	end

	if not p122 then
		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = u235
		})
		u235.BackgroundColor3 = Theme.color("MenuContainer")
		u235.BackgroundTransparency = Theme.transparency("MenuContainer")
	end

	Create("TextLabel")({
		Name = "AlertViewText",
		BackgroundTransparency = 1,
		TextWrapped = true,
		ZIndex = 10,
		Size = UDim2.new(0.95, 0, 0.6, 0),
		Position = UDim2.new(0.025, 0, 0.05, 0),
		Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
		TextSize = Theme.textSize(36),
		Text = p118,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = u235
	})
	Create("ImageLabel")({
		Image = "",
		BackgroundTransparency = 1
	})

	local guid = HttpService:GenerateGUID(false)

	local function v239(_, p125) -- line: 1699
		-- upvalues: VRService (copy), u235 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy), p121 (copy), ContextActionService (copy), guid (copy), GuiService (copy), p120 (copy), connection (copy)
		if VRService.VREnabled and (p125 == Enum.UserInputState.Begin or p125 == Enum.UserInputState.Cancel) then
			return
		end

		if not u235 then
			return
		end

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(u235, 0)
		end

		u235:Destroy()
		u235 = nil

		if p121 then
			p121()
		end

		ContextActionService:UnbindCoreAction(guid)
		GuiService.SelectedCoreObject = nil

		if p120 then
			p120:ShowBar()
		end

		if connection then
			connection:Disconnect()
		end
	end

	local uDim2 = UDim2.new(1, -20, 0, 60)
	local uDim2_3 = UDim2.new(0, 10, 0.65, 0)

	if not p122 then
		uDim2 = UDim2.new(0, 200, 0, 50)
		uDim2_3 = UDim2.new(0.5, -100, 0.65, 0)
	end

	local v242, v243 = MakeButton("AlertViewButton", p119, uDim2, v239)

	v242.Position = uDim2_3
	v242.NextSelectionLeft = v242
	v242.NextSelectionRight = v242
	v242.NextSelectionUp = v242
	v242.NextSelectionDown = v242
	v242.ZIndex = 9
	v243.ZIndex = v242.ZIndex
	v242.Parent = u235

	if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
		GuiService.SelectedCoreObject = v242
	end

	GuiService.SelectedCoreObject = v242
	ContextActionService:BindCoreAction(guid, v239, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA)

	if p120 and (isInExperienceUIVREnabled or not VRService.VREnabled) then
		p120:HideBar()
		p120.Pages.CurrentPage:Hide(1, 1)
	end
end
local function CreateNewSlider(p126, p127, p128, p129, p130) -- line: 1769
	-- upvalues: HttpService (copy), Signal (copy), Create (copy), v41 (copy), RobloxGui (copy), Theme (copy), UserInputService (copy), v5 (copy), v4 (copy), v5 (copy), addHoverState (copy), v2 (copy), v3 (copy), VRService (copy), GuiService (copy), RunService (copy)
	local t10 = {}
	local num = tonumber(p126)
	local u252 = p127
	local n4 = 0
	local timestamp = nil
	local u255 = true
	local guid = HttpService:GenerateGUID(false)

	if num <= 0 then
		error("CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer", 2)

		return
	end

	local v257 = p129 or p130
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ValueChanged"

	local v259 = Signal.new()

	t10.SliderFrame = Create("ImageButton")({
		Name = "Slider",
		Image = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		ZIndex = 2,
		NextSelectionLeft = t10.SliderFrame,
		NextSelectionRight = t10.SliderFrame,
		Size = UDim2.new(0.6, 0, 0, 50),
		AutomaticSize = if not v257 then nil else Enum.AutomaticSize.Y,
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		SelectionImageObject = v41
	})

	local v260 = nil

	if v257 then
		v260 = Create("Frame")({
			Name = "StepsAndButtonsContainer",
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 50),
			Parent = t10.SliderFrame
		})
		Create("UIListLayout")({
			Name = "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = t10.SliderFrame
		})

		local v261 = Create("Frame")({
			Name = "SliderLabels",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = t10.SliderFrame
		})

		Create("UIPadding")({
			Name = "UIPadding",
			PaddingRight = UDim.new(0, 50),
			PaddingLeft = UDim.new(0, 50),
			Parent = v261
		})

		local function isWideEnough() -- line: 1851
			-- upvalues: RobloxGui (copy)
			return RobloxGui.AbsoluteSize.X > 460
		end

		if p129 then
			t10.LeftLabel = Create("TextLabel")({
				Name = "LeftLabel",
				TextTransparency = 0.25,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p129,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
				TextSize = Theme.textSize(18, "UtilityRow"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = v261,
				Visible = RobloxGui.AbsoluteSize.X > 460
			})
		end

		if p130 then
			t10.RightLabel = Create("TextLabel")({
				Name = "RightLabel",
				TextTransparency = 0.25,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p130,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
				TextSize = Theme.textSize(18, "UtilityRow"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Right,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = v261,
				Visible = RobloxGui.AbsoluteSize.X > 460
			})
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(function() -- line: 1890
			-- upvalues: t10 (copy), RobloxGui (copy)
			if t10.LeftLabel then
				t10.LeftLabel.Visible = RobloxGui.AbsoluteSize.X > 460
			end

			if t10.RightLabel then
				t10.RightLabel.Visible = RobloxGui.AbsoluteSize.X > 460
			end
		end)
	end

	t10.StepsContainer = Create("Frame")({
		Name = "StepsContainer",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -100, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = if not v257 then t10.SliderFrame else v260
	})

	local v263 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v41,
		Parent = if not v257 then t10.SliderFrame else v260
	})
	local v264 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v41,
		Parent = if not v257 then t10.SliderFrame else v260
	})
	local v265 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v263,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})
	local v266 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/More.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v264,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v267(p131) -- line: 1961
			-- upvalues: v4 (copy)
			p131.ImageColor3 = v4
		end
		local function v268(p132) -- line: 1963
			-- upvalues: v5 (copy)
			p132.ImageColor3 = v5
		end

		addHoverState(v263, v265, v267, v268)
		addHoverState(v264, v266, v267, v268)
	end

	t10.Steps = {}

	local v269 = 1 / num

	for i = 1, num do
		local v271 = Create("ImageButton")({
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Active = false,
			Image = "",
			ZIndex = 3,
			Selectable = false,
			ImageTransparency = 0.36,
			Name = "Step" .. tostring(i),
			BackgroundColor3 = v2,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new((i - 1) * v269, 2, 0.5, 0),
			Size = UDim2.new(v269, -4, 0, 24),
			Parent = t10.StepsContainer,
			SelectionImageObject = v41
		})

		if i > u252 then
			v271.BackgroundColor3 = v3
		end

		if i == 1 or i == num then
			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v271
			})
			Create("Frame")({
				Name = "Filler",
				BorderSizePixel = 0,
				BackgroundColor3 = v271.BackgroundColor3,
				Parent = v271,
				Size = UDim2.new(0.25, 0, 1, 0),
				Position = if i ~= 1 then UDim2.new(0, 0, 0, 0) else UDim2.new(0.75, 0, 0, 0)
			})
		end

		t10.Steps[#t10.Steps + 1] = v271
	end

	local function hideSelection() -- line: 2017
		-- upvalues: num (copy), t10 (copy), v3 (copy)
		for i = 1, num do
			t10.Steps[i].BackgroundColor3 = v3

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v3
			end
		end
	end
	local function showSelection() -- line: 2025
		-- upvalues: num (copy), u252 (ref), t10 (copy), v2 (copy)
		for i = 1, num do
			if i > u252 then
				return
			end

			t10.Steps[i].BackgroundColor3 = v2

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v2
			end
		end
	end
	local function setCurrentStep(p133) -- line: 2037
		-- upvalues: p128 (ref), v263 (copy), v264 (copy), num (copy), u252 (ref), hideSelection (copy), showSelection (copy), timestamp (ref), v259 (copy), BindableEvent (copy)
		if not p128 then
			p128 = 0
		end

		v263.Visible = true
		v264.Visible = true

		if p133 <= p128 then
			p133 = p128
			v263.Visible = false
		end

		if p133 >= num then
			p133 = num
			v264.Visible = false
		end

		if p133 == u252 then
			return
		end

		u252 = p133
		hideSelection()
		showSelection()
		timestamp = tick()

		if v259 then
			v259:fire(u252)

			return
		end

		BindableEvent:Fire(u252)
	end
	local function isActivateEvent(p134) -- line: 2071
		if not p134 then
			return false
		end

		return p134.UserInputType == Enum.UserInputType.MouseButton1 or (p134.UserInputType == Enum.UserInputType.Touch or p134.UserInputType == Enum.UserInputType.Gamepad1 and p134.KeyCode == Enum.KeyCode.ButtonA)
	end
	local function mouseDownFunc(p135, p136, p137) -- line: 2082
		-- upvalues: u255 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), u252 (ref), num (copy), setCurrentStep (copy)
		if not u255 then
			return
		end

		if p135 == nil then
			return
		end

		if not if p135 then p135.UserInputType == Enum.UserInputType.MouseButton1 or (p135.UserInputType == Enum.UserInputType.Touch or p135.UserInputType == Enum.UserInputType.Gamepad1 and p135.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) and not VRService.VREnabled then
			GuiService.SelectedCoreObject = t10.SliderFrame
		end

		if not VRService.VREnabled then
			if p137 then
				n4 = p136 - u252
			else
				n4 = 0

				local connection = nil
				local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 2108
					-- upvalues: num (copy), t10 (copy), setCurrentStep (copy)
					if input.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					local PositionX = input.Position.X

					for i = 1, num do
						local AbsolutePositionX = t10.Steps[i].AbsolutePosition.X
						local AbsoluteSizeX = t10.Steps[i].AbsoluteSize.X

						if AbsolutePositionX <= PositionX and PositionX <= AbsolutePositionX + AbsoluteSizeX then
							setCurrentStep(i)

							return
						end

						if i == 1 and PositionX < AbsolutePositionX then
							setCurrentStep(0)

							return
						end

						if i == num and AbsolutePositionX <= PositionX then
							setCurrentStep(i)

							return
						end
					end
				end)

				connection = UserInputService.InputEnded:Connect(function(input) -- line: 2129
					-- upvalues: n4 (ref), connection (ref), connection2 (ref)
					if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
						return
					end

					n4 = 0
					connection:Disconnect()
					connection2:Disconnect()
				end)
			end
		else
			n4 = 0
		end

		setCurrentStep(p136)
	end
	local function mouseUpFunc(p138) -- line: 2146
		-- upvalues: u255 (ref), n4 (ref)
		if not u255 then
			return
		end

		if not if p138 then p138.UserInputType == Enum.UserInputType.MouseButton1 or (p138.UserInputType == Enum.UserInputType.Touch or p138.UserInputType == Enum.UserInputType.Gamepad1 and p138.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end

	t10.ValueChanged = BindableEvent.Event

	if v259 then
		t10.ValueChanged = v259
	end

	function t10.SetValue(_, p140) -- line: 2163
		-- upvalues: setCurrentStep (copy)
		setCurrentStep(p140)
	end
	function t10.GetValue(_) -- line: 2167
		-- upvalues: u252 (ref)
		return u252
	end
	function t10.SetInteractable(_, p143) -- line: 2171
		-- upvalues: n4 (ref), u255 (ref), t10 (copy), hideSelection (copy), showSelection (copy)
		n4 = 0
		u255 = p143
		t10.SliderFrame.Selectable = p143

		if not u255 then
			hideSelection()

			return
		end

		showSelection()
	end
	function t10.SetZIndex(_, p145) -- line: 2182
		-- upvalues: v263 (copy), v264 (copy), v265 (copy), v266 (copy), t10 (copy)
		v263.ZIndex = p145
		v264.ZIndex = p145
		v265.ZIndex = p145
		v266.ZIndex = p145

		for i = 1, #t10.Steps do
			t10.Steps[i].ZIndex = p145
		end
	end
	function t10.SetMinStep(_, p147) -- line: 2193
		-- upvalues: num (copy), p128 (ref), u252 (ref), v263 (copy), v264 (copy)
		if p147 >= 0 and p147 <= num then
			p128 = p147
		end

		if u252 <= p128 then
			u252 = p128
			v263.Visible = false
		end

		if u252 >= num then
			u252 = num
			v264.Visible = false
		end
	end

	v263.InputBegan:Connect(function(input) -- line: 2210
		-- upvalues: u252 (ref), u255 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v581 = u252 - 1

		if not u255 then
			return
		end

		if input == nil then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) and not VRService.VREnabled then
			GuiService.SelectedCoreObject = t10.SliderFrame
		end

		if not VRService.VREnabled then
			n4 = v581 - u252
		else
			n4 = 0
		end

		setCurrentStep(v581)
	end)
	v263.InputEnded:Connect(function(input) -- line: 2213
		-- upvalues: u255 (ref), n4 (ref)
		if not u255 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)
	v264.InputBegan:Connect(function(input) -- line: 2216
		-- upvalues: u252 (ref), u255 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v584 = u252 + 1

		if not u255 then
			return
		end

		if input == nil then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) and not VRService.VREnabled then
			GuiService.SelectedCoreObject = t10.SliderFrame
		end

		if not VRService.VREnabled then
			n4 = v584 - u252
		else
			n4 = 0
		end

		setCurrentStep(v584)
	end)
	v264.InputEnded:Connect(function(input) -- line: 2219
		-- upvalues: u255 (ref), n4 (ref)
		if not u255 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function onVREnabled(p148) -- line: 2223
		-- upvalues: VRService (copy), v263 (copy), u255 (ref), v264 (copy), t10 (copy), num (copy)
		if p148 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			v263.Selectable = u255
			v264.Selectable = u255
			t10.SliderFrame.Selectable = u255

			for i = 1, num do
				t10.Steps[i].Selectable = u255
				t10.Steps[i].Active = u255
			end

			return
		end

		v263.Selectable = false
		v264.Selectable = false
		t10.SliderFrame.Selectable = u255

		for i = 1, num do
			t10.Steps[i].Selectable = false
			t10.Steps[i].Active = false
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	for i = 1, num do
		t10.Steps[i].InputBegan:Connect(function(input) -- line: 2250
			-- upvalues: mouseDownFunc (copy), i (copy)
			mouseDownFunc(input, i)
		end)
		t10.Steps[i].InputEnded:Connect(function(input) -- line: 2253
			-- upvalues: u255 (ref), n4 (ref)
			if not u255 then
				return
			end

			if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
				return
			end

			n4 = 0
		end)
	end

	t10.SliderFrame.InputBegan:Connect(function(input) -- line: 2258
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), mouseDownFunc (copy), u252 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		mouseDownFunc(input, u252)
	end)
	t10.SliderFrame.InputEnded:Connect(function(input) -- line: 2267
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), u255 (ref), n4 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		if not u255 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function v280() -- line: 2277
		-- upvalues: timestamp (ref), setCurrentStep (copy), u252 (ref), n4 (ref)
		if timestamp == nil then
			return
		end

		if tick() - timestamp >= 0.2 then
			setCurrentStep(u252 + n4)
		end
	end

	local u281 = true
	local t11 = {
		[Enum.KeyCode.Thumbstick1] = true,
		[Enum.KeyCode.DPadLeft] = -1,
		[Enum.KeyCode.DPadRight] = 1,
		[Enum.KeyCode.Left] = -1,
		[Enum.KeyCode.Right] = 1,
		[Enum.KeyCode.A] = -1,
		[Enum.KeyCode.D] = 1,
		[Enum.KeyCode.ButtonA] = true
	}

	UserInputService.InputBegan:Connect(function(input) -- line: 2303
		-- upvalues: u255 (ref), u281 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref), setCurrentStep (copy), u252 (ref)
		if not u255 then
			return
		end

		if not u281 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			return
		end

		if t11[input.KeyCode] == -1 then
			n4 = -1
			setCurrentStep(u252 - 1)

			return
		end

		if t11[input.KeyCode] == 1 then
			n4 = 1
			setCurrentStep(u252 + 1)
		end
	end)
	UserInputService.InputEnded:Connect(function(input) -- line: 2331
		-- upvalues: u255 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref)
		if not u255 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			return
		end

		if t11[input.KeyCode] then
			n4 = 0
		end
	end)
	UserInputService.InputChanged:Connect(function(input) -- line: 2352
		-- upvalues: u255 (ref), n4 (ref), u281 (ref), GuiService (copy), t10 (copy), setCurrentStep (copy), u252 (ref)
		if not u255 then
			n4 = 0

			return
		end

		if not u281 then
			n4 = 0

			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			return
		end

		if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
			return
		end

		if input.Position.X > 0.8 and input.Delta.X > 0 and n4 ~= 1 then
			n4 = 1
			setCurrentStep(u252 + 1)

			return
		end

		if input.Position.X < -0.8 and input.Delta.X < 0 and n4 ~= -1 then
			n4 = -1
			setCurrentStep(u252 - 1)

			return
		end

		if math.abs(input.Position.X) < 0.8 then
			n4 = 0
		end
	end)

	local u283 = false

	GuiService.Changed:Connect(function(property) -- line: 2393
		-- upvalues: GuiService (copy), t10 (copy), u283 (ref), timestamp (ref), RunService (copy), guid (copy), v280 (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			if not u283 then
				u283 = true
				timestamp = tick()
				RunService:BindToRenderStep(guid, Enum.RenderPriority.Input.Value + 1, v280)

				return
			end
		elseif u283 then
			u283 = false
			RunService:UnbindFromRenderStep(guid)
		end
	end)
	t10.SliderFrame.AncestryChanged:Connect(function(_, parent) -- line: 2414
		-- upvalues: u281 (ref)
		u281 = parent
	end)
	setCurrentStep(u252)

	return t10
end

local n5 = 50

if v37 then
	n5 = 90
end

local t12 = {}

local function AddNewRow(p150, p151, p152, p153, p154, p155, p156, p157, p158, p159) -- line: 2429
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v41 (copy), Theme (copy), v37 (copy), GuiService (copy), t1 (copy), CreateNewSlider (copy), CreateSelector (copy), CreateDropDown (copy), VRService (copy), UserInputService (copy), CoreGui (copy)
	local n6 = 0
	local v295 = p152 ~= "TextBox"

	if t12[p150] then
		n6 = t12[p150]
	end

	local u296 = Create("ImageButton")({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageTransparency = 1,
		Active = false,
		AutoButtonColor = false,
		ZIndex = 2,
		Selectable = false,
		Name = p151 .. "Frame",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 18, 18),
		Size = UDim2.new(1, 0, 0, n5),
		AutomaticSize = if not p156 and (not p157 and not p158) then nil else Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, n6),
		SelectionImageObject = v41,
		Parent = p150.Page
	})

	u296.BackgroundColor3 = Theme.color("RowFrameBackground")
	u296.ImageColor3 = u296.BackgroundColor3
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u296
	})

	if u296 and p155 then
		u296.Position = UDim2.new(u296.Position.X.Scale, u296.Position.X.Offset, u296.Position.Y.Scale, u296.Position.Y.Offset + p155)
	end

	local u298

	if p156 then
		local v297 = Create("Frame")({
			BackgroundTransparency = 1,
			Name = p151 .. "RowLabelAndDescriptionFrame",
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(0.4, -20, 0, 50),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = u296
		})

		u298 = Create("TextLabel")({
			BackgroundTransparency = 1,
			TextWrapped = true,
			ZIndex = 2,
			LayoutOrder = 1,
			Name = p151 .. "Label",
			Text = p151,
			Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
			TextSize = Theme.textSize(16, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = v297
		})
		Create("TextLabel")({
			TextTransparency = 0.25,
			TextWrapped = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			LayoutOrder = 2,
			Name = p151 .. "Description",
			Text = p156,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
			TextSize = Theme.textSize(18, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = v297
		})
		Create("UIListLayout")({
			Name = p151 .. "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = v297
		})
		Create("UIPadding")({
			Name = p151 .. "UIListLayout",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = v297
		})
	else
		u298 = Create("TextLabel")({
			TextWrapped = true,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Name = p151 .. "Label",
			Text = p151,
			Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
			TextSize = Theme.textSize(16, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0.4, -20, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			Parent = u296
		})
		Create("UIPadding")({
			Name = p151 .. "UIPadding",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = u298
		})
	end

	if not v295 then
		u298.Text = ""
	end

	local function onResized(_, p161) -- line: 2561
		-- upvalues: u298 (ref), Theme (copy), v37 (copy)
		if p161 then
			u298.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		u298.TextSize = v37 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v300 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v300.Y > v300.X then
		u298.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u298.TextSize = v37 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[u296] = onResized

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v301 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v301.Y > v301.X then
		u298.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u298.TextSize = v37 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	local SliderFrame = nil
	local u303 = nil

	if p152 == "Slider" then
		u303 = CreateNewSlider(p153, p154, nil, p157, p158)
		u303.SliderFrame.Parent = u296
		SliderFrame = u303.SliderFrame
	elseif p152 == "Selector" then
		u303 = CreateSelector(p153, p154)
		u303.SelectorFrame.Parent = u296
		SliderFrame = u303.SelectorFrame
	elseif p152 == "DropDown" then
		u303 = CreateDropDown(p153, p154, p150.HubRef)
		u303.DropDownFrame.Parent = u296
		SliderFrame = u303.DropDownFrame
	elseif p152 == "TextBox" then
		local v304 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u303 = {
			HubRef = nil
		}

		local v305 = Create("TextBox")({
			BorderSizePixel = 0,
			TextWrapped = true,
			ZIndex = 2,
			ClearTextOnFocus = false,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.6, 0, 1, 0),
			Position = UDim2.new(1, 0, 0.5, 0),
			Text = p151,
			TextColor3 = Color3.fromRGB(49, 49, 49),
			BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5),
			TextYAlignment = Enum.TextYAlignment.Top,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
			TextSize = Theme.textSize(24, "UtilityText"),
			SelectionImageObject = v304,
			Interactable = p159,
			Parent = u296
		})

		SliderFrame = v305
		v305.Focused:Connect(function() -- line: 2615
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v305 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v305
			end

			if v305.Text == p151 then
				v305.Text = ""
			end
		end)

		if p155 then
			v305.Position = UDim2.new(v305.Position.X.Scale, v305.Position.X.Offset, v305.Position.Y.Scale, v305.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2633
			-- upvalues: VRService (copy), UserInputService (copy), v305 (copy), Theme (copy), u303 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v305.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.1)

				if u303.HubRef then
					u303.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2642
			-- upvalues: VRService (copy), UserInputService (copy), v305 (copy), Theme (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v305.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5)
			end
		end)

		local function processInput(p162) -- line: 2666
			-- upvalues: GuiService (copy), SliderFrame (ref), v305 (copy)
			if p162.UserInputState == Enum.UserInputState.Begin and (p162.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v305:CaptureFocus()
			end
		end

		v305.MouseEnter:Connect(function() -- line: 2648
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v608 = SliderFrame

			if v608 and v608.Visible and v608.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v608
			end
		end)
		UserInputService.InputBegan:Connect(processInput)
	elseif p152 == "TextEntry" then
		local v307 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u303 = {
			HubRef = nil
		}

		local v308 = Create("TextBox")({
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextWrapped = false,
			ZIndex = 2,
			ClearTextOnFocus = false,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.4, -10, 0, 40),
			Position = UDim2.new(1, 0, 0.5, 0),
			Text = p151,
			TextColor3 = Color3.fromRGB(178, 178, 178),
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
			TextSize = Theme.textSize(24, "UtilityText"),
			SelectionImageObject = v307,
			Parent = u296
		})

		SliderFrame = v308
		v308.Focused:Connect(function() -- line: 2707
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v308 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v308
			end

			if v308.Text == p151 then
				v308.Text = ""
			end
		end)

		if p155 then
			v308.Position = UDim2.new(v308.Position.X.Scale, v308.Position.X.Offset, v308.Position.Y.Scale, v308.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2725
			-- upvalues: VRService (copy), UserInputService (copy), v308 (copy), u303 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v308.BackgroundTransparency = 0.8

				if u303.HubRef then
					u303.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2734
			-- upvalues: VRService (copy), UserInputService (copy), v308 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v308.BackgroundTransparency = 1
			end
		end)

		local function processInput(p163) -- line: 2758
			-- upvalues: GuiService (copy), SliderFrame (ref), v308 (copy)
			if p163.UserInputState == Enum.UserInputState.Begin and (p163.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v308:CaptureFocus()
			end
		end

		u296.MouseEnter:Connect(function() -- line: 2740
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v611 = SliderFrame

			if v611 and v611.Visible and v611.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v611
			end
		end)

		function u303.SetZIndex(_, p165) -- line: 2769
			-- upvalues: v308 (copy)
			v308.ZIndex = p165
		end
		function u303.SetInteractable(_, p167) -- line: 2773
			-- upvalues: v308 (copy)
			v308.Selectable = p167

			if not p167 then
				v308.TextColor3 = Color3.fromRGB(49, 49, 49)
				v308.ZIndex = 1

				return
			end

			v308.TextColor3 = Color3.fromRGB(178, 178, 178)
			v308.ZIndex = 2
		end
		function u303.SetValue(_, p169) -- line: 2784
			-- upvalues: v308 (copy)
			v308.Text = p169
		end

		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = "ValueChanged"
		v308.FocusLost:Connect(function() -- line: 2791
			-- upvalues: BindableEvent (copy), v308 (copy)
			BindableEvent:Fire(v308.Text)
		end)
		u303.ValueChanged = BindableEvent.Event
		UserInputService.InputBegan:Connect(processInput)
	end

	u303.Name = p151 .. "ValueChanger"

	local SetAutoLocalize = u303.SetAutoLocalize

	function u303.SetAutoLocalize(p170, p171) -- line: 2803
		-- upvalues: u296 (ref), SetAutoLocalize (copy)
		u296.AutoLocalize = p171

		if SetAutoLocalize then
			SetAutoLocalize(p170, p171)
		end
	end

	local v312 = n6 + n5

	if p155 then
		v312 += p155
	end

	t12[p150] = v312

	if v295 then
		u296.MouseEnter:Connect(function() -- line: 2818
			-- upvalues: CoreGui (copy), u303 (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v622 = u303.SliderFrame or u303.SliderFrame or u303.DropDownFrame or u303.SelectorFrame

			if v622 and v622.Visible and v622.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v622
			end
		end)

		local function onVREnabled(p172) -- line: 2848
			-- upvalues: VRService (copy), u296 (ref), SliderFrame (ref), GuiService (copy), Theme (copy)
			if p172 == "VREnabled" then
				if VRService.VREnabled then
					u296.Selectable = true
					u296.Active = true
					SliderFrame.Active = true
					GuiService.Changed:Connect(function(property) -- line: 2854
						-- upvalues: GuiService (copy), u296 (ref), Theme (copy)
						if property == "SelectedCoreObject" then
							local SelectedCoreObject = GuiService.SelectedCoreObject

							if SelectedCoreObject and (SelectedCoreObject == u296 or SelectedCoreObject:IsDescendantOf(u296)) then
								u296.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
								u296.BackgroundTransparency = 1

								return
							end

							u296.ImageTransparency = 1
							u296.BackgroundTransparency = 1
						end
					end)

					return
				end

				u296.Selectable = false
				u296.Active = false
			end
		end

		VRService.Changed:Connect(onVREnabled)

		if VRService.VREnabled then
			u296.Selectable = true
			u296.Active = true
			SliderFrame.Active = true
			GuiService.Changed:Connect(function(property) -- line: 2854
				-- upvalues: GuiService (copy), u296 (ref), Theme (copy)
				if property == "SelectedCoreObject" then
					local SelectedCoreObject = GuiService.SelectedCoreObject

					if SelectedCoreObject and (SelectedCoreObject == u296 or SelectedCoreObject:IsDescendantOf(u296)) then
						u296.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
						u296.BackgroundTransparency = 1

						return
					end

					u296.ImageTransparency = 1
					u296.BackgroundTransparency = 1
				end
			end)
		else
			u296.Selectable = false
			u296.Active = false
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2875
			-- upvalues: VRService (copy), UserInputService (copy), u296 (ref), Theme (copy), u303 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				if VRService.VREnabled then
					u296.ImageTransparency = 0.5
					u296.BackgroundTransparency = 1
				else
					u296.ImageTransparency = 1
					u296.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
				end

				if u303.HubRef then
					u303.HubRef:ScrollToFrame(u296)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2890
			-- upvalues: VRService (copy), UserInputService (copy), u296 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				u296.ImageTransparency = 1
				u296.BackgroundTransparency = 1
			end
		end)
	end

	p150:AddRow(u296, u298, u303, p155, false)
	u303.Selection = SliderFrame

	return u296, u298, u303
end
local function AddNewRowObject(p173, p174, p175, p176, p177) -- line: 2905
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v41 (copy), Theme (copy), v37 (copy), t1 (copy), GuiService (copy), VRService (copy)
	local n7 = 0

	if t12[p173] then
		n7 = t12[p173]
	end

	local v320 = Create("ImageButton")({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageTransparency = 1,
		Active = false,
		AutoButtonColor = false,
		ZIndex = 2,
		Selectable = false,
		Name = p174 .. "Frame",
		AutomaticSize = Enum.AutomaticSize.Y,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10),
		Size = UDim2.new(1, 0, 0, n5),
		Position = UDim2.new(0, 0, 0, n7),
		SelectionImageObject = v41,
		Parent = p173.Page
	})

	v320.BackgroundColor3 = Theme.color("RowFrameBackground")
	v320.ImageColor3 = v320.BackgroundColor3
	v320.SelectionGained:Connect(function() -- line: 2933
		-- upvalues: v320 (copy), Theme (copy)
		v320.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	v320.SelectionLost:Connect(function() -- line: 2936
		-- upvalues: v320 (copy)
		v320.BackgroundTransparency = 1
	end)
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v320
	})

	local v321 = Create("TextLabel")({
		TextWrapped = true,
		BackgroundTransparency = 1,
		ZIndex = 2,
		Name = p174 .. "Label",
		Text = p174,
		Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
		TextSize = Theme.textSize(16, "UtilityRow"),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(0.4, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Parent = v320
	})

	Create("UIPadding")({
		Name = p174 .. "UIPadding",
		PaddingBottom = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		Parent = v321
	})

	local function onResized(_, p179) -- line: 2968
		-- upvalues: p177 (copy), v321 (copy), Theme (copy), v37 (copy)
		if p177 then
			UDim2.new(0, 200, 1, 0)
		end

		if p179 then
			v321.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		v321.TextSize = v37 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[v320] = onResized

	local v323 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v324 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v323, v324.Y > v324.X)

	if p176 then
		v320.Position = UDim2.new(v320.Position.X.Scale, v320.Position.X.Offset, v320.Position.Y.Scale, v320.Position.Y.Offset + p176)
	end

	local v325 = n7 + n5

	if p176 then
		v325 += p176
	end

	t12[p173] = v325
	v320.MouseEnter:Connect(function() -- line: 2996
		-- upvalues: v320 (copy), GuiService (copy)
		if v320.Visible then
			GuiService.SelectedCoreObject = v320
		end
	end)
	p175.SelectionImageObject = v41
	p175.SelectionGained:Connect(function() -- line: 3005
		-- upvalues: VRService (copy), v320 (copy), Theme (copy)
		if VRService.VREnabled then
			v320.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
			v320.BackgroundTransparency = 1

			return
		end

		v320.ImageTransparency = 1
		v320.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	p175.SelectionLost:Connect(function() -- line: 3014
		-- upvalues: v320 (copy)
		v320.ImageTransparency = 1
		v320.BackgroundTransparency = 1
	end)
	p175.Parent = v320
	p173:AddRow(v320, v321, p175, p176, true)

	return v320
end

local t13 = {
	GetEaseLinear = function(_) -- line: 3028
		-- upvalues: Linear (copy)
		return Linear
	end,
	GetEaseOutQuad = function(_) -- line: 3031
		-- upvalues: EaseOutQuad (copy)
		return EaseOutQuad
	end,
	GetEaseInOutQuad = function(_) -- line: 3034
		-- upvalues: EaseInOutQuad (copy)
		return EaseInOutQuad
	end,
	CreateNewSlider = function(_, p184, p185, p186, p187, p188) -- line: 3038
		-- upvalues: CreateNewSlider (copy)
		return CreateNewSlider(p184, p185, p186, p187, p188)
	end,
	CreateNewSelector = function(_, p190, p191) -- line: 3042
		-- upvalues: CreateSelector (copy)
		return (CreateSelector(p190, p191))
	end,
	CreateNewDropDown = function(_, p193, p194) -- line: 3046
		-- upvalues: CreateDropDown (copy)
		return (CreateDropDown(p193, p194, nil))
	end,
	AddNewRow = function(_, p196, p197, p198, p199, p200, p201, p202, p203, p204, p205) -- line: 3050
		-- upvalues: AddNewRow (copy)
		return AddNewRow(p196, p197, p198, p199, p200, p201, p202, p203, p204, p205)
	end,
	AddNewRowObject = function(_, p207, p208, p209, p210, p211) -- line: 3054
		-- upvalues: AddNewRowObject (copy)
		return (AddNewRowObject(p207, p208, p209, p210, p211))
	end,
	ShowAlert = function(_, p213, p214, p215, p216, p217) -- line: 3058
		-- upvalues: ShowAlert (copy)
		ShowAlert(p213, p214, p215, p216, p217)
	end,
	IsSmallTouchScreen = function(_) -- line: 3062
		-- upvalues: GuiService (copy), UserInputService (copy)
		local v365 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return UserInputService.TouchEnabled and (v365.Y < 500 or v365.X < 700)
	end,
	IsPortrait = function(_) -- line: 3066
		-- upvalues: GuiService (copy)
		local v367 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return v367.Y > v367.X
	end
}

if FFlagRefactorMenuConfirmationButtons or FFlagAddNextUpContainer then
	local function isUsingGamepad() -- line: 3071
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end

	function t13.IsUsingGamepad(_) -- line: 3075
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end
end

function t13.MakeStyledButton(_, p222, p223, p224, p225, p226, p227) -- line: 3080
	-- upvalues: MakeButton (copy)
	return MakeButton(p222, p223, p224, p225, p226, p227)
end
function t13.MakeStyledImageButton(_, p229, p230, p231, p232, p233, p234, p235, p236) -- line: 3084
	-- upvalues: MakeImageButton (copy)
	return MakeImageButton(p229, p230, p231, p232, p233, p234, p235, p236)
end
function t13.AddButtonRow(_, p238, p239, p240, p241, p242, p243) -- line: 3088
	-- upvalues: AddButtonRow (copy)
	return AddButtonRow(p238, p239, p240, p241, p242, p243)
end
function t13.MakeFocusState(_, p245, p246) -- line: 3092
	-- upvalues: MakeRoundedRectFocusState (copy)
	return MakeRoundedRectFocusState(p245, p246)
end
function t13.CreateSignal(_) -- line: 3096
	-- upvalues: CreateSignal (copy)
	return (CreateSignal())
end
function t13.UsesSelectedObject(_) -- line: 3100
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
function t13.TweenProperty(_, p250, p251, p252, p253, p254, p255, p256) -- line: 3104
	return PropertyTweener(p250, p251, p252, p253, p254, p255, p256)
end
function t13.OnResized(_, p258, p259) -- line: 3108
	-- upvalues: addOnResizedCallback (copy)
	return addOnResizedCallback(p258, p259)
end
function t13.FireOnResized(_) -- line: 3112
	-- upvalues: GuiService (copy), t13 (copy), t1 (copy)
	local v409 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v410 = t13:IsPortrait()

	for _, v in pairs(t1) do
		v(v409, v410)
	end
end
function t13.Lerp(_, p262, p263, p264) -- line: 3123
	return (1 - p262) * p263 + p262 * p264
end
function t13.Round(_, p266) -- line: 3128
	return p266 % 1 >= 0.5 and math.ceil(p266) or math.floor(p266)
end
function t13.IsExperienceOlderThanOneWeek(_, p268) -- line: 3132
	-- upvalues: Workspace (copy)
	if p268 ~= nil and p268.Created ~= nil then
		local UnixTimestampMillis = DateTime.fromIsoDate(p268.Created).UnixTimestampMillis

		if Workspace:GetServerTimeNow() * 1000 - UnixTimestampMillis > 604800000 then
			return true
		end
	end

	return false
end

return t13

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
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local Chrome = RobloxGui.Modules.Chrome
local v24 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.Service)
local Signals = require(CorePackages.Packages.Signals)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local FFlagHideShortcutsWhileIemDropdownActive = require(Chrome.Flags).FFlagHideShortcutsWhileIemDropdownActive
local EngineFeature2 = game:GetEngineFeature("EnablePreferredTextSizeAccessGuiService")
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local v30 = game:DefineFastFlag("IncreaseLegacyPeopleRowButtonSize", false)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CorePackages2 = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages2.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages2.Packages.BuilderIcons)
local Migration = BuilderIcons.Migration
local v38 = require(RobloxGui.Modules:WaitForChild("TenFootInterface")):IsEnabled()
local v39 = Signals.createComputed(function(p1) -- line: 86
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p1).getLastInputType(p1) == Responsive.Input.Touch
end)
local v40 = Signals.createComputed(function(p2) -- line: 91
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p2).getLastInputType(p2) == Responsive.Input.Pointer
end)
local t1 = {}

setmetatable(t1, {
	__mode = "k"
})

local v42 = Create("ImageLabel")({
	Image = "",
	BackgroundTransparency = 1
})

function clamp(p3, p4, p5) -- line: 108
	return (math.max(p3, (math.min(p4, p5))))
end

local function Linear(p6, p7, p8, p9) -- line: 113
	if p9 <= p6 then
		return p7 + p8
	end

	return p8 * p6 / p9 + p7
end
local function EaseOutQuad(p10, p11, p12, p13) -- line: 121
	if p13 <= p10 then
		return p11 + p12
	end

	local v84 = p10 / p13

	return p11 - p12 * v84 * (v84 - 2)
end
local function EaseInOutQuad(p14, p15, p16, p17) -- line: 130
	if p17 <= p14 then
		return p15 + p16
	end

	local v89 = p14 / p17

	if v89 < 0.5 then
		return 2 * p16 * v89 * v89 + p15
	end

	return p15 + p16 * (2 * (2 - v89) * v89 - 1)
end

function PropertyTweener(p18, p19, p20, p21, p22, p23, p24) -- line: 142
	-- upvalues: RunService (copy)
	local t2 = {
		StartTime = tick()
	}

	t2.EndTime = t2.StartTime + p22
	t2.Cancelled = false

	local u98 = false
	local n1 = 0

	local function finalize() -- line: 151
		-- upvalues: p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), u98 (ref), n1 (ref), p24 (copy)
		if p18 then
			p18[p19] = p23(1, p20, p21 - p20, 1)
		end

		u98 = true
		n1 = 1

		if p24 then
			p24()
		end
	end

	p18[p19] = p23(0, p20, p21 - p20, p22)
	coroutine.wrap(function() -- line: 164
		-- upvalues: t2 (copy), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), p22 (copy), n1 (ref), RunService (copy), u98 (ref), p24 (copy)
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

			u98 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end)()

	function t2.GetFinal(_) -- line: 180
		-- upvalues: p21 (copy)
		return p21
	end
	function t2.GetPercentComplete(_) -- line: 184
		-- upvalues: n1 (ref)
		return n1
	end
	function t2.IsFinished(_) -- line: 188
		-- upvalues: u98 (ref)
		return u98
	end
	function t2.Finish(p28) -- line: 192
		-- upvalues: u98 (ref), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), n1 (ref), p24 (copy)
		if not u98 then
			p28:Cancel()

			if p18 then
				p18[p19] = p23(1, p20, p21 - p20, 1)
			end

			u98 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end
	function t2.Cancel(_) -- line: 199
		-- upvalues: t2 (copy)
		t2.Cancelled = true
	end

	return t2
end

local function isTouchInput() -- line: 206
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end
local function CreateSignal() -- line: 212
	local t3 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local t4 = nil
	local u104 = nil

	function t3.fire(_, ...) -- line: 220
		-- upvalues: t4 (ref), u104 (ref), BindableEvent (copy)
		t4 = { ... }
		u104 = select("#", ...)
		BindableEvent:Fire()
	end
	function t3.connect(_, p32) -- line: 226
		-- upvalues: BindableEvent (copy), t4 (ref), u104 (ref)
		if not p32 then
			error("connect(nil)", 2)
		end

		return BindableEvent.Event:Connect(function() -- line: 230
			-- upvalues: p32 (copy), t4 (ref), u104 (ref)
			p32(unpack(t4, 1, u104))
		end)
	end
	function t3.wait(_) -- line: 235
		-- upvalues: BindableEvent (copy), t4 (ref), u104 (ref)
		BindableEvent.Event:wait()

		if not t4 then
			error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		end

		return unpack(t4, 1, u104)
	end

	return t3
end
local function getViewportSize() -- line: 246
	-- upvalues: GuiService (copy)
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	return GuiService:GetHardwareSafeViewport()
end
local function isSmallTouchScreen() -- line: 255
	-- upvalues: GuiService (copy), UserInputService (copy)
	local v105 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return UserInputService.TouchEnabled and (v105.Y < 500 or v105.X < 700)
end
local function isPortrait() -- line: 260
	-- upvalues: GuiService (copy)
	local v106 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return v106.Y > v106.X
end
local function isTenFootInterface() -- line: 265
	-- upvalues: v38 (copy)
	return v38
end
local function usesSelectedObject() -- line: 269
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
local function addHoverState(p34, p35, p36, p37) -- line: 282
	local function onNormalButtonStateCallback() -- line: 283
		-- upvalues: p34 (copy), p36 (copy), p35 (copy)
		if p34.Active then
			p36(p35)
		end
	end
	local function onHoverButtonStateCallback() -- line: 288
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
local function addOnResizedCallback(p38, p39) -- line: 302
	-- upvalues: t1 (copy), GuiService (copy)
	t1[p38] = p39

	local v115 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v116 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	p39(v115, v116.Y > v116.X)
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

local function MakeDefaultButton(p40, p41, p42, p43, p44, p45) -- line: 318
	-- upvalues: Create (copy), Theme (copy), t5 (copy), UserInputService (copy), GuiService (copy), VRService (copy)
	local v123 = Create("ImageLabel")({
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

	local u126 = Create("ImageButton")({
		AutoButtonColor = false,
		ZIndex = 2,
		Name = p40 .. "Button",
		BackgroundColor3 = Theme.color(s2),
		BackgroundTransparency = Theme.transparency(s2),
		Size = p41,
		SelectionImageObject = v123
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u126
	})

	local v127 = Create("UIStroke")({
		Name = "Border",
		Color = Theme.color(s1),
		Transparency = Theme.transparency(s1),
		Thickness = Theme.DefaultStokeThickness,
		Parent = u126
	})

	Create("BoolValue")({
		Name = "Enabled",
		Value = true,
		Parent = u126
	})

	if p42 then
		u126.MouseButton1Click:Connect(function() -- line: 365
			-- upvalues: p42 (copy), t5 (copy), UserInputService (copy)
			p42(t5[UserInputService:GetLastInputType()] or false)
		end)
	else
		if v127 then
			v127.Enabled = false
		end

		u126.Selectable = false
	end

	local function isPointerInput(p46) -- line: 375
		return p46.UserInputType == Enum.UserInputType.MouseMovement or p46.UserInputType == Enum.UserInputType.Touch
	end

	local u129 = nil

	local function setRowRef(p47) -- line: 381
		-- upvalues: u129 (ref)
		u129 = p47
	end
	local function selectButton() -- line: 385
		-- upvalues: p44 (copy), p43 (copy), u126 (ref), Theme (copy), u129 (ref)
		local v435 = p44

		if v435 == nil and p43 then
			v435 = p43.HubRef
		end

		if v435 and v435.Active or v435 == nil then
			u126.BackgroundColor3 = Theme.color("DefaultButtonHover")
			u126.BackgroundTransparency = Theme.transparency("DefaultButtonHover")

			local v436 = u126

			if u129 then
				v436 = u129
			end

			if v435 then
				v435:ScrollToFrame(v436)
			end
		end
	end
	local function deselectButton() -- line: 407
		-- upvalues: u126 (ref), Theme (copy), s2 (ref)
		u126.BackgroundColor3 = Theme.color(s2)
		u126.BackgroundTransparency = Theme.transparency(s2)
	end

	u126.InputBegan:Connect(function(input) -- line: 412
		-- upvalues: u126 (ref), selectButton (copy)
		if u126.Selectable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			selectButton()
		end
	end)
	u126.InputEnded:Connect(function(input) -- line: 417
		-- upvalues: u126 (ref), GuiService (copy), Theme (copy), s2 (ref)
		if u126.Selectable and (GuiService.SelectedCoreObject ~= u126 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
			u126.BackgroundColor3 = Theme.color(s2)
			u126.BackgroundTransparency = Theme.transparency(s2)
		end
	end)
	u126.SelectionGained:Connect(function() -- line: 423
		-- upvalues: selectButton (copy)
		selectButton()
	end)
	u126.SelectionLost:Connect(function() -- line: 426
		-- upvalues: u126 (ref), Theme (copy), s2 (ref)
		u126.BackgroundColor3 = Theme.color(s2)
		u126.BackgroundTransparency = Theme.transparency(s2)
	end)
	GuiService.Changed:Connect(function(property) -- line: 430
		-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u126 (ref), Theme (copy), s2 (ref), selectButton (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		if VRService.VREnabled or UserInputService.PreferredInput == Enum.PreferredInput.Touch and ((not UserInputService.GamepadEnabled or not true) and not false) then
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= u126 then
			u126.BackgroundColor3 = Theme.color(s2)
			u126.BackgroundTransparency = Theme.transparency(s2)

			return
		end

		if u126.Selectable then
			selectButton()
		end
	end)

	return u126, setRowRef
end
local function MakeButton(p48, p49, p50, p51, p52, p53) -- line: 451
	-- upvalues: MakeDefaultButton (copy), Create (copy), Theme (copy), GuiService (copy), UserInputService (copy), v38 (copy), EngineFeature2 (copy)
	local v139, v140 = MakeDefaultButton(p48, p50, p51, p52, p53)
	local v141 = Create("TextLabel")({
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
		Parent = v139
	})
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", v141)
	local v143 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if UserInputService.TouchEnabled and (v143.Y < 500 or v143.X < 700) then
		v141.TextSize = Theme.textSize(18)
	elseif v38 and (p48 ~= "FriendStatus" and p48 ~= "BlockButton") then
		v141.TextSize = Theme.textSize(36)
	end

	if not EngineFeature2 then
		UITextSizeConstraint.MaxTextSize = v141.TextSize
	else
		local u144 = (GuiService.PreferredTextSize.Value - 1) * 3

		UITextSizeConstraint.MaxTextSize = v141.TextSize + u144

		local TextSize = v141.TextSize

		GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(function() -- line: 487
			-- upvalues: u144 (ref), GuiService (copy), UITextSizeConstraint (copy), TextSize (copy)
			u144 = (GuiService.PreferredTextSize.Value - 1) * 3
			UITextSizeConstraint.MaxTextSize = TextSize + u144
		end)
	end

	return v139, v141, v140
end
local function MakeImageButton(p54, p55, p56, p57, p58, p59, p60, p61) -- line: 496
	-- upvalues: MakeDefaultButton (copy), Migration (copy), Theme (copy), Create (copy), v30 (copy), BuilderIcons (copy)
	if not p61 then
		p61 = "ImageButton"
	end

	local v154, v155 = MakeDefaultButton(p54, p56, p58, p59, p60, p61)
	local ImageRectOffset = nil
	local ImageRectSize = nil
	local v158 = Migration.uiblox[p55] or Migration.luaApps[p55]

	if not string.match(p55, "^rbxasset://") then
		p55 = Theme.Images[p55]
	end

	if typeof(p55) == "table" then
		ImageRectOffset = p55.ImageRectOffset
		ImageRectSize = p55.ImageRectSize
		p55 = p55.Image
	end

	local v159 = if not v158 then Create("ImageLabel")({
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
		Parent = v154
	}) else Create("TextLabel")({
		BackgroundTransparency = 1,
		ZIndex = 2,
		Name = p54 .. "TextLabel",
		Size = p57,
		TextSize = if not v30 then p57.Y.Offset * 0.6666666666666666 else p57.Y.Offset * 0.8571428571428571,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = Color3.new(1, 1, 1),
		Text = v158.name,
		FontFace = BuilderIcons.Font[v158.variant],
		Parent = v154
	})

	if p61 == "ImageButton" then
		v154.Border.Thickness = 0
		v154.Border.Transparency = 1
	end

	return v154, v159, v155
end
local function AddButtonRow(p62, p63, p64, p65, p66, p67) -- line: 551
	-- upvalues: MakeButton (copy), Create (copy)
	local v166, v167, v168 = MakeButton(p63, p64, p65, p66, p62, p67)
	local v169 = Create("Frame")({
		BackgroundTransparency = 1,
		Name = p63 .. "Row",
		Size = UDim2.new(1, 0, p65.Y.Scale, p65.Y.Offset),
		Parent = p62.Page
	})

	v166.Parent = v169
	v166.AnchorPoint = Vector2.new(1, 0)
	v166.Position = UDim2.new(1, -20, 0, 0)

	return v169, v166, v167, v168
end
local function MakeRoundedRectFocusState(p68, p69) -- line: 567
	-- upvalues: Create (copy), uDim (copy), Theme (copy), RunService (copy), UserGameSettings (copy)
	local v172 = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 12, 1, 12),
		Position = UDim2.fromOffset(-6, -6)
	})

	Create("UICorner")({
		CornerRadius = uDim,
		Parent = v172
	})

	local v173 = Create("UIStroke")({
		Transparency = 0,
		Thickness = 3,
		Color = Theme.selectionCursor.AnimatedColor,
		Parent = v172
	})
	local v174 = Create("UIGradient")({
		Rotation = 0,
		Color = Theme.selectionCursor.GradientColorSequence,
		Transparency = Theme.selectionCursor.GradientTransparencySequence,
		Parent = v173
	})

	RunService:UnbindFromRenderStep(p69)
	RunService:BindToRenderStep(p69, Enum.RenderPriority.Last.Value, function() -- line: 594
		-- upvalues: v174 (copy), Theme (copy), UserGameSettings (copy)
		local v440 = v174.Rotation + 2
		local GradientColorSequence = Theme.selectionCursor.GradientColorSequence
		local GradientTransparencySequence = Theme.selectionCursor.GradientTransparencySequence

		if UserGameSettings.ReducedMotion then
			local v443 = (math.sin((math.rad(v440))) + 1) / 2
			local Value = GradientColorSequence.Keypoints[1].Value
			local Value2 = GradientColorSequence.Keypoints[#GradientColorSequence.Keypoints].Value

			GradientColorSequence = ColorSequence.new(Value:lerp(Value2, v443))

			local Value3 = GradientTransparencySequence.Keypoints[1].Value
			local Value4 = GradientTransparencySequence.Keypoints[#GradientTransparencySequence.Keypoints].Value

			GradientTransparencySequence = NumberSequence.new(Value3 + (Value4 - Value3) * v443)
		end

		v174.Rotation = v440
		v174.Color = GradientColorSequence
		v174.Transparency = GradientTransparencySequence
	end)
	p68.AncestryChanged:Connect(function(_, parent) -- line: 618
		-- upvalues: RunService (copy), p69 (copy)
		if not parent then
			RunService:UnbindFromRenderStep(p69)
		end
	end)
	p68.SelectionImageObject = v172
end
local function CreateDropDown(p71, p72, p73) -- line: 627
	-- upvalues: Theme (copy), HttpService (copy), GuiService (copy), Create (copy), v21 (copy), CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), UserInputService (copy), ContextActionService (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v24 (copy), RobloxTranslator (copy), MakeButton (copy)
	local v178 = Theme.color("SELECTION_TEXT_COLOR_NORMAL", Color3.fromRGB(178, 178, 178))
	local color3 = Color3.fromRGB(229, 229, 229)
	local v180 = Theme.color("SELECTION_TEXT_COLOR_HIGHLIGHTED", Color3.fromRGB(255, 255, 255))
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

	local u184 = true
	local guid = HttpService:GenerateGUID(false)
	local DropDownFrameEnabled = nil
	local u187 = p71
	local v188, _ = GuiService:GetGuiInset()
	local v190 = Create("ImageButton")({
		Name = "DropDownFullscreenFrame",
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 10,
		Active = true,
		Visible = false,
		Selectable = false,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, not v21 and 0 or v188.Y),
		Position = if not v21 then nil else UDim2.new(0, 0, 0, -v188.Y),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Parent = CoreGui.RobloxGui
	})

	local function onVREnabled(p74) -- line: 679
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), v190 (copy), CoreGui (copy), t6 (copy), u187 (ref)
		if p74 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				v190.Parent = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
				v190.BackgroundTransparency = 0.2
			else
				v190.Parent = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):GetGUI()
				v190.BackgroundTransparency = 1
			end
		else
			v190.Parent = CoreGui.RobloxGui
			v190.BackgroundTransparency = 0.2
		end

		if t6.UpdateDropDownList then
			t6:UpdateDropDownList(u187)
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	local v192 = Create("ImageLabel")({
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
		Parent = v190
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v192
	})

	local v193 = Create("ScrollingFrame")({
		Name = "DropDownScrollingFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 10,
		Size = UDim2.new(1, -20, 1, -25),
		Position = UDim2.new(0, 10, 0, 10),
		ScrollBarThickness = Theme.DefaultScrollBarThickness,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = v192
	})
	local connection = nil
	local u195 = false

	local function v196(p75, p76) -- line: 743
		-- upvalues: t6 (copy), u184 (ref), p73 (copy), v190 (copy), VRService (copy), UserInputService (copy), GuiService (copy), DropDownFrame (ref), connection (ref), ContextActionService (copy), guid (copy), DropDownFrameEnabled (ref), u195 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy)
		if p75 ~= nil and p76 ~= Enum.UserInputState.Begin then
			return
		end

		t6.DropDownFrame.Selectable = u184
		p73:SetActive(true)

		if v190.Visible and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) then
			GuiService.SelectedCoreObject = DropDownFrame
		end

		v190.Visible = false

		if connection then
			connection:Disconnect()
		end

		ContextActionService:UnbindCoreAction(guid .. "Action")
		ContextActionService:UnbindCoreAction(guid .. "FreezeAction")
		DropDownFrameEnabled.Value = u184
		u195 = false

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v190, 0)
		end
	end
	local function v197() -- line: 773
	end

	local v198 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.ChooseOne")
	local uDim2 = UDim2.new(0.6, 0, 0, 40)

	t6.DropDownFrame = MakeButton("DropDownFrame", v198, uDim2, function() -- line: 775
		-- upvalues: u184 (ref), t6 (copy), u195 (ref), v190 (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), DropDownFrame (ref), GuiService (copy), connection (ref), v180 (copy), color3 (copy), v178 (copy), v196 (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v24 (copy), ContextActionService (copy), guid (copy), v197 (copy), p73 (copy), DropDownFrameEnabled (ref)
		if not u184 then
			return
		end

		t6.DropDownFrame.Selectable = false
		u195 = true
		v190.Visible = true

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v190, 0.5)
		end

		DropDownFrame = t6.DropDownFrame

		if t6.CurrentIndex and t6.CurrentIndex > 0 then
			GuiService.SelectedCoreObject = t6.Selections[t6.CurrentIndex]
		elseif #t6.Selections > 0 then
			GuiService.SelectedCoreObject = t6.Selections[1]
		end

		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 798
			-- upvalues: t6 (copy), GuiService (copy), v180 (copy), VRService (copy), color3 (copy), v178 (copy)
			for i = 1, #t6.Selections do
				if GuiService.SelectedCoreObject == t6.Selections[i] then
					t6.Selections[i].TextColor3 = v180
				else
					t6.Selections[i].TextColor3 = VRService.VREnabled and color3 or v178
				end
			end
		end)

		local v455 = v196

		if FFlagHideShortcutsWhileIemDropdownActive then
			v24:setHideShortcutBar("InExperienceMenuDropdown", true)

			function v455(p77, p78) -- line: 812
				-- upvalues: v196 (copy), v24 (copy)
				v196(p77, p78)
				v24:setHideShortcutBar("InExperienceMenuDropdown", false)
			end
		end

		ContextActionService:BindCoreAction(guid .. "FreezeAction", v197, false, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1)
		ContextActionService:BindCoreAction(guid .. "Action", v455, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
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

	local v201 = Create("ImageLabel")({
		Name = "DropDownImage",
		Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 15, 0, 10),
		Position = UDim2.new(1, -12, 0.5, 0),
		Parent = t6.DropDownFrame
	})

	t6.DropDownImage = v201

	local function setSelection(p79) -- line: 865
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v457 = false

		for k, v in pairs(t6.Selections) do
			if k == p79 then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v457 = true
			end
		end

		if v457 then
			BindableEvent:Fire(p79)
		end
	end
	local function setSelectionByValue(p80) -- line: 881
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v461 = false

		for k, v in pairs(t6.Selections) do
			if p80 == v.Text then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v461 = true
			end
		end

		if v461 then
			BindableEvent:Fire(t6.CurrentIndex)
		end

		return v461
	end
	local function setIsFaded(p81) -- line: 898
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

	function t6.SetSelectionIndex(_, p83) -- line: 913
		-- upvalues: setSelection (copy)
		setSelection(p83)
	end
	function t6.SetSelectionByValue(_, p85) -- line: 917
		-- upvalues: setSelectionByValue (copy)
		return (setSelectionByValue(p85))
	end
	function t6.ResetSelectionIndex(_) -- line: 921
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), v198 (copy), v196 (copy)
		t6.CurrentIndex = nil
		DropDownFrameTextLabel.Text = v198
		v196()
	end
	function t6.GetSelectedIndex(_) -- line: 927
		-- upvalues: t6 (copy)
		return t6.CurrentIndex
	end
	function t6.SetZIndex(_, p89) -- line: 931
		-- upvalues: t6 (copy), v201 (copy), DropDownFrameTextLabel (copy)
		t6.DropDownFrame.ZIndex = p89
		v201.ZIndex = p89
		DropDownFrameTextLabel.ZIndex = p89
	end
	function t6.SetInteractable(_, p91) -- line: 937
		-- upvalues: u184 (ref), t6 (copy), v196 (copy), VRService (copy), DropDownFrameEnabled (ref), u195 (ref)
		u184 = p91
		t6.DropDownFrame.Selectable = u184

		if not u184 then
			v196()

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

		DropDownFrameEnabled.Value = p91 and not u195
		t6.DropDownImage.Visible = p91

		if p91 then
			t6.DropDownFrame.ImageTransparency = 0

			return
		end

		t6.DropDownFrame.ImageTransparency = 0.5
	end
	function t6.SetAutoLocalize(_, p93) -- line: 964
		-- upvalues: v190 (copy)
		v190.AutoLocalize = p93
	end
	function t6.UpdateDropDownList(_, p95) -- line: 968
		-- upvalues: u187 (ref), t6 (copy), VRService (copy), Theme (copy), Create (copy), color3 (copy), v178 (copy), v193 (copy), p72 (copy), DropDownFrameTextLabel (copy), v180 (copy), v196 (copy), BindableEvent (copy), UserInputService (copy), GuiService (copy), guid (copy), v190 (copy), v192 (copy)
		u187 = p95

		if t6.Selections then
			for i = 1, #t6.Selections do
				t6.Selections[i]:Destroy()
			end
		end

		t6.Selections = {}
		t6.SelectionInfo = {}

		local VREnabled = VRService.VREnabled
		local v481 = VREnabled and Theme.font(Enum.Font.SourceSansBold, "Bold") or Theme.font(Enum.Font.SourceSans, "UtilityText")
		local v482 = VREnabled and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		local v483 = not VREnabled and 50 or 70
		local v484 = v483 + 1
		local v485 = not VREnabled and 400 or 600
		local n2 = 0

		for k, v in pairs(p95) do
			local v489 = Create("Frame")({
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			})

			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v489
			})

			local v490 = v
			local s3 = ""
			local v492 = typeof(v) == "table"

			if v492 then
				v490 = v.title
				s3 = v.subtitle
				n2 += 10
			end

			local u493

			if v492 then
				u493 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					TextYAlignment = Enum.TextYAlignment.Top,
					Size = UDim2.new(1, -28, 0, v483 + 10),
					Position = UDim2.new(0, 14, 0, (k - 1) * (v484 + 10)),
					TextColor3 = VRService.VREnabled and color3 or v178,
					Font = v481,
					TextSize = v482,
					Text = v490,
					SelectionImageObject = v489,
					Parent = v193
				})
				Create("TextLabel")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 10,
					Name = "Subtitle" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v483 * 0.8),
					Position = UDim2.new(0, 14, 0, 15),
					TextColor3 = VRService.VREnabled and color3 or v178,
					Font = v481,
					TextSize = v482 * 0.8,
					Text = s3,
					Parent = u493
				})
			else
				u493 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v483),
					Position = UDim2.new(0, 14, 0, (k - 1) * v484),
					TextColor3 = VRService.VREnabled and color3 or v178,
					Font = v481,
					TextSize = v482,
					Text = v,
					SelectionImageObject = v489,
					Parent = v193
				})
			end

			if k == p72 then
				t6.CurrentIndex = k
				DropDownFrameTextLabel.Text = v490
				u493.TextColor3 = v180
			elseif not p72 and k == 1 then
				u493.TextColor3 = v180
			end

			local function v494() -- line: 1072
				-- upvalues: DropDownFrameTextLabel (copy), u493 (ref), v196 (copy), t6 (copy), k (copy), BindableEvent (copy)
				DropDownFrameTextLabel.Text = u493.Text
				v196()
				t6.CurrentIndex = k
				BindableEvent:Fire(k)
			end

			u493.MouseButton1Click:Connect(v494)
			u493.MouseEnter:Connect(function() -- line: 1081
				-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u493 (ref)
				if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
					GuiService.SelectedCoreObject = u493
				end
			end)
			t6.Selections[k] = u493
			t6.SelectionInfo[u493] = {
				Clicked = v494
			}
		end

		GuiService:RemoveSelectionGroup(guid)
		GuiService:AddSelectionTuple(guid, unpack(t6.Selections))
		v193.CanvasSize = UDim2.new(1, -20, 0, #p95 * v484 + n2)

		local function updateDropDownSize() -- line: 1097
			-- upvalues: v193 (copy), v190 (copy), v192 (copy), v485 (copy)
			if v193.CanvasSize.Y.Offset < v190.AbsoluteSize.Y - 10 then
				v192.Size = UDim2.new(0, v485, 0, v193.CanvasSize.Y.Offset + 25)

				return
			end

			v192.Size = UDim2.new(0, v485, 0.9, 0)
		end

		v190.Changed:Connect(function(property) -- line: 1110
			-- upvalues: updateDropDownSize (copy)
			if property ~= "AbsoluteSize" then
				return
			end

			updateDropDownSize()
		end)
		updateDropDownSize()
	end

	t6:UpdateDropDownList(p71)
	v190.MouseButton1Click:Connect(v196)
	p73.PoppedMenu:Connect(function(p96) -- line: 1125
		-- upvalues: v190 (copy), v196 (copy)
		if p96 == v190 then
			v196()
		end
	end)

	return t6
end
local function CreateSelector(p97, p98) -- line: 1134
	-- upvalues: Create (copy), v42 (copy), Theme (copy), v4 (copy), UserInputService (copy), v5 (copy), addHoverState (copy), VRService (copy), GuiService (copy), EaseOutQuad (copy), EngineFeature (copy), v6 (copy), v38 (copy), v39 (copy), v40 (copy), t1 (copy)
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

	local u210 = true

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
		SelectionImageObject = v42
	})

	local v211 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v42,
		Parent = t7.SelectorFrame
	})
	local v212 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v42,
		Parent = t7.SelectorFrame
	})
	local v213 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v211
	})
	local v214 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v212
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v215(p99) -- line: 1220
			-- upvalues: v4 (copy)
			p99.ImageColor3 = v4
		end
		local function v216(p100) -- line: 1222
			-- upvalues: v5 (copy)
			p100.ImageColor3 = v5
		end

		addHoverState(v211, v213, v215, v216)
		addHoverState(v212, v214, v215, v216)
	end

	t7.Selections = {}

	local t8 = {}
	local t9 = {}
	local v219 = Create("ImageButton")({
		Name = "AutoSelectButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 2,
		Position = UDim2.new(0, v211.Size.X.Offset, 0, 0),
		Size = UDim2.new(1, v211.Size.X.Offset * -2, 1, 0),
		Parent = t7.SelectorFrame,
		SelectionImageObject = v42
	})

	v219.MouseButton1Click:Connect(function() -- line: 1243
		-- upvalues: u210 (ref), t7 (copy), VRService (copy), UserInputService (copy), GuiService (copy)
		if not u210 then
			return
		end

		if #t7.Selections <= 1 then
			return
		end

		local v499 = t7.CurrentIndex + 1

		if v499 > #t7.Selections then
			v499 = 1
		end

		t7:SetSelectionIndex(v499)

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end
	end)
	t9[v219] = true

	local function setSelection(p101, p102) -- line: 1262
		-- upvalues: t7 (copy), v211 (copy), t8 (ref), EaseOutQuad (copy), EngineFeature (copy), BindableEvent (copy)
		for k, v in pairs(t7.Selections) do
			local v504 = k == p101
			local uDim2 = UDim2.new(0, v211.Size.X.Offset, 0, 0)
			local uDim2_2 = UDim2.new(0, v211.Size.X.Offset * p102 * 3, 0, 0)

			if t8[v] then
				uDim2_2 = UDim2.new(0, v211.Size.X.Offset * -p102 * 3, 0, 0)
			end

			if uDim2_2.X.Offset < 0 then
				uDim2_2 = UDim2.new(0, uDim2_2.X.Offset + v.AbsoluteSize.X / 4, 0, 0)
			end

			if v504 then
				t8[v] = true
				v.Position = uDim2_2
				v.Visible = true
				PropertyTweener(v, "TextTransparency", 1, 0, 0.165, EaseOutQuad)

				if v:IsDescendantOf(game) then
					if EngineFeature then
						v:TweenPositionInternal(uDim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
					else
						v:TweenPosition(uDim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
					end
				else
					v.Position = uDim2
				end

				t7.CurrentIndex = k
				BindableEvent:Fire(p101)
			elseif t8[v] then
				t8[v] = false
				PropertyTweener(v, "TextTransparency", 0, 1, 0.165, EaseOutQuad)

				if v:IsDescendantOf(game) then
					if EngineFeature then
						v:TweenPositionInternal(uDim2_2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true)
					else
						v:TweenPosition(uDim2_2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true)
					end
				else
					v.Position = uDim2_2
				end
			end
		end
	end
	local function stepFunc(p103, p104) -- line: 1333
		-- upvalues: u210 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if not u210 then
			return
		end

		if p103 ~= nil and p103.UserInputType ~= Enum.UserInputType.MouseButton1 and p103.UserInputType ~= Enum.UserInputType.Gamepad1 and p103.UserInputType ~= Enum.UserInputType.Gamepad2 and p103.UserInputType ~= Enum.UserInputType.Gamepad3 and p103.UserInputType ~= Enum.UserInputType.Gamepad4 and p103.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end

		local v509 = p104 + t7.CurrentIndex
		local v510 = not (v509 > t7.CurrentIndex) and -1 or 1

		if v509 > #t7.Selections then
			v509 = 1
		elseif v509 < 1 then
			v509 = #t7.Selections
		end

		setSelection(v509, v510)
	end

	local connection = nil

	local function connectToGuiService() -- line: 1373
		-- upvalues: connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1374
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

	function t7.SetSelectionIndex(_, p106) -- line: 1387
		-- upvalues: setSelection (copy)
		setSelection(p106, 1)
	end
	function t7.GetSelectedIndex(_) -- line: 1391
		-- upvalues: t7 (copy)
		return t7.CurrentIndex
	end
	function t7.SetZIndex(_, p109) -- line: 1395
		-- upvalues: v211 (copy), v212 (copy), v213 (copy), v214 (copy), t7 (copy)
		v211.ZIndex = p109
		v212.ZIndex = p109
		v213.ZIndex = p109
		v214.ZIndex = p109

		for i = 1, #t7.Selections do
			t7.Selections[i].ZIndex = p109
		end
	end
	function t7.SetInteractable(_, p111) -- line: 1406
		-- upvalues: u210 (ref), t7 (copy), v211 (copy), v212 (copy), Theme (copy), v213 (copy), v6 (copy), v214 (copy), v4 (copy)
		u210 = p111
		t7.SelectorFrame.Selectable = u210
		v211.Active = u210
		v212.Active = u210
		v211.Visible = u210
		v212.Visible = u210

		if not u210 then
			for _, v in pairs(t7.Selections) do
				v.TextColor3 = Theme.color("NotInteractableSelection", Color3.fromRGB(255, 255, 255))
			end

			v213.ImageColor3 = v6
			v214.ImageColor3 = v6

			return
		end

		for _, v in pairs(t7.Selections) do
			v.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		v213.ImageColor3 = v4
		v214.ImageColor3 = v4
	end
	function t7.UpdateOptions(_, p113) -- line: 1431
		-- upvalues: t7 (copy), t8 (ref), Create (copy), v211 (copy), Theme (copy), v38 (copy), p98 (copy), v212 (copy)
		for _, v in pairs(t7.Selections) do
			v:Destroy()
		end

		t8 = {}
		t7.Selections = {}

		for k, v in pairs(p113) do
			local v529 = Create("TextLabel")({
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				ZIndex = 2,
				Visible = false,
				Name = "Selection" .. tostring(k),
				Size = UDim2.new(1, v211.Size.X.Offset * -2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
				TextSize = Theme.textSize(24, "UtilityText"),
				Text = v,
				Parent = t7.SelectorFrame
			})

			if v38 then
				v529.TextSize = Theme.textSize(36)
			end

			if k == p98 then
				t7.CurrentIndex = k
				v529.Position = UDim2.new(0, v211.Size.X.Offset, 0, 0)
				v529.Visible = true
				t8[v529] = true
			else
				t8[v529] = false
			end

			t7.Selections[k] = v529
		end

		local v530 = #t7.Selections > 1

		v211.Visible = v530
		v212.Visible = v530
	end

	local function onVREnabled(p114) -- line: 1479
		-- upvalues: VRService (copy), v211 (copy), v212 (copy), v219 (copy)
		if p114 ~= "VREnabled" then
			return
		end

		local VREnabled = VRService.VREnabled

		v211.Selectable = VREnabled
		v212.Selectable = VREnabled
		v219.Selectable = VREnabled
	end

	VRService.Changed:Connect(onVREnabled)

	local VREnabled = VRService.VREnabled

	v211.Selectable = VREnabled
	v212.Selectable = VREnabled
	v219.Selectable = VREnabled
	v211.InputBegan:Connect(function(input) -- line: 1491
		-- upvalues: v39 (copy), v40 (copy), u210 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v39(false) or v40(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u210 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v534 = -1 + t7.CurrentIndex
			local v535 = not (v534 > t7.CurrentIndex) and -1 or 1

			if v534 > #t7.Selections then
				v534 = 1
			elseif v534 < 1 then
				v534 = #t7.Selections
			end

			setSelection(v534, v535)
		end
	end)
	v212.InputBegan:Connect(function(input) -- line: 1497
		-- upvalues: v39 (copy), v40 (copy), u210 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v39(false) or v40(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u210 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v537 = 1 + t7.CurrentIndex
			local v538 = not (v537 > t7.CurrentIndex) and -1 or 1

			if v537 > #t7.Selections then
				v537 = 1
			elseif v537 < 1 then
				v537 = #t7.Selections
			end

			setSelection(v537, v538)
		end
	end)

	local u226 = true

	t7:UpdateOptions(p97)
	UserInputService.InputBegan:Connect(function(input) -- line: 1507
		-- upvalues: u210 (ref), u226 (ref), GuiService (copy), t7 (copy), VRService (copy), UserInputService (copy), setSelection (copy)
		if not u210 then
			return
		end

		if not u226 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if GuiService.SelectedCoreObject ~= t7.SelectorFrame then
			return
		end

		if input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.A then
			if not u210 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v540 = -1 + t7.CurrentIndex
			local v541 = not (v540 > t7.CurrentIndex) and -1 or 1

			if v540 > #t7.Selections then
				v540 = 1
			elseif v540 < 1 then
				v540 = #t7.Selections
			end

			setSelection(v540, v541)

			return
		end

		if input.KeyCode == Enum.KeyCode.DPadRight or input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.D then
			if not u210 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v542 = 1 + t7.CurrentIndex
			local v543 = not (v542 > t7.CurrentIndex) and -1 or 1

			if v542 > #t7.Selections then
				v542 = 1
			elseif v542 < 1 then
				v542 = #t7.Selections
			end

			setSelection(v542, v543)
		end
	end)
	UserInputService.InputChanged:Connect(function(input) -- line: 1540
		-- upvalues: u210 (ref), u226 (ref), n3 (ref), GuiService (copy), t7 (copy), stepFunc (copy)
		if not u210 then
			return
		end

		if not u226 then
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
	t7.SelectorFrame.AncestryChanged:Connect(function(_, parent) -- line: 1581
		-- upvalues: u226 (ref), connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		u226 = parent

		if not u226 then
			if connection then
				connection:Disconnect()

				return
			end
		else
			connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1374
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

	local function onResized(_, p117) -- line: 1592
		-- upvalues: Theme (copy), v38 (copy), t7 (copy)
		local v550 = if not p117 then v38 and Theme.textSize(36) or Theme.textSize(24, "UtilityText") else Theme.textSize(16)

		for _, v in pairs(t7.Selections) do
			v.TextSize = v550
		end
	end

	t1[t7.SelectorFrame] = onResized

	local v228 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v229 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v228, v229.Y > v229.X)
	connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1374
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
local function ShowAlert(p118, p119, p120, p121, p122) -- line: 1611
	-- upvalues: CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), Create (copy), Theme (copy), HttpService (copy), ContextActionService (copy), GuiService (copy), MakeButton (copy), UserInputService (copy)
	local RobloxGui2 = CoreGui.RobloxGui

	if RobloxGui2:FindFirstChild("AlertViewFullScreen") then
		return
	end

	local u236 = nil

	local function onVREnabled(p123) -- line: 1622
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), RobloxGui2 (ref), CoreGui (copy), u236 (ref)
		if p123 ~= "VREnabled" then
			return
		end

		local v554 = nil

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				RobloxGui2 = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			else
				v554 = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu")
				RobloxGui2 = v554:GetGUI()
			end
		else
			RobloxGui2 = CoreGui.RobloxGui
		end

		if u236 and u236.Parent ~= nil then
			u236.Parent = RobloxGui2

			if VRService.VREnabled and not isInExperienceUIVREnabled then
				v554:SetSubpanelDepth(u236, 0.5)
			end
		end
	end

	local connection = VRService.Changed:Connect(onVREnabled)

	u236 = Create("ImageLabel")({
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
		u236.ImageTransparency = 0
	else
		u236.Size = UDim2.new(0.8, 0, 0, 350)
		u236.Position = UDim2.new(0.1, 0, 0.1, 0)
	end

	if CoreGui.RobloxGui.AbsoluteSize.Y <= u236.Size.Y.Offset then
		u236.Size = UDim2.new(u236.Size.X.Scale, u236.Size.X.Offset, u236.Size.Y.Scale, CoreGui.RobloxGui.AbsoluteSize.Y)
		u236.Position = UDim2.new(u236.Position.X.Scale, -u236.Size.X.Offset / 2, 0.5, -u236.Size.Y.Offset / 2)
	end

	if not p122 then
		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = u236
		})
		u236.BackgroundColor3 = Theme.color("MenuContainer")
		u236.BackgroundTransparency = Theme.transparency("MenuContainer")
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
		Parent = u236
	})
	Create("ImageLabel")({
		Image = "",
		BackgroundTransparency = 1
	})

	local guid = HttpService:GenerateGUID(false)

	local function v240(_, p125) -- line: 1721
		-- upvalues: VRService (copy), u236 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy), p121 (copy), ContextActionService (copy), guid (copy), GuiService (copy), p120 (copy), connection (copy)
		if VRService.VREnabled and (p125 == Enum.UserInputState.Begin or p125 == Enum.UserInputState.Cancel) then
			return
		end

		if not u236 then
			return
		end

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(u236, 0)
		end

		u236:Destroy()
		u236 = nil

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

	local v243, v244 = MakeButton("AlertViewButton", p119, uDim2, v240)

	v243.Position = uDim2_3
	v243.NextSelectionLeft = v243
	v243.NextSelectionRight = v243
	v243.NextSelectionUp = v243
	v243.NextSelectionDown = v243
	v243.ZIndex = 9
	v244.ZIndex = v243.ZIndex
	v243.Parent = u236

	if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
		GuiService.SelectedCoreObject = v243
	end

	GuiService.SelectedCoreObject = v243
	ContextActionService:BindCoreAction(guid, v240, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA)

	if p120 and (isInExperienceUIVREnabled or not VRService.VREnabled) then
		p120:HideBar()
		p120.Pages.CurrentPage:Hide(1, 1)
	end
end
local function CreateNewSlider(p126, p127, p128, p129, p130) -- line: 1791
	-- upvalues: HttpService (copy), Signal (copy), Create (copy), v42 (copy), RobloxGui (copy), Theme (copy), UserInputService (copy), v5 (copy), v4 (copy), v5 (copy), addHoverState (copy), v2 (copy), v3 (copy), VRService (copy), GuiService (copy), RunService (copy)
	local t10 = {}
	local num = tonumber(p126)
	local u253 = p127
	local n4 = 0
	local timestamp = nil
	local u256 = true
	local guid = HttpService:GenerateGUID(false)

	if num <= 0 then
		error("CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer", 2)

		return
	end

	local v258 = p129 or p130
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ValueChanged"

	local v260 = Signal.new()

	t10.SliderFrame = Create("ImageButton")({
		Name = "Slider",
		Image = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		ZIndex = 2,
		NextSelectionLeft = t10.SliderFrame,
		NextSelectionRight = t10.SliderFrame,
		Size = UDim2.new(0.6, 0, 0, 50),
		AutomaticSize = if not v258 then nil else Enum.AutomaticSize.Y,
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		SelectionImageObject = v42
	})

	local v261 = nil

	if v258 then
		v261 = Create("Frame")({
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

		local v262 = Create("Frame")({
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
			Parent = v262
		})

		local function isWideEnough() -- line: 1873
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
				Parent = v262,
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
				Parent = v262,
				Visible = RobloxGui.AbsoluteSize.X > 460
			})
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(function() -- line: 1912
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
		Parent = if not v258 then t10.SliderFrame else v261
	})

	local v264 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v42,
		Parent = if not v258 then t10.SliderFrame else v261
	})
	local v265 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v42,
		Parent = if not v258 then t10.SliderFrame else v261
	})
	local v266 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v264,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})
	local v267 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/More.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v265,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v268(p131) -- line: 1983
			-- upvalues: v4 (copy)
			p131.ImageColor3 = v4
		end
		local function v269(p132) -- line: 1985
			-- upvalues: v5 (copy)
			p132.ImageColor3 = v5
		end

		addHoverState(v264, v266, v268, v269)
		addHoverState(v265, v267, v268, v269)
	end

	t10.Steps = {}

	local v270 = 1 / num

	for i = 1, num do
		local v272 = Create("ImageButton")({
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
			Position = UDim2.new((i - 1) * v270, 2, 0.5, 0),
			Size = UDim2.new(v270, -4, 0, 24),
			Parent = t10.StepsContainer,
			SelectionImageObject = v42
		})

		if i > u253 then
			v272.BackgroundColor3 = v3
		end

		if i == 1 or i == num then
			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v272
			})
			Create("Frame")({
				Name = "Filler",
				BorderSizePixel = 0,
				BackgroundColor3 = v272.BackgroundColor3,
				Parent = v272,
				Size = UDim2.new(0.25, 0, 1, 0),
				Position = if i ~= 1 then UDim2.new(0, 0, 0, 0) else UDim2.new(0.75, 0, 0, 0)
			})
		end

		t10.Steps[#t10.Steps + 1] = v272
	end

	local function hideSelection() -- line: 2039
		-- upvalues: num (copy), t10 (copy), v3 (copy)
		for i = 1, num do
			t10.Steps[i].BackgroundColor3 = v3

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v3
			end
		end
	end
	local function showSelection() -- line: 2047
		-- upvalues: num (copy), u253 (ref), t10 (copy), v2 (copy)
		for i = 1, num do
			if i > u253 then
				return
			end

			t10.Steps[i].BackgroundColor3 = v2

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v2
			end
		end
	end
	local function setCurrentStep(p133) -- line: 2059
		-- upvalues: p128 (ref), v264 (copy), v265 (copy), num (copy), u253 (ref), hideSelection (copy), showSelection (copy), timestamp (ref), v260 (copy), BindableEvent (copy)
		if not p128 then
			p128 = 0
		end

		v264.Visible = true
		v265.Visible = true

		if p133 <= p128 then
			p133 = p128
			v264.Visible = false
		end

		if p133 >= num then
			p133 = num
			v265.Visible = false
		end

		if p133 == u253 then
			return
		end

		u253 = p133
		hideSelection()
		showSelection()
		timestamp = tick()

		if v260 then
			v260:fire(u253)

			return
		end

		BindableEvent:Fire(u253)
	end
	local function isActivateEvent(p134) -- line: 2093
		if not p134 then
			return false
		end

		return p134.UserInputType == Enum.UserInputType.MouseButton1 or (p134.UserInputType == Enum.UserInputType.Touch or p134.UserInputType == Enum.UserInputType.Gamepad1 and p134.KeyCode == Enum.KeyCode.ButtonA)
	end
	local function mouseDownFunc(p135, p136, p137) -- line: 2104
		-- upvalues: u256 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), u253 (ref), num (copy), setCurrentStep (copy)
		if not u256 then
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
				n4 = p136 - u253
			else
				n4 = 0

				local connection = nil
				local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 2130
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

				connection = UserInputService.InputEnded:Connect(function(input) -- line: 2151
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
	local function mouseUpFunc(p138) -- line: 2168
		-- upvalues: u256 (ref), n4 (ref)
		if not u256 then
			return
		end

		if not if p138 then p138.UserInputType == Enum.UserInputType.MouseButton1 or (p138.UserInputType == Enum.UserInputType.Touch or p138.UserInputType == Enum.UserInputType.Gamepad1 and p138.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end

	t10.ValueChanged = BindableEvent.Event

	if v260 then
		t10.ValueChanged = v260
	end

	function t10.SetValue(_, p140) -- line: 2185
		-- upvalues: setCurrentStep (copy)
		setCurrentStep(p140)
	end
	function t10.GetValue(_) -- line: 2189
		-- upvalues: u253 (ref)
		return u253
	end
	function t10.SetInteractable(_, p143) -- line: 2193
		-- upvalues: n4 (ref), u256 (ref), t10 (copy), hideSelection (copy), showSelection (copy)
		n4 = 0
		u256 = p143
		t10.SliderFrame.Selectable = p143

		if not u256 then
			hideSelection()

			return
		end

		showSelection()
	end
	function t10.SetZIndex(_, p145) -- line: 2204
		-- upvalues: v264 (copy), v265 (copy), v266 (copy), v267 (copy), t10 (copy)
		v264.ZIndex = p145
		v265.ZIndex = p145
		v266.ZIndex = p145
		v267.ZIndex = p145

		for i = 1, #t10.Steps do
			t10.Steps[i].ZIndex = p145
		end
	end
	function t10.SetMinStep(_, p147) -- line: 2215
		-- upvalues: num (copy), p128 (ref), u253 (ref), v264 (copy), v265 (copy)
		if p147 >= 0 and p147 <= num then
			p128 = p147
		end

		if u253 <= p128 then
			u253 = p128
			v264.Visible = false
		end

		if u253 >= num then
			u253 = num
			v265.Visible = false
		end
	end

	v264.InputBegan:Connect(function(input) -- line: 2232
		-- upvalues: u253 (ref), u256 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v582 = u253 - 1

		if not u256 then
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
			n4 = v582 - u253
		else
			n4 = 0
		end

		setCurrentStep(v582)
	end)
	v264.InputEnded:Connect(function(input) -- line: 2235
		-- upvalues: u256 (ref), n4 (ref)
		if not u256 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)
	v265.InputBegan:Connect(function(input) -- line: 2238
		-- upvalues: u253 (ref), u256 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v585 = u253 + 1

		if not u256 then
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
			n4 = v585 - u253
		else
			n4 = 0
		end

		setCurrentStep(v585)
	end)
	v265.InputEnded:Connect(function(input) -- line: 2241
		-- upvalues: u256 (ref), n4 (ref)
		if not u256 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function onVREnabled(p148) -- line: 2245
		-- upvalues: VRService (copy), v264 (copy), u256 (ref), v265 (copy), t10 (copy), num (copy)
		if p148 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			v264.Selectable = u256
			v265.Selectable = u256
			t10.SliderFrame.Selectable = u256

			for i = 1, num do
				t10.Steps[i].Selectable = u256
				t10.Steps[i].Active = u256
			end

			return
		end

		v264.Selectable = false
		v265.Selectable = false
		t10.SliderFrame.Selectable = u256

		for i = 1, num do
			t10.Steps[i].Selectable = false
			t10.Steps[i].Active = false
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	for i = 1, num do
		t10.Steps[i].InputBegan:Connect(function(input) -- line: 2272
			-- upvalues: mouseDownFunc (copy), i (copy)
			mouseDownFunc(input, i)
		end)
		t10.Steps[i].InputEnded:Connect(function(input) -- line: 2275
			-- upvalues: u256 (ref), n4 (ref)
			if not u256 then
				return
			end

			if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
				return
			end

			n4 = 0
		end)
	end

	t10.SliderFrame.InputBegan:Connect(function(input) -- line: 2280
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), mouseDownFunc (copy), u253 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		mouseDownFunc(input, u253)
	end)
	t10.SliderFrame.InputEnded:Connect(function(input) -- line: 2289
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), u256 (ref), n4 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		if not u256 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function v281() -- line: 2299
		-- upvalues: timestamp (ref), setCurrentStep (copy), u253 (ref), n4 (ref)
		if timestamp == nil then
			return
		end

		if tick() - timestamp >= 0.2 then
			setCurrentStep(u253 + n4)
		end
	end

	local u282 = true
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

	UserInputService.InputBegan:Connect(function(input) -- line: 2325
		-- upvalues: u256 (ref), u282 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref), setCurrentStep (copy), u253 (ref)
		if not u256 then
			return
		end

		if not u282 then
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
			setCurrentStep(u253 - 1)

			return
		end

		if t11[input.KeyCode] == 1 then
			n4 = 1
			setCurrentStep(u253 + 1)
		end
	end)
	UserInputService.InputEnded:Connect(function(input) -- line: 2353
		-- upvalues: u256 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref)
		if not u256 then
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
	UserInputService.InputChanged:Connect(function(input) -- line: 2374
		-- upvalues: u256 (ref), n4 (ref), u282 (ref), GuiService (copy), t10 (copy), setCurrentStep (copy), u253 (ref)
		if not u256 then
			n4 = 0

			return
		end

		if not u282 then
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
			setCurrentStep(u253 + 1)

			return
		end

		if input.Position.X < -0.8 and input.Delta.X < 0 and n4 ~= -1 then
			n4 = -1
			setCurrentStep(u253 - 1)

			return
		end

		if math.abs(input.Position.X) < 0.8 then
			n4 = 0
		end
	end)

	local u284 = false

	GuiService.Changed:Connect(function(property) -- line: 2415
		-- upvalues: GuiService (copy), t10 (copy), u284 (ref), timestamp (ref), RunService (copy), guid (copy), v281 (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			if not u284 then
				u284 = true
				timestamp = tick()
				RunService:BindToRenderStep(guid, Enum.RenderPriority.Input.Value + 1, v281)

				return
			end
		elseif u284 then
			u284 = false
			RunService:UnbindFromRenderStep(guid)
		end
	end)
	t10.SliderFrame.AncestryChanged:Connect(function(_, parent) -- line: 2436
		-- upvalues: u282 (ref)
		u282 = parent
	end)
	setCurrentStep(u253)

	return t10
end

local n5 = 50

if v38 then
	n5 = 90
end

local t12 = {}

local function AddNewRow(p150, p151, p152, p153, p154, p155, p156, p157, p158, p159) -- line: 2451
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v42 (copy), Theme (copy), v38 (copy), GuiService (copy), t1 (copy), CreateNewSlider (copy), CreateSelector (copy), CreateDropDown (copy), VRService (copy), UserInputService (copy), CoreGui (copy)
	local n6 = 0
	local v296 = p152 ~= "TextBox"

	if t12[p150] then
		n6 = t12[p150]
	end

	local u297 = Create("ImageButton")({
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
		SelectionImageObject = v42,
		Parent = p150.Page
	})

	u297.BackgroundColor3 = Theme.color("RowFrameBackground")
	u297.ImageColor3 = u297.BackgroundColor3
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u297
	})

	if u297 and p155 then
		u297.Position = UDim2.new(u297.Position.X.Scale, u297.Position.X.Offset, u297.Position.Y.Scale, u297.Position.Y.Offset + p155)
	end

	local u299

	if p156 then
		local v298 = Create("Frame")({
			BackgroundTransparency = 1,
			Name = p151 .. "RowLabelAndDescriptionFrame",
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(0.4, -20, 0, 50),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = u297
		})

		u299 = Create("TextLabel")({
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
			Parent = v298
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
			Parent = v298
		})
		Create("UIListLayout")({
			Name = p151 .. "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = v298
		})
		Create("UIPadding")({
			Name = p151 .. "UIListLayout",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = v298
		})
	else
		u299 = Create("TextLabel")({
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
			Parent = u297
		})
		Create("UIPadding")({
			Name = p151 .. "UIPadding",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = u299
		})
	end

	if not v296 then
		u299.Text = ""
	end

	local function onResized(_, p161) -- line: 2583
		-- upvalues: u299 (ref), Theme (copy), v38 (copy)
		if p161 then
			u299.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		u299.TextSize = v38 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v301 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v301.Y > v301.X then
		u299.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u299.TextSize = v38 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[u297] = onResized

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v302 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v302.Y > v302.X then
		u299.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u299.TextSize = v38 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	local SliderFrame = nil
	local u304 = nil

	if p152 == "Slider" then
		u304 = CreateNewSlider(p153, p154, nil, p157, p158)
		u304.SliderFrame.Parent = u297
		SliderFrame = u304.SliderFrame
	elseif p152 == "Selector" then
		u304 = CreateSelector(p153, p154)
		u304.SelectorFrame.Parent = u297
		SliderFrame = u304.SelectorFrame
	elseif p152 == "DropDown" then
		u304 = CreateDropDown(p153, p154, p150.HubRef)
		u304.DropDownFrame.Parent = u297
		SliderFrame = u304.DropDownFrame
	elseif p152 == "TextBox" then
		local v305 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u304 = {
			HubRef = nil
		}

		local v306 = Create("TextBox")({
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
			SelectionImageObject = v305,
			Interactable = p159,
			Parent = u297
		})

		SliderFrame = v306
		v306.Focused:Connect(function() -- line: 2637
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v306 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v306
			end

			if v306.Text == p151 then
				v306.Text = ""
			end
		end)

		if p155 then
			v306.Position = UDim2.new(v306.Position.X.Scale, v306.Position.X.Offset, v306.Position.Y.Scale, v306.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2655
			-- upvalues: VRService (copy), UserInputService (copy), v306 (copy), Theme (copy), u304 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v306.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.1)

				if u304.HubRef then
					u304.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2664
			-- upvalues: VRService (copy), UserInputService (copy), v306 (copy), Theme (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v306.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5)
			end
		end)

		local function processInput(p162) -- line: 2688
			-- upvalues: GuiService (copy), SliderFrame (ref), v306 (copy)
			if p162.UserInputState == Enum.UserInputState.Begin and (p162.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v306:CaptureFocus()
			end
		end

		v306.MouseEnter:Connect(function() -- line: 2670
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v609 = SliderFrame

			if v609 and v609.Visible and v609.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v609
			end
		end)
		UserInputService.InputBegan:Connect(processInput)
	elseif p152 == "TextEntry" then
		local v308 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u304 = {
			HubRef = nil
		}

		local v309 = Create("TextBox")({
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
			SelectionImageObject = v308,
			Parent = u297
		})

		SliderFrame = v309
		v309.Focused:Connect(function() -- line: 2729
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v309 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v309
			end

			if v309.Text == p151 then
				v309.Text = ""
			end
		end)

		if p155 then
			v309.Position = UDim2.new(v309.Position.X.Scale, v309.Position.X.Offset, v309.Position.Y.Scale, v309.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2747
			-- upvalues: VRService (copy), UserInputService (copy), v309 (copy), u304 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v309.BackgroundTransparency = 0.8

				if u304.HubRef then
					u304.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2756
			-- upvalues: VRService (copy), UserInputService (copy), v309 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v309.BackgroundTransparency = 1
			end
		end)

		local function processInput(p163) -- line: 2780
			-- upvalues: GuiService (copy), SliderFrame (ref), v309 (copy)
			if p163.UserInputState == Enum.UserInputState.Begin and (p163.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v309:CaptureFocus()
			end
		end

		u297.MouseEnter:Connect(function() -- line: 2762
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v612 = SliderFrame

			if v612 and v612.Visible and v612.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v612
			end
		end)

		function u304.SetZIndex(_, p165) -- line: 2791
			-- upvalues: v309 (copy)
			v309.ZIndex = p165
		end
		function u304.SetInteractable(_, p167) -- line: 2795
			-- upvalues: v309 (copy)
			v309.Selectable = p167

			if not p167 then
				v309.TextColor3 = Color3.fromRGB(49, 49, 49)
				v309.ZIndex = 1

				return
			end

			v309.TextColor3 = Color3.fromRGB(178, 178, 178)
			v309.ZIndex = 2
		end
		function u304.SetValue(_, p169) -- line: 2806
			-- upvalues: v309 (copy)
			v309.Text = p169
		end

		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = "ValueChanged"
		v309.FocusLost:Connect(function() -- line: 2813
			-- upvalues: BindableEvent (copy), v309 (copy)
			BindableEvent:Fire(v309.Text)
		end)
		u304.ValueChanged = BindableEvent.Event
		UserInputService.InputBegan:Connect(processInput)
	end

	u304.Name = p151 .. "ValueChanger"

	local SetAutoLocalize = u304.SetAutoLocalize

	function u304.SetAutoLocalize(p170, p171) -- line: 2825
		-- upvalues: u297 (ref), SetAutoLocalize (copy)
		u297.AutoLocalize = p171

		if SetAutoLocalize then
			SetAutoLocalize(p170, p171)
		end
	end

	local v313 = n6 + n5

	if p155 then
		v313 += p155
	end

	t12[p150] = v313

	if v296 then
		u297.MouseEnter:Connect(function() -- line: 2840
			-- upvalues: CoreGui (copy), u304 (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v623 = u304.SliderFrame or u304.SliderFrame or u304.DropDownFrame or u304.SelectorFrame

			if v623 and v623.Visible and v623.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v623
			end
		end)

		local function onVREnabled(p172) -- line: 2870
			-- upvalues: VRService (copy), u297 (ref), SliderFrame (ref), GuiService (copy), Theme (copy)
			if p172 == "VREnabled" then
				if VRService.VREnabled then
					u297.Selectable = true
					u297.Active = true
					SliderFrame.Active = true
					GuiService.Changed:Connect(function(property) -- line: 2876
						-- upvalues: GuiService (copy), u297 (ref), Theme (copy)
						if property == "SelectedCoreObject" then
							local SelectedCoreObject = GuiService.SelectedCoreObject

							if SelectedCoreObject and (SelectedCoreObject == u297 or SelectedCoreObject:IsDescendantOf(u297)) then
								u297.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
								u297.BackgroundTransparency = 1

								return
							end

							u297.ImageTransparency = 1
							u297.BackgroundTransparency = 1
						end
					end)

					return
				end

				u297.Selectable = false
				u297.Active = false
			end
		end

		VRService.Changed:Connect(onVREnabled)

		if VRService.VREnabled then
			u297.Selectable = true
			u297.Active = true
			SliderFrame.Active = true
			GuiService.Changed:Connect(function(property) -- line: 2876
				-- upvalues: GuiService (copy), u297 (ref), Theme (copy)
				if property == "SelectedCoreObject" then
					local SelectedCoreObject = GuiService.SelectedCoreObject

					if SelectedCoreObject and (SelectedCoreObject == u297 or SelectedCoreObject:IsDescendantOf(u297)) then
						u297.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
						u297.BackgroundTransparency = 1

						return
					end

					u297.ImageTransparency = 1
					u297.BackgroundTransparency = 1
				end
			end)
		else
			u297.Selectable = false
			u297.Active = false
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2897
			-- upvalues: VRService (copy), UserInputService (copy), u297 (ref), Theme (copy), u304 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				if VRService.VREnabled then
					u297.ImageTransparency = 0.5
					u297.BackgroundTransparency = 1
				else
					u297.ImageTransparency = 1
					u297.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
				end

				if u304.HubRef then
					u304.HubRef:ScrollToFrame(u297)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2912
			-- upvalues: VRService (copy), UserInputService (copy), u297 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				u297.ImageTransparency = 1
				u297.BackgroundTransparency = 1
			end
		end)
	end

	p150:AddRow(u297, u299, u304, p155, false)
	u304.Selection = SliderFrame

	return u297, u299, u304
end
local function AddNewRowObject(p173, p174, p175, p176, p177) -- line: 2927
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v42 (copy), Theme (copy), v38 (copy), t1 (copy), GuiService (copy), VRService (copy)
	local n7 = 0

	if t12[p173] then
		n7 = t12[p173]
	end

	local v321 = Create("ImageButton")({
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
		SelectionImageObject = v42,
		Parent = p173.Page
	})

	v321.BackgroundColor3 = Theme.color("RowFrameBackground")
	v321.ImageColor3 = v321.BackgroundColor3
	v321.SelectionGained:Connect(function() -- line: 2955
		-- upvalues: v321 (copy), Theme (copy)
		v321.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	v321.SelectionLost:Connect(function() -- line: 2958
		-- upvalues: v321 (copy)
		v321.BackgroundTransparency = 1
	end)
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v321
	})

	local v322 = Create("TextLabel")({
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
		Parent = v321
	})

	Create("UIPadding")({
		Name = p174 .. "UIPadding",
		PaddingBottom = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		Parent = v322
	})

	local function onResized(_, p179) -- line: 2990
		-- upvalues: p177 (copy), v322 (copy), Theme (copy), v38 (copy)
		if p177 then
			UDim2.new(0, 200, 1, 0)
		end

		if p179 then
			v322.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		v322.TextSize = v38 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[v321] = onResized

	local v324 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v325 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v324, v325.Y > v325.X)

	if p176 then
		v321.Position = UDim2.new(v321.Position.X.Scale, v321.Position.X.Offset, v321.Position.Y.Scale, v321.Position.Y.Offset + p176)
	end

	local v326 = n7 + n5

	if p176 then
		v326 += p176
	end

	t12[p173] = v326
	v321.MouseEnter:Connect(function() -- line: 3018
		-- upvalues: v321 (copy), GuiService (copy)
		if v321.Visible then
			GuiService.SelectedCoreObject = v321
		end
	end)
	p175.SelectionImageObject = v42
	p175.SelectionGained:Connect(function() -- line: 3027
		-- upvalues: VRService (copy), v321 (copy), Theme (copy)
		if VRService.VREnabled then
			v321.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
			v321.BackgroundTransparency = 1

			return
		end

		v321.ImageTransparency = 1
		v321.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	p175.SelectionLost:Connect(function() -- line: 3036
		-- upvalues: v321 (copy)
		v321.ImageTransparency = 1
		v321.BackgroundTransparency = 1
	end)
	p175.Parent = v321
	p173:AddRow(v321, v322, p175, p176, true)

	return v321
end

local t13 = {
	GetEaseLinear = function(_) -- line: 3050
		-- upvalues: Linear (copy)
		return Linear
	end,
	GetEaseOutQuad = function(_) -- line: 3053
		-- upvalues: EaseOutQuad (copy)
		return EaseOutQuad
	end,
	GetEaseInOutQuad = function(_) -- line: 3056
		-- upvalues: EaseInOutQuad (copy)
		return EaseInOutQuad
	end,
	CreateNewSlider = function(_, p184, p185, p186, p187, p188) -- line: 3060
		-- upvalues: CreateNewSlider (copy)
		return CreateNewSlider(p184, p185, p186, p187, p188)
	end,
	CreateNewSelector = function(_, p190, p191) -- line: 3064
		-- upvalues: CreateSelector (copy)
		return (CreateSelector(p190, p191))
	end,
	CreateNewDropDown = function(_, p193, p194) -- line: 3068
		-- upvalues: CreateDropDown (copy)
		return (CreateDropDown(p193, p194, nil))
	end,
	AddNewRow = function(_, p196, p197, p198, p199, p200, p201, p202, p203, p204, p205) -- line: 3072
		-- upvalues: AddNewRow (copy)
		return AddNewRow(p196, p197, p198, p199, p200, p201, p202, p203, p204, p205)
	end,
	AddNewRowObject = function(_, p207, p208, p209, p210, p211) -- line: 3076
		-- upvalues: AddNewRowObject (copy)
		return (AddNewRowObject(p207, p208, p209, p210, p211))
	end,
	ShowAlert = function(_, p213, p214, p215, p216, p217) -- line: 3080
		-- upvalues: ShowAlert (copy)
		ShowAlert(p213, p214, p215, p216, p217)
	end,
	IsSmallTouchScreen = function(_) -- line: 3084
		-- upvalues: GuiService (copy), UserInputService (copy)
		local v366 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return UserInputService.TouchEnabled and (v366.Y < 500 or v366.X < 700)
	end,
	IsPortrait = function(_) -- line: 3088
		-- upvalues: GuiService (copy)
		local v368 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return v368.Y > v368.X
	end
}

if FFlagRefactorMenuConfirmationButtons or FFlagAddNextUpContainer then
	local function isUsingGamepad() -- line: 3093
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end

	function t13.IsUsingGamepad(_) -- line: 3097
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end
end

function t13.MakeStyledButton(_, p222, p223, p224, p225, p226, p227) -- line: 3102
	-- upvalues: MakeButton (copy)
	return MakeButton(p222, p223, p224, p225, p226, p227)
end
function t13.MakeStyledImageButton(_, p229, p230, p231, p232, p233, p234, p235, p236) -- line: 3106
	-- upvalues: MakeImageButton (copy)
	return MakeImageButton(p229, p230, p231, p232, p233, p234, p235, p236)
end
function t13.AddButtonRow(_, p238, p239, p240, p241, p242, p243) -- line: 3110
	-- upvalues: AddButtonRow (copy)
	return AddButtonRow(p238, p239, p240, p241, p242, p243)
end
function t13.MakeFocusState(_, p245, p246) -- line: 3114
	-- upvalues: MakeRoundedRectFocusState (copy)
	return MakeRoundedRectFocusState(p245, p246)
end
function t13.CreateSignal(_) -- line: 3118
	-- upvalues: CreateSignal (copy)
	return (CreateSignal())
end
function t13.UsesSelectedObject(_) -- line: 3122
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
function t13.TweenProperty(_, p250, p251, p252, p253, p254, p255, p256) -- line: 3126
	return PropertyTweener(p250, p251, p252, p253, p254, p255, p256)
end
function t13.OnResized(_, p258, p259) -- line: 3130
	-- upvalues: addOnResizedCallback (copy)
	return addOnResizedCallback(p258, p259)
end
function t13.FireOnResized(_) -- line: 3134
	-- upvalues: GuiService (copy), t13 (copy), t1 (copy)
	local v410 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v411 = t13:IsPortrait()

	for _, v in pairs(t1) do
		v(v410, v411)
	end
end
function t13.Lerp(_, p262, p263, p264) -- line: 3145
	return (1 - p262) * p263 + p262 * p264
end
function t13.Round(_, p266) -- line: 3150
	return p266 % 1 >= 0.5 and math.ceil(p266) or math.floor(p266)
end
function t13.IsExperienceOlderThanOneWeek(_, p268) -- line: 3154
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

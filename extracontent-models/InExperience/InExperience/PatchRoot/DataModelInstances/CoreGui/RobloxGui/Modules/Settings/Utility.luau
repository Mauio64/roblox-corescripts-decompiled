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
local v20 = game:DefineFastFlag("RepositionDropDownScrim", false)
local Chrome = RobloxGui.Modules.Chrome
local v22 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.Service)
local Signals = require(CorePackages.Packages.Signals)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local FFlagHideShortcutsWhileIemDropdownActive = require(Chrome.Flags).FFlagHideShortcutsWhileIemDropdownActive
local EngineFeature = game:GetEngineFeature("EnablePreferredTextSizeAccessGuiService")
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local v28 = game:DefineFastFlag("IncreaseLegacyPeopleRowButtonSize", false)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CorePackages2 = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages2.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages2.Packages.BuilderIcons)
local Migration = BuilderIcons.Migration
local v36 = require(RobloxGui.Modules:WaitForChild("TenFootInterface")):IsEnabled()
local v37 = Signals.createComputed(function(p1) -- line: 83
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p1).getLastInputType(p1) == Responsive.Input.Touch
end)
local v38 = Signals.createComputed(function(p2) -- line: 88
	-- upvalues: Responsive (copy)
	return Responsive.GetInputModeStore(p2).getLastInputType(p2) == Responsive.Input.Pointer
end)
local t1 = {}

setmetatable(t1, {
	__mode = "k"
})

local v40 = Create("ImageLabel")({
	Image = "",
	BackgroundTransparency = 1
})

function clamp(p3, p4, p5) -- line: 105
	return (math.max(p3, (math.min(p4, p5))))
end

local function Linear(p6, p7, p8, p9) -- line: 110
	if p9 <= p6 then
		return p7 + p8
	end

	return p8 * p6 / p9 + p7
end
local function EaseOutQuad(p10, p11, p12, p13) -- line: 118
	if p13 <= p10 then
		return p11 + p12
	end

	local v82 = p10 / p13

	return p11 - p12 * v82 * (v82 - 2)
end
local function EaseInOutQuad(p14, p15, p16, p17) -- line: 127
	if p17 <= p14 then
		return p15 + p16
	end

	local v87 = p14 / p17

	if v87 < 0.5 then
		return 2 * p16 * v87 * v87 + p15
	end

	return p15 + p16 * (2 * (2 - v87) * v87 - 1)
end

function PropertyTweener(p18, p19, p20, p21, p22, p23, p24) -- line: 139
	-- upvalues: RunService (copy)
	local t2 = {
		StartTime = tick()
	}

	t2.EndTime = t2.StartTime + p22
	t2.Cancelled = false

	local u96 = false
	local n1 = 0

	local function finalize() -- line: 148
		-- upvalues: p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), u96 (ref), n1 (ref), p24 (copy)
		if p18 then
			p18[p19] = p23(1, p20, p21 - p20, 1)
		end

		u96 = true
		n1 = 1

		if p24 then
			p24()
		end
	end

	p18[p19] = p23(0, p20, p21 - p20, p22)
	coroutine.wrap(function() -- line: 161
		-- upvalues: t2 (copy), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), p22 (copy), n1 (ref), RunService (copy), u96 (ref), p24 (copy)
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

			u96 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end)()

	function t2.GetFinal(_) -- line: 177
		-- upvalues: p21 (copy)
		return p21
	end
	function t2.GetPercentComplete(_) -- line: 181
		-- upvalues: n1 (ref)
		return n1
	end
	function t2.IsFinished(_) -- line: 185
		-- upvalues: u96 (ref)
		return u96
	end
	function t2.Finish(p28) -- line: 189
		-- upvalues: u96 (ref), p18 (copy), p19 (copy), p23 (copy), p20 (copy), p21 (copy), n1 (ref), p24 (copy)
		if not u96 then
			p28:Cancel()

			if p18 then
				p18[p19] = p23(1, p20, p21 - p20, 1)
			end

			u96 = true
			n1 = 1

			if p24 then
				p24()
			end
		end
	end
	function t2.Cancel(_) -- line: 196
		-- upvalues: t2 (copy)
		t2.Cancelled = true
	end

	return t2
end

local function isTouchInput() -- line: 203
	-- upvalues: UserInputService (copy)
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end
local function CreateSignal() -- line: 209
	local t3 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local t4 = nil
	local u102 = nil

	function t3.fire(_, ...) -- line: 217
		-- upvalues: t4 (ref), u102 (ref), BindableEvent (copy)
		t4 = { ... }
		u102 = select("#", ...)
		BindableEvent:Fire()
	end
	function t3.connect(_, p32) -- line: 223
		-- upvalues: BindableEvent (copy), t4 (ref), u102 (ref)
		if not p32 then
			error("connect(nil)", 2)
		end

		return BindableEvent.Event:Connect(function() -- line: 227
			-- upvalues: p32 (copy), t4 (ref), u102 (ref)
			p32(unpack(t4, 1, u102))
		end)
	end
	function t3.wait(_) -- line: 232
		-- upvalues: BindableEvent (copy), t4 (ref), u102 (ref)
		BindableEvent.Event:wait()

		if not t4 then
			error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		end

		return unpack(t4, 1, u102)
	end

	return t3
end
local function getViewportSize() -- line: 243
	-- upvalues: GuiService (copy)
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	return GuiService:GetHardwareSafeViewport()
end
local function isSmallTouchScreen() -- line: 252
	-- upvalues: GuiService (copy), UserInputService (copy)
	local v103 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return UserInputService.TouchEnabled and (v103.Y < 500 or v103.X < 700)
end
local function isPortrait() -- line: 257
	-- upvalues: GuiService (copy)
	local v104 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	return v104.Y > v104.X
end
local function isTenFootInterface() -- line: 262
	-- upvalues: v36 (copy)
	return v36
end
local function usesSelectedObject() -- line: 266
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
local function addHoverState(p34, p35, p36, p37) -- line: 279
	local function onNormalButtonStateCallback() -- line: 280
		-- upvalues: p34 (copy), p36 (copy), p35 (copy)
		if p34.Active then
			p36(p35)
		end
	end
	local function onHoverButtonStateCallback() -- line: 285
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
local function addOnResizedCallback(p38, p39) -- line: 299
	-- upvalues: t1 (copy), GuiService (copy)
	t1[p38] = p39

	local v113 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v114 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	p39(v113, v114.Y > v114.X)
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

local function MakeDefaultButton(p40, p41, p42, p43, p44, p45) -- line: 315
	-- upvalues: Create (copy), Theme (copy), t5 (copy), UserInputService (copy), GuiService (copy), VRService (copy)
	local v121 = Create("ImageLabel")({
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

	local u124 = Create("ImageButton")({
		AutoButtonColor = false,
		ZIndex = 2,
		Name = p40 .. "Button",
		BackgroundColor3 = Theme.color(s2),
		BackgroundTransparency = Theme.transparency(s2),
		Size = p41,
		SelectionImageObject = v121
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u124
	})

	local v125 = Create("UIStroke")({
		Name = "Border",
		Color = Theme.color(s1),
		Transparency = Theme.transparency(s1),
		Thickness = Theme.DefaultStokeThickness,
		Parent = u124
	})

	Create("BoolValue")({
		Name = "Enabled",
		Value = true,
		Parent = u124
	})

	if p42 then
		u124.MouseButton1Click:Connect(function() -- line: 362
			-- upvalues: p42 (copy), t5 (copy), UserInputService (copy)
			p42(t5[UserInputService:GetLastInputType()] or false)
		end)
	else
		if v125 then
			v125.Enabled = false
		end

		u124.Selectable = false
	end

	local function isPointerInput(p46) -- line: 372
		return p46.UserInputType == Enum.UserInputType.MouseMovement or p46.UserInputType == Enum.UserInputType.Touch
	end

	local u127 = nil

	local function setRowRef(p47) -- line: 378
		-- upvalues: u127 (ref)
		u127 = p47
	end
	local function selectButton() -- line: 382
		-- upvalues: p44 (copy), p43 (copy), u124 (ref), Theme (copy), u127 (ref)
		local v433 = p44

		if v433 == nil and p43 then
			v433 = p43.HubRef
		end

		if v433 and v433.Active or v433 == nil then
			u124.BackgroundColor3 = Theme.color("DefaultButtonHover")
			u124.BackgroundTransparency = Theme.transparency("DefaultButtonHover")

			local v434 = u124

			if u127 then
				v434 = u127
			end

			if v433 then
				v433:ScrollToFrame(v434)
			end
		end
	end
	local function deselectButton() -- line: 404
		-- upvalues: u124 (ref), Theme (copy), s2 (ref)
		u124.BackgroundColor3 = Theme.color(s2)
		u124.BackgroundTransparency = Theme.transparency(s2)
	end

	u124.InputBegan:Connect(function(input) -- line: 409
		-- upvalues: u124 (ref), selectButton (copy)
		if u124.Selectable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			selectButton()
		end
	end)
	u124.InputEnded:Connect(function(input) -- line: 414
		-- upvalues: u124 (ref), GuiService (copy), Theme (copy), s2 (ref)
		if u124.Selectable and (GuiService.SelectedCoreObject ~= u124 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
			u124.BackgroundColor3 = Theme.color(s2)
			u124.BackgroundTransparency = Theme.transparency(s2)
		end
	end)
	u124.SelectionGained:Connect(function() -- line: 420
		-- upvalues: selectButton (copy)
		selectButton()
	end)
	u124.SelectionLost:Connect(function() -- line: 423
		-- upvalues: u124 (ref), Theme (copy), s2 (ref)
		u124.BackgroundColor3 = Theme.color(s2)
		u124.BackgroundTransparency = Theme.transparency(s2)
	end)
	GuiService.Changed:Connect(function(property) -- line: 427
		-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u124 (ref), Theme (copy), s2 (ref), selectButton (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		if VRService.VREnabled or UserInputService.PreferredInput == Enum.PreferredInput.Touch and ((not UserInputService.GamepadEnabled or not true) and not false) then
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= u124 then
			u124.BackgroundColor3 = Theme.color(s2)
			u124.BackgroundTransparency = Theme.transparency(s2)

			return
		end

		if u124.Selectable then
			selectButton()
		end
	end)

	return u124, setRowRef
end
local function MakeButton(p48, p49, p50, p51, p52, p53) -- line: 448
	-- upvalues: MakeDefaultButton (copy), Create (copy), Theme (copy), GuiService (copy), UserInputService (copy), v36 (copy), EngineFeature (copy)
	local v137, v138 = MakeDefaultButton(p48, p50, p51, p52, p53)
	local v139 = Create("TextLabel")({
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
		Parent = v137
	})
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint", v139)
	local v141 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if UserInputService.TouchEnabled and (v141.Y < 500 or v141.X < 700) then
		v139.TextSize = Theme.textSize(18)
	elseif v36 and (p48 ~= "FriendStatus" and p48 ~= "BlockButton") then
		v139.TextSize = Theme.textSize(36)
	end

	if not EngineFeature then
		UITextSizeConstraint.MaxTextSize = v139.TextSize
	else
		local u142 = (GuiService.PreferredTextSize.Value - 1) * 3

		UITextSizeConstraint.MaxTextSize = v139.TextSize + u142

		local TextSize = v139.TextSize

		GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(function() -- line: 484
			-- upvalues: u142 (ref), GuiService (copy), UITextSizeConstraint (copy), TextSize (copy)
			u142 = (GuiService.PreferredTextSize.Value - 1) * 3
			UITextSizeConstraint.MaxTextSize = TextSize + u142
		end)
	end

	return v137, v139, v138
end
local function MakeImageButton(p54, p55, p56, p57, p58, p59, p60, p61) -- line: 493
	-- upvalues: MakeDefaultButton (copy), Migration (copy), Theme (copy), Create (copy), v28 (copy), BuilderIcons (copy)
	if not p61 then
		p61 = "ImageButton"
	end

	local v152, v153 = MakeDefaultButton(p54, p56, p58, p59, p60, p61)
	local ImageRectOffset = nil
	local ImageRectSize = nil
	local v156 = Migration.uiblox[p55] or Migration.luaApps[p55]

	if not string.match(p55, "^rbxasset://") then
		p55 = Theme.Images[p55]
	end

	if typeof(p55) == "table" then
		ImageRectOffset = p55.ImageRectOffset
		ImageRectSize = p55.ImageRectSize
		p55 = p55.Image
	end

	local v157 = if not v156 then Create("ImageLabel")({
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
		Parent = v152
	}) else Create("TextLabel")({
		BackgroundTransparency = 1,
		ZIndex = 2,
		Name = p54 .. "TextLabel",
		Size = p57,
		TextSize = if not v28 then p57.Y.Offset * 0.6666666666666666 else p57.Y.Offset * 0.8571428571428571,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = Color3.new(1, 1, 1),
		Text = v156.name,
		FontFace = BuilderIcons.Font[v156.variant],
		Parent = v152
	})

	if p61 == "ImageButton" then
		v152.Border.Thickness = 0
		v152.Border.Transparency = 1
	end

	return v152, v157, v153
end
local function AddButtonRow(p62, p63, p64, p65, p66, p67) -- line: 548
	-- upvalues: MakeButton (copy), Create (copy)
	local v164, v165, v166 = MakeButton(p63, p64, p65, p66, p62, p67)
	local v167 = Create("Frame")({
		BackgroundTransparency = 1,
		Name = p63 .. "Row",
		Size = UDim2.new(1, 0, p65.Y.Scale, p65.Y.Offset),
		Parent = p62.Page
	})

	v164.Parent = v167
	v164.AnchorPoint = Vector2.new(1, 0)
	v164.Position = UDim2.new(1, -20, 0, 0)

	return v167, v164, v165, v166
end
local function MakeRoundedRectFocusState(p68, p69) -- line: 564
	-- upvalues: Create (copy), uDim (copy), Theme (copy), RunService (copy), UserGameSettings (copy)
	local v170 = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 12, 1, 12),
		Position = UDim2.fromOffset(-6, -6)
	})

	Create("UICorner")({
		CornerRadius = uDim,
		Parent = v170
	})

	local v171 = Create("UIStroke")({
		Transparency = 0,
		Thickness = 3,
		Color = Theme.selectionCursor.AnimatedColor,
		Parent = v170
	})
	local v172 = Create("UIGradient")({
		Rotation = 0,
		Color = Theme.selectionCursor.GradientColorSequence,
		Transparency = Theme.selectionCursor.GradientTransparencySequence,
		Parent = v171
	})

	RunService:UnbindFromRenderStep(p69)
	RunService:BindToRenderStep(p69, Enum.RenderPriority.Last.Value, function() -- line: 591
		-- upvalues: v172 (copy), Theme (copy), UserGameSettings (copy)
		local v438 = v172.Rotation + 2
		local GradientColorSequence = Theme.selectionCursor.GradientColorSequence
		local GradientTransparencySequence = Theme.selectionCursor.GradientTransparencySequence

		if UserGameSettings.ReducedMotion then
			local v441 = (math.sin((math.rad(v438))) + 1) / 2
			local Value = GradientColorSequence.Keypoints[1].Value
			local Value2 = GradientColorSequence.Keypoints[#GradientColorSequence.Keypoints].Value

			GradientColorSequence = ColorSequence.new(Value:lerp(Value2, v441))

			local Value3 = GradientTransparencySequence.Keypoints[1].Value
			local Value4 = GradientTransparencySequence.Keypoints[#GradientTransparencySequence.Keypoints].Value

			GradientTransparencySequence = NumberSequence.new(Value3 + (Value4 - Value3) * v441)
		end

		v172.Rotation = v438
		v172.Color = GradientColorSequence
		v172.Transparency = GradientTransparencySequence
	end)
	p68.AncestryChanged:Connect(function(_, parent) -- line: 615
		-- upvalues: RunService (copy), p69 (copy)
		if not parent then
			RunService:UnbindFromRenderStep(p69)
		end
	end)
	p68.SelectionImageObject = v170
end
local function CreateDropDown(p71, p72, p73) -- line: 624
	-- upvalues: Theme (copy), HttpService (copy), GuiService (copy), Create (copy), v20 (copy), CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), UserInputService (copy), ContextActionService (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v22 (copy), RobloxTranslator (copy), MakeButton (copy)
	local v176 = Theme.color("SELECTION_TEXT_COLOR_NORMAL", Color3.fromRGB(178, 178, 178))
	local color3 = Color3.fromRGB(229, 229, 229)
	local v178 = Theme.color("SELECTION_TEXT_COLOR_HIGHLIGHTED", Color3.fromRGB(255, 255, 255))
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

	local u182 = true
	local guid = HttpService:GenerateGUID(false)
	local DropDownFrameEnabled = nil
	local u185 = p71
	local v186, _ = GuiService:GetGuiInset()
	local v188 = Create("ImageButton")({
		Name = "DropDownFullscreenFrame",
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 10,
		Active = true,
		Visible = false,
		Selectable = false,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, not v20 and 0 or v186.Y),
		Position = if not v20 then nil else UDim2.new(0, 0, 0, -v186.Y),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Parent = CoreGui.RobloxGui
	})

	local function onVREnabled(p74) -- line: 676
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), v188 (copy), CoreGui (copy), t6 (copy), u185 (ref)
		if p74 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				v188.Parent = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
				v188.BackgroundTransparency = 0.2
			else
				v188.Parent = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):GetGUI()
				v188.BackgroundTransparency = 1
			end
		else
			v188.Parent = CoreGui.RobloxGui
			v188.BackgroundTransparency = 0.2
		end

		if t6.UpdateDropDownList then
			t6:UpdateDropDownList(u185)
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	local v190 = Create("ImageLabel")({
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
		Parent = v188
	})

	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v190
	})

	local v191 = Create("ScrollingFrame")({
		Name = "DropDownScrollingFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 10,
		Size = UDim2.new(1, -20, 1, -25),
		Position = UDim2.new(0, 10, 0, 10),
		ScrollBarThickness = Theme.DefaultScrollBarThickness,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = v190
	})
	local connection = nil
	local u193 = false

	local function v194(p75, p76) -- line: 740
		-- upvalues: t6 (copy), u182 (ref), p73 (copy), v188 (copy), VRService (copy), UserInputService (copy), GuiService (copy), DropDownFrame (ref), connection (ref), ContextActionService (copy), guid (copy), DropDownFrameEnabled (ref), u193 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy)
		if p75 ~= nil and p76 ~= Enum.UserInputState.Begin then
			return
		end

		t6.DropDownFrame.Selectable = u182
		p73:SetActive(true)

		if v188.Visible and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) then
			GuiService.SelectedCoreObject = DropDownFrame
		end

		v188.Visible = false

		if connection then
			connection:Disconnect()
		end

		ContextActionService:UnbindCoreAction(guid .. "Action")
		ContextActionService:UnbindCoreAction(guid .. "FreezeAction")
		DropDownFrameEnabled.Value = u182
		u193 = false

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v188, 0)
		end
	end
	local function v195() -- line: 770
	end

	local v196 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.ChooseOne")
	local uDim2 = UDim2.new(0.6, 0, 0, 40)

	t6.DropDownFrame = MakeButton("DropDownFrame", v196, uDim2, function() -- line: 772
		-- upvalues: u182 (ref), t6 (copy), u193 (ref), v188 (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), DropDownFrame (ref), GuiService (copy), connection (ref), v178 (copy), color3 (copy), v176 (copy), v194 (copy), FFlagHideShortcutsWhileIemDropdownActive (copy), v22 (copy), ContextActionService (copy), guid (copy), v195 (copy), p73 (copy), DropDownFrameEnabled (ref)
		if not u182 then
			return
		end

		t6.DropDownFrame.Selectable = false
		u193 = true
		v188.Visible = true

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(v188, 0.5)
		end

		DropDownFrame = t6.DropDownFrame

		if t6.CurrentIndex and t6.CurrentIndex > 0 then
			GuiService.SelectedCoreObject = t6.Selections[t6.CurrentIndex]
		elseif #t6.Selections > 0 then
			GuiService.SelectedCoreObject = t6.Selections[1]
		end

		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 795
			-- upvalues: t6 (copy), GuiService (copy), v178 (copy), VRService (copy), color3 (copy), v176 (copy)
			for i = 1, #t6.Selections do
				if GuiService.SelectedCoreObject == t6.Selections[i] then
					t6.Selections[i].TextColor3 = v178
				else
					t6.Selections[i].TextColor3 = VRService.VREnabled and color3 or v176
				end
			end
		end)

		local v453 = v194

		if FFlagHideShortcutsWhileIemDropdownActive then
			v22:setHideShortcutBar("InExperienceMenuDropdown", true)

			function v453(p77, p78) -- line: 809
				-- upvalues: v194 (copy), v22 (copy)
				v194(p77, p78)
				v22:setHideShortcutBar("InExperienceMenuDropdown", false)
			end
		end

		ContextActionService:BindCoreAction(guid .. "FreezeAction", v195, false, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1)
		ContextActionService:BindCoreAction(guid .. "Action", v453, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
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

	local v199 = Create("ImageLabel")({
		Name = "DropDownImage",
		Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 15, 0, 10),
		Position = UDim2.new(1, -12, 0.5, 0),
		Parent = t6.DropDownFrame
	})

	t6.DropDownImage = v199

	local function setSelection(p79) -- line: 862
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v455 = false

		for k, v in pairs(t6.Selections) do
			if k == p79 then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v455 = true
			end
		end

		if v455 then
			BindableEvent:Fire(p79)
		end
	end
	local function setSelectionByValue(p80) -- line: 878
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), BindableEvent (copy)
		local v459 = false

		for k, v in pairs(t6.Selections) do
			if p80 == v.Text then
				DropDownFrameTextLabel.Text = v.Text
				t6.CurrentIndex = k
				v459 = true
			end
		end

		if v459 then
			BindableEvent:Fire(t6.CurrentIndex)
		end

		return v459
	end
	local function setIsFaded(p81) -- line: 895
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

	function t6.SetSelectionIndex(_, p83) -- line: 910
		-- upvalues: setSelection (copy)
		setSelection(p83)
	end
	function t6.SetSelectionByValue(_, p85) -- line: 914
		-- upvalues: setSelectionByValue (copy)
		return (setSelectionByValue(p85))
	end
	function t6.ResetSelectionIndex(_) -- line: 918
		-- upvalues: t6 (copy), DropDownFrameTextLabel (copy), v196 (copy), v194 (copy)
		t6.CurrentIndex = nil
		DropDownFrameTextLabel.Text = v196
		v194()
	end
	function t6.GetSelectedIndex(_) -- line: 924
		-- upvalues: t6 (copy)
		return t6.CurrentIndex
	end
	function t6.SetZIndex(_, p89) -- line: 928
		-- upvalues: t6 (copy), v199 (copy), DropDownFrameTextLabel (copy)
		t6.DropDownFrame.ZIndex = p89
		v199.ZIndex = p89
		DropDownFrameTextLabel.ZIndex = p89
	end
	function t6.SetInteractable(_, p91) -- line: 934
		-- upvalues: u182 (ref), t6 (copy), v194 (copy), VRService (copy), DropDownFrameEnabled (ref), u193 (ref)
		u182 = p91
		t6.DropDownFrame.Selectable = u182

		if not u182 then
			v194()

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

		DropDownFrameEnabled.Value = p91 and not u193
		t6.DropDownImage.Visible = p91

		if p91 then
			t6.DropDownFrame.ImageTransparency = 0

			return
		end

		t6.DropDownFrame.ImageTransparency = 0.5
	end
	function t6.SetAutoLocalize(_, p93) -- line: 961
		-- upvalues: v188 (copy)
		v188.AutoLocalize = p93
	end
	function t6.UpdateDropDownList(_, p95) -- line: 965
		-- upvalues: u185 (ref), t6 (copy), VRService (copy), Theme (copy), Create (copy), color3 (copy), v176 (copy), v191 (copy), p72 (copy), DropDownFrameTextLabel (copy), v178 (copy), v194 (copy), BindableEvent (copy), UserInputService (copy), GuiService (copy), guid (copy), v188 (copy), v190 (copy)
		u185 = p95

		if t6.Selections then
			for i = 1, #t6.Selections do
				t6.Selections[i]:Destroy()
			end
		end

		t6.Selections = {}
		t6.SelectionInfo = {}

		local VREnabled = VRService.VREnabled
		local v479 = VREnabled and Theme.font(Enum.Font.SourceSansBold, "Bold") or Theme.font(Enum.Font.SourceSans, "UtilityText")
		local v480 = VREnabled and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		local v481 = not VREnabled and 50 or 70
		local v482 = v481 + 1
		local v483 = not VREnabled and 400 or 600
		local n2 = 0

		for k, v in pairs(p95) do
			local v487 = Create("Frame")({
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			})

			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v487
			})

			local v488 = v
			local s3 = ""
			local v490 = typeof(v) == "table"

			if v490 then
				v488 = v.title
				s3 = v.subtitle
				n2 += 10
			end

			local u491

			if v490 then
				u491 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					TextYAlignment = Enum.TextYAlignment.Top,
					Size = UDim2.new(1, -28, 0, v481 + 10),
					Position = UDim2.new(0, 14, 0, (k - 1) * (v482 + 10)),
					TextColor3 = VRService.VREnabled and color3 or v176,
					Font = v479,
					TextSize = v480,
					Text = v488,
					SelectionImageObject = v487,
					Parent = v191
				})
				Create("TextLabel")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 10,
					Name = "Subtitle" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v481 * 0.8),
					Position = UDim2.new(0, 14, 0, 15),
					TextColor3 = VRService.VREnabled and color3 or v176,
					Font = v479,
					TextSize = v480 * 0.8,
					Text = s3,
					Parent = u491
				})
			else
				u491 = Create("TextButton")({
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 10,
					Name = "Selection" .. tostring(k),
					Size = UDim2.new(1, -28, 0, v481),
					Position = UDim2.new(0, 14, 0, (k - 1) * v482),
					TextColor3 = VRService.VREnabled and color3 or v176,
					Font = v479,
					TextSize = v480,
					Text = v,
					SelectionImageObject = v487,
					Parent = v191
				})
			end

			if k == p72 then
				t6.CurrentIndex = k
				DropDownFrameTextLabel.Text = v488
				u491.TextColor3 = v178
			elseif not p72 and k == 1 then
				u491.TextColor3 = v178
			end

			local function v492() -- line: 1069
				-- upvalues: DropDownFrameTextLabel (copy), u491 (ref), v194 (copy), t6 (copy), k (copy), BindableEvent (copy)
				DropDownFrameTextLabel.Text = u491.Text
				v194()
				t6.CurrentIndex = k
				BindableEvent:Fire(k)
			end

			u491.MouseButton1Click:Connect(v492)
			u491.MouseEnter:Connect(function() -- line: 1078
				-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), u491 (ref)
				if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
					GuiService.SelectedCoreObject = u491
				end
			end)
			t6.Selections[k] = u491
			t6.SelectionInfo[u491] = {
				Clicked = v492
			}
		end

		GuiService:RemoveSelectionGroup(guid)
		GuiService:AddSelectionTuple(guid, unpack(t6.Selections))
		v191.CanvasSize = UDim2.new(1, -20, 0, #p95 * v482 + n2)

		local function updateDropDownSize() -- line: 1094
			-- upvalues: v191 (copy), v188 (copy), v190 (copy), v483 (copy)
			if v191.CanvasSize.Y.Offset < v188.AbsoluteSize.Y - 10 then
				v190.Size = UDim2.new(0, v483, 0, v191.CanvasSize.Y.Offset + 25)

				return
			end

			v190.Size = UDim2.new(0, v483, 0.9, 0)
		end

		v188.Changed:Connect(function(property) -- line: 1107
			-- upvalues: updateDropDownSize (copy)
			if property ~= "AbsoluteSize" then
				return
			end

			updateDropDownSize()
		end)
		updateDropDownSize()
	end

	t6:UpdateDropDownList(p71)
	v188.MouseButton1Click:Connect(v194)
	p73.PoppedMenu:Connect(function(p96) -- line: 1122
		-- upvalues: v188 (copy), v194 (copy)
		if p96 == v188 then
			v194()
		end
	end)

	return t6
end
local function CreateSelector(p97, p98) -- line: 1131
	-- upvalues: Create (copy), v40 (copy), Theme (copy), v4 (copy), UserInputService (copy), v5 (copy), addHoverState (copy), VRService (copy), GuiService (copy), EaseOutQuad (copy), v6 (copy), v36 (copy), v37 (copy), v38 (copy), t1 (copy)
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

	local u208 = true

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
		SelectionImageObject = v40
	})

	local v209 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v40,
		Parent = t7.SelectorFrame
	})
	local v210 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v40,
		Parent = t7.SelectorFrame
	})
	local v211 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v209
	})
	local v212 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		ImageColor3 = v4,
		Parent = v210
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v213(p99) -- line: 1217
			-- upvalues: v4 (copy)
			p99.ImageColor3 = v4
		end
		local function v214(p100) -- line: 1219
			-- upvalues: v5 (copy)
			p100.ImageColor3 = v5
		end

		addHoverState(v209, v211, v213, v214)
		addHoverState(v210, v212, v213, v214)
	end

	t7.Selections = {}

	local t8 = {}
	local t9 = {}
	local v217 = Create("ImageButton")({
		Name = "AutoSelectButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 2,
		Position = UDim2.new(0, v209.Size.X.Offset, 0, 0),
		Size = UDim2.new(1, v209.Size.X.Offset * -2, 1, 0),
		Parent = t7.SelectorFrame,
		SelectionImageObject = v40
	})

	v217.MouseButton1Click:Connect(function() -- line: 1240
		-- upvalues: u208 (ref), t7 (copy), VRService (copy), UserInputService (copy), GuiService (copy)
		if not u208 then
			return
		end

		if #t7.Selections <= 1 then
			return
		end

		local v497 = t7.CurrentIndex + 1

		if v497 > #t7.Selections then
			v497 = 1
		end

		t7:SetSelectionIndex(v497)

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end
	end)
	t9[v217] = true

	local function setSelection(p101, p102) -- line: 1259
		-- upvalues: t7 (copy), v209 (copy), t8 (ref), EaseOutQuad (copy), BindableEvent (copy)
		for k, v in pairs(t7.Selections) do
			local v502 = k == p101
			local uDim2 = UDim2.new(0, v209.Size.X.Offset, 0, 0)
			local uDim2_2 = UDim2.new(0, v209.Size.X.Offset * p102 * 3, 0, 0)

			if t8[v] then
				uDim2_2 = UDim2.new(0, v209.Size.X.Offset * -p102 * 3, 0, 0)
			end

			if uDim2_2.X.Offset < 0 then
				uDim2_2 = UDim2.new(0, uDim2_2.X.Offset + v.AbsoluteSize.X / 4, 0, 0)
			end

			if v502 then
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
	local function stepFunc(p103, p104) -- line: 1310
		-- upvalues: u208 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if not u208 then
			return
		end

		if p103 ~= nil and p103.UserInputType ~= Enum.UserInputType.MouseButton1 and p103.UserInputType ~= Enum.UserInputType.Gamepad1 and p103.UserInputType ~= Enum.UserInputType.Gamepad2 and p103.UserInputType ~= Enum.UserInputType.Gamepad3 and p103.UserInputType ~= Enum.UserInputType.Gamepad4 and p103.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
			GuiService.SelectedCoreObject = t7.SelectorFrame
		end

		local v507 = p104 + t7.CurrentIndex
		local v508 = not (v507 > t7.CurrentIndex) and -1 or 1

		if v507 > #t7.Selections then
			v507 = 1
		elseif v507 < 1 then
			v507 = #t7.Selections
		end

		setSelection(v507, v508)
	end

	local connection = nil

	local function connectToGuiService() -- line: 1350
		-- upvalues: connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1351
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

	function t7.SetSelectionIndex(_, p106) -- line: 1364
		-- upvalues: setSelection (copy)
		setSelection(p106, 1)
	end
	function t7.GetSelectedIndex(_) -- line: 1368
		-- upvalues: t7 (copy)
		return t7.CurrentIndex
	end
	function t7.SetZIndex(_, p109) -- line: 1372
		-- upvalues: v209 (copy), v210 (copy), v211 (copy), v212 (copy), t7 (copy)
		v209.ZIndex = p109
		v210.ZIndex = p109
		v211.ZIndex = p109
		v212.ZIndex = p109

		for i = 1, #t7.Selections do
			t7.Selections[i].ZIndex = p109
		end
	end
	function t7.SetInteractable(_, p111) -- line: 1383
		-- upvalues: u208 (ref), t7 (copy), v209 (copy), v210 (copy), Theme (copy), v211 (copy), v6 (copy), v212 (copy), v4 (copy)
		u208 = p111
		t7.SelectorFrame.Selectable = u208
		v209.Active = u208
		v210.Active = u208
		v209.Visible = u208
		v210.Visible = u208

		if not u208 then
			for _, v in pairs(t7.Selections) do
				v.TextColor3 = Theme.color("NotInteractableSelection", Color3.fromRGB(255, 255, 255))
			end

			v211.ImageColor3 = v6
			v212.ImageColor3 = v6

			return
		end

		for _, v in pairs(t7.Selections) do
			v.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		v211.ImageColor3 = v4
		v212.ImageColor3 = v4
	end
	function t7.UpdateOptions(_, p113) -- line: 1408
		-- upvalues: t7 (copy), t8 (ref), Create (copy), v209 (copy), Theme (copy), v36 (copy), p98 (copy), v210 (copy)
		for _, v in pairs(t7.Selections) do
			v:Destroy()
		end

		t8 = {}
		t7.Selections = {}

		for k, v in pairs(p113) do
			local v527 = Create("TextLabel")({
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				ZIndex = 2,
				Visible = false,
				Name = "Selection" .. tostring(k),
				Size = UDim2.new(1, v209.Size.X.Offset * -2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
				TextSize = Theme.textSize(24, "UtilityText"),
				Text = v,
				Parent = t7.SelectorFrame
			})

			if v36 then
				v527.TextSize = Theme.textSize(36)
			end

			if k == p98 then
				t7.CurrentIndex = k
				v527.Position = UDim2.new(0, v209.Size.X.Offset, 0, 0)
				v527.Visible = true
				t8[v527] = true
			else
				t8[v527] = false
			end

			t7.Selections[k] = v527
		end

		local v528 = #t7.Selections > 1

		v209.Visible = v528
		v210.Visible = v528
	end

	local function onVREnabled(p114) -- line: 1456
		-- upvalues: VRService (copy), v209 (copy), v210 (copy), v217 (copy)
		if p114 ~= "VREnabled" then
			return
		end

		local VREnabled = VRService.VREnabled

		v209.Selectable = VREnabled
		v210.Selectable = VREnabled
		v217.Selectable = VREnabled
	end

	VRService.Changed:Connect(onVREnabled)

	local VREnabled = VRService.VREnabled

	v209.Selectable = VREnabled
	v210.Selectable = VREnabled
	v217.Selectable = VREnabled
	v209.InputBegan:Connect(function(input) -- line: 1468
		-- upvalues: v37 (copy), v38 (copy), u208 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v37(false) or v38(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u208 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v532 = -1 + t7.CurrentIndex
			local v533 = not (v532 > t7.CurrentIndex) and -1 or 1

			if v532 > #t7.Selections then
				v532 = 1
			elseif v532 < 1 then
				v532 = #t7.Selections
			end

			setSelection(v532, v533)
		end
	end)
	v210.InputBegan:Connect(function(input) -- line: 1474
		-- upvalues: v37 (copy), v38 (copy), u208 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t7 (copy), setSelection (copy)
		if v37(false) or v38(false) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not u208 then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v535 = 1 + t7.CurrentIndex
			local v536 = not (v535 > t7.CurrentIndex) and -1 or 1

			if v535 > #t7.Selections then
				v535 = 1
			elseif v535 < 1 then
				v535 = #t7.Selections
			end

			setSelection(v535, v536)
		end
	end)

	local u224 = true

	t7:UpdateOptions(p97)
	UserInputService.InputBegan:Connect(function(input) -- line: 1484
		-- upvalues: u208 (ref), u224 (ref), GuiService (copy), t7 (copy), VRService (copy), UserInputService (copy), setSelection (copy)
		if not u208 then
			return
		end

		if not u224 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if GuiService.SelectedCoreObject ~= t7.SelectorFrame then
			return
		end

		if input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.A then
			if not u208 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v538 = -1 + t7.CurrentIndex
			local v539 = not (v538 > t7.CurrentIndex) and -1 or 1

			if v538 > #t7.Selections then
				v538 = 1
			elseif v538 < 1 then
				v538 = #t7.Selections
			end

			setSelection(v538, v539)

			return
		end

		if input.KeyCode == Enum.KeyCode.DPadRight or input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.D then
			if not u208 then
				return
			end

			if input ~= nil and input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Gamepad2 and input.UserInputType ~= Enum.UserInputType.Gamepad3 and input.UserInputType ~= Enum.UserInputType.Gamepad4 and input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = t7.SelectorFrame
			end

			local v540 = 1 + t7.CurrentIndex
			local v541 = not (v540 > t7.CurrentIndex) and -1 or 1

			if v540 > #t7.Selections then
				v540 = 1
			elseif v540 < 1 then
				v540 = #t7.Selections
			end

			setSelection(v540, v541)
		end
	end)
	UserInputService.InputChanged:Connect(function(input) -- line: 1517
		-- upvalues: u208 (ref), u224 (ref), n3 (ref), GuiService (copy), t7 (copy), stepFunc (copy)
		if not u208 then
			return
		end

		if not u224 then
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
	t7.SelectorFrame.AncestryChanged:Connect(function(_, parent) -- line: 1558
		-- upvalues: u224 (ref), connection (ref), GuiService (copy), t7 (copy), t9 (copy), VRService (copy)
		u224 = parent

		if not u224 then
			if connection then
				connection:Disconnect()

				return
			end
		else
			connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1351
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

	local function onResized(_, p117) -- line: 1569
		-- upvalues: Theme (copy), v36 (copy), t7 (copy)
		local v548 = if not p117 then v36 and Theme.textSize(36) or Theme.textSize(24, "UtilityText") else Theme.textSize(16)

		for _, v in pairs(t7.Selections) do
			v.TextSize = v548
		end
	end

	t1[t7.SelectorFrame] = onResized

	local v226 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v227 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v226, v227.Y > v227.X)
	connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1351
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
local function ShowAlert(p118, p119, p120, p121, p122) -- line: 1588
	-- upvalues: CoreGui (copy), VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), Create (copy), Theme (copy), HttpService (copy), ContextActionService (copy), GuiService (copy), MakeButton (copy), UserInputService (copy)
	local RobloxGui2 = CoreGui.RobloxGui

	if RobloxGui2:FindFirstChild("AlertViewFullScreen") then
		return
	end

	local u234 = nil

	local function onVREnabled(p123) -- line: 1599
		-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), CorePackages2 (copy), RobloxGui2 (ref), CoreGui (copy), u234 (ref)
		if p123 ~= "VREnabled" then
			return
		end

		local v552 = nil

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local PanelType = VrSpatialUi.Constants.PanelType

				RobloxGui2 = VrSpatialUi.UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			else
				v552 = require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu")
				RobloxGui2 = v552:GetGUI()
			end
		else
			RobloxGui2 = CoreGui.RobloxGui
		end

		if u234 and u234.Parent ~= nil then
			u234.Parent = RobloxGui2

			if VRService.VREnabled and not isInExperienceUIVREnabled then
				v552:SetSubpanelDepth(u234, 0.5)
			end
		end
	end

	local connection = VRService.Changed:Connect(onVREnabled)

	u234 = Create("ImageLabel")({
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
		u234.ImageTransparency = 0
	else
		u234.Size = UDim2.new(0.8, 0, 0, 350)
		u234.Position = UDim2.new(0.1, 0, 0.1, 0)
	end

	if CoreGui.RobloxGui.AbsoluteSize.Y <= u234.Size.Y.Offset then
		u234.Size = UDim2.new(u234.Size.X.Scale, u234.Size.X.Offset, u234.Size.Y.Scale, CoreGui.RobloxGui.AbsoluteSize.Y)
		u234.Position = UDim2.new(u234.Position.X.Scale, -u234.Size.X.Offset / 2, 0.5, -u234.Size.Y.Offset / 2)
	end

	if not p122 then
		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = u234
		})
		u234.BackgroundColor3 = Theme.color("MenuContainer")
		u234.BackgroundTransparency = Theme.transparency("MenuContainer")
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
		Parent = u234
	})
	Create("ImageLabel")({
		Image = "",
		BackgroundTransparency = 1
	})

	local guid = HttpService:GenerateGUID(false)

	local function v238(_, p125) -- line: 1698
		-- upvalues: VRService (copy), u234 (ref), isInExperienceUIVREnabled (copy), CorePackages2 (copy), p121 (copy), ContextActionService (copy), guid (copy), GuiService (copy), p120 (copy), connection (copy)
		if VRService.VREnabled and (p125 == Enum.UserInputState.Begin or p125 == Enum.UserInputState.Cancel) then
			return
		end

		if not u234 then
			return
		end

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			require(CorePackages2.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetSubpanelDepth(u234, 0)
		end

		u234:Destroy()
		u234 = nil

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

	local v241, v242 = MakeButton("AlertViewButton", p119, uDim2, v238)

	v241.Position = uDim2_3
	v241.NextSelectionLeft = v241
	v241.NextSelectionRight = v241
	v241.NextSelectionUp = v241
	v241.NextSelectionDown = v241
	v241.ZIndex = 9
	v242.ZIndex = v241.ZIndex
	v241.Parent = u234

	if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
		GuiService.SelectedCoreObject = v241
	end

	GuiService.SelectedCoreObject = v241
	ContextActionService:BindCoreAction(guid, v238, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA)

	if p120 and (isInExperienceUIVREnabled or not VRService.VREnabled) then
		p120:HideBar()
		p120.Pages.CurrentPage:Hide(1, 1)
	end
end
local function CreateNewSlider(p126, p127, p128, p129, p130) -- line: 1768
	-- upvalues: HttpService (copy), Signal (copy), Create (copy), v40 (copy), RobloxGui (copy), Theme (copy), UserInputService (copy), v5 (copy), v4 (copy), v5 (copy), addHoverState (copy), v2 (copy), v3 (copy), VRService (copy), GuiService (copy), RunService (copy)
	local t10 = {}
	local num = tonumber(p126)
	local u251 = p127
	local n4 = 0
	local timestamp = nil
	local u254 = true
	local guid = HttpService:GenerateGUID(false)

	if num <= 0 then
		error("CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer", 2)

		return
	end

	local v256 = p129 or p130
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ValueChanged"

	local v258 = Signal.new()

	t10.SliderFrame = Create("ImageButton")({
		Name = "Slider",
		Image = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		ZIndex = 2,
		NextSelectionLeft = t10.SliderFrame,
		NextSelectionRight = t10.SliderFrame,
		Size = UDim2.new(0.6, 0, 0, 50),
		AutomaticSize = if not v256 then nil else Enum.AutomaticSize.Y,
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		SelectionImageObject = v40
	})

	local v259 = nil

	if v256 then
		v259 = Create("Frame")({
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

		local v260 = Create("Frame")({
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
			Parent = v260
		})

		local function isWideEnough() -- line: 1850
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
				Parent = v260,
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
				Parent = v260,
				Visible = RobloxGui.AbsoluteSize.X > 460
			})
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(function() -- line: 1889
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
		Parent = if not v256 then t10.SliderFrame else v259
	})

	local v262 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v40,
		Parent = if not v256 then t10.SliderFrame else v259
	})
	local v263 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 3,
		Selectable = false,
		Active = true,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		SelectionImageObject = v40,
		Parent = if not v256 then t10.SliderFrame else v259
	})
	local v264 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v262,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})
	local v265 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Settings/Slider/More.png",
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Parent = v263,
		ImageColor3 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and v5 or v4
	})

	if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
		local function v266(p131) -- line: 1960
			-- upvalues: v4 (copy)
			p131.ImageColor3 = v4
		end
		local function v267(p132) -- line: 1962
			-- upvalues: v5 (copy)
			p132.ImageColor3 = v5
		end

		addHoverState(v262, v264, v266, v267)
		addHoverState(v263, v265, v266, v267)
	end

	t10.Steps = {}

	local v268 = 1 / num

	for i = 1, num do
		local v270 = Create("ImageButton")({
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
			Position = UDim2.new((i - 1) * v268, 2, 0.5, 0),
			Size = UDim2.new(v268, -4, 0, 24),
			Parent = t10.StepsContainer,
			SelectionImageObject = v40
		})

		if i > u251 then
			v270.BackgroundColor3 = v3
		end

		if i == 1 or i == num then
			Create("UICorner")({
				CornerRadius = Theme.DefaultCornerRadius,
				Parent = v270
			})
			Create("Frame")({
				Name = "Filler",
				BorderSizePixel = 0,
				BackgroundColor3 = v270.BackgroundColor3,
				Parent = v270,
				Size = UDim2.new(0.25, 0, 1, 0),
				Position = if i ~= 1 then UDim2.new(0, 0, 0, 0) else UDim2.new(0.75, 0, 0, 0)
			})
		end

		t10.Steps[#t10.Steps + 1] = v270
	end

	local function hideSelection() -- line: 2016
		-- upvalues: num (copy), t10 (copy), v3 (copy)
		for i = 1, num do
			t10.Steps[i].BackgroundColor3 = v3

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v3
			end
		end
	end
	local function showSelection() -- line: 2024
		-- upvalues: num (copy), u251 (ref), t10 (copy), v2 (copy)
		for i = 1, num do
			if i > u251 then
				return
			end

			t10.Steps[i].BackgroundColor3 = v2

			if i == 1 or i == num then
				t10.Steps[i].Filler.BackgroundColor3 = v2
			end
		end
	end
	local function setCurrentStep(p133) -- line: 2036
		-- upvalues: p128 (ref), v262 (copy), v263 (copy), num (copy), u251 (ref), hideSelection (copy), showSelection (copy), timestamp (ref), v258 (copy), BindableEvent (copy)
		if not p128 then
			p128 = 0
		end

		v262.Visible = true
		v263.Visible = true

		if p133 <= p128 then
			p133 = p128
			v262.Visible = false
		end

		if p133 >= num then
			p133 = num
			v263.Visible = false
		end

		if p133 == u251 then
			return
		end

		u251 = p133
		hideSelection()
		showSelection()
		timestamp = tick()

		if v258 then
			v258:fire(u251)

			return
		end

		BindableEvent:Fire(u251)
	end
	local function isActivateEvent(p134) -- line: 2070
		if not p134 then
			return false
		end

		return p134.UserInputType == Enum.UserInputType.MouseButton1 or (p134.UserInputType == Enum.UserInputType.Touch or p134.UserInputType == Enum.UserInputType.Gamepad1 and p134.KeyCode == Enum.KeyCode.ButtonA)
	end
	local function mouseDownFunc(p135, p136, p137) -- line: 2081
		-- upvalues: u254 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), u251 (ref), num (copy), setCurrentStep (copy)
		if not u254 then
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
				n4 = p136 - u251
			else
				n4 = 0

				local connection = nil
				local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 2107
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

				connection = UserInputService.InputEnded:Connect(function(input) -- line: 2128
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
	local function mouseUpFunc(p138) -- line: 2145
		-- upvalues: u254 (ref), n4 (ref)
		if not u254 then
			return
		end

		if not if p138 then p138.UserInputType == Enum.UserInputType.MouseButton1 or (p138.UserInputType == Enum.UserInputType.Touch or p138.UserInputType == Enum.UserInputType.Gamepad1 and p138.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end

	t10.ValueChanged = BindableEvent.Event

	if v258 then
		t10.ValueChanged = v258
	end

	function t10.SetValue(_, p140) -- line: 2162
		-- upvalues: setCurrentStep (copy)
		setCurrentStep(p140)
	end
	function t10.GetValue(_) -- line: 2166
		-- upvalues: u251 (ref)
		return u251
	end
	function t10.SetInteractable(_, p143) -- line: 2170
		-- upvalues: n4 (ref), u254 (ref), t10 (copy), hideSelection (copy), showSelection (copy)
		n4 = 0
		u254 = p143
		t10.SliderFrame.Selectable = p143

		if not u254 then
			hideSelection()

			return
		end

		showSelection()
	end
	function t10.SetZIndex(_, p145) -- line: 2181
		-- upvalues: v262 (copy), v263 (copy), v264 (copy), v265 (copy), t10 (copy)
		v262.ZIndex = p145
		v263.ZIndex = p145
		v264.ZIndex = p145
		v265.ZIndex = p145

		for i = 1, #t10.Steps do
			t10.Steps[i].ZIndex = p145
		end
	end
	function t10.SetMinStep(_, p147) -- line: 2192
		-- upvalues: num (copy), p128 (ref), u251 (ref), v262 (copy), v263 (copy)
		if p147 >= 0 and p147 <= num then
			p128 = p147
		end

		if u251 <= p128 then
			u251 = p128
			v262.Visible = false
		end

		if u251 >= num then
			u251 = num
			v263.Visible = false
		end
	end

	v262.InputBegan:Connect(function(input) -- line: 2209
		-- upvalues: u251 (ref), u254 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v580 = u251 - 1

		if not u254 then
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
			n4 = v580 - u251
		else
			n4 = 0
		end

		setCurrentStep(v580)
	end)
	v262.InputEnded:Connect(function(input) -- line: 2212
		-- upvalues: u254 (ref), n4 (ref)
		if not u254 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)
	v263.InputBegan:Connect(function(input) -- line: 2215
		-- upvalues: u251 (ref), u254 (ref), VRService (copy), UserInputService (copy), GuiService (copy), t10 (copy), n4 (ref), setCurrentStep (copy)
		local v583 = u251 + 1

		if not u254 then
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
			n4 = v583 - u251
		else
			n4 = 0
		end

		setCurrentStep(v583)
	end)
	v263.InputEnded:Connect(function(input) -- line: 2218
		-- upvalues: u254 (ref), n4 (ref)
		if not u254 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function onVREnabled(p148) -- line: 2222
		-- upvalues: VRService (copy), v262 (copy), u254 (ref), v263 (copy), t10 (copy), num (copy)
		if p148 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			v262.Selectable = u254
			v263.Selectable = u254
			t10.SliderFrame.Selectable = u254

			for i = 1, num do
				t10.Steps[i].Selectable = u254
				t10.Steps[i].Active = u254
			end

			return
		end

		v262.Selectable = false
		v263.Selectable = false
		t10.SliderFrame.Selectable = u254

		for i = 1, num do
			t10.Steps[i].Selectable = false
			t10.Steps[i].Active = false
		end
	end

	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	for i = 1, num do
		t10.Steps[i].InputBegan:Connect(function(input) -- line: 2249
			-- upvalues: mouseDownFunc (copy), i (copy)
			mouseDownFunc(input, i)
		end)
		t10.Steps[i].InputEnded:Connect(function(input) -- line: 2252
			-- upvalues: u254 (ref), n4 (ref)
			if not u254 then
				return
			end

			if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
				return
			end

			n4 = 0
		end)
	end

	t10.SliderFrame.InputBegan:Connect(function(input) -- line: 2257
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), mouseDownFunc (copy), u251 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		mouseDownFunc(input, u251)
	end)
	t10.SliderFrame.InputEnded:Connect(function(input) -- line: 2266
		-- upvalues: VRService (copy), GuiService (copy), t10 (copy), u254 (ref), n4 (ref)
		if VRService.VREnabled then
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
				return
			end
		end

		if not u254 then
			return
		end

		if not if input then input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonA) else false then
			return
		end

		n4 = 0
	end)

	local function v279() -- line: 2276
		-- upvalues: timestamp (ref), setCurrentStep (copy), u251 (ref), n4 (ref)
		if timestamp == nil then
			return
		end

		if tick() - timestamp >= 0.2 then
			setCurrentStep(u251 + n4)
		end
	end

	local u280 = true
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

	UserInputService.InputBegan:Connect(function(input) -- line: 2302
		-- upvalues: u254 (ref), u280 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref), setCurrentStep (copy), u251 (ref)
		if not u254 then
			return
		end

		if not u280 then
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
			setCurrentStep(u251 - 1)

			return
		end

		if t11[input.KeyCode] == 1 then
			n4 = 1
			setCurrentStep(u251 + 1)
		end
	end)
	UserInputService.InputEnded:Connect(function(input) -- line: 2330
		-- upvalues: u254 (ref), GuiService (copy), t10 (copy), t11 (copy), n4 (ref)
		if not u254 then
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
	UserInputService.InputChanged:Connect(function(input) -- line: 2351
		-- upvalues: u254 (ref), n4 (ref), u280 (ref), GuiService (copy), t10 (copy), setCurrentStep (copy), u251 (ref)
		if not u254 then
			n4 = 0

			return
		end

		if not u280 then
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
			setCurrentStep(u251 + 1)

			return
		end

		if input.Position.X < -0.8 and input.Delta.X < 0 and n4 ~= -1 then
			n4 = -1
			setCurrentStep(u251 - 1)

			return
		end

		if math.abs(input.Position.X) < 0.8 then
			n4 = 0
		end
	end)

	local u282 = false

	GuiService.Changed:Connect(function(property) -- line: 2392
		-- upvalues: GuiService (copy), t10 (copy), u282 (ref), timestamp (ref), RunService (copy), guid (copy), v279 (copy)
		if property ~= "SelectedCoreObject" then
			return
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t10.SliderFrame.Parent) then
			if not u282 then
				u282 = true
				timestamp = tick()
				RunService:BindToRenderStep(guid, Enum.RenderPriority.Input.Value + 1, v279)

				return
			end
		elseif u282 then
			u282 = false
			RunService:UnbindFromRenderStep(guid)
		end
	end)
	t10.SliderFrame.AncestryChanged:Connect(function(_, parent) -- line: 2413
		-- upvalues: u280 (ref)
		u280 = parent
	end)
	setCurrentStep(u251)

	return t10
end

local n5 = 50

if v36 then
	n5 = 90
end

local t12 = {}

local function AddNewRow(p150, p151, p152, p153, p154, p155, p156, p157, p158, p159) -- line: 2428
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v40 (copy), Theme (copy), v36 (copy), GuiService (copy), t1 (copy), CreateNewSlider (copy), CreateSelector (copy), CreateDropDown (copy), VRService (copy), UserInputService (copy), CoreGui (copy)
	local n6 = 0
	local v294 = p152 ~= "TextBox"

	if t12[p150] then
		n6 = t12[p150]
	end

	local u295 = Create("ImageButton")({
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
		SelectionImageObject = v40,
		Parent = p150.Page
	})

	u295.BackgroundColor3 = Theme.color("RowFrameBackground")
	u295.ImageColor3 = u295.BackgroundColor3
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = u295
	})

	if u295 and p155 then
		u295.Position = UDim2.new(u295.Position.X.Scale, u295.Position.X.Offset, u295.Position.Y.Scale, u295.Position.Y.Offset + p155)
	end

	local u297

	if p156 then
		local v296 = Create("Frame")({
			BackgroundTransparency = 1,
			Name = p151 .. "RowLabelAndDescriptionFrame",
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(0.4, -20, 0, 50),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = u295
		})

		u297 = Create("TextLabel")({
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
			Parent = v296
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
			Parent = v296
		})
		Create("UIListLayout")({
			Name = p151 .. "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = v296
		})
		Create("UIPadding")({
			Name = p151 .. "UIListLayout",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = v296
		})
	else
		u297 = Create("TextLabel")({
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
			Parent = u295
		})
		Create("UIPadding")({
			Name = p151 .. "UIPadding",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = u297
		})
	end

	if not v294 then
		u297.Text = ""
	end

	local function onResized(_, p161) -- line: 2560
		-- upvalues: u297 (ref), Theme (copy), v36 (copy)
		if p161 then
			u297.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		u297.TextSize = v36 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v299 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v299.Y > v299.X then
		u297.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u297.TextSize = v36 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[u295] = onResized

	if _G.__TESTEZ_RUNNING_TEST__ then
		Vector2.new(1024, 1024)
	else
		GuiService:GetHardwareSafeViewport()
	end

	local v300 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	if v300.Y > v300.X then
		u297.TextSize = Theme.textSize(16, "UtilityRow")
	else
		u297.TextSize = v36 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	local SliderFrame = nil
	local u302 = nil

	if p152 == "Slider" then
		u302 = CreateNewSlider(p153, p154, nil, p157, p158)
		u302.SliderFrame.Parent = u295
		SliderFrame = u302.SliderFrame
	elseif p152 == "Selector" then
		u302 = CreateSelector(p153, p154)
		u302.SelectorFrame.Parent = u295
		SliderFrame = u302.SelectorFrame
	elseif p152 == "DropDown" then
		u302 = CreateDropDown(p153, p154, p150.HubRef)
		u302.DropDownFrame.Parent = u295
		SliderFrame = u302.DropDownFrame
	elseif p152 == "TextBox" then
		local v303 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u302 = {
			HubRef = nil
		}

		local v304 = Create("TextBox")({
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
			SelectionImageObject = v303,
			Interactable = p159,
			Parent = u295
		})

		SliderFrame = v304
		v304.Focused:Connect(function() -- line: 2614
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v304 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v304
			end

			if v304.Text == p151 then
				v304.Text = ""
			end
		end)

		if p155 then
			v304.Position = UDim2.new(v304.Position.X.Scale, v304.Position.X.Offset, v304.Position.Y.Scale, v304.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2632
			-- upvalues: VRService (copy), UserInputService (copy), v304 (copy), Theme (copy), u302 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v304.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.1)

				if u302.HubRef then
					u302.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2641
			-- upvalues: VRService (copy), UserInputService (copy), v304 (copy), Theme (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v304.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5)
			end
		end)

		local function processInput(p162) -- line: 2665
			-- upvalues: GuiService (copy), SliderFrame (ref), v304 (copy)
			if p162.UserInputState == Enum.UserInputState.Begin and (p162.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v304:CaptureFocus()
			end
		end

		v304.MouseEnter:Connect(function() -- line: 2647
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v607 = SliderFrame

			if v607 and v607.Visible and v607.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v607
			end
		end)
		UserInputService.InputBegan:Connect(processInput)
	elseif p152 == "TextEntry" then
		local v306 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		u302 = {
			HubRef = nil
		}

		local v307 = Create("TextBox")({
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
			SelectionImageObject = v306,
			Parent = u295
		})

		SliderFrame = v307
		v307.Focused:Connect(function() -- line: 2706
			-- upvalues: VRService (copy), UserInputService (copy), GuiService (copy), v307 (copy), p151 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				GuiService.SelectedCoreObject = v307
			end

			if v307.Text == p151 then
				v307.Text = ""
			end
		end)

		if p155 then
			v307.Position = UDim2.new(v307.Position.X.Scale, v307.Position.X.Offset, v307.Position.Y.Scale, v307.Position.Y.Offset + p155)
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2724
			-- upvalues: VRService (copy), UserInputService (copy), v307 (copy), u302 (ref), SliderFrame (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v307.BackgroundTransparency = 0.8

				if u302.HubRef then
					u302.HubRef:ScrollToFrame(SliderFrame)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2733
			-- upvalues: VRService (copy), UserInputService (copy), v307 (copy)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				v307.BackgroundTransparency = 1
			end
		end)

		local function processInput(p163) -- line: 2757
			-- upvalues: GuiService (copy), SliderFrame (ref), v307 (copy)
			if p163.UserInputState == Enum.UserInputState.Begin and (p163.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == SliderFrame) then
				v307:CaptureFocus()
			end
		end

		u295.MouseEnter:Connect(function() -- line: 2739
			-- upvalues: CoreGui (copy), SliderFrame (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v610 = SliderFrame

			if v610 and v610.Visible and v610.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v610
			end
		end)

		function u302.SetZIndex(_, p165) -- line: 2768
			-- upvalues: v307 (copy)
			v307.ZIndex = p165
		end
		function u302.SetInteractable(_, p167) -- line: 2772
			-- upvalues: v307 (copy)
			v307.Selectable = p167

			if not p167 then
				v307.TextColor3 = Color3.fromRGB(49, 49, 49)
				v307.ZIndex = 1

				return
			end

			v307.TextColor3 = Color3.fromRGB(178, 178, 178)
			v307.ZIndex = 2
		end
		function u302.SetValue(_, p169) -- line: 2783
			-- upvalues: v307 (copy)
			v307.Text = p169
		end

		local BindableEvent = Instance.new("BindableEvent")

		BindableEvent.Name = "ValueChanged"
		v307.FocusLost:Connect(function() -- line: 2790
			-- upvalues: BindableEvent (copy), v307 (copy)
			BindableEvent:Fire(v307.Text)
		end)
		u302.ValueChanged = BindableEvent.Event
		UserInputService.InputBegan:Connect(processInput)
	end

	u302.Name = p151 .. "ValueChanger"

	local SetAutoLocalize = u302.SetAutoLocalize

	function u302.SetAutoLocalize(p170, p171) -- line: 2802
		-- upvalues: u295 (ref), SetAutoLocalize (copy)
		u295.AutoLocalize = p171

		if SetAutoLocalize then
			SetAutoLocalize(p170, p171)
		end
	end

	local v311 = n6 + n5

	if p155 then
		v311 += p155
	end

	t12[p150] = v311

	if v294 then
		u295.MouseEnter:Connect(function() -- line: 2817
			-- upvalues: CoreGui (copy), u302 (ref), VRService (copy), UserInputService (copy), p150 (copy), GuiService (copy)
			local DropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if DropDownFullscreenFrame and DropDownFullscreenFrame.Visible then
				return
			end

			local v621 = u302.SliderFrame or u302.SliderFrame or u302.DropDownFrame or u302.SelectorFrame

			if v621 and v621.Visible and v621.ZIndex > 1 and (not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false))) and p150.Active then
				GuiService.SelectedCoreObject = v621
			end
		end)

		local function onVREnabled(p172) -- line: 2847
			-- upvalues: VRService (copy), u295 (ref), SliderFrame (ref), GuiService (copy), Theme (copy)
			if p172 == "VREnabled" then
				if VRService.VREnabled then
					u295.Selectable = true
					u295.Active = true
					SliderFrame.Active = true
					GuiService.Changed:Connect(function(property) -- line: 2853
						-- upvalues: GuiService (copy), u295 (ref), Theme (copy)
						if property == "SelectedCoreObject" then
							local SelectedCoreObject = GuiService.SelectedCoreObject

							if SelectedCoreObject and (SelectedCoreObject == u295 or SelectedCoreObject:IsDescendantOf(u295)) then
								u295.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
								u295.BackgroundTransparency = 1

								return
							end

							u295.ImageTransparency = 1
							u295.BackgroundTransparency = 1
						end
					end)

					return
				end

				u295.Selectable = false
				u295.Active = false
			end
		end

		VRService.Changed:Connect(onVREnabled)

		if VRService.VREnabled then
			u295.Selectable = true
			u295.Active = true
			SliderFrame.Active = true
			GuiService.Changed:Connect(function(property) -- line: 2853
				-- upvalues: GuiService (copy), u295 (ref), Theme (copy)
				if property == "SelectedCoreObject" then
					local SelectedCoreObject = GuiService.SelectedCoreObject

					if SelectedCoreObject and (SelectedCoreObject == u295 or SelectedCoreObject:IsDescendantOf(u295)) then
						u295.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
						u295.BackgroundTransparency = 1

						return
					end

					u295.ImageTransparency = 1
					u295.BackgroundTransparency = 1
				end
			end)
		else
			u295.Selectable = false
			u295.Active = false
		end

		SliderFrame.SelectionGained:Connect(function() -- line: 2874
			-- upvalues: VRService (copy), UserInputService (copy), u295 (ref), Theme (copy), u302 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				if VRService.VREnabled then
					u295.ImageTransparency = 0.5
					u295.BackgroundTransparency = 1
				else
					u295.ImageTransparency = 1
					u295.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
				end

				if u302.HubRef then
					u302.HubRef:ScrollToFrame(u295)
				end
			end
		end)
		SliderFrame.SelectionLost:Connect(function() -- line: 2889
			-- upvalues: VRService (copy), UserInputService (copy), u295 (ref)
			if not VRService.VREnabled and (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or (UserInputService.GamepadEnabled and true or false)) then
				u295.ImageTransparency = 1
				u295.BackgroundTransparency = 1
			end
		end)
	end

	p150:AddRow(u295, u297, u302, p155, false)
	u302.Selection = SliderFrame

	return u295, u297, u302
end
local function AddNewRowObject(p173, p174, p175, p176, p177) -- line: 2904
	-- upvalues: t12 (copy), Create (copy), n5 (ref), v40 (copy), Theme (copy), v36 (copy), t1 (copy), GuiService (copy), VRService (copy)
	local n7 = 0

	if t12[p173] then
		n7 = t12[p173]
	end

	local v319 = Create("ImageButton")({
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
		SelectionImageObject = v40,
		Parent = p173.Page
	})

	v319.BackgroundColor3 = Theme.color("RowFrameBackground")
	v319.ImageColor3 = v319.BackgroundColor3
	v319.SelectionGained:Connect(function() -- line: 2932
		-- upvalues: v319 (copy), Theme (copy)
		v319.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	v319.SelectionLost:Connect(function() -- line: 2935
		-- upvalues: v319 (copy)
		v319.BackgroundTransparency = 1
	end)
	Create("UICorner")({
		CornerRadius = Theme.DefaultCornerRadius,
		Parent = v319
	})

	local v320 = Create("TextLabel")({
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
		Parent = v319
	})

	Create("UIPadding")({
		Name = p174 .. "UIPadding",
		PaddingBottom = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		Parent = v320
	})

	local function onResized(_, p179) -- line: 2967
		-- upvalues: p177 (copy), v320 (copy), Theme (copy), v36 (copy)
		if p177 then
			UDim2.new(0, 200, 1, 0)
		end

		if p179 then
			v320.TextSize = Theme.textSize(16, "UtilityRow")

			return
		end

		v320.TextSize = v36 and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
	end

	t1[v319] = onResized

	local v322 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v323 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

	onResized(v322, v323.Y > v323.X)

	if p176 then
		v319.Position = UDim2.new(v319.Position.X.Scale, v319.Position.X.Offset, v319.Position.Y.Scale, v319.Position.Y.Offset + p176)
	end

	local v324 = n7 + n5

	if p176 then
		v324 += p176
	end

	t12[p173] = v324
	v319.MouseEnter:Connect(function() -- line: 2995
		-- upvalues: v319 (copy), GuiService (copy)
		if v319.Visible then
			GuiService.SelectedCoreObject = v319
		end
	end)
	p175.SelectionImageObject = v40
	p175.SelectionGained:Connect(function() -- line: 3004
		-- upvalues: VRService (copy), v319 (copy), Theme (copy)
		if VRService.VREnabled then
			v319.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
			v319.BackgroundTransparency = 1

			return
		end

		v319.ImageTransparency = 1
		v319.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	p175.SelectionLost:Connect(function() -- line: 3013
		-- upvalues: v319 (copy)
		v319.ImageTransparency = 1
		v319.BackgroundTransparency = 1
	end)
	p175.Parent = v319
	p173:AddRow(v319, v320, p175, p176, true)

	return v319
end

local t13 = {
	GetEaseLinear = function(_) -- line: 3027
		-- upvalues: Linear (copy)
		return Linear
	end,
	GetEaseOutQuad = function(_) -- line: 3030
		-- upvalues: EaseOutQuad (copy)
		return EaseOutQuad
	end,
	GetEaseInOutQuad = function(_) -- line: 3033
		-- upvalues: EaseInOutQuad (copy)
		return EaseInOutQuad
	end,
	CreateNewSlider = function(_, p184, p185, p186, p187, p188) -- line: 3037
		-- upvalues: CreateNewSlider (copy)
		return CreateNewSlider(p184, p185, p186, p187, p188)
	end,
	CreateNewSelector = function(_, p190, p191) -- line: 3041
		-- upvalues: CreateSelector (copy)
		return (CreateSelector(p190, p191))
	end,
	CreateNewDropDown = function(_, p193, p194) -- line: 3045
		-- upvalues: CreateDropDown (copy)
		return (CreateDropDown(p193, p194, nil))
	end,
	AddNewRow = function(_, p196, p197, p198, p199, p200, p201, p202, p203, p204, p205) -- line: 3049
		-- upvalues: AddNewRow (copy)
		return AddNewRow(p196, p197, p198, p199, p200, p201, p202, p203, p204, p205)
	end,
	AddNewRowObject = function(_, p207, p208, p209, p210, p211) -- line: 3053
		-- upvalues: AddNewRowObject (copy)
		return (AddNewRowObject(p207, p208, p209, p210, p211))
	end,
	ShowAlert = function(_, p213, p214, p215, p216, p217) -- line: 3057
		-- upvalues: ShowAlert (copy)
		ShowAlert(p213, p214, p215, p216, p217)
	end,
	IsSmallTouchScreen = function(_) -- line: 3061
		-- upvalues: GuiService (copy), UserInputService (copy)
		local v364 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return UserInputService.TouchEnabled and (v364.Y < 500 or v364.X < 700)
	end,
	IsPortrait = function(_) -- line: 3065
		-- upvalues: GuiService (copy)
		local v366 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)

		return v366.Y > v366.X
	end
}

if FFlagRefactorMenuConfirmationButtons then
	local function isUsingGamepad() -- line: 3070
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end

	function t13.IsUsingGamepad(_) -- line: 3074
		-- upvalues: t5 (copy), UserInputService (copy)
		return t5[UserInputService:GetLastInputType()] or false
	end
end

function t13.MakeStyledButton(_, p222, p223, p224, p225, p226, p227) -- line: 3079
	-- upvalues: MakeButton (copy)
	return MakeButton(p222, p223, p224, p225, p226, p227)
end
function t13.MakeStyledImageButton(_, p229, p230, p231, p232, p233, p234, p235, p236) -- line: 3083
	-- upvalues: MakeImageButton (copy)
	return MakeImageButton(p229, p230, p231, p232, p233, p234, p235, p236)
end
function t13.AddButtonRow(_, p238, p239, p240, p241, p242, p243) -- line: 3087
	-- upvalues: AddButtonRow (copy)
	return AddButtonRow(p238, p239, p240, p241, p242, p243)
end
function t13.MakeFocusState(_, p245, p246) -- line: 3091
	-- upvalues: MakeRoundedRectFocusState (copy)
	return MakeRoundedRectFocusState(p245, p246)
end
function t13.CreateSignal(_) -- line: 3095
	-- upvalues: CreateSignal (copy)
	return (CreateSignal())
end
function t13.UsesSelectedObject(_) -- line: 3099
	-- upvalues: VRService (copy), UserInputService (copy)
	if VRService.VREnabled then
		return false
	end

	if UserInputService.PreferredInput == Enum.PreferredInput.Touch and not UserInputService.GamepadEnabled then
		return false
	end

	return true
end
function t13.TweenProperty(_, p250, p251, p252, p253, p254, p255, p256) -- line: 3103
	return PropertyTweener(p250, p251, p252, p253, p254, p255, p256)
end
function t13.OnResized(_, p258, p259) -- line: 3107
	-- upvalues: addOnResizedCallback (copy)
	return addOnResizedCallback(p258, p259)
end
function t13.FireOnResized(_) -- line: 3111
	-- upvalues: GuiService (copy), t13 (copy), t1 (copy)
	local v408 = if not _G.__TESTEZ_RUNNING_TEST__ then GuiService:GetHardwareSafeViewport() else Vector2.new(1024, 1024)
	local v409 = t13:IsPortrait()

	for _, v in pairs(t1) do
		v(v408, v409)
	end
end
function t13.Lerp(_, p262, p263, p264) -- line: 3122
	return (1 - p262) * p263 + p262 * p264
end
function t13.Round(_, p266) -- line: 3127
	return p266 % 1 >= 0.5 and math.ceil(p266) or math.floor(p266)
end
function t13.IsExperienceOlderThanOneWeek(_, p268) -- line: 3131
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

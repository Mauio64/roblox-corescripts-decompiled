local Theme = require(script.Parent.Theme)

local color = Theme.color("SELECTED_COLOR", Color3.fromRGB(0, 162, 255))
local color2 = Theme.color("NON_SELECTED_COLOR", Color3.fromRGB(78, 84, 96))

local color3 = Theme.color("ARROW_COLOR", Color3.fromRGB(204, 204, 204))
local color4 = Theme.color("ARROW_COLOR_HOVER", Color3.fromRGB(255, 255, 255))

local color5 = Theme.color("ARROW_COLOR_INACTIVE", Color3.fromRGB(150, 150, 150))

local udim = UDim.new(0, 14)

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
local defineFastFlag = game:DefineFastFlag("RepositionDropDownScrim", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUIScaleEngineOptions = SharedFlags.FFlagUIScaleEngineOptions
local FFlagUIScaleSliderImprovements = require(RobloxGui.Modules.Settings.Flags.FFlagUIScaleSliderImprovements)

local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Service

if Chrome2.Enabled() then
	Service = require(Chrome.Service)
else
	Service = nil
end

local Signals = require(CorePackages.Packages.Signals)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local Flags = require(Chrome.Flags)
local FFlagHideShortcutsWhileIemDropdownActive = Flags.FFlagHideShortcutsWhileIemDropdownActive

local engineFeature = game:GetEngineFeature("EnablePreferredTextSizeAccessGuiService")

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local defineFastFlag2 = game:DefineFastFlag("IncreaseLegacyPeopleRowButtonSize", false)

local shouldSelectorArrowStep = require(RobloxGui.Modules.Settings.shouldSelectorArrowStep)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local CorePackages2 = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages2.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local Create = AppCommonLib.Create
local BuilderIcons = require(CorePackages2.Packages.BuilderIcons)
local Migration = BuilderIcons.Migration

local SharedFlags2 = require(CorePackages2.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags2.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules:WaitForChild("TenFootInterface"))
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot

local computed = Signals.createComputed(function(p): boolean
	return Responsive.GetInputModeStore(p).getLastInputType(p) == Responsive.Input.Touch
end)

local computed2 = Signals.createComputed(function(p): boolean
	return Responsive.GetInputModeStore(p).getLastInputType(p) == Responsive.Input.Pointer
end)

local v2 = {}
setmetatable(v2, { __mode = "k" })

local selectionImageObject = Create("ImageLabel")({ Image = "", BackgroundTransparency = 1 })

function clamp(p, p2, p3)
	return (math.max(p, (math.min(p2, p3))))
end

local function Linear(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	return p3 * p / p4 + p2
end

local function EaseOutQuad(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	p /= p4
	return p2 - p3 * p * (p - 2)
end

local function EaseInOutQuad(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	p /= p4

	if p < 0.5 then
		return 2 * p3 * p * p + p2
	end

	return p2 + p3 * (2 * (2 - p) * p - 1)
end

function PropertyTweener(p, p2, p3, final, p4, callback, callback2)
	local v3 = {}
	v3.StartTime = tick()
	v3.EndTime = v3.StartTime + p4
	v3.Cancelled = false

	local v4 = false
	local percentComplete = 0

	local function finalize() -- 2 equivalent calls inferred from this helper
		if p then
			p[p2] = callback(1, p3, final - p3, 1)
		end

		v4 = true
		percentComplete = 1

		if callback2 then
			callback2()
		end
	end

	p[p2] = callback(0, p3, final - p3, p4)
	coroutine.wrap(function()
		local now = tick()

		while now < v3.EndTime and p do
			if v3.Cancelled then
				return
			end

			p[p2] = callback(now - v3.StartTime, p3, final - p3, p4)
			percentComplete = clamp(0, 1, (now - v3.StartTime) / p4)
			RunService.RenderStepped:Wait()
			now = tick()
		end

		if v3.Cancelled == false and p then
			finalize() -- inferred equivalent call
		end
	end)()

	function v3.GetFinal(_)
		return final
	end

	function v3.GetPercentComplete(_)
		return percentComplete
	end

	function v3.IsFinished(_)
		return v4
	end

	function v3:Finish()
		if not v4 then
			self:Cancel()
			finalize() -- inferred equivalent call
		end
	end

	function v3:Cancel()
		v3.Cancelled = true
	end

	return v3
end

local function isTouchInput(): boolean -- 5 equivalent calls inferred from this helper
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end

local function CreateSignal()
	local bindableEvent = Instance.new("BindableEvent")

	local v3 = nil
	local v4 = nil
	return {
		fire = function(self, ...)
			v3 = { ... }
			v4 = select("#", ...)
			bindableEvent:Fire()
		end,
		connect = function(self, callback)
			if not callback then
				error("connect(nil)", 2)
			end

			return bindableEvent.Event:Connect(function()
				callback(unpack(v3, 1, v4))
			end)
		end,
		wait = function(self)
			bindableEvent.Event:wait()

			if not v3 then
				error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			end

			return unpack(v3, 1, v4)
		end
	}
end

local function getViewportSize() -- 6 equivalent calls inferred from this helper
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Vector2.new(1024, 1024)
	end

	return GuiService:GetHardwareSafeViewport()
end

local function isSmallTouchScreen() -- 2 equivalent calls inferred from this helper
	local viewportSize = getViewportSize() -- inferred equivalent call
	return UserInputService.TouchEnabled and (viewportSize.Y < 500 or viewportSize.X < 700)
end

local function isPortrait(): boolean -- 4 equivalent calls inferred from this helper
	local viewportSize = getViewportSize() -- inferred equivalent call
	return viewportSize.Y > viewportSize.X
end

local function isTenFootInterface()
	return v
end

local function usesSelectedObject() -- 21 equivalent calls inferred from this helper
	return not VRService.VREnabled and ((not isTouchInput() or UserInputService.GamepadEnabled) and true or false) -- inferred equivalent call
end

local function addHoverState(data, p, fn, fn2)
	local function onNormalButtonStateCallback()
		if data.Active then
			fn(p)
		end
	end
	local function onHoverButtonStateCallback()
		if data.Active then
			fn2(p)
		end
	end

	data.MouseEnter:Connect(onHoverButtonStateCallback)
	data.SelectionGained:Connect(onHoverButtonStateCallback)
	data.MouseLeave:Connect(onNormalButtonStateCallback)
	data.SelectionLost:Connect(onNormalButtonStateCallback)

	fn(p)
end

local function addOnResizedCallback(p, callback) -- 2 equivalent calls inferred from this helper
	v2[p] = callback
	callback(getViewportSize(), isPortrait()) -- inferred equivalent call
end

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}

local function MakeDefaultButton(p, size, callback, p2, p3, p4)
	local selectionImageObject2 = Create("ImageLabel")({ Image = "", BackgroundTransparency = 1 })
	local v3, v4

	if p == "DropDownFrame" then
		v3 = "ControlInputBackground"
		v4 = "ControlInputStroke"
	else
		v3 = "DefaultButton"
		v4 = "DefaultButtonStroke"
	end

	local v5 = p4 == "ImageButton" and "ImageButton" or v3

	local parent = Create("ImageButton")({
		Name = p .. "Button",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.color(v5),
		BackgroundTransparency = Theme.transparency(v5),
		Size = size,
		ZIndex = 2,
		SelectionImageObject = selectionImageObject2
	})

	Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent })

	local v6 = Create("UIStroke")({
		Name = "Border",
		Color = Theme.color(v4),
		Transparency = Theme.transparency(v4),
		Thickness = Theme.DefaultStokeThickness,
		Parent = parent
	})

	Create("BoolValue")({ Name = "Enabled", Parent = parent, Value = true })

	if callback then
		parent.MouseButton1Click:Connect(function()
			callback(set[UserInputService:GetLastInputType()] or false)
		end)
	else
		if v6 then
			v6.Enabled = false
		end

		parent.Selectable = false
	end

	local function isPointerInput(p5): boolean
		return p5.UserInputType == Enum.UserInputType.MouseMovement or p5.UserInputType == Enum.UserInputType.Touch
	end

	local v7 = nil
	local function setRowRef(p5)
		v7 = p5
	end

	local function selectButton()
		local v8 = p3

		if v8 == nil and p2 then
			v8 = p2.HubRef
		end

		if v8 and v8.Active or v8 == nil then
			parent.BackgroundColor3 = Theme.color("DefaultButtonHover")
			parent.BackgroundTransparency = Theme.transparency("DefaultButtonHover")

			local v9 = parent

			if v7 then
				v9 = v7
			end

			if v8 then
				v8:ScrollToFrame(v9)
			end
		end
	end

	local function deselectButton() -- 3 equivalent calls inferred from this helper
		parent.BackgroundColor3 = Theme.color(v5)
		parent.BackgroundTransparency = Theme.transparency(v5)
	end

	parent.InputBegan:Connect(function(input)
		if
			parent.Selectable
			and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
		then
			selectButton()
		end
	end)
	parent.InputEnded:Connect(function(input)
		if
			parent.Selectable
			and GuiService.SelectedCoreObject ~= parent
			and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
		then
			deselectButton() -- inferred equivalent call
		end
	end)

	parent.SelectionGained:Connect(function()
		selectButton()
	end)
	parent.SelectionLost:Connect(function()
		deselectButton() -- inferred equivalent call
	end)

	GuiService.Changed:Connect(function(p5)
		if not (p5 == "SelectedCoreObject" and usesSelectedObject()) then -- inferred equivalent call
			return
		end

		if GuiService.SelectedCoreObject == nil or GuiService.SelectedCoreObject ~= parent then
			deselectButton() -- inferred equivalent call
		elseif parent.Selectable then
			selectButton()
		end
	end)

	return parent, setRowRef
end

local function MakeButton(p, text, p2, p3, p4, p5)
	local parent, v3 = MakeDefaultButton(p, p2, p3, p4, p5)

	local v4 = Create("TextLabel")({
		Name = p .. "TextLabel",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		TextColor3 = Theme.color("WhiteButtonText", Color3.fromRGB(255, 255, 255)),
		TextTransparency = Theme.transparency("WhiteButtonText", 0),
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Theme.font(Enum.Font.SourceSansBold, "Button"),
		TextSize = Theme.textSize(24, "Button"),
		Text = text,
		TextScaled = false,
		TextWrapped = true,
		ZIndex = 2,
		Parent = parent
	})

	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", v4)

	if isSmallTouchScreen() then -- inferred equivalent call
		v4.TextSize = Theme.textSize(18)
	elseif v and p ~= "FriendStatus" and p ~= "BlockButton" then
		v4.TextSize = Theme.textSize(36)
	end

	if engineFeature then
		local v5 = (GuiService.PreferredTextSize.Value - 1) * 3
		uiTextSizeConstraint.MaxTextSize = v4.TextSize + v5
		local textSize = v4.TextSize
		GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
			v5 = (GuiService.PreferredTextSize.Value - 1) * 3
			uiTextSizeConstraint.MaxTextSize = textSize + v5
		end)
	else
		uiTextSizeConstraint.MaxTextSize = v4.TextSize
	end

	return parent, v4, v3
end

local function MakeImageButton(p, image, size, size2, p2, p3, p4, value)
	value = value or "ImageButton"
	local parent, v3 = MakeDefaultButton(p, size, p2, p3, p4, value)

	local imageRectOffset = nil
	local imageRectSize = nil

	local v4 = Migration.uiblox[image] or Migration.luaApps[image]

	if not string.match(image, "^rbxasset://") then
		image = Theme.Images[image]
	end

	if typeof(image) == "table" then
		imageRectOffset = image.ImageRectOffset
		imageRectSize = image.ImageRectSize
		image = image.Image
	end

	local v5

	if v4 then
		local create = Create("TextLabel")
		local v6 = {
			Name = p .. "TextLabel",
			BackgroundTransparency = 1,
			Size = size2,
			TextSize = 0,
			Position = 0,
			AnchorPoint = 0,
			TextColor3 = 0,
			Text = 0,
			FontFace = 0,
			Parent = 0,
			ZIndex = 2
		}
		local textSize

		if defineFastFlag2 then
			textSize = size2.Y.Offset * (6 / 7)
		else
			textSize = size2.Y.Offset * (2 / 3)
		end

		v6.TextSize = textSize

		v6.Position = UDim2.new(0.5, 0, 0.5, 0)
		v6.AnchorPoint = Vector2.new(0.5, 0.5)
		v6.TextColor3 = Color3.new(1, 1, 1)
		v6.Text = v4.name
		v6.FontFace = BuilderIcons.Font[v4.variant]
		v6.Parent = parent
		v5 = create(v6)
	else
		v5 = Create("ImageLabel")({
			Name = p .. "ImageLabel",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = size2,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = image,
			ImageRectOffset = imageRectOffset,
			ImageRectSize = imageRectSize,
			ZIndex = 2,
			Parent = parent
		})
	end

	if value == "ImageButton" then
		parent.Border.Thickness = 0
		parent.Border.Transparency = 1
	end

	return parent, v5, v3
end

local function AddButtonRow(p, p2, text, p3, p4, p5)
	local v3, v4, v5 = MakeButton(p2, text, p3, p4, p, p5)
	local parent = Create("Frame")({
		Name = p2 .. "Row",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, p3.Y.Scale, p3.Y.Offset),
		Parent = p.Page
	})

	v3.Parent = parent
	v3.AnchorPoint = Vector2.new(1, 0)
	v3.Position = UDim2.new(1, -20, 0, 0)
	return parent, v3, v4, v5
end

local function MakeRoundedRectFocusState(instance, p)
	local v3 = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 12, 1, 12),
		Position = UDim2.fromOffset(-6, -6)
	})

	Create("UICorner")({ CornerRadius = udim, Parent = v3 })

	local parent2 = Create("UIStroke")({
		Color = Theme.selectionCursor.AnimatedColor,
		Transparency = 0,
		Thickness = 3,
		Parent = v3
	})

	local v4 = Create("UIGradient")({
		Rotation = 0,
		Color = Theme.selectionCursor.GradientColorSequence,
		Transparency = Theme.selectionCursor.GradientTransparencySequence,
		Parent = parent2
	})

	RunService:UnbindFromRenderStep(p)

	RunService:BindToRenderStep(p, Enum.RenderPriority.Last.Value, function()
		local rotation = v4.Rotation + 2
		local color6 = Theme.selectionCursor.GradientColorSequence
		local transparency = Theme.selectionCursor.GradientTransparencySequence

		if UserGameSettings.ReducedMotion then
			local midpoint = (math.sin((math.rad(rotation))) + 1) / 2

			local value = color6.Keypoints[1].Value
			local value2 = color6.Keypoints[#color6.Keypoints].Value
			color6 = ColorSequence.new(value:lerp(value2, midpoint))

			local value3 = transparency.Keypoints[1].Value
			local value4 = transparency.Keypoints[#transparency.Keypoints].Value
			transparency = NumberSequence.new(value3 + (value4 - value3) * midpoint)
		end

		v4.Rotation = rotation
		v4.Color = color6
		v4.Transparency = transparency
	end)

	instance.AncestryChanged:Connect(function(_, parent)
		if not parent then
			RunService:UnbindFromRenderStep(p)
		end
	end)

	instance.SelectionImageObject = v3
end

local function CreateDropDown(p, p2, object)
	local color6 = Theme.color("SELECTION_TEXT_COLOR_NORMAL", Color3.fromRGB(178, 178, 178))
	local color7 = Color3.fromRGB(229, 229, 229)

	local color8 = Theme.color("SELECTION_TEXT_COLOR_HIGHLIGHTED", Color3.fromRGB(255, 255, 255))

	local dropDownFrame = nil

	local dropDown = {}
	dropDown.CurrentIndex = nil
	dropDown.UpdateDropDownList = nil
	dropDown.DropDownFrame = nil
	dropDown.Selections = nil
	local bindableEvent = Instance.new("BindableEvent")
	bindableEvent.Name = "IndexChanged"

	if type(p) ~= "table" then
		error("CreateDropDown dropDownStringTable (first arg) is not a table", 2)
		return dropDown
	end

	local indexChanged = Instance.new("BindableEvent")
	indexChanged.Name = "IndexChanged"

	local selectable = true
	local guid = HttpService:GenerateGUID(false)
	local enabled = nil
	local v3 = p

	local guiInset, _ = GuiService:GetGuiInset()
	local create = Create("ImageButton")
	local dropDownFullscreenFrame = {
		Name = "DropDownFullscreenFrame",
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, not defineFastFlag and 0 or guiInset.Y),
		Position = 0,
		BackgroundColor3 = 0,
		ZIndex = 10,
		Active = true,
		Visible = false,
		Selectable = false,
		AutoButtonColor = false,
		Parent = 0
	}
	local position

	if defineFastFlag then
		position = UDim2.new(0, 0, 0, -guiInset.Y)
	end

	dropDownFullscreenFrame.Position = position
	dropDownFullscreenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

	dropDownFullscreenFrame.Parent = CoreGui.RobloxGui
	local parent = create(dropDownFullscreenFrame)

	local function onVREnabled(p3)
		if p3 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local panelType = VrSpatialUi.Constants.PanelType
				parent.Parent = VrSpatialUi.UIManager.getInstance():getPanelObject(panelType.MoreMenu)
				parent.BackgroundTransparency = 0.2
			else
				local VrCommon = require(CorePackages2.Workspace.Packages.VrCommon)
				parent.Parent = VrCommon.Panel3D.Get("SettingsMenu"):GetGUI()
				parent.BackgroundTransparency = 1
			end
		else
			parent.Parent = CoreGui.RobloxGui
			parent.BackgroundTransparency = 0.2
		end

		if dropDown.UpdateDropDownList then
			dropDown:UpdateDropDownList(v3)
		end
	end
	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	local parent2 = Create("ImageLabel")({
		Name = "DropDownSelectionFrame",
		Image = "",
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(8, 6, 46, 44),
		BackgroundTransparency = Theme.transparency("DropdownListBg", 1),
		BackgroundColor3 = Theme.color("DropdownListBg"),
		Size = UDim2.new(0.6, 0, 0.9, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 10,
		Parent = parent
	})

	Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent2 })

	local parent3 = Create("ScrollingFrame")({
		Name = "DropDownScrollingFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 1, -25),
		Position = UDim2.new(0, 10, 0, 10),
		ZIndex = 10,
		ScrollBarThickness = Theme.DefaultScrollBarThickness,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = parent2
	})

	local selectedCoreObjectChangedConnection = nil
	local v4 = false
	local function onMouseButton1Click(p3, p4)
		if p3 ~= nil and p4 ~= Enum.UserInputState.Begin then
			return
		end

		dropDown.DropDownFrame.Selectable = selectable

		object:SetActive(true)

		if parent.Visible and usesSelectedObject() then -- inferred equivalent call
			GuiService.SelectedCoreObject = dropDownFrame
		end

		parent.Visible = false

		if selectedCoreObjectChangedConnection then
			selectedCoreObjectChangedConnection:Disconnect()
		end

		ContextActionService:UnbindCoreAction(guid .. "Action")
		ContextActionService:UnbindCoreAction(guid .. "FreezeAction")

		enabled.Value = selectable
		v4 = false

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			local VrCommon = require(CorePackages2.Workspace.Packages.VrCommon)
			VrCommon.Panel3D.Get("SettingsMenu"):SetSubpanelDepth(parent, 0)
		end
	end
	local function fn() end

	local function fn2()
		if not selectable then
			return
		end

		dropDown.DropDownFrame.Selectable = false
		v4 = true

		parent.Visible = true

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			local VrCommon = require(CorePackages2.Workspace.Packages.VrCommon)
			VrCommon.Panel3D.Get("SettingsMenu"):SetSubpanelDepth(parent, 0.5)
		end

		dropDownFrame = dropDown.DropDownFrame

		if dropDown.CurrentIndex and dropDown.CurrentIndex > 0 then
			GuiService.SelectedCoreObject = dropDown.Selections[dropDown.CurrentIndex]
		elseif #dropDown.Selections > 0 then
			GuiService.SelectedCoreObject = dropDown.Selections[1]
		end

		selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			for i = 1, #dropDown.Selections do
				if GuiService.SelectedCoreObject == dropDown.Selections[i] then
					dropDown.Selections[i].TextColor3 = color8
				else
					dropDown.Selections[i].TextColor3 = VRService.VREnabled and color7 or color6
				end
			end
		end)

		local v5 = onMouseButton1Click

		if FFlagHideShortcutsWhileIemDropdownActive then
			Service:setHideShortcutBar("InExperienceMenuDropdown", true)
			v5 = function(p3, p4)
				onMouseButton1Click(p3, p4)
				Service:setHideShortcutBar("InExperienceMenuDropdown", false)
			end
		end

		ContextActionService:BindCoreAction(
			guid .. "FreezeAction",
			fn,
			false,
			Enum.UserInputType.Keyboard,
			Enum.UserInputType.Gamepad1
		)

		ContextActionService:BindCoreAction(guid .. "Action", v5, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)

		object:SetActive(false)

		enabled.Value = false
	end

	local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.ChooseOne")

	dropDown.DropDownFrame = MakeButton("DropDownFrame", formatByKey, UDim2.new(0.6, 0, 0, 40), fn2, nil, object)
	dropDown.DropDownFrame.Position = UDim2.new(1, 0, 0.5, 0)
	dropDown.DropDownFrame.AnchorPoint = Vector2.new(1, 0.5)

	enabled = dropDown.DropDownFrame.Enabled
	local dropDownFrameTextLabel = dropDown.DropDownFrame.DropDownFrameTextLabel
	dropDownFrameTextLabel.Position = UDim2.new(0, 15, 0, 0)
	dropDownFrameTextLabel.Size = UDim2.new(1, -50, 1, 0)
	dropDownFrameTextLabel.ClipsDescendants = true
	dropDownFrameTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	local dropDownImage = Create("ImageLabel")({
		Name = "DropDownImage",
		Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(0, 15, 0, 10),
		Position = UDim2.new(1, -12, 0.5, 0),
		ZIndex = 2,
		Parent = dropDown.DropDownFrame
	})

	dropDown.DropDownImage = dropDownImage

	local function setSelection(p3)
		local flag = false

		for k, selection in pairs(dropDown.Selections) do
			if k ~= p3 then
				continue
			end

			dropDownFrameTextLabel.Text = selection.Text
			dropDown.CurrentIndex = k
			flag = true
		end

		if flag then
			indexChanged:Fire(p3)
		end
	end

	local function setSelectionByValue(p3)
		local flag = false

		for k, selection in pairs(dropDown.Selections) do
			if selection.Text ~= p3 then
				continue
			end

			dropDownFrameTextLabel.Text = selection.Text
			dropDown.CurrentIndex = k
			flag = true
		end

		if flag then
			indexChanged:Fire(dropDown.CurrentIndex)
		end

		return flag
	end

	local function setIsFaded(vrEnabled) -- 2 equivalent calls inferred from this helper
		if vrEnabled then
			dropDown.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5
			dropDown.DropDownFrame.ImageTransparency = 0.5
			dropDown.DropDownImage.ImageTransparency = 0.5
		else
			dropDown.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
			dropDown.DropDownFrame.ImageTransparency = 0
			dropDown.DropDownImage.ImageTransparency = 0
		end
	end

	dropDown.IndexChanged = indexChanged.Event

	function dropDown:SetSelectionIndex(p3)
		setSelection(p3)
	end

	function dropDown.SetSelectionByValue(_, p3)
		return setSelectionByValue(p3)
	end

	function dropDown.ResetSelectionIndex(_)
		dropDown.CurrentIndex = nil
		dropDownFrameTextLabel.Text = formatByKey
		onMouseButton1Click()
	end

	function dropDown.GetSelectedIndex(_)
		return dropDown.CurrentIndex
	end

	function dropDown:SetZIndex(zIndex)
		dropDown.DropDownFrame.ZIndex = zIndex
		dropDownImage.ZIndex = zIndex
		dropDownFrameTextLabel.ZIndex = zIndex
	end

	function dropDown.SetInteractable(_, visible)
		selectable = visible
		dropDown.DropDownFrame.Selectable = selectable

		if selectable then
			setIsFaded(false) -- inferred equivalent call

			if not VRService.VREnabled then
				dropDown:SetZIndex(2)
			end
		else
			onMouseButton1Click()
			setIsFaded(VRService.VREnabled) -- inferred equivalent call

			if not VRService.VREnabled then
				dropDown:SetZIndex(1)
			end
		end

		enabled.Value = visible and not v4

		dropDown.DropDownImage.Visible = visible

		if visible then
			dropDown.DropDownFrame.ImageTransparency = 0
		else
			dropDown.DropDownFrame.ImageTransparency = 0.5
		end
	end

	function dropDown.SetAutoLocalize(_, autoLocalize)
		parent.AutoLocalize = autoLocalize
	end

	function dropDown:UpdateDropDownList(list)
		v3 = list

		if dropDown.Selections then
			for i = 1, #dropDown.Selections do
				dropDown.Selections[i]:Destroy()
			end
		end

		dropDown.Selections = {}
		dropDown.SelectionInfo = {}

		local vrEnabled = VRService.VREnabled
		local font = vrEnabled and Theme.font(Enum.Font.SourceSansBold, "Bold")
			or Theme.font(Enum.Font.SourceSans, "UtilityText")
		local textSize = vrEnabled and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		local v5 = vrEnabled and 70 or 50
		local v6 = v5 + 1
		local total = 0
		local v7 = vrEnabled and 600 or 400

		for k, item in pairs(list) do
			local v8 = Create("Frame")({
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			})

			Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = v8 })

			local v9 = typeof(item) == "table"
			local text, text2

			if v9 then
				text = item.title
				text2 = item.subtitle
				total += 10
			else
				text = item
				text2 = ""
			end

			local v10

			if v9 then
				v10 = Create("TextButton")({
					Name = "Selection" .. tostring(k),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					TextYAlignment = Enum.TextYAlignment.Top,
					Size = UDim2.new(1, -28, 0, v5 + 10),
					Position = UDim2.new(0, 14, 0, (k - 1) * (v6 + 10)),
					TextColor3 = VRService.VREnabled and color7 or color6,
					Font = font,
					TextSize = textSize,
					Text = text,
					ZIndex = 10,
					SelectionImageObject = v8,
					Parent = parent3
				})

				Create("TextLabel")({
					Name = "Subtitle" .. tostring(k),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, -28, 0, v5 * 0.8),
					Position = UDim2.new(0, 14, 0, 15),
					TextColor3 = VRService.VREnabled and color7 or color6,
					Font = font,
					TextSize = textSize * 0.8,
					Text = text2,
					ZIndex = 10,
					Parent = v10
				})
			else
				v10 = Create("TextButton")({
					Name = "Selection" .. tostring(k),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Size = UDim2.new(1, -28, 0, v5),
					Position = UDim2.new(0, 14, 0, (k - 1) * v6),
					TextColor3 = VRService.VREnabled and color7 or color6,
					Font = font,
					TextSize = textSize,
					Text = item,
					ZIndex = 10,
					SelectionImageObject = v8,
					Parent = parent3
				})
			end

			if k == p2 then
				dropDown.CurrentIndex = k
				dropDownFrameTextLabel.Text = text
				v10.TextColor3 = color8
			elseif not p2 and k == 1 then
				v10.TextColor3 = color8
			end

			local function onMouseButton1Click2()
				dropDownFrameTextLabel.Text = v10.Text
				onMouseButton1Click()
				dropDown.CurrentIndex = k
				indexChanged:Fire(k)
			end

			v10.MouseButton1Click:Connect(onMouseButton1Click2)

			v10.MouseEnter:Connect(function()
				if usesSelectedObject() then -- inferred equivalent call
					GuiService.SelectedCoreObject = v10
				end
			end)

			dropDown.Selections[k] = v10
			dropDown.SelectionInfo[v10] = { Clicked = onMouseButton1Click2 }
		end

		GuiService:RemoveSelectionGroup(guid)
		GuiService:AddSelectionTuple(guid, unpack(dropDown.Selections))

		parent3.CanvasSize = UDim2.new(1, -20, 0, #list * v6 + total)

		local function updateDropDownSize()
			if parent3.CanvasSize.Y.Offset < parent.AbsoluteSize.Y - 10 then
				parent2.Size = UDim2.new(0, v7, 0, parent3.CanvasSize.Y.Offset + 25)
			else
				parent2.Size = UDim2.new(0, v7, 0.9, 0)
			end
		end

		parent.Changed:Connect(function(p3)
			if p3 ~= "AbsoluteSize" then
				return
			end

			updateDropDownSize()
		end)

		updateDropDownSize()
	end

	dropDown:UpdateDropDownList(p)

	parent.MouseButton1Click:Connect(onMouseButton1Click)

	object.PoppedMenu:Connect(function(p3)
		if p3 == parent then
			onMouseButton1Click()
		end
	end)

	return dropDown
end

local function CreateSelector(p, p2)
	local v3 = 0

	local selector = {}
	selector.HubRef = nil
	selector.SetSelectionIndex = nil

	if type(p) ~= "table" then
		error("CreateSelector selectionStringTable (first arg) is not a table", 2)
		return selector
	end

	local indexChanged = Instance.new("BindableEvent")
	indexChanged.Name = "IndexChanged"

	local v4 = true

	selector.CurrentIndex = 0

	selector.SelectorFrame = Create("ImageButton")({
		Name = "Selector",
		Image = "",
		AutoButtonColor = false,
		NextSelectionLeft = selector.SelectorFrame,
		NextSelectionRight = selector.SelectorFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, 0, 0, 50),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		ZIndex = 2,
		SelectionImageObject = selectionImageObject
	})

	local parent2 = Create("ImageButton")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		Image = "",
		ZIndex = 3,
		Selectable = false,
		SelectionImageObject = selectionImageObject,
		Parent = selector.SelectorFrame
	})

	local parent3 = Create("ImageButton")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		Image = "",
		ZIndex = 3,
		Selectable = false,
		SelectionImageObject = selectionImageObject,
		Parent = selector.SelectorFrame
	})

	local v5 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
		ImageColor3 = color3,
		ZIndex = 4,
		Parent = parent2
	})

	local v6 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 30),
		Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
		ImageColor3 = color3,
		ZIndex = 4,
		Parent = parent3
	})

	if not isTouchInput() then -- inferred equivalent call
		local function fn(p3)
			p3.ImageColor3 = color3
		end
		local function fn2(p3)
			p3.ImageColor3 = color4
		end
		addHoverState(parent2, v5, fn, fn2)
		addHoverState(parent3, v6, fn, fn2)
	end

	selector.Selections = {}
	local v7 = {}
	local set2 = {}

	local v8 = Create("ImageButton")({
		Name = "AutoSelectButton",
		BackgroundTransparency = 1,
		Image = "",
		Position = UDim2.new(0, parent2.Size.X.Offset, 0, 0),
		Size = UDim2.new(1, parent2.Size.X.Offset * -2, 1, 0),
		Parent = selector.SelectorFrame,
		ZIndex = 2,
		SelectionImageObject = selectionImageObject
	})

	v8.MouseButton1Click:Connect(function()
		if not v4 or #selector.Selections <= 1 then
			return
		end

		local v9 = selector.CurrentIndex + 1
		selector:SetSelectionIndex(#selector.Selections < v9 and 1 or v9)

		if usesSelectedObject() then -- inferred equivalent call
			GuiService.SelectedCoreObject = selector.SelectorFrame
		end
	end)
	set2[v8] = true

	local function setSelection(p3, p4)
		for k, selection in pairs(selector.Selections) do
			local v9 = k == p3
			local udim2 = UDim2.new(0, parent2.Size.X.Offset, 0, 0)
			local udim3 = UDim2.new(0, parent2.Size.X.Offset * p4 * 3, 0, 0)

			if v7[selection] then
				udim3 = UDim2.new(0, parent2.Size.X.Offset * -p4 * 3, 0, 0)
			end

			if udim3.X.Offset < 0 then
				udim3 = UDim2.new(0, udim3.X.Offset + selection.AbsoluteSize.X / 4, 0, 0)
			end

			if v9 then
				v7[selection] = true
				selection.Position = udim3
				selection.Visible = true
				PropertyTweener(selection, "TextTransparency", 1, 0, 0.165, EaseOutQuad)

				if selection:IsDescendantOf(game) then
					selection:TweenPositionInternal(udim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
				else
					selection.Position = udim2
				end

				selector.CurrentIndex = k
				indexChanged:Fire(p3)
			elseif v7[selection] then
				v7[selection] = false
				PropertyTweener(selection, "TextTransparency", 0, 1, 0.165, EaseOutQuad)

				if selection:IsDescendantOf(game) then
					selection:TweenPositionInternal(udim3, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true)
				else
					selection.Position = udim3
				end
			end
		end
	end

	local function stepFunc(input, p3) -- 2 equivalent calls inferred from this helper
		if not v4 then
			return
		end

		if
			input ~= nil
			and input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Gamepad1
			and input.UserInputType ~= Enum.UserInputType.Gamepad2
			and input.UserInputType ~= Enum.UserInputType.Gamepad3
			and input.UserInputType ~= Enum.UserInputType.Gamepad4
			and input.UserInputType ~= Enum.UserInputType.Keyboard
		then
			return
		end

		if usesSelectedObject() then -- inferred equivalent call
			GuiService.SelectedCoreObject = selector.SelectorFrame
		end

		local v9 = p3 + selector.CurrentIndex

		local v10 = selector.CurrentIndex < v9 and 1 or -1

		setSelection(#selector.Selections < v9 and 1 or v9 < 1 and #selector.Selections or v9, v10)
	end

	local selectedCoreObjectChangedConnection = nil
	local function connectToGuiService() -- 2 equivalent calls inferred from this helper
		selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			if #selector.Selections <= 0 then
				return
			end

			if
				GuiService.SelectedCoreObject ~= nil
				and set2[GuiService.SelectedCoreObject]
				and not VRService.VREnabled
			then
				GuiService.SelectedCoreObject = selector.SelectorFrame
			end
		end)
	end

	selector.IndexChanged = indexChanged.Event

	function selector:SetSelectionIndex(p3)
		setSelection(p3, 1)
	end

	function selector.GetSelectedIndex(_)
		return selector.CurrentIndex
	end

	function selector:SetZIndex(zIndex)
		parent2.ZIndex = zIndex
		parent3.ZIndex = zIndex
		v5.ZIndex = zIndex
		v6.ZIndex = zIndex

		for i = 1, #selector.Selections do
			selector.Selections[i].ZIndex = zIndex
		end
	end

	function selector.SetInteractable(_, p3)
		v4 = p3
		selector.SelectorFrame.Selectable = v4

		parent2.Active = v4
		parent3.Active = v4

		parent2.Visible = v4
		parent3.Visible = v4

		if v4 then
			for _, selection in pairs(selector.Selections) do
				selection.TextColor3 = Color3.fromRGB(255, 255, 255)
			end

			v5.ImageColor3 = color3
			v6.ImageColor3 = color3
		else
			for _, selection in pairs(selector.Selections) do
				selection.TextColor3 = Theme.color("NotInteractableSelection", Color3.fromRGB(255, 255, 255))
			end

			v5.ImageColor3 = color5
			v6.ImageColor3 = color5
		end
	end

	function selector:UpdateOptions(items)
		for _, selection in pairs(selector.Selections) do
			selection:Destroy()
		end

		v7 = {}
		selector.Selections = {}

		for k, item in pairs(items) do
			local v9 = Create("TextLabel")({
				Name = "Selection" .. tostring(k),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, parent2.Size.X.Offset * -2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
				TextSize = Theme.textSize(24, "UtilityText"),
				TextWrapped = true,
				Text = item,
				ZIndex = 2,
				Visible = false,
				Parent = selector.SelectorFrame
			})

			if v then
				v9.TextSize = Theme.textSize(36)
			end

			if k == p2 then
				selector.CurrentIndex = k
				v9.Position = UDim2.new(0, parent2.Size.X.Offset, 0, 0)
				v9.Visible = true

				v7[v9] = true
			else
				v7[v9] = false
			end

			selector.Selections[k] = v9
		end

		local visible = #selector.Selections > 1
		parent2.Visible = visible
		parent3.Visible = visible
	end

	local function onVREnabled(p3) -- 1 equivalent call inferred from this helper
		if p3 ~= "VREnabled" then
			return
		end

		local vrEnabled = VRService.VREnabled
		parent2.Selectable = vrEnabled
		parent3.Selectable = vrEnabled
		v8.Selectable = vrEnabled
	end
	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled") -- inferred equivalent call
	parent2.InputBegan:Connect(function(input)
		if shouldSelectorArrowStep(input.UserInputType, computed(false), computed2(false)) then
			if not v4 then
				return
			end

			if usesSelectedObject() then -- inferred equivalent call
				GuiService.SelectedCoreObject = selector.SelectorFrame
			end

			local v9 = -1 + selector.CurrentIndex

			local v10 = selector.CurrentIndex < v9 and 1 or -1

			setSelection(#selector.Selections < v9 and 1 or v9 < 1 and #selector.Selections or v9, v10)
		end
	end)
	parent3.InputBegan:Connect(function(input)
		if shouldSelectorArrowStep(input.UserInputType, computed(false), computed2(false)) then
			if not v4 then
				return
			end

			if usesSelectedObject() then -- inferred equivalent call
				GuiService.SelectedCoreObject = selector.SelectorFrame
			end

			local v9 = 1 + selector.CurrentIndex

			local v10 = selector.CurrentIndex < v9 and 1 or -1

			setSelection(#selector.Selections < v9 and 1 or v9 < 1 and #selector.Selections or v9, v10)
		end
	end)

	local v9 = true
	selector:UpdateOptions(p)

	UserInputService.InputBegan:Connect(function(input)
		if
			not v4
			or not v9
			or input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard
			or GuiService.SelectedCoreObject ~= selector.SelectorFrame
		then
			return
		end

		if
			input.KeyCode == Enum.KeyCode.DPadLeft
			or input.KeyCode == Enum.KeyCode.Left
			or input.KeyCode == Enum.KeyCode.A
		then
			stepFunc(input, -1) -- inferred equivalent call
		elseif
			input.KeyCode == Enum.KeyCode.DPadRight
			or input.KeyCode == Enum.KeyCode.Right
			or input.KeyCode == Enum.KeyCode.D
		then
			stepFunc(input, 1) -- inferred equivalent call
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not v4 then
			return
		end

		if not v9 then
			v3 = 0
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		local selectedCoreObject = GuiService.SelectedCoreObject

		if not (selectedCoreObject and selectedCoreObject:IsDescendantOf(selector.SelectorFrame.Parent) and input.KeyCode == Enum.KeyCode.Thumbstick1) then
			return
		end

		if input.Position.X > 0.8 and input.Delta.X > 0 and v3 ~= 1 then
			v3 = 1
			stepFunc(input, v3)
		elseif input.Position.X < -0.8 and input.Delta.X < 0 and v3 ~= -1 then
			v3 = -1
			stepFunc(input, v3)
		elseif math.abs(input.Position.X) < 0.8 then
			v3 = 0
		end
	end)

	selector.SelectorFrame.AncestryChanged:Connect(function(_, parent)
		v9 = parent

		if v9 then
			connectToGuiService() -- inferred equivalent call
		elseif selectedCoreObjectChangedConnection then
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end)

	local function onResized(_, p3)
		local textSize

		if p3 then
			textSize = Theme.textSize(16)
		else
			textSize = v and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		end

		for _, selection in pairs(selector.Selections) do
			selection.TextSize = textSize
		end
	end
	addOnResizedCallback(selector.SelectorFrame, onResized) -- inferred equivalent call
	connectToGuiService() -- inferred equivalent call
	return selector
end

local function ShowAlert(text, p, object, callback, p2)
	local parent = CoreGui.RobloxGui

	if parent:FindFirstChild("AlertViewFullScreen") then
		return
	end

	local parent2 = nil

	local function onVREnabled(p3)
		if p3 ~= "VREnabled" then
			return
		end

		local settingsMenu = nil

		if VRService.VREnabled then
			if isInExperienceUIVREnabled then
				local VrSpatialUi = require(CorePackages2.Workspace.Packages.VrSpatialUi)
				local panelType = VrSpatialUi.Constants.PanelType
				parent = VrSpatialUi.UIManager.getInstance():getPanelObject(panelType.MoreMenu)
			else
				local VrCommon = require(CorePackages2.Workspace.Packages.VrCommon)
				settingsMenu = VrCommon.Panel3D.Get("SettingsMenu")
				parent = settingsMenu:GetGUI()
			end
		else
			parent = CoreGui.RobloxGui
		end

		if parent2 and parent2.Parent ~= nil then
			parent2.Parent = parent

			if VRService.VREnabled and not isInExperienceUIVREnabled then
				settingsMenu:SetSubpanelDepth(parent2, 0.5)
			end
		end
	end
	local changedConnection = VRService.Changed:Connect(onVREnabled)

	parent2 = Create("ImageLabel")({
		Name = "AlertViewBacking",
		Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 6, 46, 44),
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		Size = UDim2.new(0, 400, 0, 350),
		Position = UDim2.new(0.5, -200, 0.5, -175),
		ZIndex = 9,
		Parent = parent
	})

	onVREnabled("VREnabled")

	if p2 then
		parent2.ImageTransparency = 0
	else
		local v3 = not isInExperienceUIVREnabled and VRService.VREnabled

		if v3 then
			parent2.ImageTransparency = 0
		else
			parent2.Size = UDim2.new(0.8, 0, 0, 350)
			parent2.Position = UDim2.new(0.1, 0, 0.1, 0)
		end
	end

	if CoreGui.RobloxGui.AbsoluteSize.Y <= parent2.Size.Y.Offset then
		parent2.Size = UDim2.new(
			parent2.Size.X.Scale,
			parent2.Size.X.Offset,
			parent2.Size.Y.Scale,
			CoreGui.RobloxGui.AbsoluteSize.Y
		)

		parent2.Position = UDim2.new(
			parent2.Position.X.Scale,
			-parent2.Size.X.Offset / 2,
			0.5,
			-parent2.Size.Y.Offset / 2
		)
	end

	if not p2 then
		Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent2 })

		parent2.BackgroundColor3 = Theme.color("MenuContainer")
		parent2.BackgroundTransparency = Theme.transparency("MenuContainer")
	end

	Create("TextLabel")({
		Name = "AlertViewText",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.95, 0, 0.6, 0),
		Position = UDim2.new(0.025, 0, 0.05, 0),
		Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
		TextSize = Theme.textSize(36),
		Text = text,
		TextWrapped = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 10,
		Parent = parent2
	})

	Create("ImageLabel")({ Image = "", BackgroundTransparency = 1 })

	local guid = HttpService:GenerateGUID(false)

	local function fn(_, p3)
		if
			VRService.VREnabled and (p3 == Enum.UserInputState.Begin or p3 == Enum.UserInputState.Cancel)
			or not parent2
		then
			return
		end

		if VRService.VREnabled and not isInExperienceUIVREnabled then
			local VrCommon = require(CorePackages2.Workspace.Packages.VrCommon)
			VrCommon.Panel3D.Get("SettingsMenu"):SetSubpanelDepth(parent2, 0)
		end

		parent2:Destroy()
		parent2 = nil

		if callback then
			callback()
		end

		ContextActionService:UnbindCoreAction(guid)
		GuiService.SelectedCoreObject = nil

		if object then
			object:ShowBar()
		end

		if changedConnection then
			changedConnection:Disconnect()
		end
	end

	local udim2 = UDim2.new(1, -20, 0, 60)
	local udim3 = UDim2.new(0, 10, 0.65, 0)

	if not p2 then
		udim2 = UDim2.new(0, 200, 0, 50)
		udim3 = UDim2.new(0.5, -100, 0.65, 0)
	end

	local v3, v4 = MakeButton("AlertViewButton", p, udim2, fn)
	v3.Position = udim3
	v3.NextSelectionLeft = v3
	v3.NextSelectionRight = v3
	v3.NextSelectionUp = v3
	v3.NextSelectionDown = v3
	v3.ZIndex = 9
	v4.ZIndex = v3.ZIndex
	v3.Parent = parent2

	if usesSelectedObject() then -- inferred equivalent call
		GuiService.SelectedCoreObject = v3
	end

	GuiService.SelectedCoreObject = v3

	ContextActionService:BindCoreAction(
		guid,
		fn,
		false,
		Enum.KeyCode.Escape,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.ButtonA
	)

	if object and (isInExperienceUIVREnabled or not VRService.VREnabled) then
		object:HideBar()
		object.Pages.CurrentPage:Hide(1, 1)
	end
end

local function CreateNewSlider(p, p2, p3, text, text2)
	local v3 = {}

	local v4 = tonumber(p)
	local value = p2

	local v5 = 0
	local lastTime = nil

	local v6 = true

	local v7 = nil

	local v8 = false
	local v9 = false

	local v10 = nil

	local guid = HttpService:GenerateGUID(false)

	if v4 <= 0 then
		error(
			"CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer",
			2
		)

		return
	end

	local v11 = text or text2

	local valueChanged = Instance.new("BindableEvent")
	valueChanged.Name = "ValueChanged"
	local valueChanged2 = Signal.new()

	local create = Create("ImageButton")
	local slider = {
		Name = "Slider",
		Image = "",
		AutoButtonColor = false,
		NextSelectionLeft = v3.SliderFrame,
		NextSelectionRight = v3.SliderFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, 0, 0, 50),
		AutomaticSize = 0,
		Position = 0,
		AnchorPoint = 0,
		SelectionImageObject = 0,
		ZIndex = 2
	}
	local automaticSize

	if v11 then
		automaticSize = Enum.AutomaticSize.Y
	end

	slider.AutomaticSize = automaticSize
	slider.Position = UDim2.new(1, 0, 0.5, 0)
	slider.AnchorPoint = Vector2.new(1, 0.5)
	slider.SelectionImageObject = selectionImageObject
	v3.SliderFrame = create(slider)
	local parent2

	if v11 then
		parent2 = Create("Frame")({
			Name = "StepsAndButtonsContainer",
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Parent = v3.SliderFrame
		})

		Create("UIListLayout")({
			Name = "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = v3.SliderFrame
		})

		local parent = Create("Frame")({
			Name = "SliderLabels",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = v3.SliderFrame,
			LayoutOrder = 2
		})

		Create("UIPadding")({
			Name = "UIPadding",
			PaddingRight = UDim.new(0, 50),
			PaddingLeft = UDim.new(0, 50),
			Parent = parent
		})

		local function isWideEnough(): boolean -- 4 equivalent calls inferred from this helper
			return RobloxGui.AbsoluteSize.X > 460
		end

		if text then
			v3.LeftLabel = Create("TextLabel")({
				Name = "LeftLabel",
				Text = text,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
				TextSize = Theme.textSize(18, "UtilityRow"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0.25,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = parent,
				Visible = isWideEnough() -- inferred equivalent call
			})
		end

		if text2 then
			v3.RightLabel = Create("TextLabel")({
				Name = "RightLabel",
				Text = text2,
				Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
				TextSize = Theme.textSize(18, "UtilityRow"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0.25,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = parent,
				Visible = isWideEnough() -- inferred equivalent call
			})
		end

		RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(function()
			if v3.LeftLabel then
				v3.LeftLabel.Visible = isWideEnough() -- inferred equivalent call
			end

			if v3.RightLabel then
				v3.RightLabel.Visible = isWideEnough() -- inferred equivalent call
			end
		end)
	end

	local create2 = Create("Frame")
	local stepsContainer = {
		Name = "StepsContainer",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -100, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = 0
	}

	local parent3 = if v11 then parent2 else v3.SliderFrame
	stepsContainer.Parent = parent3
	v3.StepsContainer = create2(stepsContainer)

	local create3 = Create("ImageButton")
	local leftButton = {
		Name = "LeftButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		Image = "",
		ZIndex = 3,
		Selectable = false,
		SelectionImageObject = selectionImageObject,
		Active = true,
		Parent = 0
	}

	local parent4 = if v11 then parent2 else v3.SliderFrame
	leftButton.Parent = parent4
	local parent5 = create3(leftButton)

	local create4 = Create("ImageButton")
	local rightButton = {
		Name = "RightButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, Theme.SelectorArrowButtonWidth, 0, 50),
		Image = "",
		ZIndex = 3,
		Selectable = false,
		SelectionImageObject = selectionImageObject,
		Active = true,
		Parent = 0
	}

	if not v11 then
		parent2 = v3.SliderFrame
	end

	rightButton.Parent = parent2
	local parent6 = create4(rightButton)

	local v12 = Create("ImageLabel")({
		Name = "LeftButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
		ZIndex = 4,
		Parent = parent5,
		ImageColor3 = isTouchInput() and color4 or color3 -- inferred equivalent call
	})

	local v13 = Create("ImageLabel")({
		Name = "RightButton",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 30, 0, 30),
		Image = "rbxasset://textures/ui/Settings/Slider/More.png",
		ZIndex = 4,
		Parent = parent6,
		ImageColor3 = isTouchInput() and color4 or color3 -- inferred equivalent call
	})

	if not isTouchInput() then -- inferred equivalent call
		local function fn(p4)
			p4.ImageColor3 = color3
		end
		local function fn2(p4)
			p4.ImageColor3 = color4
		end

		addHoverState(parent5, v12, fn, fn2)
		addHoverState(parent6, v13, fn, fn2)
	end

	v3.Steps = {}

	local v14 = 1 / v4

	for i = 1, v4 do
		local parent = Create("ImageButton")({
			Name = "Step" .. tostring(i),
			BackgroundColor3 = color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Active = false,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new((i - 1) * v14, 2, 0.5, 0),
			Size = UDim2.new(v14, -4, 0, 24),
			Image = "",
			ZIndex = 3,
			Selectable = false,
			ImageTransparency = 0.36,
			Parent = v3.StepsContainer,
			SelectionImageObject = selectionImageObject
		})

		if value < i then
			parent.BackgroundColor3 = color2
		end

		if i == 1 or i == v4 then
			Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent })

			local create5 = Create("Frame")
			local filler = {
				Name = "Filler",
				BackgroundColor3 = parent.BackgroundColor3,
				Parent = parent,
				Size = UDim2.new(0.25, 0, 1, 0),
				BorderSizePixel = 0,
				Position = 0
			}
			local position

			if i == 1 then
				position = UDim2.new(0.75, 0, 0, 0)
			else
				position = UDim2.new(0, 0, 0, 0)
			end

			filler.Position = position
			create5(filler)
		end

		v3.Steps[#v3.Steps + 1] = parent
	end

	local function hideSelection()
		for i = 1, v4 do
			v3.Steps[i].BackgroundColor3 = color2

			if FFlagUIScaleEngineOptions and v7 then
				v3.Steps[i].BackgroundTransparency = v7[i] and 0 or 0.8
			elseif i == 1 or i == v4 then
				v3.Steps[i].Filler.BackgroundColor3 = color2
			end
		end
	end
	local function showSelection()
		for i = 1, v4 do
			if value < i then
				break
			end

			if FFlagUIScaleEngineOptions and v7 then
				if v7[i] or i == value and not FFlagUIScaleSliderImprovements then
					v3.Steps[i].BackgroundTransparency = 0
					v3.Steps[i].BackgroundColor3 = color
				end
			else
				v3.Steps[i].BackgroundColor3 = color

				if i == 1 or i == v4 then
					v3.Steps[i].Filler.BackgroundColor3 = color
				end
			end
		end
	end

	local function updateEnabledArrows() -- 3 equivalent calls inferred from this helper
		local v15 = false
		local v16 = false

		for k, v17 in v7 do
			if not v17 then
				continue
			end

			v15 = v15 or k < value
			v16 = v16 or value < k
		end

		parent5.Visible = v6 and v15
		parent6.Visible = v6 and v16
	end

	local function setCurrentStep(value2, p4)
		if FFlagUIScaleEngineOptions and v7 and not p4 and value2 ~= value then
			value2 = math.clamp(value2, 1, v4)
			local v15 = if value2 < value then -1 else 1

			while not v7[value2] do
				value2 += v15

				if value2 < 1 or v4 < value2 then
					return
				end
			end
		end

		if not p3 then
			p3 = 0
		end

		parent5.Visible = true
		parent6.Visible = true

		if value2 <= p3 then
			value2 = p3
			parent5.Visible = false
		end

		if v4 <= value2 then
			value2 = v4
			parent6.Visible = false
		end

		if value == value2 then
			if FFlagUIScaleEngineOptions and v7 then
				updateEnabledArrows() -- inferred equivalent call
			end
		else
			value = value2

			if FFlagUIScaleEngineOptions and v7 then
				updateEnabledArrows() -- inferred equivalent call
			end

			hideSelection()
			showSelection()

			lastTime = tick()

			if FFlagUIScaleSliderImprovements and v8 then
				v9 = true
			elseif valueChanged2 then
				valueChanged2:fire(value)
			else
				valueChanged:Fire(value)
			end
		end
	end

	local function endDeferredValueChanged() -- 3 equivalent calls inferred from this helper
		v8 = false
		v10 = nil

		if not v9 then
			return
		end

		v9 = false

		if valueChanged2 then
			valueChanged2:fire(value)
		else
			valueChanged:Fire(value)
		end
	end

	local function isActivateEvent(p4): boolean -- 3 equivalent calls inferred from this helper
		if not p4 then
			return false
		end

		if p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.Touch then
			return true
		elseif p4.UserInputType == Enum.UserInputType.Gamepad1 then
			return p4.KeyCode == Enum.KeyCode.ButtonA
		else
			return false
		end
	end

	local function mouseDownFunc(input, p4, p5)
		if
			not v6
			or FFlagUIScaleEngineOptions and v7 and not (p5 or v7[p4])
			or input == nil
			or not isActivateEvent(input) -- inferred equivalent call
		then
			return
		end

		if usesSelectedObject() and not VRService.VREnabled then -- inferred equivalent call
			GuiService.SelectedCoreObject = v3.SliderFrame
		end

		if FFlagUIScaleSliderImprovements and input ~= v10 then
			endDeferredValueChanged() -- inferred equivalent call
			local v15 = FFlagUIScaleEngineOptions

			if v15 then
				if v7 == nil then
					v15 = false
				else
					v15 = not (p5 or VRService.VREnabled)
				end
			end

			v8 = v15

			if not v8 then
				input = nil
			end

			v10 = input
		end

		if VRService.VREnabled then
			v5 = 0
		elseif p5 then
			v5 = p4 - value
		else
			v5 = 0

			local inputEndedConnection = nil

			local inputChangedConnection = UserInputService.InputChanged:Connect(function(input2)
				if input2.UserInputType ~= Enum.UserInputType.MouseMovement then
					return
				end

				local x = input2.Position.X

				for i = 1, v4 do
					local x2 = v3.Steps[i].AbsolutePosition.X
					local x3 = v3.Steps[i].AbsoluteSize.X

					if x2 <= x and x <= x2 + x3 then
						setCurrentStep(i)
						break
					end

					if i == 1 and x < x2 then
						setCurrentStep(0)
						break
					end

					if i == v4 and x2 <= x then
						setCurrentStep(i)
						break
					end
				end
			end)
			inputEndedConnection = UserInputService.InputEnded:Connect(function(input2)
				if not isActivateEvent(input2) then -- inferred equivalent call
					return
				end

				v5 = 0
				inputEndedConnection:Disconnect()
				inputChangedConnection:Disconnect()

				if FFlagUIScaleSliderImprovements and v8 then
					endDeferredValueChanged() -- inferred equivalent call
				end
			end)
		end

		setCurrentStep(p4)
	end

	local function mouseUpFunc(input) -- 4 equivalent calls inferred from this helper
		if not (v6 and isActivateEvent(input)) then -- inferred equivalent call
			return
		end

		v5 = 0
	end

	v3.ValueChanged = valueChanged.Event

	if valueChanged2 then
		v3.ValueChanged = valueChanged2
	end

	function v3.SetValue(_, p4)
		if FFlagUIScaleEngineOptions then
			setCurrentStep(p4, v7 ~= nil)
		else
			setCurrentStep(p4)
		end
	end

	function v3.GetValue(_)
		return value
	end

	function v3.SetEnabledSteps(_, p4)
		if not FFlagUIScaleEngineOptions then
			return
		end

		v7 = p4

		for k, step in v3.Steps do
			local filler = step:FindFirstChild("Filler")

			if filler then
				local uiCorner = step:FindFirstChildOfClass("UICorner")
				local topLeftRadius

				if k == 1 then
					topLeftRadius = Theme.DefaultCornerRadius
				else
					topLeftRadius = UDim.new(0, 0)
				end

				uiCorner.TopLeftRadius = topLeftRadius
				uiCorner.BottomLeftRadius = uiCorner.TopLeftRadius
				local topRightRadius

				if k == v4 then
					topRightRadius = Theme.DefaultCornerRadius
				else
					topRightRadius = UDim.new(0, 0)
				end

				uiCorner.TopRightRadius = topRightRadius
				uiCorner.BottomRightRadius = uiCorner.TopRightRadius
				filler:Destroy()
			end

			local v15 = v6 and p4[k]

			step.BackgroundTransparency = (p4[k] or k == value) and 0 or 0.8
			step.Active = VRService.VREnabled and v15
			step.Selectable = VRService.VREnabled and v15
		end

		hideSelection()
		showSelection()
		updateEnabledArrows() -- inferred equivalent call
	end

	function v3.SetInteractable(_, selectable)
		v5 = 0
		v6 = selectable
		v3.SliderFrame.Selectable = selectable

		if v6 then
			showSelection()
		else
			hideSelection()
		end
	end

	function v3:SetZIndex(zIndex)
		parent5.ZIndex = zIndex
		parent6.ZIndex = zIndex
		v12.ZIndex = zIndex
		v13.ZIndex = zIndex

		for i = 1, #v3.Steps do
			v3.Steps[i].ZIndex = zIndex
		end
	end

	function v3.SetMinStep(_, p4)
		if p4 >= 0 and p4 <= v4 then
			p3 = p4
		end

		if value <= p3 then
			value = p3
			parent5.Visible = false
		end

		if v4 <= value then
			value = v4
			parent6.Visible = false
		end
	end

	parent5.InputBegan:Connect(function(input)
		mouseDownFunc(input, value - 1, true)
	end)
	parent5.InputEnded:Connect(function(input)
		mouseUpFunc(input) -- inferred equivalent call
	end)
	parent6.InputBegan:Connect(function(input)
		mouseDownFunc(input, value + 1, true)
	end)
	parent6.InputEnded:Connect(function(input)
		mouseUpFunc(input) -- inferred equivalent call
	end)

	local function onVREnabled(p4)
		if p4 ~= "VREnabled" then
			return
		end

		if VRService.VREnabled then
			parent5.Selectable = v6
			parent6.Selectable = v6
			v3.SliderFrame.Selectable = v6

			for i = 1, v4 do
				if FFlagUIScaleEngineOptions and v7 then
					local v15 = v6 and v7[i]
					v3.Steps[i].Selectable = v15
					v3.Steps[i].Active = v15
				else
					v3.Steps[i].Selectable = v6
					v3.Steps[i].Active = v6
				end
			end
		else
			parent5.Selectable = false
			parent6.Selectable = false
			v3.SliderFrame.Selectable = v6

			for i = 1, v4 do
				v3.Steps[i].Selectable = false
				v3.Steps[i].Active = false
			end
		end
	end
	VRService.Changed:Connect(onVREnabled)
	onVREnabled("VREnabled")

	for i = 1, v4 do
		v3.Steps[i].InputBegan:Connect(function(input)
			mouseDownFunc(input, i)
		end)
		v3.Steps[i].InputEnded:Connect(function(input)
			mouseUpFunc(input) -- inferred equivalent call
		end)
	end

	v3.SliderFrame.InputBegan:Connect(function(input)
		if VRService.VREnabled then
			local selectedCoreObject = GuiService.SelectedCoreObject

			if not (selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent)) then
				return
			end
		end

		mouseDownFunc(input, value)
	end)
	v3.SliderFrame.InputEnded:Connect(function(input)
		if VRService.VREnabled then
			local selectedCoreObject = GuiService.SelectedCoreObject

			if not (selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent)) then
				return
			end
		end

		mouseUpFunc(input) -- inferred equivalent call
	end)

	local function fn()
		if lastTime == nil then
			return
		end

		if tick() - lastTime >= 0.2 then
			setCurrentStep(value + v5)
		end
	end

	local v15 = true

	local v16 = {
		[Enum.KeyCode.Thumbstick1] = true,
		[Enum.KeyCode.DPadLeft] = -1,
		[Enum.KeyCode.DPadRight] = 1,
		[Enum.KeyCode.Left] = -1,
		[Enum.KeyCode.Right] = 1,
		[Enum.KeyCode.A] = -1,
		[Enum.KeyCode.D] = 1,
		[Enum.KeyCode.ButtonA] = true
	}

	UserInputService.InputBegan:Connect(function(input)
		if
			not v6
			or not v15
			or input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard
		then
			return
		end

		local selectedCoreObject = GuiService.SelectedCoreObject

		if not (selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent)) then
			return
		end

		if FFlagUIScaleSliderImprovements and v8 and v16[input.KeyCode] then
			endDeferredValueChanged() -- inferred equivalent call
		end

		if v16[input.KeyCode] == -1 then
			v5 = -1
			setCurrentStep(value - 1)
		elseif v16[input.KeyCode] == 1 then
			v5 = 1
			setCurrentStep(value + 1)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if
			not v6
			or input.UserInputType ~= Enum.UserInputType.Gamepad1 and input.UserInputType ~= Enum.UserInputType.Keyboard
		then
			return
		end

		local selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent) and v16[input.KeyCode] then
			v5 = 0
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not v6 then
			v5 = 0
			return
		end

		if not v15 then
			v5 = 0
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		local selectedCoreObject = GuiService.SelectedCoreObject

		if not (selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent) and input.KeyCode == Enum.KeyCode.Thumbstick1) then
			return
		end

		if input.Position.X > 0.8 and input.Delta.X > 0 and v5 ~= 1 then
			v5 = 1
			setCurrentStep(value + 1)
		elseif input.Position.X < -0.8 and input.Delta.X < 0 and v5 ~= -1 then
			v5 = -1
			setCurrentStep(value - 1)
		elseif math.abs(input.Position.X) < 0.8 then
			v5 = 0
		end
	end)

	local flag = false
	GuiService.Changed:Connect(function(p4)
		if p4 ~= "SelectedCoreObject" then
			return
		end

		local selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject and selectedCoreObject:IsDescendantOf(v3.SliderFrame.Parent) then
			if not flag then
				flag = true
				lastTime = tick()
				RunService:BindToRenderStep(guid, Enum.RenderPriority.Input.Value + 1, fn)
			end
		elseif flag then
			flag = false
			RunService:UnbindFromRenderStep(guid)
		end
	end)

	v3.SliderFrame.AncestryChanged:Connect(function(_, parent)
		v15 = parent
	end)

	setCurrentStep(value)

	return v3
end

local v3 = v and 90 or 50
local v4 = {}
local function AddNewRow(object, text2, p, p2, p3, p4, text3, text4, text5, interactable)
	local v5 = p ~= "TextBox"
	local v6 = not v4[object] and 0 or v4[object]

	local create = Create("ImageButton")
	local v7 = {
		Name = text2 .. "Frame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 18, 18),
		ImageTransparency = 1,
		Active = false,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, v3),
		AutomaticSize = 0,
		Position = 0,
		ZIndex = 2,
		Selectable = false,
		SelectionImageObject = 0,
		Parent = 0
	}
	local automaticSize

	if text3 or text4 or text5 then
		automaticSize = Enum.AutomaticSize.Y
	end

	v7.AutomaticSize = automaticSize

	v7.Position = UDim2.new(0, 0, 0, v6)

	v7.SelectionImageObject = selectionImageObject
	v7.Parent = object.Page
	local parent = create(v7)

	parent.BackgroundColor3 = Theme.color("RowFrameBackground")
	parent.ImageColor3 = parent.BackgroundColor3
	Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent })

	if parent and p4 then
		parent.Position = UDim2.new(
			parent.Position.X.Scale,
			parent.Position.X.Offset,
			parent.Position.Y.Scale,
			parent.Position.Y.Offset + p4
		)
	end

	local parent2

	if text3 then
		local parent3 = Create("Frame")({
			Name = text2 .. "RowLabelAndDescriptionFrame",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(0.4, -20, 0, 50),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = parent
		})

		parent2 = Create("TextLabel")({
			Name = text2 .. "Label",
			Text = text2,
			Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
			TextSize = Theme.textSize(16, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			ZIndex = 2,
			Parent = parent3,
			LayoutOrder = 1
		})

		Create("TextLabel")({
			Name = text2 .. "Description",
			Text = text3,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityRow"),
			TextSize = Theme.textSize(18, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = 0.25,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2,
			Parent = parent3,
			LayoutOrder = 2
		})

		Create("UIListLayout")({
			Name = text2 .. "UIListLayout",
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = parent3
		})

		Create("UIPadding")({
			Name = text2 .. "UIListLayout",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = parent3
		})
	else
		parent2 = Create("TextLabel")({
			Name = text2 .. "Label",
			Text = text2,
			Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
			TextSize = Theme.textSize(16, "UtilityRow"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.4, -20, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			ZIndex = 2,
			Parent = parent
		})

		Create("UIPadding")({
			Name = text2 .. "UIPadding",
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			Parent = parent2
		})
	end

	if not v5 then
		parent2.Text = ""
	end

	local function onResized(_, p5) -- 4 equivalent calls inferred from this helper
		if p5 then
			parent2.TextSize = Theme.textSize(16, "UtilityRow")
		else
			parent2.TextSize = v and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		end
	end

	getViewportSize() -- inferred equivalent call

	if isPortrait() then -- inferred equivalent call
		onResized(nil, true) -- inferred equivalent call
	else
		onResized(nil, false) -- inferred equivalent call
	end

	v2[parent] = onResized
	getViewportSize() -- inferred equivalent call

	if isPortrait() then -- inferred equivalent call
		onResized(nil, true) -- inferred equivalent call
	else
		onResized(nil, false) -- inferred equivalent call
	end

	local selection = nil
	local v8 = nil

	if p == "Slider" then
		v8 = CreateNewSlider(p2, p3, nil, text4, text5)
		v8.SliderFrame.Parent = parent
		selection = v8.SliderFrame
	elseif p == "Selector" then
		v8 = CreateSelector(p2, p3)
		v8.SelectorFrame.Parent = parent
		selection = v8.SelectorFrame
	elseif p == "DropDown" then
		v8 = CreateDropDown(p2, p3, object.HubRef)
		v8.DropDownFrame.Parent = parent
		selection = v8.DropDownFrame
	elseif p == "TextBox" then
		local selectionImageObject2 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		v8 = {}
		v8.HubRef = nil

		local selectedCoreObject = Create("TextBox")({
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.6, 0, 1, 0),
			Position = UDim2.new(1, 0, 0.5, 0),
			Text = text2,
			TextColor3 = Color3.fromRGB(49, 49, 49),
			BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5),
			BorderSizePixel = 0,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
			TextSize = Theme.textSize(24, "UtilityText"),
			ZIndex = 2,
			SelectionImageObject = selectionImageObject2,
			ClearTextOnFocus = false,
			Interactable = interactable,
			Parent = parent
		})

		selection = selectedCoreObject

		selectedCoreObject.Focused:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				GuiService.SelectedCoreObject = selectedCoreObject
			end

			if selectedCoreObject.Text == text2 then
				selectedCoreObject.Text = ""
			end
		end)

		if p4 then
			selectedCoreObject.Position = UDim2.new(
				selectedCoreObject.Position.X.Scale,
				selectedCoreObject.Position.X.Offset,
				selectedCoreObject.Position.Y.Scale,
				selectedCoreObject.Position.Y.Offset + p4
			)
		end

		selection.SelectionGained:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				selectedCoreObject.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.1)

				if v8.HubRef then
					v8.HubRef:ScrollToFrame(selection)
				end
			end
		end)
		selection.SelectionLost:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				selectedCoreObject.BackgroundTransparency = Theme.transparency("ControlInputBackground", 0.5)
			end
		end)

		local function onMouseEnter()
			local dropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if dropDownFullscreenFrame and dropDownFullscreenFrame.Visible then
				return
			end

			local selectedCoreObject2 = selection

			if
				selectedCoreObject2
				and selectedCoreObject2.Visible
				and selectedCoreObject2.ZIndex > 1
				and usesSelectedObject() -- inferred equivalent call
				and object.Active
			then
				GuiService.SelectedCoreObject = selectedCoreObject2
			end
		end
		local function processInput(p5)
			if
				p5.UserInputState == Enum.UserInputState.Begin
				and p5.KeyCode == Enum.KeyCode.Return
				and GuiService.SelectedCoreObject == selection
			then
				selectedCoreObject:CaptureFocus()
			end
		end
		selectedCoreObject.MouseEnter:Connect(onMouseEnter)

		UserInputService.InputBegan:Connect(processInput)
	elseif p == "TextEntry" then
		local selectionImageObject2 = Create("ImageLabel")({
			Image = "",
			BackgroundTransparency = 1
		})

		v8 = {}
		v8.HubRef = nil

		local selectedCoreObject = Create("TextBox")({
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.4, -10, 0, 40),
			Position = UDim2.new(1, 0, 0.5, 0),
			Text = text2,
			TextColor3 = Color3.fromRGB(178, 178, 178),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = false,
			Font = Theme.font(Enum.Font.SourceSans, "UtilityText"),
			TextSize = Theme.textSize(24, "UtilityText"),
			ZIndex = 2,
			SelectionImageObject = selectionImageObject2,
			ClearTextOnFocus = false,
			Parent = parent
		})

		selection = selectedCoreObject

		selectedCoreObject.Focused:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				GuiService.SelectedCoreObject = selectedCoreObject
			end

			if selectedCoreObject.Text == text2 then
				selectedCoreObject.Text = ""
			end
		end)

		if p4 then
			selectedCoreObject.Position = UDim2.new(
				selectedCoreObject.Position.X.Scale,
				selectedCoreObject.Position.X.Offset,
				selectedCoreObject.Position.Y.Scale,
				selectedCoreObject.Position.Y.Offset + p4
			)
		end

		selection.SelectionGained:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				selectedCoreObject.BackgroundTransparency = 0.8

				if v8.HubRef then
					v8.HubRef:ScrollToFrame(selection)
				end
			end
		end)
		selection.SelectionLost:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				selectedCoreObject.BackgroundTransparency = 1
			end
		end)

		local function onMouseEnter()
			local dropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if dropDownFullscreenFrame and dropDownFullscreenFrame.Visible then
				return
			end

			local selectedCoreObject2 = selection

			if
				selectedCoreObject2
				and selectedCoreObject2.Visible
				and selectedCoreObject2.ZIndex > 1
				and usesSelectedObject() -- inferred equivalent call
				and object.Active
			then
				GuiService.SelectedCoreObject = selectedCoreObject2
			end
		end
		local function processInput(p5)
			if
				p5.UserInputState == Enum.UserInputState.Begin
				and p5.KeyCode == Enum.KeyCode.Return
				and GuiService.SelectedCoreObject == selection
			then
				selectedCoreObject:CaptureFocus()
			end
		end
		parent.MouseEnter:Connect(onMouseEnter)

		function v8:SetZIndex(zIndex)
			selectedCoreObject.ZIndex = zIndex
		end

		function v8.SetInteractable(_, selectable)
			selectedCoreObject.Selectable = selectable

			if selectable then
				selectedCoreObject.TextColor3 = Color3.fromRGB(178, 178, 178)
				selectedCoreObject.ZIndex = 2
			else
				selectedCoreObject.TextColor3 = Color3.fromRGB(49, 49, 49)
				selectedCoreObject.ZIndex = 1
			end
		end

		function v8.SetValue(_, text)
			selectedCoreObject.Text = text
		end

		local valueChanged = Instance.new("BindableEvent")
		valueChanged.Name = "ValueChanged"

		selectedCoreObject.FocusLost:Connect(function()
			valueChanged:Fire(selectedCoreObject.Text)
		end)

		v8.ValueChanged = valueChanged.Event

		UserInputService.InputBegan:Connect(processInput)
	end

	v8.Name = text2 .. "ValueChanger"

	local setAutoLocalize = v8.SetAutoLocalize
	function v8.SetAutoLocalize(p5, autoLocalize)
		parent.AutoLocalize = autoLocalize

		if setAutoLocalize then
			setAutoLocalize(p5, autoLocalize)
		end
	end

	local v9 = v6 + v3

	if p4 then
		v9 += p4
	end

	v4[object] = v9

	if v5 then
		local function onMouseEnter()
			local dropDownFullscreenFrame = CoreGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

			if dropDownFullscreenFrame and dropDownFullscreenFrame.Visible then
				return
			end

			local sliderFrame = v8.SliderFrame or v8.SliderFrame or v8.DropDownFrame or v8.SelectorFrame

			if
				sliderFrame
				and sliderFrame.Visible
				and sliderFrame.ZIndex > 1
				and usesSelectedObject() -- inferred equivalent call
				and object.Active
			then
				GuiService.SelectedCoreObject = sliderFrame
			end
		end
		parent.MouseEnter:Connect(onMouseEnter)

		local function onVREnabled(p5)
			if p5 == "VREnabled" then
				if VRService.VREnabled then
					parent.Selectable = true
					parent.Active = true
					selection.Active = true
					GuiService.Changed:Connect(function(p6)
						if p6 == "SelectedCoreObject" then
							local selectedCoreObject = GuiService.SelectedCoreObject

							if
								selectedCoreObject
								and (selectedCoreObject == parent or selectedCoreObject:IsDescendantOf(parent))
							then
								parent.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
								parent.BackgroundTransparency = 1
							else
								parent.ImageTransparency = 1
								parent.BackgroundTransparency = 1
							end
						end
					end)
				else
					parent.Selectable = false
					parent.Active = false
				end
			end
		end
		VRService.Changed:Connect(onVREnabled)

		if VRService.VREnabled then
			parent.Selectable = true
			parent.Active = true
			selection.Active = true
			GuiService.Changed:Connect(function(p5)
				if p5 == "SelectedCoreObject" then
					local selectedCoreObject = GuiService.SelectedCoreObject

					if
						selectedCoreObject
						and (selectedCoreObject == parent or selectedCoreObject:IsDescendantOf(parent))
					then
						parent.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
						parent.BackgroundTransparency = 1
					else
						parent.ImageTransparency = 1
						parent.BackgroundTransparency = 1
					end
				end
			end)
		else
			parent.Selectable = false
			parent.Active = false
		end

		selection.SelectionGained:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				if VRService.VREnabled then
					parent.ImageTransparency = 0.5
					parent.BackgroundTransparency = 1
				else
					parent.ImageTransparency = 1
					parent.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
				end

				if v8.HubRef then
					v8.HubRef:ScrollToFrame(parent)
				end
			end
		end)
		selection.SelectionLost:Connect(function()
			if usesSelectedObject() then -- inferred equivalent call
				parent.ImageTransparency = 1
				parent.BackgroundTransparency = 1
			end
		end)
	end

	object:AddRow(parent, parent2, v8, p4, false)

	v8.Selection = selection

	return parent, parent2, v8
end

local function AddNewRowObject(object, text, state, p, p2)
	local v5 = not v4[object] and 0 or v4[object]

	local v6 = Create("ImageButton")({
		Name = text .. "Frame",
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10),
		ImageTransparency = 1,
		Active = false,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, v3),
		Position = UDim2.new(0, 0, 0, v5),
		ZIndex = 2,
		Selectable = false,
		SelectionImageObject = selectionImageObject,
		Parent = object.Page
	})

	v6.BackgroundColor3 = Theme.color("RowFrameBackground")
	v6.ImageColor3 = v6.BackgroundColor3
	v6.SelectionGained:Connect(function()
		v6.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
	end)
	v6.SelectionLost:Connect(function()
		v6.BackgroundTransparency = 1
	end)

	Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = v6 })

	local parent = Create("TextLabel")({
		Name = text .. "Label",
		Text = text,
		Font = Theme.font(Enum.Font.SourceSansBold, "UtilityRow"),
		TextSize = Theme.textSize(16, "UtilityRow"),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(0.4, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		ZIndex = 2,
		Parent = v6
	})

	Create("UIPadding")({
		Name = text .. "UIPadding",
		PaddingBottom = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		Parent = parent
	})

	local function onResized(_, p3)
		if p2 then
			UDim2.new(0, 200, 1, 0)
		end

		if p3 then
			parent.TextSize = Theme.textSize(16, "UtilityRow")
		else
			parent.TextSize = v and Theme.textSize(36) or Theme.textSize(24, "UtilityText")
		end
	end

	addOnResizedCallback(v6, onResized) -- inferred equivalent call

	if p then
		v6.Position = UDim2.new(
			v6.Position.X.Scale,
			v6.Position.X.Offset,
			v6.Position.Y.Scale,
			v6.Position.Y.Offset + p
		)
	end

	local v7 = v5 + v3

	if p then
		v7 += p
	end

	v4[object] = v7

	local function onMouseEnter()
		if v6.Visible then
			GuiService.SelectedCoreObject = v6
		end
	end
	v6.MouseEnter:Connect(onMouseEnter)

	state.SelectionImageObject = selectionImageObject

	state.SelectionGained:Connect(function()
		if VRService.VREnabled then
			v6.ImageTransparency = Theme.transparency("RowFrameBackground", 0.5)
			v6.BackgroundTransparency = 1
		else
			v6.ImageTransparency = 1
			v6.BackgroundTransparency = Theme.transparency("RowFrameBackground", 0.5)
		end
	end)
	state.SelectionLost:Connect(function()
		v6.ImageTransparency = 1
		v6.BackgroundTransparency = 1
	end)

	state.Parent = v6

	object:AddRow(v6, parent, state, p, true)
	return v6
end

local Utility = {}

function Utility.GetEaseLinear(_)
	return Linear
end

function Utility.GetEaseOutQuad(_)
	return EaseOutQuad
end

function Utility.GetEaseInOutQuad(_)
	return EaseInOutQuad
end

function Utility.CreateNewSlider(_, p, p2, p3, text, text2)
	return CreateNewSlider(p, p2, p3, text, text2)
end

function Utility.CreateNewSelector(_, p, p2)
	return CreateSelector(p, p2)
end

function Utility.CreateNewDropDown(_, p, p2)
	return CreateDropDown(p, p2, nil)
end

function Utility.AddNewRow(_, p, text, p2, p3, p4, p5, text2, text3, text4, interactable)
	return AddNewRow(p, text, p2, p3, p4, p5, text2, text3, text4, interactable)
end

function Utility.AddNewRowObject(_, p, text, p2, p3, p4)
	return AddNewRowObject(p, text, p2, p3, p4)
end

function Utility.ShowAlert(_, text, p, p2, p3, p4)
	ShowAlert(text, p, p2, p3, p4)
end

function Utility.IsSmallTouchScreen(_)
	return isSmallTouchScreen() -- inferred equivalent call
end

function Utility:IsPortrait()
	return isPortrait() -- inferred equivalent call
end

if FFlagRefactorMenuConfirmationButtons then
	local function isUsingGamepad() -- 1 equivalent call inferred from this helper
		return set[UserInputService:GetLastInputType()] or false
	end

	function Utility.IsUsingGamepad(_)
		return isUsingGamepad() -- inferred equivalent call
	end
end

function Utility.MakeStyledButton(_, p, text, p2, p3, p4, p5)
	return MakeButton(p, text, p2, p3, p4, p5)
end

function Utility.MakeStyledImageButton(_, p, p2, size, size2, p3, p4, p5, p6)
	return MakeImageButton(p, p2, size, size2, p3, p4, p5, p6)
end

function Utility.AddButtonRow(_, p, p2, text, p3, p4, p5)
	return AddButtonRow(p, p2, text, p3, p4, p5)
end

function Utility.MakeFocusState(_, p, p2)
	return MakeRoundedRectFocusState(p, p2)
end

function Utility.CreateSignal(_)
	return CreateSignal()
end

function Utility.UsesSelectedObject(_)
	return usesSelectedObject() -- inferred equivalent call
end

function Utility.TweenProperty(_, p, p2, p3, p4, p5, p6, p7)
	return PropertyTweener(p, p2, p3, p4, p5, p6, p7)
end

function Utility.OnResized(_, p, p2)
	return addOnResizedCallback(p, p2)
end

function Utility.FireOnResized(_)
	local viewportSize = getViewportSize() -- inferred equivalent call
	local isPortrait2 = Utility:IsPortrait()

	for _, v5 in pairs(v2) do
		v5(viewportSize, isPortrait2)
	end
end

function Utility.Lerp(_, p, p2, p3)
	return (1 - p) * p2 + p * p3
end

function Utility.Round(_, p)
	return p % 1 >= 0.5 and math.ceil(p) or math.floor(p)
end

function Utility.IsExperienceOlderThanOneWeek(_, p): boolean
	if p ~= nil and p.Created ~= nil then
		local unixTimestampMillis = DateTime.fromIsoDate(p.Created).UnixTimestampMillis

		if Workspace:GetServerTimeNow() * 1000 - unixTimestampMillis > 604800000 then
			return true
		end
	end

	return false
end

return Utility

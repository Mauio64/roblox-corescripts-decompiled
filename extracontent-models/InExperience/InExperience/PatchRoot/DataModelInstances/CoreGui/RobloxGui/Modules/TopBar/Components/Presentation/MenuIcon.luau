local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local GamepadService = game:GetService("GamepadService")
local ContextActionService = game:GetService("ContextActionService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagReduceTopBarInsetsWhileHidden = SharedFlags.FFlagReduceTopBarInsetsWhileHidden
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant

require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome2.FocusUtils
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome3.Enabled

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local Service

if Enabled() and (FFlagEnableConsoleExpControls or isInExperienceUIVREnabled) then
	Service = require(Chrome.Service)
else
	Service = nil
end

local Constants

if Enabled() and FFlagEnableConsoleExpControls then
	Constants = require(Chrome.ChromeShared.Unibar.Constants)
else
	Constants = nil
end

require(RobloxGui.Modules.TenFootInterface)
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
require(RobloxGui.Modules.PlayerList.PlayerListManager)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local BadgeOver12 = require(script.Parent.BadgeOver12)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon.Stores
local Signals = require(CorePackages.Packages.Signals)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local createEffect = Signals.createEffect

local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub

local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local CoreGuiCommon2 = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon2.Flags.FFlagTopBarSignalizeKeepOutAreas
local defineFastFlag = game:DefineFastFlag("EnableReferralRewardTooltip", false)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon2.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateDisplayOptionsRodux = require(script.Parent.Parent.Parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)

local parent = script.Parent.Parent
local actions = parent.Parent.Actions
local Constants2 = require(parent.Parent.Constants)
local SetGamepadMenuOpen = require(actions.SetGamepadMenuOpen)
local SetKeepOutArea = require(actions.SetKeepOutArea)
local menuIconHoveredSignal = require(script.Parent.menuIconHoveredSignal)
local GamepadConnector

if FFlagEnableConsoleExpControls and not Enabled() then
	GamepadConnector = nil
else
	GamepadConnector = require(script.Parent.Parent.GamepadConnector)
end

local InGameMenuInit

if isNewInGameMenuEnabled() then
	InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
else
	InGameMenuInit = nil
end

local isNewTiltIconEnabled = require(RobloxGui.Modules.isNewTiltIconEnabled)

local tooltipCallout = nil
local isSpatial = nil
local panel3DInSpatialUI = nil
local panelType = nil
local SPATIAL_TOOLTIP_SPACING = nil
local uiManager = nil
local fn

if isInExperienceUIVREnabled then
	local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
	isSpatial = AppCommonLib.isSpatial
	tooltipCallout = UIBlox.App.Dialog.TooltipCallout
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
	panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	panelType = VrSpatialUi.Constants.PanelType
	SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING
	fn = function(): boolean
		if isInExperienceUIVREnabled and isSpatial() then
			local v = Service:showTopBar()
			local bottomBarInteractionOnAnimationSupported = uiManager.getInstance():isBottomBarInteractionOnAnimationSupported()
			return not (v or bottomBarInteractionOnAnimationSupported)
		end

		return false
	end
else
	fn = nil
end

local IconButton = require(script.Parent.IconButton)

local withReferralRewardTooltipInfo = require(script.Parent.withReferralRewardTooltipInfo)

local extended = Roact.PureComponent:extend("MenuIcon")

local enabled = Enabled()
local v = enabled and 0.65 or 0.4
local hotkeyCodes = { Enum.KeyCode.Escape }

local strictInterface = t.strictInterface
local v2 = {
	layoutOrder = t.integer,
	setGamepadMenuOpen = 0,
	iconScale = 0,
	onAreaChanged = 0,
	showBadgeOver12 = 0,
	menuIconRef = 0,
	unibarMenuRef = 0,
	referralRewardTooltipText = 0
}
local setGamepadMenuOpen

if not FFlagTopBarDeprecateDisplayOptionsRodux then
	setGamepadMenuOpen = t.callback
end

v2.setGamepadMenuOpen = setGamepadMenuOpen
local iconScale

if not FFlagTopBarSignalizeMenuOpen then
	iconScale = t.optional(t.number)
end

v2.iconScale = iconScale
v2.onAreaChanged = t.optional(t.callback)
v2.showBadgeOver12 = t.optional(t.boolean)
local menuIconRef

if Enabled() and FFlagEnableConsoleExpControls then
	menuIconRef = t.optional(t.any)
end

v2.menuIconRef = menuIconRef
local unibarMenuRef

if Enabled() and FFlagEnableConsoleExpControls then
	unibarMenuRef = t.optional(t.any)
end

v2.unibarMenuRef = unibarMenuRef
v2.referralRewardTooltipText = t.optional(t.string)
extended.validateProps = strictInterface(v2)

function extended:init()
	self:setState({
		vrShowMenuIcon = false,
		showTooltip = false,
		isHovering = false,
		clickLatched = not enabled and nil,
		enableFlashingDot = false
	})

	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)

	if FFlagTopBarSignalizeMenuOpen then
		SettingsShowSignal:connect(function(tiltMenuOpen)
			self:setState({ tiltMenuOpen = tiltMenuOpen })
		end)
	end

	if not Enabled() then
		task.spawn(function()
			self:setState({ enableFlashingDot = true })
		end)
	end

	function self.menuIconActivated()
		local isHovering

		if not enabled then
			isHovering = false
		end

		self:setState({
			showTooltip = false,
			isHovering = isHovering,
			clickLatched = enabled and true or nil
		})

		if isInExperienceUIVREnabled then
			if fn() then
				return
			end
		else
			if VRService.VREnabled and (VRHub.ShowTopBar or GamepadService.GamepadCursorEnabled) then
				InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
				return
			end

			if isNewInGameMenuEnabled() then
				InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)
				return
			end
		end

		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if FFlagAddUILessMode then
			SettingsHub:ToggleVisibility(nil, InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
		else
			SettingsHub:ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
		end
	end
	function self.fireMenuIconHoveredSignal(p)
		menuIconHoveredSignal:fire(p)
	end
	function self.menuIconOnHover()
		if isInExperienceUIVREnabled and fn() then
			return
		end

		if enabled then
			self:setState({ isHovering = true })

			self.fireMenuIconHoveredSignal(true)

			delay(v, function()
				if self.state.isHovering and not self.state.clickLatched then
					if isInExperienceUIVREnabled and fn() then
						return
					end

					self:setState({ showTooltip = true })
				end
			end)
		else
			self.fireMenuIconHoveredSignal(false)
		end

		if isNewInGameMenuEnabled() then
			if not isSubjectToDesktopPolicies() then
				return
			end

			InGameMenuInit.openInGameMenu(InGameMenuConstants.InitalPageKey)
			InGameMenuInit.setMenuIconTooltipOpen(false)
		end
	end

	function self.menuIconOnHoverEnd()
		self:setState({
			showTooltip = false,
			isHovering = false,
			clickLatched = not enabled and nil
		})
	end

	function self.showTopBarCallback()
		if self.state.vrShowMenuIcon ~= false then
			self:setState({ vrShowMenuIcon = false })
		end
	end

	if Enabled() and FFlagEnableConsoleExpControls then
		function self.onMenuIconSelectionChanged(_, flag: boolean, _, p)
			if FFlagEnableConsoleExpControls then
				if GamepadService.GamepadCursorEnabled then
					return
				end

				if
					not (FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled)
					and p
					and string.find(p.Name, Constants.ICON_NAME_PREFIX)
				then
					Service:enableFocusNav()
				end

				FocusUtils.MenuIconSelectedSignal:set(flag)
			else
				local function unfocusTilt(_, p2, _)
					if
						(FFlagEnableConsoleExpControls or p2 ~= Enum.UserInputState.End)
						and (not FFlagEnableConsoleExpControls or p2 ~= Enum.UserInputState.Begin)
					then
						return Enum.ContextActionResult.Pass
					end

					GuiService.SelectedCoreObject = nil
					return Enum.ContextActionResult.Sink
				end

				if flag then
					ContextActionService:BindCoreAction("Unfocus_Tilt", unfocusTilt, false, Enum.KeyCode.ButtonB)
					return
				end

				ContextActionService:UnbindCoreAction("Unfocus_Tilt")

				if
					not (FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled)
					and p
					and string.find(p.Name, Constants.ICON_NAME_PREFIX)
				then
					Service:enableFocusNav()
				end
			end
		end
	end

	local v3

	if FFlagEnableConsoleExpControls then
		v3 = Enabled() and GamepadConnector
	else
		v3 = Enabled
	end

	if v3 and FFlagEnableConsoleExpControls then
		local showTopBar = GamepadConnector:getShowTopBar()

		local binding, setShowIcon = Roact.createBinding(showTopBar:get())
		self.showIcon = binding
		self.setShowIcon = setShowIcon

		if FFlagReduceTopBarInsetsWhileHidden then
			self.priorAbsolutePosition = Vector2.zero
			self.priorAbsoluteSize = Vector2.zero
		end

		showTopBar:connect(function()
			local v4 = showTopBar:get()
			self.setShowIcon(v4)

			if FFlagReduceTopBarInsetsWhileHidden then
				if v4 then
					self.props.onAreaChanged(
						Constants2.MenuIconKeepOutAreaId,
						self.priorAbsolutePosition,
						self.priorAbsoluteSize
					)
				else
					self.props.onAreaChanged(Constants2.MenuIconKeepOutAreaId, Vector2.zero, Vector2.zero)
				end
			end
		end)
	end

	if Enabled() and FFlagEnableConsoleExpControls then
		Service:onTriggerMenuIcon():connect(function()
			GuiService.SelectedCoreObject = self.props.menuIconRef:getValue()
			FocusUtils.MenuIconSelectedSignal:set(true)
		end)
	end

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		self.uiLessStore = Stores.GetUILessStore(false)

		if self.uiLessStore.getUILessModeEnabled(false) then
			local binding, setShowIcon = Roact.createBinding(true)
			self.showIcon = binding
			self.setShowIcon = setShowIcon

			self.priorAbsolutePosition = Vector2.zero
			self.priorAbsoluteSize = Vector2.zero

			self.disposeEffect = createEffect(function(p)
				local uiVisible = self.uiLessStore.getUIVisible(p)
				self.setShowIcon(uiVisible)

				if uiVisible then
					self.props.onAreaChanged(
						Constants2.MenuIconKeepOutAreaId,
						self.priorAbsolutePosition,
						self.priorAbsoluteSize
					)
				else
					self.props.onAreaChanged(Constants2.MenuIconKeepOutAreaId, Vector2.zero, Vector2.zero)
				end
			end)
		end
	end
end

function extended:renderWithTooltipCompat(p, p2, callback)
	if not (isInExperienceUIVREnabled and isSpatial()) then
		return withTooltip(p, p2, callback)
	end

	local function fn2(p3)
		self:setState({
			triggerPointSize = p3.AbsoluteSize,
			triggerPointPosition = p3.AbsolutePosition
		})
	end
	local createElement = React.createElement
	local fragment = React.Fragment
	local vrSpatialTooltip

	if p2.active and self.state.triggerPointSize and panel3DInSpatialUI then
		vrSpatialTooltip = React.createElement(panel3DInSpatialUI, {
			panelType = panelType.ToolTipsContainer,
			renderFunction = function(p3)
				return React.createElement(tooltipCallout, {
					textAlignment = Enum.TextXAlignment.Center,
					headerText = p.headerText,
					orientation = TooltipOrientation.Top,
					distanceOffset = 0,
					triggerPointCenter = Vector2.new(
						self.state.triggerPointPosition.X + self.state.triggerPointSize.X / 2,
						p3.Y - SPATIAL_TOOLTIP_SPACING
					),
					contentOffsetVector = Vector2.zero,
					triggerPointRadius = Vector2.zero
				})
			end
		})
	end

	return createElement(fragment, nil, {
		["VRSpatialTooltip"] = vrSpatialTooltip,
		MenuIconTriggerPoint = callback(fn2)
	})
end

function extended.willUnmount(data)
	if
		FFlagAddUILessMode
		and FIntAddUILessModeVariant ~= 0
		and data.uiLessStore.getUILessModeEnabled(false)
		and data.disposeEffect
	then
		data.disposeEffect()
	end

	if FFlagTopBarSignalizeMenuOpen and data.tiltMenuDisposeEffect then
		data.tiltMenuDisposeEffect()
	end

	if data.disposeUiScaleEffect then
		data.disposeUiScaleEffect()
	end
end

function extended:render()
	local v3 = isInExperienceUIVREnabled and true or not VRService.VREnabled or self.state.vrShowMenuIcon

	local v4 = Constants2.TopBarButtonHeight * self.state.UiScale
	local v5 = Constants2.TopBarButtonPadding * self.state.UiScale
	local v6 = Constants2.MENU_ICON_SIZE * self.state.UiScale

	local function fn2(p)
		if p then
			if FFlagReduceTopBarInsetsWhileHidden then
				self.priorAbsolutePosition = p.AbsolutePosition
				self.priorAbsoluteSize = p.AbsoluteSize

				if (not FFlagEnableConsoleExpControls or Enabled()) and GamepadConnector:getShowTopBar():get() then
					self.props.onAreaChanged(Constants2.MenuIconKeepOutAreaId, p.AbsolutePosition, p.AbsoluteSize)
				end
			elseif
				FFlagAddUILessMode
				and FIntAddUILessModeVariant ~= 0
				and self.uiLessStore.getUILessModeEnabled(false)
			then
				self.priorAbsolutePosition = p.AbsolutePosition
				self.priorAbsoluteSize = p.AbsoluteSize

				if self.uiLessStore.getUIVisible(false) then
					self.props.onAreaChanged(Constants2.MenuIconKeepOutAreaId, p.AbsolutePosition, p.AbsoluteSize)
				end
			else
				self.props.onAreaChanged(Constants2.MenuIconKeepOutAreaId, p.AbsolutePosition, p.AbsoluteSize)
			end
		end
	end

	local createElement = Roact.createElement
	local v7 = {
		icon = not isNewTiltIconEnabled() and "rbxasset://textures/ui/TopBar/coloredlogo.png" or Images["icons/logo/block"],
		iconSize = 0,
		useIconScaleAnimation = 0,
		onActivated = 0,
		onHover = 0,
		onHoverEnd = 0,
		enableFlashingDot = 0,
		modal = 0
	}
	local iconSize

	if FFlagTopBarSignalizeMenuOpen then
		iconSize = v6 * (not self.state.tiltMenuOpen and 1 or Constants2.MenuIconOpenScale)
	else
		iconSize = v6 * (self.props.iconScale or 1)
	end

	v7.iconSize = iconSize

	v7.useIconScaleAnimation = isNewTiltIconEnabled()
	v7.onActivated = self.menuIconActivated
	v7.onHover = self.menuIconOnHover
	local onHoverEnd

	if enabled then
		onHoverEnd = self.menuIconOnHoverEnd
	end

	v7.onHoverEnd = onHoverEnd
	v7.enableFlashingDot = self.state.enableFlashingDot
	v7.modal = FFlagAddUILessMode
		and FIntAddUILessModeVariant == 2
		and self.uiLessStore.getUILessModeEnabled(false)
		and true
		or nil
	local element = createElement(IconButton, v7)

	local showTopBarListener = GamepadService and Roact.createElement(ExternalEventConnection, {
		event = VRHub.ShowTopBarChanged.Event or GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"),
		callback = self.showTopBarCallback
	})
	local badgeOver

	if self.props.showBadgeOver12 then
		local createElement2 = Roact.createElement
		local position

		if Enabled() then
			position = UDim2.new(0, 1, 1, -(v5 + 1))
		else
			position = UDim2.new(0, -4, 1, 4)
		end

		badgeOver = createElement2(BadgeOver12, { position = position })
	else
		badgeOver = nil
	end

	if enabled then
		local headerText = "Roblox Menu"
		pcall(function()
			headerText = RobloxTranslator:FormatByKey("CoreScripts.TopBar.RobloxMenu")
		end)
		local v8 = {
			textAlignment = Enum.TextXAlignment.Center,
			headerText = headerText,
			hotkeyCodes = hotkeyCodes
		}

		if defineFastFlag and self.props.referralRewardTooltipText and self.props.referralRewardTooltipText ~= "" then
			v8.headerText = self.props.referralRewardTooltipText
			v8.hotkeyCodes = {}
		end

		local v9 = {
			active = self.state.showTooltip,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Bottom,
			DisplayOrder = 10
		}

		if defineFastFlag and self.props.referralRewardTooltipText and self.props.referralRewardTooltipText ~= "" then
			v9.active = true
		end

		return self:renderWithTooltipCompat(v8, v9, function(callback)
			local function fn3(p)
				fn2(p)
				callback(p)
			end

			local iconHitArea

			if
				Enabled()
				and FFlagEnableConsoleExpControls
				and self.props.unibarMenuRef
				and self.props.unibarMenuRef.current
			then
				local v10 = Service:menuList():get()[1]
				local v11

				if v10 then
					v11 = Constants.ICON_NAME_PREFIX .. v10.id
				end

				local child

				if self.props.unibarMenuRef.current and v11 then
					child = self.props.unibarMenuRef.current:FindFirstChild(v11, true)
				end

				local createElement2 = Roact.createElement
				local v12 = {
					icon = not isNewTiltIconEnabled() and "rbxasset://textures/ui/TopBar/coloredlogo.png" or Images["icons/logo/block"],
					iconSize = 0,
					useIconScaleAnimation = 0,
					onActivated = 0,
					onHover = 0,
					onHoverEnd = 0,
					enableFlashingDot = 0,
					onSelectionChanged = 0,
					nextSelectionRightRef = 0,
					forwardRef = 0
				}
				local iconSize2

				if FFlagTopBarSignalizeMenuOpen then
					iconSize2 = v6 * (not self.state.tiltMenuOpen and 1 or Constants2.MenuIconOpenScale)
				else
					iconSize2 = v6 * (self.props.iconScale or 1)
				end

				v12.iconSize = iconSize2

				v12.useIconScaleAnimation = isNewTiltIconEnabled()
				v12.onActivated = self.menuIconActivated
				v12.onHover = self.menuIconOnHover
				local onHoverEnd2

				if enabled then
					onHoverEnd2 = self.menuIconOnHoverEnd
				end

				v12.onHoverEnd = onHoverEnd2
				v12.enableFlashingDot = self.state.enableFlashingDot
				v12.onSelectionChanged = self.onMenuIconSelectionChanged
				v12.nextSelectionRightRef = child
				v12.forwardRef = self.props.menuIconRef
				iconHitArea = createElement2(IconButton, v12)
			end

			local createElement2 = Roact.createElement
			local visible

			if
				Enabled() and FFlagEnableConsoleExpControls
				or FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and self.uiLessStore.getUILessModeEnabled(false)
			then
				visible = self.showIcon:map(function(p)
					return v3 and p
				end)
			else
				visible = v3
			end

			local v10 = {
				["Visible"] = nil,
				["Visible"] = nil,
				["Visible"] = nil,
				["Visible"] = nil,
				Visible = visible,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v4, 1, 0),
				LayoutOrder = self.props.layoutOrder,
				SelectionGroup = Enabled() and FFlagEnableConsoleExpControls and true or nil
			}
			local selectionBehaviorLeft

			if Enabled() and FFlagEnableConsoleExpControls then
				selectionBehaviorLeft = Enum.SelectionBehavior.Stop
			end

			v10.SelectionBehaviorLeft = selectionBehaviorLeft
			local selectionBehaviorUp

			if Enabled() and FFlagEnableConsoleExpControls then
				selectionBehaviorUp = Enum.SelectionBehavior.Stop
			end

			v10.SelectionBehaviorUp = selectionBehaviorUp
			local selectionBehaviorDown

			if Enabled() and FFlagEnableConsoleExpControls then
				selectionBehaviorDown = Enum.SelectionBehavior.Stop
			end

			v10.SelectionBehaviorDown = selectionBehaviorDown
			v10[Roact.Change.AbsoluteSize] = fn3
			v10[Roact.Change.AbsolutePosition] = fn3
			local v11 = {
				BadgeOver12 = badgeOver,
				Background = 0,
				IconHitArea = 0,
				ShowTopBarListener = 0
			}
			local background

			if not (Enabled() and FFlagEnableConsoleExpControls and self.props.unibarMenuRef and self.props.unibarMenuRef.current) then
				background = element
			end

			v11.Background = background

			if not (Enabled() and FFlagEnableConsoleExpControls) then
				iconHitArea = nil
			end

			v11.IconHitArea = iconHitArea
			v11.ShowTopBarListener = showTopBarListener
			return createElement2("Frame", v10, v11)
		end)
	else
		local createElement2 = Roact.createElement
		local visible

		if
			Enabled() and FFlagEnableConsoleExpControls
			or FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and self.uiLessStore.getUILessModeEnabled(false)
		then
			visible = self.showIcon:map(function(p)
				return v3 and p
			end)
		else
			visible = v3
		end

		return createElement2("Frame", {
			Visible = visible,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v4, 1, 0),
			LayoutOrder = self.props.layoutOrder,
			[Roact.Change.AbsoluteSize] = fn2,
			[Roact.Change.AbsolutePosition] = fn2
		}, {
			BadgeOver12 = badgeOver,
			Background = element,
			ShowTopBarListener = showTopBarListener
		})
	end
end

local function mapDispatchToProps(callback)
	return {
		setGamepadMenuOpen = not FFlagTopBarDeprecateDisplayOptionsRodux and function(p)
			return callback(SetGamepadMenuOpen(p))
		end or nil,
		onAreaChanged = not FFlagTopBarSignalizeKeepOutAreas and function(p, p2, p3)
			return callback(SetKeepOutArea(p, p2, p3))
		end or nil
	}
end

local v3 = RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)

if defineFastFlag then
	return withReferralRewardTooltipInfo(v3)
end

return v3

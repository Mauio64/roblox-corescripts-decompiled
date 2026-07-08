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
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local v27 = if not Enabled() or not FFlagEnableConsoleExpControls and not isInExperienceUIVREnabled then nil else require(Chrome.Service)
local v28 = if not Enabled() or not FFlagEnableConsoleExpControls then nil else require(Chrome.ChromeShared.Unibar.Constants)

require(RobloxGui.Modules.TenFootInterface)

local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)

require(RobloxGui.Modules.PlayerList.PlayerListManager)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local BadgeOver12 = require(script.Parent.BadgeOver12)
local Stores = require(CorePackages.Workspace.Packages.CoreGuiCommon).Stores
local Signals = require(CorePackages.Packages.Signals)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local createEffect = Signals.createEffect
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local v42 = game:DefineFastFlag("EnableReferralRewardTooltip", false)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateDisplayOptionsRodux = require(script.Parent.Parent.Parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Parent.Actions
local Constants = require(ParentParent.Parent.Constants)
local SetGamepadMenuOpen = require(Actions.SetGamepadMenuOpen)
local SetKeepOutArea = require(Actions.SetKeepOutArea)
local menuIconHoveredSignal = require(script.Parent.menuIconHoveredSignal)
local v51 = if not not FFlagEnableConsoleExpControls and not Enabled() then nil else require(script.Parent.Parent.GamepadConnector)
local InGameMenuInit = nil

if isNewInGameMenuEnabled() then
	InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
end

local isNewTiltIconEnabled = require(RobloxGui.Modules.isNewTiltIconEnabled)
local TooltipCallout = nil
local isSpatial = nil
local Panel3DInSpatialUI = nil
local PanelType = nil
local SPATIAL_TOOLTIP_SPACING = nil
local UIManager = nil
local u60 = nil

if isInExperienceUIVREnabled then
	isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
	TooltipCallout = UIBlox.App.Dialog.TooltipCallout

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	PanelType = VrSpatialUi.Constants.PanelType
	SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING

	function u60() -- line: 88
		-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (ref), v27 (copy), UIManager (ref)
		if isInExperienceUIVREnabled and isSpatial() then
			local v70 = v27:showTopBar()
			local v71 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

			return not v70 and not v71
		end

		return false
	end
end

local IconButton = require(script.Parent.IconButton)
local withReferralRewardTooltipInfo = require(script.Parent.withReferralRewardTooltipInfo)
local v64 = Roact.PureComponent:extend("MenuIcon")
local v65 = Enabled()
local v66 = not v65 and 0.4 or 0.65
local t1 = { Enum.KeyCode.Escape }

v64.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	setGamepadMenuOpen = if not FFlagTopBarDeprecateDisplayOptionsRodux then t.callback else nil,
	iconScale = if not FFlagTopBarSignalizeMenuOpen then t.optional(t.number) else nil,
	onAreaChanged = t.optional(t.callback),
	showBadgeOver12 = t.optional(t.boolean),
	menuIconRef = if not Enabled() or not FFlagEnableConsoleExpControls then nil else t.optional(t.any),
	unibarMenuRef = if not Enabled() or not FFlagEnableConsoleExpControls then nil else t.optional(t.any),
	referralRewardTooltipText = t.optional(t.string)
})

function v64.init(p1) -- line: 125
	-- upvalues: v65 (copy), Signals (copy), Display (copy), FFlagTopBarSignalizeMenuOpen (copy), SettingsShowSignal (copy), Enabled (copy), isInExperienceUIVREnabled (copy), u60 (ref), RobloxGui (copy), FFlagAddUILessMode (copy), InGameMenuConstants (copy), VRService (copy), VRHub (copy), GamepadService (copy), InGameMenuInit (ref), isNewInGameMenuEnabled (copy), menuIconHoveredSignal (copy), v66 (copy), isSubjectToDesktopPolicies (copy), FFlagEnableConsoleExpControls (copy), FFlagShowUnibarOnVirtualCursor (copy), v28 (copy), v27 (copy), FocusUtils (copy), GuiService (copy), ContextActionService (copy), v51 (copy), Roact (copy), FFlagReduceTopBarInsetsWhileHidden (copy), Constants (copy), FIntAddUILessModeVariant (copy), Stores (copy), createEffect (copy)
	p1:setState({
		vrShowMenuIcon = false,
		showTooltip = false,
		isHovering = false,
		enableFlashingDot = false,
		clickLatched = not v65 and nil
	})
	p1.disposeUiScaleEffect = Signals.createEffect(function(p2) -- line: 133
		-- upvalues: Display (copy), p1 (copy)
		local v97 = Display.GetDisplayStore(p2)

		p1:setState({
			UiScale = v97.getUIScale(p2)
		})
	end)

	if FFlagTopBarSignalizeMenuOpen then
		SettingsShowSignal:connect(function(p3) -- line: 142
			-- upvalues: p1 (copy)
			p1:setState({
				tiltMenuOpen = p3
			})
		end)
	end

	if not Enabled() then
		task.spawn(function() -- line: 151
			-- upvalues: p1 (copy)
			p1:setState({
				enableFlashingDot = true
			})
		end)
	end

	function p1.menuIconActivated() -- line: 158
		-- upvalues: p1 (copy), v65 (copy), isInExperienceUIVREnabled (copy), u60 (ref), RobloxGui (copy), FFlagAddUILessMode (copy), InGameMenuConstants (copy), VRService (copy), VRHub (copy), GamepadService (copy), InGameMenuInit (ref), isNewInGameMenuEnabled (copy)
		p1:setState({
			showTooltip = false,
			isHovering = not not v65 and nil,
			clickLatched = not not v65 or nil
		})

		if isInExperienceUIVREnabled then
			if u60() then
				return
			end

			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			if FFlagAddUILessMode then
				SettingsHub:ToggleVisibility(nil, InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)

				return
			end

			SettingsHub:ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)

			return
		end

		if VRService.VREnabled and (VRHub.ShowTopBar or GamepadService.GamepadCursorEnabled) then
			InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)

			return
		end

		if isNewInGameMenuEnabled() then
			InGameMenuInit.openInGameMenu(InGameMenuConstants.MainPagePageKey)

			return
		end

		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if FFlagAddUILessMode then
			SettingsHub:ToggleVisibility(nil, InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)

			return
		end

		SettingsHub:ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
	end
	function p1.fireMenuIconHoveredSignal(p4) -- line: 193
		-- upvalues: menuIconHoveredSignal (copy)
		menuIconHoveredSignal:fire(p4)
	end
	function p1.menuIconOnHover() -- line: 196
		-- upvalues: isInExperienceUIVREnabled (copy), u60 (ref), v65 (copy), p1 (copy), v66 (copy), isNewInGameMenuEnabled (copy), isSubjectToDesktopPolicies (copy), InGameMenuInit (ref), InGameMenuConstants (copy)
		if isInExperienceUIVREnabled and u60() then
			return
		end

		if v65 then
			p1:setState({
				isHovering = true
			})
			p1.fireMenuIconHoveredSignal(true)
			delay(v66, function() -- line: 206
				-- upvalues: p1 (copy), isInExperienceUIVREnabled (copy), u60 (ref)
				if p1.state.isHovering and not p1.state.clickLatched then
					if isInExperienceUIVREnabled and u60() then
						return
					end

					p1:setState({
						showTooltip = true
					})
				end
			end)
		else
			p1.fireMenuIconHoveredSignal(false)
		end

		if isNewInGameMenuEnabled() then
			if not isSubjectToDesktopPolicies() then
				return
			end

			InGameMenuInit.openInGameMenu(InGameMenuConstants.InitalPageKey)
			InGameMenuInit.setMenuIconTooltipOpen(false)
		end
	end
	function p1.menuIconOnHoverEnd() -- line: 230
		-- upvalues: p1 (copy), v65 (copy)
		p1:setState({
			showTooltip = false,
			isHovering = false,
			clickLatched = not v65 and nil
		})
	end
	function p1.showTopBarCallback() -- line: 238
		-- upvalues: p1 (copy)
		if p1.state.vrShowMenuIcon ~= false then
			p1:setState({
				vrShowMenuIcon = false
			})
		end
	end

	if Enabled() and FFlagEnableConsoleExpControls then
		function p1.onMenuIconSelectionChanged(_, b1: boolean, _, p7) -- line: 248
			-- upvalues: FFlagEnableConsoleExpControls (copy), GamepadService (copy), FFlagShowUnibarOnVirtualCursor (copy), v28 (copy), v27 (copy), FocusUtils (copy), GuiService (copy), ContextActionService (copy)
			if FFlagEnableConsoleExpControls then
				if GamepadService.GamepadCursorEnabled then
					return
				end

				if (not FFlagShowUnibarOnVirtualCursor or not GamepadService.GamepadCursorEnabled) and p7 and string.find(p7.Name, v28.ICON_NAME_PREFIX) then
					v27:enableFocusNav()
				end

				FocusUtils.MenuIconSelectedSignal:set(b1)

				return
			end

			local function unfocusTilt(_, p9, _) -- line: 259
				-- upvalues: FFlagEnableConsoleExpControls (copy), GuiService (copy)
				if not FFlagEnableConsoleExpControls and p9 == Enum.UserInputState.End or FFlagEnableConsoleExpControls and p9 == Enum.UserInputState.Begin then
					GuiService.SelectedCoreObject = nil

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end

			if b1 then
				ContextActionService:BindCoreAction("Unfocus_Tilt", unfocusTilt, false, Enum.KeyCode.ButtonB)

				return
			end

			ContextActionService:UnbindCoreAction("Unfocus_Tilt")

			if (not FFlagShowUnibarOnVirtualCursor or not GamepadService.GamepadCursorEnabled) and p7 and string.find(p7.Name, v28.ICON_NAME_PREFIX) then
				v27:enableFocusNav()
			end
		end
	end

	if ((if not FFlagEnableConsoleExpControls then Enabled else Enabled() and v51)) and FFlagEnableConsoleExpControls then
		local v73 = v51:getShowTopBar()
		local v74, v75 = Roact.createBinding(v73:get())

		p1.showIcon = v74
		p1.setShowIcon = v75

		if FFlagReduceTopBarInsetsWhileHidden then
			p1.priorAbsolutePosition = Vector2.zero
			p1.priorAbsoluteSize = Vector2.zero
		end

		v73:connect(function() -- line: 292
			-- upvalues: v73 (copy), p1 (copy), FFlagReduceTopBarInsetsWhileHidden (copy), Constants (copy)
			local v107 = v73:get()

			p1.setShowIcon(v107)

			if FFlagReduceTopBarInsetsWhileHidden then
				if v107 then
					p1.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, p1.priorAbsolutePosition, p1.priorAbsoluteSize)

					return
				end

				p1.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, Vector2.zero, Vector2.zero)
			end
		end)
	end

	if Enabled() and FFlagEnableConsoleExpControls then
		v27:onTriggerMenuIcon():connect(function() -- line: 307
			-- upvalues: GuiService (copy), p1 (copy), FocusUtils (copy)
			GuiService.SelectedCoreObject = p1.props.menuIconRef:getValue()
			FocusUtils.MenuIconSelectedSignal:set(true)
		end)
	end

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		p1.uiLessStore = Stores.GetUILessStore(false)

		if p1.uiLessStore.getUILessModeEnabled(false) then
			local v76, v77 = Roact.createBinding(true)

			p1.showIcon = v76
			p1.setShowIcon = v77
			p1.priorAbsolutePosition = Vector2.zero
			p1.priorAbsoluteSize = Vector2.zero
			p1.disposeEffect = createEffect(function(p11) -- line: 322
				-- upvalues: p1 (copy), Constants (copy)
				local v109 = p1.uiLessStore.getUIVisible(p11)

				p1.setShowIcon(v109)

				if v109 then
					p1.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, p1.priorAbsolutePosition, p1.priorAbsoluteSize)

					return
				end

				p1.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, Vector2.zero, Vector2.zero)
			end)
		end
	end
end
function v64.renderWithTooltipCompat(p12, p13, p14, p15) -- line: 336
	-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (ref), React (copy), Panel3DInSpatialUI (ref), PanelType (ref), TooltipCallout (ref), TooltipOrientation (copy), SPATIAL_TOOLTIP_SPACING (ref), withTooltip (copy)
	if isInExperienceUIVREnabled and isSpatial() then
		return React.createElement(React.Fragment, nil, {
			VRSpatialTooltip = if not p14.active or (not p12.state.triggerPointSize or not Panel3DInSpatialUI) then nil else React.createElement(Panel3DInSpatialUI, {
				panelType = PanelType.ToolTipsContainer,
				renderFunction = function(p16) -- line: 354
					-- upvalues: React (copy), TooltipCallout (ref), p13 (copy), TooltipOrientation (copy), p12 (copy), SPATIAL_TOOLTIP_SPACING (ref)
					return React.createElement(TooltipCallout, {
						distanceOffset = 0,
						textAlignment = Enum.TextXAlignment.Center,
						headerText = p13.headerText,
						orientation = TooltipOrientation.Top,
						triggerPointCenter = Vector2.new(p12.state.triggerPointPosition.X + p12.state.triggerPointSize.X / 2, p16.Y - SPATIAL_TOOLTIP_SPACING),
						contentOffsetVector = Vector2.zero,
						triggerPointRadius = Vector2.zero
					})
				end
			}),
			MenuIconTriggerPoint = p15(function(p17) -- line: 339
				-- upvalues: p12 (copy)
				p12:setState({
					triggerPointSize = p17.AbsoluteSize,
					triggerPointPosition = p17.AbsolutePosition
				})
			end)
		})
	end

	return withTooltip(p13, p14, p15)
end
function v64.willUnmount(p18) -- line: 378
	-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), FFlagTopBarSignalizeMenuOpen (copy)
	if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and p18.uiLessStore.getUILessModeEnabled(false) and p18.disposeEffect) then
		p18.disposeEffect()
	end

	if FFlagTopBarSignalizeMenuOpen and p18.tiltMenuDisposeEffect then
		p18.tiltMenuDisposeEffect()
	end

	if p18.disposeUiScaleEffect then
		p18.disposeUiScaleEffect()
	end
end
function v64.render(p19) -- line: 395
	-- upvalues: isInExperienceUIVREnabled (copy), VRService (copy), Constants (copy), FFlagReduceTopBarInsetsWhileHidden (copy), FFlagEnableConsoleExpControls (copy), Enabled (copy), v51 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Roact (copy), IconButton (copy), isNewTiltIconEnabled (copy), Images (copy), FFlagTopBarSignalizeMenuOpen (copy), v65 (copy), GamepadService (copy), ExternalEventConnection (copy), VRHub (copy), BadgeOver12 (copy), RobloxTranslator (copy), t1 (copy), v42 (copy), CoreGui (copy), TooltipOrientation (copy), v27 (copy), v28 (copy)
	local u84 = not not isInExperienceUIVREnabled or (not VRService.VREnabled or p19.state.vrShowMenuIcon)
	local v85 = Constants.TopBarButtonHeight * p19.state.UiScale
	local v86 = Constants.TopBarButtonPadding * p19.state.UiScale
	local v87 = Constants.MENU_ICON_SIZE * p19.state.UiScale

	local function v88(p20) -- line: 407
		-- upvalues: FFlagReduceTopBarInsetsWhileHidden (copy), p19 (copy), FFlagEnableConsoleExpControls (copy), Enabled (copy), v51 (copy), Constants (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy)
		if p20 then
			if FFlagReduceTopBarInsetsWhileHidden then
				p19.priorAbsolutePosition = p20.AbsolutePosition
				p19.priorAbsoluteSize = p20.AbsoluteSize

				if (not FFlagEnableConsoleExpControls or Enabled()) and v51:getShowTopBar():get() then
					p19.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, p20.AbsolutePosition, p20.AbsoluteSize)

					return
				end
			elseif FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and p19.uiLessStore.getUILessModeEnabled(false) then
				p19.priorAbsolutePosition = p20.AbsolutePosition
				p19.priorAbsoluteSize = p20.AbsoluteSize

				if p19.uiLessStore.getUIVisible(false) then
					p19.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, p20.AbsolutePosition, p20.AbsoluteSize)

					return
				end
			else
				p19.props.onAreaChanged(Constants.MenuIconKeepOutAreaId, p20.AbsolutePosition, p20.AbsoluteSize)
			end
		end
	end

	local v89 = Roact.createElement(IconButton, {
		icon = not isNewTiltIconEnabled() and "rbxasset://textures/ui/TopBar/coloredlogo.png" or Images["icons/logo/block"],
		iconSize = if not FFlagTopBarSignalizeMenuOpen then v87 * (p19.props.iconScale or 1) else v87 * (not p19.state.tiltMenuOpen and 1 or Constants.MenuIconOpenScale),
		useIconScaleAnimation = isNewTiltIconEnabled(),
		onActivated = p19.menuIconActivated,
		onHover = p19.menuIconOnHover,
		onHoverEnd = if not v65 then nil else p19.menuIconOnHoverEnd,
		enableFlashingDot = p19.state.enableFlashingDot,
		modal = FFlagAddUILessMode and (FIntAddUILessModeVariant == 2 and not not p19.uiLessStore.getUILessModeEnabled(false)) or nil
	})
	local v90 = GamepadService and Roact.createElement(ExternalEventConnection, {
		event = VRHub.ShowTopBarChanged.Event or GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"),
		callback = p19.showTopBarCallback
	})
	local v91 = if not p19.props.showBadgeOver12 then nil else Roact.createElement(BadgeOver12, {
		position = if not Enabled() then UDim2.new(0, -4, 1, 4) else UDim2.new(0, 1, 1, -(v86 + 1))
	})

	if v65 then
		local s1 = "Roblox Menu"

		pcall(function() -- line: 459
			-- upvalues: s1 (ref), RobloxTranslator (copy)
			s1 = RobloxTranslator:FormatByKey("CoreScripts.TopBar.RobloxMenu")
		end)

		local t2 = {
			textAlignment = Enum.TextXAlignment.Center,
			headerText = s1,
			hotkeyCodes = t1
		}

		if v42 and p19.props.referralRewardTooltipText and p19.props.referralRewardTooltipText ~= "" then
			t2.headerText = p19.props.referralRewardTooltipText
			t2.hotkeyCodes = {}
		end

		local t3 = {
			DisplayOrder = 10,
			active = p19.state.showTooltip,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Bottom
		}

		if v42 and p19.props.referralRewardTooltipText and p19.props.referralRewardTooltipText ~= "" then
			t3.active = true
		end

		return p19:renderWithTooltipCompat(t2, t3, function(p21) -- line: 484
			-- upvalues: v88 (copy), Enabled (copy), FFlagEnableConsoleExpControls (copy), p19 (copy), v27 (copy), v28 (copy), Roact (copy), IconButton (copy), isNewTiltIconEnabled (copy), Images (copy), FFlagTopBarSignalizeMenuOpen (copy), v87 (copy), Constants (copy), v65 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u84 (ref), v85 (copy), v91 (copy), v89 (copy), v90 (copy)
			local function v114(p22) -- line: 485
				-- upvalues: v88 (copy), p21 (copy)
				v88(p22)
				p21(p22)
			end

			local v115 = nil

			if Enabled() and (FFlagEnableConsoleExpControls and p19.props.unibarMenuRef and p19.props.unibarMenuRef.current) then
				local v116 = v27:menuList():get()[1]
				local v117 = if not v116 then nil else v28.ICON_NAME_PREFIX .. v116.id
				local v118 = if not p19.props.unibarMenuRef.current or not v117 then nil else p19.props.unibarMenuRef.current:FindFirstChild(v117, true)

				v115 = Roact.createElement(IconButton, {
					icon = not isNewTiltIconEnabled() and "rbxasset://textures/ui/TopBar/coloredlogo.png" or Images["icons/logo/block"],
					iconSize = if not FFlagTopBarSignalizeMenuOpen then v87 * (p19.props.iconScale or 1) else v87 * (not p19.state.tiltMenuOpen and 1 or Constants.MenuIconOpenScale),
					useIconScaleAnimation = isNewTiltIconEnabled(),
					onActivated = p19.menuIconActivated,
					onHover = p19.menuIconOnHover,
					onHoverEnd = if not v65 then nil else p19.menuIconOnHoverEnd,
					enableFlashingDot = p19.state.enableFlashingDot,
					onSelectionChanged = p19.onMenuIconSelectionChanged,
					nextSelectionRightRef = v118,
					forwardRef = p19.props.menuIconRef
				})
			end

			return Roact.createElement("Frame", {
				Visible = if not (not not Enabled() and FFlagEnableConsoleExpControls) and (not FFlagAddUILessMode or (FIntAddUILessModeVariant == 0 or not p19.uiLessStore.getUILessModeEnabled(false))) then u84 else p19.showIcon:map(function(p23) -- line: 516
					-- upvalues: u84 (ref)
					return u84 and p23
				end),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v85, 1, 0),
				LayoutOrder = p19.props.layoutOrder,
				SelectionGroup = Enabled() and not not FFlagEnableConsoleExpControls or nil,
				SelectionBehaviorLeft = if not Enabled() or not FFlagEnableConsoleExpControls then nil else Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = if not Enabled() or not FFlagEnableConsoleExpControls then nil else Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = if not Enabled() or not FFlagEnableConsoleExpControls then nil else Enum.SelectionBehavior.Stop,
				[Roact.Change.AbsoluteSize] = v114,
				[Roact.Change.AbsolutePosition] = v114
			}, {
				BadgeOver12 = v91,
				Background = if not Enabled() or (not FFlagEnableConsoleExpControls or (not p19.props.unibarMenuRef or not p19.props.unibarMenuRef.current)) then v89 else nil,
				IconHitArea = if not Enabled() or not FFlagEnableConsoleExpControls then nil else v115,
				ShowTopBarListener = v90
			})
		end)
	end

	return Roact.createElement("Frame", {
		Visible = if not (not not Enabled() and FFlagEnableConsoleExpControls) and (not FFlagAddUILessMode or (FIntAddUILessModeVariant == 0 or not p19.uiLessStore.getUILessModeEnabled(false))) then u84 else p19.showIcon:map(function(p24) -- line: 537
			-- upvalues: u84 (ref)
			return u84 and p24
		end),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v85, 1, 0),
		LayoutOrder = p19.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = v88,
		[Roact.Change.AbsolutePosition] = v88
	}, {
		BadgeOver12 = v91,
		Background = v89,
		ShowTopBarListener = v90
	})
end

local function mapDispatchToProps(p25) -- line: 553
	-- upvalues: FFlagTopBarDeprecateDisplayOptionsRodux (copy), SetGamepadMenuOpen (copy), FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy)
	return {
		setGamepadMenuOpen = not FFlagTopBarDeprecateDisplayOptionsRodux and function(p26) -- line: 557
			-- upvalues: p25 (copy), SetGamepadMenuOpen (copy)
			return p25(SetGamepadMenuOpen(p26))
		end or nil,
		onAreaChanged = not FFlagTopBarSignalizeKeepOutAreas and function(p27, p28, p29) -- line: 562
			-- upvalues: p25 (copy), SetKeepOutArea (copy)
			return p25(SetKeepOutArea(p27, p28, p29))
		end or nil
	}
end

local v69 = RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v64)

if v42 then
	return withReferralRewardTooltipInfo(v69)
end

return v69

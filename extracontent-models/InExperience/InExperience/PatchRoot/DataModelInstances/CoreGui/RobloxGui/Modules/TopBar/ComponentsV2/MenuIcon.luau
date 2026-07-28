game:GetService("ContextActionService")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")

game:GetService("VRService")

local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Chrome = ParentParentParent.Chrome
local Service = require(Chrome.Service)
local Constants = require(ParentParent.Constants)
local InGameMenuConstants = require(ParentParentParent.InGameMenuConstants)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local Display = require(CorePackages.Workspace.Packages.Display)
local Foundation = require(CorePackages.Packages.Foundation)
local Motion = require(CorePackages.Packages.Motion)
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar
local View = Foundation.View
local Icon = Foundation.Icon
local ControlState = Foundation.Enums.ControlState
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local useIsPlaytestMode = require(Chrome.ChromeShared.Hooks.useIsPlaytestMode)
local getSideSheetVisibility = require(CorePackages.Workspace.Packages.InExperienceSideSheet).getSideSheetVisibility
local menuIconHoveredSignal = require(ParentParent.Components.Presentation.menuIconHoveredSignal)
local BadgeOver12 = require(ParentParent.Components.Presentation.BadgeOver12)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local TooltipCallout = UIBlox.App.Dialog.TooltipCallout
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local UIManager = VrSpatialUi.UIManager
local Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
local PanelType = VrSpatialUi.Constants.PanelType
local SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING
local v44 = if not FFlagEnablePlaytestModeUnibar then nil else Foundation.Utility.getTokens(Foundation.Enums.Theme.Light)
local t1 = { Enum.KeyCode.Escape }

local function MenuIcon(t2: {[any]: any}) -- line: 93
	-- upvalues: useTokens (copy), FFlagEnablePlaytestModeUnibar (copy), useIsPlaytestMode (copy), v44 (copy), FFlagEnableSideSheet (copy), SignalsReact (copy), Display (copy), Constants (copy), React (copy), Motion (copy), GuiService (copy), Service (copy), Constants2 (copy), useCursor (copy), Foundation (copy), t1 (copy), CoreGui (copy), TooltipOrientation (copy), RobloxTranslator (copy), SettingsShowSignal (copy), Signals (copy), getSideSheetVisibility (copy), FocusUtils (copy), ControlState (copy), isSpatial (copy), UIManager (copy), menuIconHoveredSignal (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), ParentParentParent (copy), InGameMenuConstants (copy), TooltipCallout (copy), SPATIAL_TOOLTIP_SPACING (copy), Panel3DInSpatialUI (copy), PanelType (copy), withTooltip (copy), View (copy), BadgeOver12 (copy), Icon (copy)
	local v50 = useTokens()
	local v51 = nil

	if FFlagEnablePlaytestModeUnibar then
		v51 = useIsPlaytestMode()
	end

	local v52 = if not FFlagEnablePlaytestModeUnibar or not v51 then if not FFlagEnableSideSheet then nil else v50.Color.ActionEmphasis.Foreground else v44.Color.Content.Emphasis
	local v53 = if not FFlagEnablePlaytestModeUnibar or not v51 then v50.Color.OverMedia.OverMedia_0 else v44.Color.OverMedia.OverMedia_0
	local v54 = SignalsReact.useSignalState(function(p1) -- line: 110
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p1).getUIScale(p1)
	end)
	local _ = Constants.TopBarButtonHeight * v54
	local v56 = Constants.TopBarButtonPadding * v54
	local v57 = Constants.MENU_ICON_SIZE * v54
	local v58 = React.useMemo(function() -- line: 117
		-- upvalues: Motion (copy), v57 (copy), Constants (copy)
		return {
			menuOpen = Motion.createState({
				size = v57 * Constants.MenuIconOpenScale
			}),
			menuClosed = Motion.createState({
				size = v57
			})
		}
	end, { v54 })
	local v59, v60 = Motion.useMotion(v58.menuClosed)
	local v61, v62 = React.useBinding(GuiService.PreferredTransparency)
	local v63 = React.useRef(false)
	local v64 = React.useRef(false)
	local u65 = nil

	if t2.unibarMenuRef and t2.unibarMenuRef.current then
		local v66 = Service:menuList():get()[1]
		local v67 = if not v66 then nil else Constants2.ICON_NAME_PREFIX .. v66.id

		u65 = if not t2.unibarMenuRef.current or not v67 then nil else t2.unibarMenuRef.current:FindFirstChild(v67, true)
	end

	local v68, v69 = React.useState(false)
	local v70, v71 = React.useState(Vector2.zero)
	local v72, v73 = React.useState(Vector2.zero)
	local v74 = useCursor(Foundation.Enums.CursorType.SkinToneCircle)
	local v75 = React.useRef("Roblox Menu")
	local t3 = {
		textAlignment = Enum.TextXAlignment.Center,
		headerText = v75.current,
		hotkeyCodes = t1
	}
	local t4 = {
		DisplayOrder = 10,
		active = v68,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Bottom
	}

	React.useEffect(function() -- line: 166
		-- upvalues: v75 (copy), RobloxTranslator (copy), GuiService (copy), v62 (copy), SettingsShowSignal (copy), v60 (copy), v58 (copy), FFlagEnableSideSheet (copy), Signals (copy), getSideSheetVisibility (copy), t2 (copy), Service (copy), FocusUtils (copy)
		pcall(function() -- line: 167
			-- upvalues: v75 (copy), RobloxTranslator (copy)
			v75.current = RobloxTranslator:FormatByKey("CoreScripts.TopBar.RobloxMenu")
		end)

		local connection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 171
			-- upvalues: v62 (copy), GuiService (copy)
			v62(GuiService.PreferredTransparency)
		end)
		local v84 = SettingsShowSignal:connect(function(p2) -- line: 174
			-- upvalues: v60 (copy), v58 (copy)
			v60(if not p2 then v58.menuClosed else v58.menuOpen)
		end)
		local u85 = nil

		if FFlagEnableSideSheet then
			u85 = Signals.createEffect(function(p3) -- line: 180
				-- upvalues: getSideSheetVisibility (copy), v60 (copy), v58 (copy)
				local v101 = getSideSheetVisibility(p3)

				v60(if not v101 then v58.menuClosed else v58.menuOpen)
			end)
		end

		local u86 = nil

		if t2.menuIconRef then
			u86 = Service:onTriggerMenuIcon():connect(function() -- line: 188
				-- upvalues: GuiService (copy), t2 (copy), FocusUtils (copy)
				GuiService.SelectedCoreObject = t2.menuIconRef.current
				FocusUtils.MenuIconSelectedSignal:set(true)
			end)
		end

		return function() -- line: 194
			-- upvalues: FFlagEnableSideSheet (copy), u85 (ref), connection (copy), v84 (copy), u86 (ref)
			if FFlagEnableSideSheet and u85 then
				u85()
			end

			connection:Disconnect()
			v84:Disconnect()

			if u86 then
				u86:disconnect()
			end
		end
	end, {})

	local v78 = React.useRef(ControlState.Default)
	local v79 = React.useCallback(function(p4) -- line: 207
		-- upvalues: ControlState (copy), isSpatial (copy), Service (copy), UIManager (copy), v64 (copy), menuIconHoveredSignal (copy), v63 (copy), v69 (copy), FocusUtils (copy), v78 (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), GuiService (copy), Constants2 (copy)
		if p4 == ControlState.Hover then
			local v90

			if isSpatial() then
				local v88 = Service:showTopBar()
				local v89 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

				v90 = not v88 and not v89
			else
				v90 = false
			end

			if v90 then
				return
			end

			v64.current = true
			menuIconHoveredSignal:fire(true)
			task.delay(0.65, function() -- line: 215
				-- upvalues: v64 (copy), v63 (copy), isSpatial (copy), Service (copy), UIManager (copy), v69 (copy)
				if v64.current and not v63.current then
					local v104

					if isSpatial() then
						local v102 = Service:showTopBar()
						local v103 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

						v104 = not v102 and not v103
					else
						v104 = false
					end

					if v104 then
						return
					end

					v69(true)
				end
			end)
		elseif p4 == ControlState.Selected then
			FocusUtils.MenuIconSelectedSignal:set(true)
		elseif p4 == ControlState.Default then
			if v78.current == ControlState.Hover then
				v69(false)
				v64.current = false
				v63.current = false
			elseif v78.current == ControlState.Selected then
				if (not FFlagShowUnibarOnVirtualCursor or not GamepadService.GamepadCursorEnabled) and GuiService.SelectedCoreObject and string.find(GuiService.SelectedCoreObject.Name, Constants2.ICON_NAME_PREFIX) then
					Service:enableFocusNav()
				end

				FocusUtils.MenuIconSelectedSignal:set(false)
			end
		end

		v78.current = p4
	end, {})
	local v80 = React.useCallback(function() -- line: 241
		-- upvalues: v69 (copy), v63 (copy), isSpatial (copy), Service (copy), UIManager (copy), ParentParentParent (copy), InGameMenuConstants (copy)
		v69(false)
		v63.current = true

		local v93

		if isSpatial() then
			local v91 = Service:showTopBar()
			local v92 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

			v93 = not v91 and not v92
		else
			v93 = false
		end

		if v93 then
			return
		end

		require(ParentParentParent.Settings.SettingsHub):ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
	end, {})

	local function renderWithTooltipCompat(p5, p6, p7) -- line: 252
		-- upvalues: isSpatial (copy), v71 (copy), v73 (copy), React (copy), TooltipCallout (copy), TooltipOrientation (copy), v72 (copy), v70 (copy), SPATIAL_TOOLTIP_SPACING (copy), Panel3DInSpatialUI (copy), PanelType (copy), withTooltip (copy)
		if isSpatial() then
			local v97 = React.useCallback(function(vector2: Vector2) -- line: 259
				-- upvalues: React (copy), TooltipCallout (copy), p5 (copy), TooltipOrientation (copy), v72 (copy), v70 (copy), SPATIAL_TOOLTIP_SPACING (copy)
				return React.createElement(TooltipCallout, {
					distanceOffset = 0,
					textAlignment = Enum.TextXAlignment.Center,
					headerText = p5.headerText,
					orientation = TooltipOrientation.Top,
					triggerPointCenter = Vector2.new(v72.X + v70.X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING),
					contentOffsetVector = Vector2.zero,
					triggerPointRadius = Vector2.zero
				})
			end, {
				p5,
				v72,
				v70
			})

			return React.createElement(React.Fragment, nil, {
				VRSpatialTooltip = if not p6.active or (not v70 or not Panel3DInSpatialUI) then nil else React.createElement(Panel3DInSpatialUI, {
					panelType = PanelType.ToolTipsContainer,
					renderFunction = v97
				}),
				MenuIconTriggerPoint = p7(function(p8) -- line: 255
					-- upvalues: v71 (copy), v73 (copy)
					v71(p8.AbsoluteSize)
					v73(p8.AbsolutePosition)
				end)
			})
		end

		return withTooltip(p5, p6, p7)
	end

	return renderWithTooltipCompat(t3, t4, (React.useCallback(function(p9) -- line: 293
		-- upvalues: React (copy), View (copy), FFlagEnableSideSheet (copy), v61 (copy), v53 (copy), u65 (ref), v74 (copy), t2 (copy), v80 (copy), v79 (copy), BadgeOver12 (copy), v56 (copy), Icon (copy), Foundation (copy), v59 (copy), v52 (copy)
		return React.createElement(View, {
			tag = "radius-circle aspect-1-1",
			backgroundStyle = if FFlagEnableSideSheet then nil else v61:map(function(p10) -- line: 297
				-- upvalues: v53 (copy)
				local v108 = v53

				v108.Transparency = v108.Transparency * p10

				return v108
			end),
			Size = UDim2.fromScale(1, 1),
			NextSelectionRight = u65,
			selection = {
				Selectable = true,
				SelectionImageObject = v74
			},
			selectionGroup = {
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			},
			ref = t2.menuIconRef,
			onAbsoluteSizeChanged = p9,
			onAbsolutePositionChanged = p9,
			onActivated = if FFlagEnableSideSheet then nil else v80,
			onStateChanged = if FFlagEnableSideSheet then nil else v79
		}, {
			BadgeOver12 = if not t2.showBadgeOver12 then nil else React.createElement(BadgeOver12, {
				position = UDim2.new(0, 1, 1, -(v56 + 1))
			}),
			Icon = React.createElement(Icon, {
				name = Foundation.Enums.IconName.Tilt,
				size = v59.size,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				style = v52
			})
		})
	end, {
		v61,
		u65,
		v74,
		v80,
		v79,
		t2.showBadgeOver12,
		v52,
		v53
	})))
end

return MenuIcon

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
local View = Foundation.View
local Icon = Foundation.Icon
local ControlState = Foundation.Enums.ControlState
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
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
local t1 = { Enum.KeyCode.Escape }

local function MenuIcon(t2: {[any]: any}) -- line: 86
	-- upvalues: useTokens (copy), SignalsReact (copy), Display (copy), Constants (copy), React (copy), Motion (copy), GuiService (copy), Service (copy), Constants2 (copy), useCursor (copy), Foundation (copy), t1 (copy), CoreGui (copy), TooltipOrientation (copy), RobloxTranslator (copy), SettingsShowSignal (copy), FFlagEnableSideSheet (copy), Signals (copy), getSideSheetVisibility (copy), FocusUtils (copy), ControlState (copy), isSpatial (copy), UIManager (copy), menuIconHoveredSignal (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), ParentParentParent (copy), InGameMenuConstants (copy), TooltipCallout (copy), SPATIAL_TOOLTIP_SPACING (copy), Panel3DInSpatialUI (copy), PanelType (copy), withTooltip (copy), View (copy), BadgeOver12 (copy), Icon (copy)
	local v47 = useTokens()
	local v48 = SignalsReact.useSignalState(function(p1) -- line: 89
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p1).getUIScale(p1)
	end)
	local _ = Constants.TopBarButtonHeight * v48
	local v50 = Constants.TopBarButtonPadding * v48
	local v51 = Constants.MENU_ICON_SIZE * v48
	local v52 = React.useMemo(function() -- line: 96
		-- upvalues: Motion (copy), v51 (copy), Constants (copy)
		return {
			menuOpen = Motion.createState({
				size = v51 * Constants.MenuIconOpenScale
			}),
			menuClosed = Motion.createState({
				size = v51
			})
		}
	end, { v48 })
	local v53, v54 = Motion.useMotion(v52.menuClosed)
	local v55, v56 = React.useBinding(GuiService.PreferredTransparency)
	local v57 = React.useRef(false)
	local v58 = React.useRef(false)
	local u59 = nil

	if t2.unibarMenuRef and t2.unibarMenuRef.current then
		local v60 = Service:menuList():get()[1]
		local v61 = if not v60 then nil else Constants2.ICON_NAME_PREFIX .. v60.id

		u59 = if not t2.unibarMenuRef.current or not v61 then nil else t2.unibarMenuRef.current:FindFirstChild(v61, true)
	end

	local v62, v63 = React.useState(false)
	local v64, v65 = React.useState(Vector2.zero)
	local v66, v67 = React.useState(Vector2.zero)
	local v68 = useCursor(Foundation.Enums.CursorType.SkinToneCircle)
	local v69 = React.useRef("Roblox Menu")
	local t3 = {
		textAlignment = Enum.TextXAlignment.Center,
		headerText = v69.current,
		hotkeyCodes = t1
	}
	local t4 = {
		DisplayOrder = 10,
		active = v62,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Bottom
	}

	React.useEffect(function() -- line: 145
		-- upvalues: v69 (copy), RobloxTranslator (copy), GuiService (copy), v56 (copy), SettingsShowSignal (copy), v54 (copy), v52 (copy), FFlagEnableSideSheet (copy), Signals (copy), getSideSheetVisibility (copy), t2 (copy), Service (copy), FocusUtils (copy)
		pcall(function() -- line: 146
			-- upvalues: v69 (copy), RobloxTranslator (copy)
			v69.current = RobloxTranslator:FormatByKey("CoreScripts.TopBar.RobloxMenu")
		end)

		local connection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 150
			-- upvalues: v56 (copy), GuiService (copy)
			v56(GuiService.PreferredTransparency)
		end)
		local v78 = SettingsShowSignal:connect(function(p2) -- line: 153
			-- upvalues: v54 (copy), v52 (copy)
			v54(if not p2 then v52.menuClosed else v52.menuOpen)
		end)
		local u79 = nil

		if FFlagEnableSideSheet then
			u79 = Signals.createEffect(function(p3) -- line: 159
				-- upvalues: getSideSheetVisibility (copy), v54 (copy), v52 (copy)
				local v95 = getSideSheetVisibility(p3)

				v54(if not v95 then v52.menuClosed else v52.menuOpen)
			end)
		end

		local u80 = nil

		if t2.menuIconRef then
			u80 = Service:onTriggerMenuIcon():connect(function() -- line: 167
				-- upvalues: GuiService (copy), t2 (copy), FocusUtils (copy)
				GuiService.SelectedCoreObject = t2.menuIconRef.current
				FocusUtils.MenuIconSelectedSignal:set(true)
			end)
		end

		return function() -- line: 173
			-- upvalues: FFlagEnableSideSheet (copy), u79 (ref), connection (copy), v78 (copy), u80 (ref)
			if FFlagEnableSideSheet and u79 then
				u79()
			end

			connection:Disconnect()
			v78:Disconnect()

			if u80 then
				u80:disconnect()
			end
		end
	end, {})

	local v72 = React.useRef(ControlState.Default)
	local v73 = React.useCallback(function(p4) -- line: 186
		-- upvalues: ControlState (copy), isSpatial (copy), Service (copy), UIManager (copy), v58 (copy), menuIconHoveredSignal (copy), v57 (copy), v63 (copy), FocusUtils (copy), v72 (copy), FFlagShowUnibarOnVirtualCursor (copy), GamepadService (copy), GuiService (copy), Constants2 (copy)
		if p4 == ControlState.Hover then
			local v84

			if isSpatial() then
				local v82 = Service:showTopBar()
				local v83 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

				v84 = not v82 and not v83
			else
				v84 = false
			end

			if v84 then
				return
			end

			v58.current = true
			menuIconHoveredSignal:fire(true)
			task.delay(0.65, function() -- line: 194
				-- upvalues: v58 (copy), v57 (copy), isSpatial (copy), Service (copy), UIManager (copy), v63 (copy)
				if v58.current and not v57.current then
					local v98

					if isSpatial() then
						local v96 = Service:showTopBar()
						local v97 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

						v98 = not v96 and not v97
					else
						v98 = false
					end

					if v98 then
						return
					end

					v63(true)
				end
			end)
		elseif p4 == ControlState.Selected then
			FocusUtils.MenuIconSelectedSignal:set(true)
		elseif p4 == ControlState.Default then
			if v72.current == ControlState.Hover then
				v63(false)
				v58.current = false
				v57.current = false
			elseif v72.current == ControlState.Selected then
				if (not FFlagShowUnibarOnVirtualCursor or not GamepadService.GamepadCursorEnabled) and GuiService.SelectedCoreObject and string.find(GuiService.SelectedCoreObject.Name, Constants2.ICON_NAME_PREFIX) then
					Service:enableFocusNav()
				end

				FocusUtils.MenuIconSelectedSignal:set(false)
			end
		end

		v72.current = p4
	end, {})
	local v74 = React.useCallback(function() -- line: 220
		-- upvalues: v63 (copy), v57 (copy), isSpatial (copy), Service (copy), UIManager (copy), ParentParentParent (copy), InGameMenuConstants (copy)
		v63(false)
		v57.current = true

		local v87

		if isSpatial() then
			local v85 = Service:showTopBar()
			local v86 = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()

			v87 = not v85 and not v86
		else
			v87 = false
		end

		if v87 then
			return
		end

		require(ParentParentParent.Settings.SettingsHub):ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
	end, {})

	local function renderWithTooltipCompat(p5, p6, p7) -- line: 231
		-- upvalues: isSpatial (copy), v65 (copy), v67 (copy), React (copy), TooltipCallout (copy), TooltipOrientation (copy), v66 (copy), v64 (copy), SPATIAL_TOOLTIP_SPACING (copy), Panel3DInSpatialUI (copy), PanelType (copy), withTooltip (copy)
		if isSpatial() then
			local v91 = React.useCallback(function(vector2: Vector2) -- line: 238
				-- upvalues: React (copy), TooltipCallout (copy), p5 (copy), TooltipOrientation (copy), v66 (copy), v64 (copy), SPATIAL_TOOLTIP_SPACING (copy)
				return React.createElement(TooltipCallout, {
					distanceOffset = 0,
					textAlignment = Enum.TextXAlignment.Center,
					headerText = p5.headerText,
					orientation = TooltipOrientation.Top,
					triggerPointCenter = Vector2.new(v66.X + v64.X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING),
					contentOffsetVector = Vector2.zero,
					triggerPointRadius = Vector2.zero
				})
			end, {
				p5,
				v66,
				v64
			})

			return React.createElement(React.Fragment, nil, {
				VRSpatialTooltip = if not p6.active or (not v64 or not Panel3DInSpatialUI) then nil else React.createElement(Panel3DInSpatialUI, {
					panelType = PanelType.ToolTipsContainer,
					renderFunction = v91
				}),
				MenuIconTriggerPoint = p7(function(p8) -- line: 234
					-- upvalues: v65 (copy), v67 (copy)
					v65(p8.AbsoluteSize)
					v67(p8.AbsolutePosition)
				end)
			})
		end

		return withTooltip(p5, p6, p7)
	end

	return renderWithTooltipCompat(t3, t4, (React.useCallback(function(p9) -- line: 272
		-- upvalues: React (copy), View (copy), FFlagEnableSideSheet (copy), v55 (copy), v47 (copy), u59 (ref), v68 (copy), t2 (copy), v74 (copy), v73 (copy), BadgeOver12 (copy), v50 (copy), Icon (copy), Foundation (copy), v53 (copy)
		return React.createElement(View, {
			tag = "radius-circle aspect-1-1",
			backgroundStyle = if FFlagEnableSideSheet then nil else v55:map(function(p10) -- line: 276
				-- upvalues: v47 (copy)
				local OverMedia_0 = v47.Color.OverMedia.OverMedia_0

				OverMedia_0.Transparency = OverMedia_0.Transparency * p10

				return OverMedia_0
			end),
			Size = UDim2.fromScale(1, 1),
			NextSelectionRight = u59,
			selection = {
				Selectable = true,
				SelectionImageObject = v68
			},
			selectionGroup = {
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			},
			ref = t2.menuIconRef,
			onAbsoluteSizeChanged = p9,
			onAbsolutePositionChanged = p9,
			onActivated = if FFlagEnableSideSheet then nil else v74,
			onStateChanged = if FFlagEnableSideSheet then nil else v73
		}, {
			BadgeOver12 = if not t2.showBadgeOver12 then nil else React.createElement(BadgeOver12, {
				position = UDim2.new(0, 1, 1, -(v50 + 1))
			}),
			Icon = React.createElement(Icon, {
				name = Foundation.Enums.IconName.Tilt,
				size = v53.size,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				style = if not FFlagEnableSideSheet then nil else v47.Color.ActionEmphasis.Foreground
			})
		})
	end, {
		v55,
		u59,
		v68,
		v74,
		v73,
		t2.showBadgeOver12
	})))
end

return MenuIcon

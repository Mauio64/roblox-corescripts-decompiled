require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local FFlagProfileTradeItemsExposureLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileTradeItemsExposureLogging")
local FFlagProfileTradeItemsImpressionLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileTradeItemsImpressionLogging")
local useTradeItemsExposureLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useTradeItemsExposureLogger")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local contextualMenuContainsAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/contextualMenuContainsAction")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local FFlagProfileGamepadPrimaryActionFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileGamepadPrimaryActionFocus")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useComposedRef = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ReactUtils").useComposedRef
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ContextualMenu")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local button = Foundation.Button
local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior

local function CTAButton(props)
	local state, setState = React.useState(false)

	local v5 = if FFlagProfileTradeItemsExposureLogging then useTradeItemsExposureLogger() else nil

	local v6 = if FFlagProfileTradeItemsImpressionLogging then useProfileAnalyticsContext() else nil

	local v7 = React.useCallback(function()
		setState(false)
	end, {})

	local v8 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v9 = React.useMemo(function()
		local v10 = {}
		v10[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(v7)
		}

		return v10
	end, { v7 })

	local v10 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = v9,
		isAutoFocusRoot = true,
		isFocusable = state
	})

	local ref = React.useRef(nil)

	local menuItem = props.buttonItem.menuItem
	local v11

	if FFlagProfileGamepadPrimaryActionFocus then
		v11 = useComposedRef(ref, (FocusNavigationUtils.useFocusOnMount()))
		local v13 = useProfileWrapperContext()

		if
			props.layoutOrder ~= 1
			or menuItem.id == Enums.ProfileActions.ContextualOverflow
			or v13.headerVariant == Enums.ProfileTabVariants.MeTab
		then
			v11 = ref
		end
	end

	local displayValue = menuItem.displayValue
	local icon = displayValue.icon
	local text = displayValue.text
	local contextualMenuItems = props.buttonItem.contextualMenuItems
	local v12

	if props.buttonItem.buttonStyle then
		v12 = props.buttonItem.buttonStyle
	else
		v12 = buttonVariant.Standard
	end

	local v13 = contextualMenuItems and #contextualMenuItems > 0
	local isDisabled = props.buttonItem.menuItem.isDisabled

	local useCallback = React.useCallback
	local function fn()
		if FFlagProfileTradeItemsExposureLogging and menuItem.id == Enums.ProfileActions.ContextualOverflow and not state then
			v5()
		end

		if
			FFlagProfileTradeItemsImpressionLogging
			and menuItem.id == Enums.ProfileActions.ContextualOverflow
			and not state
			and contextualMenuContainsAction(contextualMenuItems, Enums.ProfileActions.TradeItems)
		then
			v6.fireAnalyticsEvent(EventNames.ContextualMenuTradeItemsImpression, {
				buttonSurface = Enums.ButtonSurface.ContextualMenu
			})
		end

		if not v13 then
			menuItem.onActivated()

			return
		end

		if not state then
			menuItem.onActivated()
		end

		v8()
	end

	local id = menuItem.id
	local onActivated = menuItem.onActivated
	local v15 = if FFlagProfileTradeItemsExposureLogging then v5 else nil
	local v16 = if FFlagProfileTradeItemsImpressionLogging then v6 else nil
	local v18 = useCallback(fn, {
		v13,
		state,
		id,
		onActivated,
		v8,
		v15,
		v16,
		if FFlagProfileTradeItemsImpressionLogging then contextualMenuItems else nil
	})

	local v19 = not (icon == nil) and text == nil
	local v20

	if v19 then
		local createElement = React.createElement
		local v22 = {
			icon = icon,
			LayoutOrder = props.layoutOrder,
			onActivated = v18,
			variant = buttonVariant.Standard,
			ref = 0,
			isDisabled = 0
		}

		if not FFlagProfileGamepadPrimaryActionFocus then
			v11 = ref
		end

		v22.ref = v11
		v22.isDisabled = isDisabled
		v20 = createElement(iconButton, v22)
	else
		local createElement = React.createElement
		local v22 = {
			text = text,
			icon = icon,
			onActivated = v18,
			fillBehavior = fillBehavior.Fill,
			variant = v12,
			isLoading = props.buttonItem.isLoading,
			LayoutOrder = props.layoutOrder,
			ref = 0,
			isDisabled = 0
		}

		if not FFlagProfileGamepadPrimaryActionFocus then
			v11 = ref
		end

		v22.ref = v11
		v22.isDisabled = isDisabled
		v20 = createElement(button, v22)
	end

	local createElement = React.createElement
	local v22 = {
		tag = {
			["auto-xy"] = v19,
			["fill auto-y"] = not v19
		},
		LayoutOrder = props.layoutOrder
	}

	local v24 = if v13 then React.createElement(module13, {
		isOpen = state,
		menuItems = contextualMenuItems,
		anchorRef = ref,
		menuRef = v10,
		closeMenu = v7,
		align = props.align
	}) else nil
	return createElement(view, v22, { Button = v20, ContextualMenu = v24 })
end

return CTAButton

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
require(ProfilePlatform.Components.CTARow.Types)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfileTradeItemsExposureLogging = require(ProfilePlatform.Flags.FFlagProfileTradeItemsExposureLogging)
local FFlagProfileTradeItemsImpressionLogging = require(ProfilePlatform.Flags.FFlagProfileTradeItemsImpressionLogging)
local useTradeItemsExposureLogger = require(ProfilePlatform.Hooks.useTradeItemsExposureLogger)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local contextualMenuContainsAction = require(ProfilePlatform.Utils.contextualMenuContainsAction)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local FFlagProfileGamepadPrimaryActionFocus = require(ProfilePlatform.Flags.FFlagProfileGamepadPrimaryActionFocus)

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useComposedRef = ReactUtils.useComposedRef
require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local ContextualMenu = require(ProfilePlatform.Components.CTARow.ContextualMenu)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior

local function CTAButton(props)
	local state, setState = React.useState(false)
	local v

	if FFlagProfileTradeItemsExposureLogging then
		v = useTradeItemsExposureLogger()
	else
		v = nil
	end

	local v2

	if FFlagProfileTradeItemsImpressionLogging then
		v2 = useProfileAnalyticsContext()
	else
		v2 = nil
	end

	local closeMenu = React.useCallback(function()
		setState(false)
	end, {})

	local v3 = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	local customEventHandlers = React.useMemo(function()
		local v4 = {}
		v4[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(closeMenu)
		}

		return v4
	end, { closeMenu })

	local menuRef = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = customEventHandlers,
		isAutoFocusRoot = true,
		isFocusable = state
	})

	local ref = React.useRef(nil)

	local menuItem = props.buttonItem.menuItem
	local ref2

	if FFlagProfileGamepadPrimaryActionFocus then
		ref2 = useComposedRef(ref, (FocusNavigationUtils.useFocusOnMount()))
		local v4 = useProfileWrapperContext()

		if
			props.layoutOrder ~= 1
			or menuItem.id == Enums.ProfileActions.ContextualOverflow
			or v4.headerVariant == Enums.ProfileTabVariants.MeTab
		then
			ref2 = ref
		end
	end

	local displayValue = menuItem.displayValue
	local icon = displayValue.icon
	local text = displayValue.text
	local contextualMenuItems = props.buttonItem.contextualMenuItems
	local variant

	if props.buttonItem.buttonStyle then
		variant = props.buttonItem.buttonStyle
	else
		variant = ButtonVariant.Standard
	end

	local v4 = contextualMenuItems and #contextualMenuItems > 0
	local isDisabled = props.buttonItem.menuItem.isDisabled

	local useCallback = React.useCallback
	local function fn()
		if
			FFlagProfileTradeItemsExposureLogging
			and menuItem.id == Enums.ProfileActions.ContextualOverflow
			and not state
		then
			v()
		end

		if
			FFlagProfileTradeItemsImpressionLogging
			and menuItem.id == Enums.ProfileActions.ContextualOverflow
			and not state
			and contextualMenuContainsAction(contextualMenuItems, Enums.ProfileActions.TradeItems)
		then
			v2.fireAnalyticsEvent(EventNames.ContextualMenuTradeItemsImpression, {
				buttonSurface = Enums.ButtonSurface.ContextualMenu
			})
		end

		if not v4 then
			menuItem.onActivated()

			return
		end

		if not state then
			menuItem.onActivated()
		end

		v3()
	end

	local id = menuItem.id
	local onActivated = menuItem.onActivated
	local v5

	if FFlagProfileTradeItemsExposureLogging then
		v5 = v
	end

	local v6

	if FFlagProfileTradeItemsImpressionLogging then
		v6 = v2
	end

	local v7

	if FFlagProfileTradeItemsImpressionLogging then
		v7 = contextualMenuItems
	end

	local onActivated2 = useCallback(fn, { v4, state, id, onActivated, v3, v5, v6, v7 })
	local autoxy

	if icon == nil then
		autoxy = false
	else
		autoxy = text == nil
	end

	local button

	if autoxy then
		local createElement = React.createElement
		local v8 = {
			icon = icon,
			LayoutOrder = props.layoutOrder,
			onActivated = onActivated2,
			variant = ButtonVariant.Standard,
			ref = 0,
			isDisabled = 0
		}

		if not FFlagProfileGamepadPrimaryActionFocus then
			ref2 = ref
		end

		v8.ref = ref2
		v8.isDisabled = isDisabled
		button = createElement(IconButton, v8)
	else
		local createElement = React.createElement
		local v8 = {
			text = text,
			icon = icon,
			onActivated = onActivated2,
			fillBehavior = FillBehavior.Fill,
			variant = variant,
			isLoading = props.buttonItem.isLoading,
			LayoutOrder = props.layoutOrder,
			ref = 0,
			isDisabled = 0
		}

		if not FFlagProfileGamepadPrimaryActionFocus then
			ref2 = ref
		end

		v8.ref = ref2
		v8.isDisabled = isDisabled
		button = createElement(Button, v8)
	end

	local createElement = React.createElement
	local v8 = {
		tag = {
			["auto-xy"] = autoxy,
			["fill auto-y"] = not autoxy
		},
		LayoutOrder = props.layoutOrder
	}
	local contextualMenu

	if v4 then
		contextualMenu = React.createElement(ContextualMenu, {
			isOpen = state,
			menuItems = contextualMenuItems,
			anchorRef = ref,
			menuRef = menuRef,
			closeMenu = closeMenu,
			align = props.align
		})
	end

	return createElement(View, v8, { Button = button, ContextualMenu = contextualMenu })
end

return CTAButton

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)

local React = require(ProfilePlatformParent.React)

require(ProfilePlatformParent.ReactFocusNavigation)

local InputHandlers = require(ProfilePlatformParent.InputHandlers)
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local ContextualMenu = require(ProfilePlatform.Components.CTARow.ContextualMenu)
local FFlagAddCTAButtonAnalytics = require(ProfilePlatform.Flags.FFlagAddCTAButtonAnalytics)
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior

local function CTAButton(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ButtonVariant (copy), FFlagAddCTAButtonAnalytics (copy), IconButton (copy), Button (copy), FillBehavior (copy), View (copy), ContextualMenu (copy)
	local v19, v20 = React.useState(false)
	local v21 = React.useCallback(function() -- line: 45
		-- upvalues: v20 (copy)
		v20(false)
	end, {})
	local v22 = React.useCallback(function() -- line: 49
		-- upvalues: v20 (copy)
		v20(function(p1) -- line: 50
			return not p1
		end)
	end, {})
	local v23 = React.useMemo(function() -- line: 55
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v21 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(v21)
			}
		}
	end, { v21 })
	local v24 = useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = v23,
		isFocusable = v19
	})
	local v25 = React.useRef(nil)
	local menuItem = t1.buttonItem.menuItem
	local displayValue = menuItem.displayValue
	local icon = displayValue.icon
	local text = displayValue.text
	local contextualMenuItems = t1.buttonItem.contextualMenuItems
	local v31 = if not t1.buttonItem.buttonStyle then ButtonVariant.Standard else t1.buttonItem.buttonStyle
	local v32 = contextualMenuItems and #contextualMenuItems > 0
	local isDisabled = t1.buttonItem.menuItem.isDisabled
	local v34 = if not FFlagAddCTAButtonAnalytics then if not v32 then menuItem.onActivated else v22 else React.useCallback(function() -- line: 81
		-- upvalues: v32 (copy), v19 (copy), menuItem (copy), v22 (copy)
		if v32 then
			if not v19 then
				menuItem.onActivated()
			end

			v22()

			return
		end

		menuItem.onActivated()
	end, {
		v32,
		v19,
		menuItem.onActivated,
		v22
	})
	local v35 = icon ~= nil and text == nil
	local v36 = if not v35 then React.createElement(Button, {
		text = text,
		icon = icon,
		onActivated = v34,
		fillBehavior = FillBehavior.Fill,
		variant = v31,
		isLoading = t1.buttonItem.isLoading,
		LayoutOrder = t1.layoutOrder,
		ref = v25,
		isDisabled = isDisabled
	}) else React.createElement(IconButton, {
		icon = icon,
		LayoutOrder = t1.layoutOrder,
		onActivated = v34,
		variant = ButtonVariant.Standard,
		ref = v25,
		isDisabled = isDisabled
	})

	return React.createElement(View, {
		tag = {
			["auto-xy"] = v35,
			["fill auto-y"] = not v35
		},
		LayoutOrder = t1.layoutOrder
	}, {
		Button = v36,
		ContextualMenu = if not v32 then nil else React.createElement(ContextualMenu, {
			isOpen = v19,
			menuItems = contextualMenuItems,
			anchorRef = v25,
			menuRef = v24,
			closeMenu = v21,
			align = t1.align
		})
	})
end

return CTAButton

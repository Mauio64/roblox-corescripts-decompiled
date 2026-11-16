local parent = script:FindFirstAncestor("CurrencyTransfers").Parent

local React = require(parent.React)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useTransferSheetFocus(callback)
	local eventHandlers = React.useMemo(function()
		local v = {}
		v[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				callback()
				object:cancel()
			end)
		}

		return v
	end, { callback })

	local v, v2 = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))
	return v2, (useFocusOnMount(v))
end

return useTransferSheetFocus

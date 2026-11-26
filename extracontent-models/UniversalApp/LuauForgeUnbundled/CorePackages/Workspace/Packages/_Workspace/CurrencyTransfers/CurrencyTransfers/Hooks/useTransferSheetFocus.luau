local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/ReactFocusNavigation")

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useTransferSheetFocus(callback)
	local v5 = React.useMemo(function()
		local v6 = {}
		v6[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				callback()
				object:cancel()
			end)
		}

		return v6
	end, { callback })

	local v7, v8 = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = v5,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))
	return v8, (useFocusOnMount(v7))
end

return useTransferSheetFocus

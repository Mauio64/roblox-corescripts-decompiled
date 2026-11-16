local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactFocusNavigation")

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useClosableFocusRoot(data)
	local onClose = data.onClose
	local v5 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })
	return useFocusRoot({
		surfaceIdentifier = data.surfaceIdentifier,
		isFocusable = data.isOpen,
		isAutoFocusRoot = true,
		shouldRestoreFocus = data.shouldRestoreFocus,
		eventMap = navigateBacks,
		eventHandlers = v5
	})
end

return useClosableFocusRoot

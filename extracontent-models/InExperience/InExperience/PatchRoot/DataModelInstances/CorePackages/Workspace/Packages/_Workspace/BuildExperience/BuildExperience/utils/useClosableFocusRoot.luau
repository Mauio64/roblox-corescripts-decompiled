local parent = script:FindFirstAncestor("BuildExperience").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useClosableFocusRoot(data)
	local onClose = data.onClose
	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
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
		eventHandlers = eventHandlers
	})
end

return useClosableFocusRoot

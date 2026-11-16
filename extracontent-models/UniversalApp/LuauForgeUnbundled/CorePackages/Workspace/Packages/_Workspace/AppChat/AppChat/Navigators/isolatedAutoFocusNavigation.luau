local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local autoFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/autoFocusNavigation")

local function isolatedAutoFocusNavigation(p2, p3, callback)
	return function(p4)
		local v5 = React.useMemo(function()
			return {
				[focusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						if callback then
							callback(p4)
							object:cancel()
						end
					end)
				}
			}
		end, { callback })

		local createElement = React.createElement
		local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
		local v6 = {
			surfaceIdentifier = p3,
			isIsolated = true,
			shouldRestoreFocus = true,
			isAutoFocusRoot = false,
			isFocusable = true,
			customEventHandlers = nil
		}

		if not callback then
			v5 = nil
		end

		v6.customEventHandlers = v5
		return createElement(focusNavigableSurfaceWrapper, v6, {
			content = React.createElement(autoFocusNavigation(p2), p4)
		})
	end
end

return isolatedAutoFocusNavigation

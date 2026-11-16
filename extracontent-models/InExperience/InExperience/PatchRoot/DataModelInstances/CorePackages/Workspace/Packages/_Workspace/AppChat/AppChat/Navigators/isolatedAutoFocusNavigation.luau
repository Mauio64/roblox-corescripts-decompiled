local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local autoFocusNavigation = require(script.Parent.autoFocusNavigation)

local function isolatedAutoFocusNavigation(p, surfaceIdentifier, callback)
	return function(p2)
		local customEventHandlers = React.useMemo(function()
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						if callback then
							callback(p2)
							object:cancel()
						end
					end)
				}
			}
		end, { callback })

		local createElement = React.createElement
		local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
		local v = {
			surfaceIdentifier = surfaceIdentifier,
			isIsolated = true,
			shouldRestoreFocus = true,
			isAutoFocusRoot = false,
			isFocusable = true,
			customEventHandlers = nil
		}

		if not callback then
			customEventHandlers = nil
		end

		v.customEventHandlers = customEventHandlers
		return createElement(focusNavigableSurfaceWrapper, v, {
			content = React.createElement(autoFocusNavigation(p), p2)
		})
	end
end

return isolatedAutoFocusNavigation

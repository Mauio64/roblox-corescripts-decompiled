local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local autoFocusNavigation = require(script.Parent.autoFocusNavigation)

local function isolatedAutoFocusNavigation(p1, p2, p3: ((...any) -> ...any)?) -- line: 13
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusNavigationUtils (copy), autoFocusNavigation (copy)
	return function(p4) -- line: 18
		-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), p3 (copy), FocusNavigationUtils (copy), p2 (copy), autoFocusNavigation (copy), p1 (copy)
		local v12 = React.useMemo(function() -- line: 19
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p3 (copy), p4 (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p5) -- line: 22
						-- upvalues: p3 (copy), p4 (copy)
						if p3 then
							p3(p4)
							p5:cancel()
						end
					end)
				}
			}
		end, { p3 })

		return React.createElement(FocusNavigationUtils.FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			shouldRestoreFocus = true,
			isAutoFocusRoot = false,
			isFocusable = true,
			surfaceIdentifier = p2,
			customEventHandlers = if not p3 then nil else v12
		}, {
			content = React.createElement(autoFocusNavigation(p1), p4)
		})
	end
end

return isolatedAutoFocusNavigation

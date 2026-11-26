local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module = require("@luauforge/bundled/ehL")
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local function ConsoleVideoFocusBinding(data)
	local v5 = React.useMemo(function()
		if not data.enabled then
			return {}
		end

		return { [Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.Mute }
	end, { data.enabled })

	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.Mute] = {
				handler = InputHandlers.onRelease(function()
					if data.toggleMuteSignal then
						data.toggleMuteSignal:fire()
					end
				end)
			}
		}
	end, { data.toggleMuteSignal })

	local v7 = ReactFocusNavigation.useEventMap(v5)
	local v8 = ReactFocusNavigation.useEventHandlerMap(v6, v7)

	return data.render(v8)
end

return ConsoleVideoFocusBinding

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/InputHandlers")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/ReactFocusNavigation")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

return {
	useGameJoinCardGamepadNavigation = function(callback, p2)
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
			shouldRestoreFocus = false,
			isFocusable = p2
		})))
		local v9 = useFocusOnMount(v7)

		if not p2 then
			v9 = v7
		end

		return { rootRef = v8, primaryButtonFocusRef = v9 }
	end,
	assignPrimaryFocusRef = function(list, focusRef)
		if list == nil or focusRef == nil or list[1] == nil then
			return list
		end

		local clone = table.clone(list)
		local clone2 = table.clone(list[1])
		clone2.focusRef = focusRef
		clone[1] = clone2
		return clone
	end
}

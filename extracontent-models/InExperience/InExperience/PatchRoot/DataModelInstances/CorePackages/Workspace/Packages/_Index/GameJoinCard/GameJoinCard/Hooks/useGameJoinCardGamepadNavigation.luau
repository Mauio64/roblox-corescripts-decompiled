local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior

require(GameJoinCard.Components.Actions.Types)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}
local UseGameJoinCardGamepadNavigation = {}

function UseGameJoinCardGamepadNavigation.useGameJoinCardGamepadNavigation(callback, isFocusable: boolean)
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

	local v, rootRef = useMostRecentOrDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		isFocusable = isFocusable
	})))
	local primaryButtonFocusRef = useFocusOnMount(v)

	if not isFocusable then
		primaryButtonFocusRef = v
	end

	return { rootRef = rootRef, primaryButtonFocusRef = primaryButtonFocusRef }
end

function UseGameJoinCardGamepadNavigation.assignPrimaryFocusRef(list, focusRef)
	if list == nil or focusRef == nil or list[1] == nil then
		return list
	end

	local clone = table.clone(list)
	local clone2 = table.clone(list[1])
	clone2.focusRef = focusRef
	clone[1] = clone2
	return clone
end

return UseGameJoinCardGamepadNavigation

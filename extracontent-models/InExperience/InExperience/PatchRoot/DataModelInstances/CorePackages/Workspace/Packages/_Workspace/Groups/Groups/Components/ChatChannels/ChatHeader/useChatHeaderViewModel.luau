local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)
local UserLib = require(parent.UserLib)

require(script.Parent.ChatHeaderView)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useChatHeaderViewModel(data)
	local state, setState = React.useState(false)

	local onCloseMenu = React.useCallback(function()
		setState(false)
	end, {})

	local onToggleMenu = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	local menuItems = React.useMemo(function()
		local result = {}

		for k, v in data.overflowActions or {} do
			table.insert(result, {
				id = tostring(k),
				text = v.title,
				onActivated = function()
					onCloseMenu()
					v.action()
				end
			})
		end

		return result
	end, { data.overflowActions, onCloseMenu })

	local v = #menuItems > 0

	React.useEffect(function()
		if not v then
			setState(false)
		end
	end, { v })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCloseMenu()
					object:cancel()
				end)
			}
		}
	end, { onCloseMenu })

	local menuRef = FocusNavigationUtils.useFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state and v,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local isUserIcon = data.iconType == "user"
	local icon

	if isUserIcon then
		icon = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions(
			tostring(data.iconTargetId),
			UserLib.Utils.Constants.RbxthumbTypes.AvatarHeadShot,
			150
		)
	else
		icon = `rbxassetid://{data.iconTargetId}`
	end

	return {
		title = data.title,
		subtitle = data.subtitle,
		icon = icon,
		isUserIcon = isUserIcon,
		ctaButton = data.ctaButton,
		onClick = data.onClick,
		menuItems = menuItems,
		isMenuOpen = state,
		onToggleMenu = onToggleMenu,
		onCloseMenu = onCloseMenu,
		menuRef = menuRef,
		LayoutOrder = data.LayoutOrder,
		testId = data.testId or "--groups-chat-header"
	}
end

return useChatHeaderViewModel

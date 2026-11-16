local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local threeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function CommentActionsMenu(props)
	local onClose = props.onClose
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

	local v6 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = props.isOpen,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v5
	})

	local createElement = React.createElement
	local menu = Foundation.Menu
	local v7 = {
		isOpen = props.isOpen,
		items = props.items,
		side = 0,
		align = 0,
		anchorRef = 0,
		onPressedOutside = 0,
		ref = 0,
		LayoutOrder = 0,
		testId = 0
	}

	local v8 = if props.anchorRef == nil then popoverSide.Bottom else popoverSide.Top
	v7.side = v8
	v7.align = popoverAlign.End
	v7.anchorRef = props.anchorRef
	v7.onPressedOutside = onClose
	v7.ref = v6
	v7.LayoutOrder = props.LayoutOrder
	v7.testId = `moments-comment-actions-menu-{props.commentId}`
	return createElement(menu, v7, props.anchorRef == nil and {
		Button = React.createElement(Foundation.IconButton, {
			icon = threeDotsHorizontal,
			isCircular = true,
			size = inputSize.XSmall,
			onActivated = props.onButtonActivated,
			testId = `moments-comment-actions-button-{props.commentId}`
		})
	} or nil)
end

return CommentActionsMenu

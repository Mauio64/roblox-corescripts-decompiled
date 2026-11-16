local parent = script:FindFirstAncestor("Moments").Parent

local BuilderIcons = require(parent.BuilderIcons)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local ThreeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function CommentActionsMenu(props)
	local onClose = props.onClose
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

	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = props.isOpen,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local createElement = React.createElement
	local menu = Foundation.Menu
	local v = {
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
	local side

	if props.anchorRef == nil then
		side = PopoverSide.Bottom
	else
		side = PopoverSide.Top
	end

	v.side = side
	v.align = PopoverAlign.End
	v.anchorRef = props.anchorRef
	v.onPressedOutside = onClose
	v.ref = ref
	v.LayoutOrder = props.LayoutOrder
	v.testId = `moments-comment-actions-menu-{props.commentId}`
	return createElement(menu, v, props.anchorRef == nil and {
		Button = React.createElement(Foundation.IconButton, {
			icon = ThreeDotsHorizontal,
			isCircular = true,
			size = InputSize.XSmall,
			onActivated = props.onButtonActivated,
			testId = `moments-comment-actions-button-{props.commentId}`
		})
	} or nil)
end

return CommentActionsMenu

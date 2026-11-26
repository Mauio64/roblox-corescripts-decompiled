local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/ReactFocusNavigation")

local ReactionPicker = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionPicker")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local usePressGestures = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Hooks/usePressGestures")
local useReactionDragSelect = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Hooks/useReactionDragSelect")
local toGuiSpace = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/toGuiSpace")

local popover = Foundation.Popover
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local v5 = {
	[Enum.KeyCode.ButtonB] = "NavigateBack",
	[Enum.KeyCode.Escape] = "NavigateBack"
}

local function ReactionPickerPopover(props)
	local v6 = useTokens()
	local v7 = useReactionDragSelect(props.onReactionSelected)

	local onOpen = props.onOpen
	local onDoubleTap = props.onDoubleTap
	usePressGestures(props.anchorRef, {
		onTap = props.onTap or onOpen,
		onDoubleTap = onDoubleTap and function(p2)
			local current = props.anchorRef.current

			if typeof(current) == "Instance" then
				p2 = toGuiSpace(p2, current)
			end

			onDoubleTap(p2)
		end or nil,
		onHold = onOpen and function()
			if not props.isOpen then
				onOpen()
			end
		end or nil,
		onHoldMoved = v7.onDragMoved,
		onHoldEnded = v7.onDragEnded,
		holdDuration = props.holdDuration
	})

	local onDismiss = props.onDismiss
	local v8 = React.useMemo(function()
		return {
			NavigateBack = {
				handler = InputHandlers.onRelease(function()
					if onDismiss then
						onDismiss()
					end
				end)
			}
		}
	end, { onDismiss })
	local v9 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = props.isOpen,
		isAutoFocusRoot = true,
		eventMap = v5,
		eventHandlers = v8
	})

	return React.createElement(popover.Root, { isOpen = props.isOpen }, {
		Anchor = React.createElement(popover.Anchor, { anchorRef = props.anchorRef }),
		Content = React.createElement(popover.Content, {
			side = props.side or popoverSide.Top,
			align = props.align,
			hasArrow = false,
			radius = props.radius or radius.Circle,
			backgroundStyle = v6.Color.None,
			onPressedOutside = onDismiss,
			ref = v9
		}, {
			Picker = React.createElement(ReactionPicker, {
				onReactionSelected = props.onReactionSelected,
				selectedReactions = props.selectedReactions,
				reactions = props.reactions,
				reactionSize = props.reactionSize,
				radius = props.radius,
				backgroundStyle = props.backgroundStyle,
				hoveredReaction = v7.hoveredReaction,
				getButtonRef = v7.getButtonRef,
				testId = props.testId
			})
		})
	})
end

return ReactionPickerPopover

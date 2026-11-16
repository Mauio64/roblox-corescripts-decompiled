local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local ReactionPicker = require(Reactions.Components.ReactionPicker)
require(Reactions.Enums.ReactionSize)
require(Reactions.Enums.ReactionType)
local usePressGestures = require(Reactions.Hooks.usePressGestures)
local useReactionDragSelect = require(Reactions.Hooks.useReactionDragSelect)
local toGuiSpace = require(Reactions.Utils.toGuiSpace)

local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local eventMap = { [Enum.KeyCode.ButtonB] = "NavigateBack", [Enum.KeyCode.Escape] = "NavigateBack" }

local function ReactionPickerPopover(props)
	local v = useTokens()
	local v2 = useReactionDragSelect(props.onReactionSelected)

	local onOpen = props.onOpen
	local onDoubleTap = props.onDoubleTap
	usePressGestures(props.anchorRef, {
		onTap = props.onTap or onOpen,
		onDoubleTap = onDoubleTap and function(vector2: Vector2)
			local current = props.anchorRef.current

			if typeof(current) == "Instance" then
				vector2 = toGuiSpace(vector2, current)
			end

			onDoubleTap(vector2)
		end or nil,
		onHold = onOpen and function()
			if not props.isOpen then
				onOpen()
			end
		end or nil,
		onHoldMoved = v2.onDragMoved,
		onHoldEnded = v2.onDragEnded,
		holdDuration = props.holdDuration
	})

	local onDismiss = props.onDismiss
	local eventHandlers = React.useMemo(function()
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
	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = props.isOpen,
		isAutoFocusRoot = true,
		eventMap = eventMap,
		eventHandlers = eventHandlers
	})

	return React.createElement(Popover.Root, { isOpen = props.isOpen }, {
		Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
		Content = React.createElement(Popover.Content, {
			side = props.side or PopoverSide.Top,
			align = props.align,
			hasArrow = false,
			radius = props.radius or Radius.Circle,
			backgroundStyle = v.Color.None,
			onPressedOutside = onDismiss,
			ref = ref
		}, {
			Picker = React.createElement(ReactionPicker, {
				onReactionSelected = props.onReactionSelected,
				selectedReactions = props.selectedReactions,
				reactions = props.reactions,
				reactionSize = props.reactionSize,
				radius = props.radius,
				backgroundStyle = props.backgroundStyle,
				hoveredReaction = v2.hoveredReaction,
				getButtonRef = v2.getButtonRef,
				testId = props.testId
			})
		})
	})
end

return ReactionPickerPopover

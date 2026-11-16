local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Reactions = require(parent.Reactions)

local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local PopoverAlign = Foundation.Enums.PopoverAlign

local function AddReactionButton(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local onDismiss = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated = React.useCallback(function()
		setState(function(flag: boolean): boolean
			return not flag
		end)
	end, {})

	local function selectReaction(p)
		onDismiss()
		props.onReactionSelected(p)
	end

	return React.createElement(React.Fragment, nil, {
		Button = React.createElement(IconButton, {
			icon = IconName.SquareFaceEmoji,
			isCircular = true,
			variant = ButtonVariant.Utility,
			onActivated = onActivated,
			LayoutOrder = props.layoutOrder,
			ref = ref,
			testId = "reaction-add"
		}),
		Picker = React.createElement(Reactions.ReactionPickerPopover, {
			isOpen = state,
			anchorRef = ref,
			align = PopoverAlign.Start,
			reactions = props.reactions,
			selectedReactions = props.selectedReactions,
			onReactionSelected = selectReaction,
			onDismiss = onDismiss
		})
	})
end

return AddReactionButton

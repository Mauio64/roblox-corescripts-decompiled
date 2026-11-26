local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Reactions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Reactions")

local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local popoverAlign = Foundation.Enums.PopoverAlign

local function AddReactionButton(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		setState(false)
	end, {})

	local v6 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local function selectReaction(p2)
		v5()
		props.onReactionSelected(p2)
	end

	return React.createElement(React.Fragment, nil, {
		Button = React.createElement(iconButton, {
			icon = iconName.SquareFaceEmoji,
			isCircular = true,
			variant = buttonVariant.Utility,
			onActivated = v6,
			LayoutOrder = props.layoutOrder,
			ref = ref,
			testId = "reaction-add"
		}),
		Picker = React.createElement(Reactions.ReactionPickerPopover, {
			isOpen = state,
			anchorRef = ref,
			align = popoverAlign.Start,
			reactions = props.reactions,
			selectedReactions = props.selectedReactions,
			onReactionSelected = selectReaction,
			onDismiss = v5
		})
	})
end

return AddReactionButton

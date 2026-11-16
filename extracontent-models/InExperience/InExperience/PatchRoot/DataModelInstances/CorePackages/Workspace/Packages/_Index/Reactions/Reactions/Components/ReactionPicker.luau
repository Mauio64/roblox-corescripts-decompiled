local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Constants = require(Reactions.Constants)
local ReactionButton = require(Reactions.Components.ReactionButton)
require(Reactions.Enums.ReactionSize)
require(Reactions.Enums.ReactionType)

local Radius = Foundation.Enums.Radius
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ReactionPicker(props)
	local v = useTokens()
	local reactions = props.reactions or Constants.PossibleReactions
	local testId = props.testId or "reaction-picker"
	local selectedReactions = props.selectedReactions
	local radius = props.radius or Radius.Circle

	local v2 = React.useMemo(function()
		local children = {}

		for k, reaction in reactions do
			local createElement = React.createElement
			local v2 = {
				reactionType = reaction,
				isActive = selectedReactions ~= nil and selectedReactions[reaction] == true,
				isHovered = props.hoveredReaction == reaction,
				reactionSize = props.reactionSize,
				buttonRef = 0,
				onActivated = 0,
				entryDelay = 0,
				layoutOrder = 0,
				testId = 0
			}
			local buttonRef

			if props.getButtonRef then
				buttonRef = props.getButtonRef(reaction)
			end

			v2.buttonRef = buttonRef
			function v2.onActivated(vector2: Vector2)
				props.onReactionSelected(reaction, vector2)
			end
			v2.entryDelay = (k - 1) * 0.04
			v2.layoutOrder = k
			v2.testId = `{testId}--{reaction}`
			children[reaction] = createElement(ReactionButton, v2)
		end

		return children
	end, {
		reactions,
		selectedReactions,
		props.hoveredReaction,
		props.reactionSize,
		props.getButtonRef,
		props.onReactionSelected,
		testId
	})

	return React.createElement(View, {
		tag = {
			["row gap-xxsmall auto-xy padding-small stroke-standard stroke-default"] = true,
			["radius-small"] = radius == Radius.Small,
			["radius-medium"] = radius == Radius.Medium,
			["radius-circle"] = radius == Radius.Circle
		},
		backgroundStyle = props.backgroundStyle or v.Color.Surface.Surface_200,
		LayoutOrder = props.layoutOrder,
		testId = testId
	}, v2)
end

return ReactionPicker

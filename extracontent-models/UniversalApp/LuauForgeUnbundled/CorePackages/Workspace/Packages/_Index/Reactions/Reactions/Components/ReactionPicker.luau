local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Constants")
local ReactionButton = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionButton")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")

local radius = Foundation.Enums.Radius
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ReactionPicker(props)
	local v5 = useTokens()
	local reactions = props.reactions or Constants.PossibleReactions
	local testId = props.testId or "reaction-picker"
	local selectedReactions = props.selectedReactions
	local radius2 = props.radius or radius.Circle

	local v6 = React.useMemo(function()
		local children = {}

		for k, reaction in reactions do
			local createElement = React.createElement
			local v8 = {
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
			local v10 = if props.getButtonRef then props.getButtonRef(reaction) else nil
			v8.buttonRef = v10
			function v8.onActivated(p2)
				props.onReactionSelected(reaction, p2)
			end
			v8.entryDelay = (k - 1) * 0.04
			v8.layoutOrder = k
			v8.testId = `{testId}--{reaction}`
			children[reaction] = createElement(ReactionButton, v8)
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

	return React.createElement(view, {
		tag = {
			["row gap-xxsmall auto-xy padding-small stroke-standard stroke-default"] = true,
			["radius-small"] = radius2 == radius.Small,
			["radius-medium"] = radius2 == radius.Medium,
			["radius-circle"] = radius2 == radius.Circle
		},
		backgroundStyle = props.backgroundStyle or v5.Color.Surface.Surface_200,
		LayoutOrder = props.layoutOrder,
		testId = testId
	}, v6)
end

return ReactionPicker

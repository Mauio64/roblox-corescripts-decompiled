local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Constants")
local ReactionSize = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")

local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function getSizeToken(p2, p3)
	if p3 == ReactionSize.XSmall then
		return p2.Size.Size_500
	end

	if p3 == ReactionSize.Small then
		return p2.Size.Size_600
	end

	if p3 == ReactionSize.Large then
		return p2.Size.Size_1200
	end

	return p2.Size.Size_800
end

local function Reaction(props)
	local v5 = useTokens()
	local v6

	if typeof(props.reactionType) == "string" then
		v6 = Constants.ReactionIconMappings[props.reactionType]
	else
		v6 = props.reactionType:map(function(p2)
			return Constants.ReactionIconMappings[p2] or ""
		end)
	end

	local size = props.size
	local v7

	if size == ReactionSize.XSmall then
		v7 = v5.Size.Size_500
	elseif size == ReactionSize.Small then
		v7 = v5.Size.Size_600
	else
		v7 = if size == ReactionSize.Large then v5.Size.Size_1200 else v5.Size.Size_800
	end

	return React.createElement(image, {
		Image = v6,
		Size = props.Size or UDim2.fromOffset(v7, v7),
		imageStyle = props.imageStyle,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Rotation = props.Rotation,
		scale = props.scale,
		AnchorPoint = props.AnchorPoint,
		ZIndex = props.ZIndex,
		testId = props.testId
	})
end

return React.memo(Reaction)

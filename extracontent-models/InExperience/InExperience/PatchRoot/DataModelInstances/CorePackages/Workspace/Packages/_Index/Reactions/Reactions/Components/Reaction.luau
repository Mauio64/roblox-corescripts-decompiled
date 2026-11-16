local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Constants = require(Reactions.Constants)
local ReactionSize = require(Reactions.Enums.ReactionSize)
require(Reactions.Enums.ReactionType)

local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function getSizeToken(p, size) -- 1 equivalent call inferred from this helper
	if size == ReactionSize.XSmall then
		return p.Size.Size_500
	end

	if size == ReactionSize.Small then
		return p.Size.Size_600
	end

	if size == ReactionSize.Large then
		return p.Size.Size_1200
	end

	return p.Size.Size_800
end

local function Reaction(props)
	local v = useTokens()
	local image

	if typeof(props.reactionType) == "string" then
		image = Constants.ReactionIconMappings[props.reactionType]
	else
		image = props.reactionType:map(function(p: string)
			return Constants.ReactionIconMappings[p] or ""
		end)
	end

	local sizeToken = getSizeToken(v, props.size) -- inferred equivalent call

	return React.createElement(Image, {
		Image = image,
		Size = props.Size or UDim2.fromOffset(sizeToken, sizeToken),
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

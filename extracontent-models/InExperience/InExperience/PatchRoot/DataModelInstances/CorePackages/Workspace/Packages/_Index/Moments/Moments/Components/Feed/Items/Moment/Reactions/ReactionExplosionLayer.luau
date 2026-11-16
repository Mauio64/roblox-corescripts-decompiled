local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local useSignalState = SignalsReact.useSignalState

local ReactionEffectsContext = require(script.Parent.ReactionEffectsContext)
local reactionsConstants = require(script.Parent.reactionsConstants)
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)
local ReactionExplosion

if FFlagMomentsUseSharedReactions then
	ReactionExplosion = require(parent.Reactions.ReactionExplosion)
else
	ReactionExplosion = require(script.Parent.ReactionExplosion)
end

local useReactionEffects = ReactionEffectsContext.useReactionEffects
local EXPLOSION_LAYER_ZINDEX = reactionsConstants.EXPLOSION_LAYER_ZINDEX

local signal = Signals.createSignal({})

local function ReactionExplosionLayer()
	local v = useReactionEffects()
	local v2 = if v == nil then signal else v.getExplosions
	local v3 = useSignalState(v2)

	local children = {}

	for _, v4 in v3 do
		children[`explosion_{v4.id}`] = React.createElement(ReactionExplosion, {
			reactionType = v4.reactionType,
			position = UDim2.fromOffset(v4.originLocal.X, v4.originLocal.Y),
			onComplete = function()
				if v ~= nil then
					v.onExplosionComplete(v4.id)
				end
			end
		})
	end

	local createElement = React.createElement
	local ref

	if v ~= nil then
		ref = v.layerRef
	end

	return createElement(
		View,
		{
			ref = ref,
			tag = "size-full",
			BackgroundTransparency = 1,
			ZIndex = EXPLOSION_LAYER_ZINDEX
		},
		children
	)
end

return React.memo(ReactionExplosionLayer)

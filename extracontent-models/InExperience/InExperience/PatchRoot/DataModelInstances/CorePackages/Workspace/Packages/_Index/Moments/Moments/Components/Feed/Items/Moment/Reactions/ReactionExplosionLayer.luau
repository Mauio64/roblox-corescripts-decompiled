local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local ReactionEffectsContext = require(script.Parent.ReactionEffectsContext)
local ReactionExplosion = require(script.Parent.ReactionExplosion)
local reactionsConstants = require(script.Parent.reactionsConstants)
local useReactionEffects = ReactionEffectsContext.useReactionEffects
local EXPLOSION_LAYER_ZINDEX = reactionsConstants.EXPLOSION_LAYER_ZINDEX
local v13 = Signals.createSignal({})

local function ReactionExplosionLayer() -- line: 32
	-- upvalues: useReactionEffects (copy), v13 (copy), useSignalState (copy), React (copy), ReactionExplosion (copy), View (copy), EXPLOSION_LAYER_ZINDEX (copy)
	local v15 = useReactionEffects()
	local v16 = if v15 == nil then v13 else v15.getExplosions
	local t1 = {}

	for _, v19 in (useSignalState(v16)) do
		t1[`explosion_{ v19.id }`] = React.createElement(ReactionExplosion, {
			reactionType = v19.reactionType,
			position = UDim2.fromOffset(v19.originLocal.X, v19.originLocal.Y),
			onComplete = function() -- line: 42
				-- upvalues: v15 (copy), v19 (copy)
				if v15 ~= nil then
					v15.onExplosionComplete(v19.id)
				end
			end
		})
	end

	return React.createElement(View, {
		tag = "size-full",
		BackgroundTransparency = 1,
		ref = if v15 == nil then nil else v15.layerRef,
		ZIndex = EXPLOSION_LAYER_ZINDEX
	}, t1)
end

return React.memo(ReactionExplosionLayer)

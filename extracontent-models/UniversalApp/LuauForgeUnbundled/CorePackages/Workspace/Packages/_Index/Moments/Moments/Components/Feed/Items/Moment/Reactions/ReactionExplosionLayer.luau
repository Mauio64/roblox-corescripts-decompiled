local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local view = Foundation.View
local useSignalState = SignalsReact.useSignalState

local ReactionEffectsContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/ReactionEffectsContext")
local reactionsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/reactionsConstants")
local v5 = if require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions") then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/ReactionExplosion") else require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/ReactionExplosion")

local useReactionEffects = ReactionEffectsContext.useReactionEffects
local EXPLOSION_LAYER_ZINDEX = reactionsConstants.EXPLOSION_LAYER_ZINDEX

local signal = Signals.createSignal({})

local function ReactionExplosionLayer()
	local v6 = useReactionEffects()
	local v7 = if v6 == nil then signal else v6.getExplosions
	local v8 = useSignalState(v7)

	local children = {}

	for k, v9 in v8 do
		children[`explosion_{v9.id}`] = React.createElement(v5, {
			reactionType = v9.reactionType,
			position = UDim2.fromOffset(v9.originLocal.X, v9.originLocal.Y),
			onComplete = function()
				if v6 ~= nil then
					v6.onExplosionComplete(v9.id)
				end
			end
		})
	end

	local createElement = React.createElement
	local v11 = if v6 ~= nil then v6.layerRef else nil
	return createElement(
		view,
		{
			ref = v11,
			tag = "size-full",
			BackgroundTransparency = 1,
			ZIndex = EXPLOSION_LAYER_ZINDEX
		},
		children
	)
end

return React.memo(ReactionExplosionLayer)

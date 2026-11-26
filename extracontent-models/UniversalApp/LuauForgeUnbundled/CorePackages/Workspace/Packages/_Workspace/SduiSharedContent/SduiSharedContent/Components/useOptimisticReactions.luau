local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/ContentReactionsStoreTypes")
local createContentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/createContentReactionsStore")
local getContentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/getContentReactionsStore")

local v5 = {}

local function useOptimisticReactions(value, p2, callback)
	local v6 = p2 or v5
	local v7 = value or ""
	local v8 = v7 == ""
	local v9 = React.useMemo(function()
		if v8 then
			return (createContentReactionsStore())
		end

		return nil
	end, { v8 })
	local v10 = v9 or getContentReactionsStore(false)

	React.useEffect(function()
		if v9 then
			return v9.dispose
		end

		return nil
	end, { v9 })

	local v11 = {
		v10,
		v7,
		SignalsReact.useSignalState(v10.getContentReactions(v7).data),
		v6
	}
	local v12 = React.useMemo(function()
		return v10.getReactions(v7, v6)
	end, v11)

	React.useEffect(function()
		v10.reconcileReactions(v7, v6)
	end, { v10, v7, v6 })

	return v12, (React.useCallback(function(data)
		local emoteId = data.emoteId

		if emoteId == "" or callback == nil or v10.isReactionPending(v7, emoteId) then
			return
		end

		local v13 = not data.hasUserAppliedReaction
		local v14 = callback(nil, nil, { emoteId = emoteId, shouldAdd = v13 })

		if not Promise.is(v14) then
			return
		end

		v10.updateReaction(v7, v6, data, {
			emoteId = emoteId,
			reactionType = data.reactionType,
			hasUserAppliedReaction = v13,
			reactionCount = math.max(0, (data.reactionCount or 0) + (v13 and 1 or -1))
		}, v14)
	end, { v10, v7, v6, callback }))
end

return useOptimisticReactions

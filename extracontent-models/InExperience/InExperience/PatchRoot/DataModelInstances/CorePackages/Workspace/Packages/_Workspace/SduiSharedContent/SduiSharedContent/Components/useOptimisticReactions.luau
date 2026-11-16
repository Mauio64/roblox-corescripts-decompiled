local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local Promise = require(parent.Promise)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(SduiSharedContent.Stores.ContentReactionsStoreTypes)
local createContentReactionsStore = require(SduiSharedContent.Stores.createContentReactionsStore)
local getContentReactionsStore = require(SduiSharedContent.Stores.getContentReactionsStore)

local v = {}

local function useOptimisticReactions(value: string?, p, callback)
	local v2 = p or v
	local v3 = value or ""
	local v4 = v3 == ""
	local v5 = React.useMemo(function()
		if v4 then
			return (createContentReactionsStore())
		end

		return nil
	end, { v4 })
	local v6 = v5 or getContentReactionsStore(false)

	React.useEffect(function()
		return if v5 then v5.dispose else nil
	end, { v5 })

	local v7 = {
		v6,
		v3,
		SignalsReact.useSignalState(v6.getContentReactions(v3).data),
		v2
	}
	local v8 = React.useMemo(function()
		return v6.getReactions(v3, v2)
	end, v7)

	React.useEffect(function()
		v6.reconcileReactions(v3, v2)
	end, { v6, v3, v2 })

	return v8, (React.useCallback(function(data)
		local emoteId = data.emoteId

		if emoteId == "" or callback == nil or v6.isReactionPending(v3, emoteId) then
			return
		end

		local v9 = not data.hasUserAppliedReaction
		local v10 = callback(nil, nil, { emoteId = emoteId, shouldAdd = v9 })

		if not Promise.is(v10) then
			return
		end

		v6.updateReaction(v3, v2, data, {
			emoteId = emoteId,
			reactionType = data.reactionType,
			hasUserAppliedReaction = v9,
			reactionCount = math.max(0, (data.reactionCount or 0) + (v9 and 1 or -1))
		}, v10)
	end, { v6, v3, v2, callback }))
end

return useOptimisticReactions

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")

local createSignal = Signals.createSignal

local v5 = { sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} }

local function createCommentSessionFiltersStore()
	local signal, v6 = createSignal(v5)

	return {
		getFilters = signal,
		reset = function()
			v6({ sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} })
		end,
		hideCommentForSession = function(p2)
			local v7 = signal(false)

			if v7.sessionHiddenCommentIds[p2] == true then
				return
			end

			local clone = table.clone(v7.sessionHiddenCommentIds)
			clone[p2] = true
			v6({
				sessionHiddenCommentIds = clone,
				recentlyBlockedAuthorIds = v7.recentlyBlockedAuthorIds
			})
		end,
		markAuthorRecentlyBlocked = function(p2)
			local v7 = signal(false)

			if v7.recentlyBlockedAuthorIds[p2] == true then
				return
			end

			local clone = table.clone(v7.recentlyBlockedAuthorIds)
			clone[p2] = true
			v6({
				sessionHiddenCommentIds = v7.sessionHiddenCommentIds,
				recentlyBlockedAuthorIds = clone
			})
		end,
		unmarkAuthorRecentlyBlocked = function(p2)
			local v7 = signal(false)

			if v7.recentlyBlockedAuthorIds[p2] ~= true then
				return
			end

			local clone = table.clone(v7.recentlyBlockedAuthorIds)
			clone[p2] = nil
			v6({
				sessionHiddenCommentIds = v7.sessionHiddenCommentIds,
				recentlyBlockedAuthorIds = clone
			})
		end,
		isCommentSessionHidden = function(p2): boolean
			return signal(false).sessionHiddenCommentIds[p2] == true
		end,
		isAuthorRecentlyBlocked = function(p2): boolean
			return signal(false).recentlyBlockedAuthorIds[p2] == true
		end
	}
end

return createCommentSessionFiltersStore

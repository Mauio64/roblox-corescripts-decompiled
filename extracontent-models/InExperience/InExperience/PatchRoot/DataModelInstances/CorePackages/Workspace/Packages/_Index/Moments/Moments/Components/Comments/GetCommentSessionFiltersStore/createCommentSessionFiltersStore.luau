local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

require(script.Parent.Parent.GetCommentCollectionStore.CommentCollectionTypes)

local createSignal = Signals.createSignal

local v = { sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} }

local function createCommentSessionFiltersStore()
	local signal, v2 = createSignal(v)

	return {
		getFilters = signal,
		reset = function()
			v2({ sessionHiddenCommentIds = {}, recentlyBlockedAuthorIds = {} })
		end,
		hideCommentForSession = function(p: string)
			local v3 = signal(false)

			if v3.sessionHiddenCommentIds[p] == true then
				return
			end

			local clone = table.clone(v3.sessionHiddenCommentIds)
			clone[p] = true
			v2({
				sessionHiddenCommentIds = clone,
				recentlyBlockedAuthorIds = v3.recentlyBlockedAuthorIds
			})
		end,
		markAuthorRecentlyBlocked = function(p: string)
			local v3 = signal(false)

			if v3.recentlyBlockedAuthorIds[p] == true then
				return
			end

			local clone = table.clone(v3.recentlyBlockedAuthorIds)
			clone[p] = true
			v2({
				sessionHiddenCommentIds = v3.sessionHiddenCommentIds,
				recentlyBlockedAuthorIds = clone
			})
		end,
		unmarkAuthorRecentlyBlocked = function(p: string)
			local v3 = signal(false)

			if v3.recentlyBlockedAuthorIds[p] ~= true then
				return
			end

			local clone = table.clone(v3.recentlyBlockedAuthorIds)
			clone[p] = nil
			v2({
				sessionHiddenCommentIds = v3.sessionHiddenCommentIds,
				recentlyBlockedAuthorIds = clone
			})
		end,
		isCommentSessionHidden = function(p: string): boolean
			return signal(false).sessionHiddenCommentIds[p] == true
		end,
		isAuthorRecentlyBlocked = function(p: string): boolean
			return signal(false).recentlyBlockedAuthorIds[p] == true
		end
	}
end

return createCommentSessionFiltersStore

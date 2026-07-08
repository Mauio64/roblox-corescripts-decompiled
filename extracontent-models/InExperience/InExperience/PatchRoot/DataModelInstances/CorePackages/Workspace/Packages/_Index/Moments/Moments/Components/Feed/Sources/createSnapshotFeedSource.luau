local Moments = script:FindFirstAncestor("Moments")

require(Moments.Components.Feed.FeedTypes)

local function createSnapshotFeedSource(t1: {[any]: any}, t2: {[any]: any}?) -- line: 27
	local v5 = t2 or {}
	local v6 = table.clone(t1)

	return {
		fetchAsync = function(_) -- line: 33
			-- upvalues: v6 (copy)
			return {
				nextCursor = nil,
				items = table.clone(v6)
			}
		end,
		id = v5.id or "snapshot",
		recommendationSource = v5.recommendationSource
	}
end

return createSnapshotFeedSource

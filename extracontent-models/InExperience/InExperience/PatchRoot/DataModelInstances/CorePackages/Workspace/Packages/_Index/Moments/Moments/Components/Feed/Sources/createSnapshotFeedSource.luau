local Moments = script:FindFirstAncestor("Moments")

require(Moments.Components.Feed.FeedTypes)

local function createSnapshotFeedSource(p, options)
	local v = options or {}

	local clone = table.clone(p)

	return {
		fetchAsync = function(_)
			return { items = table.clone(clone), nextCursor = nil }
		end,
		id = v.id or "snapshot",
		recommendationSource = v.recommendationSource
	}
end

return createSnapshotFeedSource

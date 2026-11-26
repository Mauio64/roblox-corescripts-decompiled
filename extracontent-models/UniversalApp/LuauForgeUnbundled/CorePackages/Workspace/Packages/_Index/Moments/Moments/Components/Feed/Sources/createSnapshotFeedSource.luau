require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function createSnapshotFeedSource(p2, options)
	local v5 = options or {}

	local clone = table.clone(p2)

	return {
		fetchAsync = function(p3)
			return { items = table.clone(clone), nextCursor = nil }
		end,
		id = v5.id or "snapshot",
		recommendationSource = v5.recommendationSource
	}
end

return createSnapshotFeedSource

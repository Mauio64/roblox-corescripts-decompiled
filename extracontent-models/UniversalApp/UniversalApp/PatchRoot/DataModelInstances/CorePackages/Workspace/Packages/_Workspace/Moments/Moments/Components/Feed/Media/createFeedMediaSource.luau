local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.Signals)
require(MomentsParent.MomentsCommon)
require(Moments.Components.Feed.FeedTypes)

local toMediaItem = require(script.Parent.toMediaItem)

local function createFeedMediaSource(p1, p2) -- line: 31
	-- upvalues: toMediaItem (copy)
	return {
		getActiveIndex = p1.getCurrentIndex,
		getItems = function(p3) -- line: 43
			-- upvalues: p1 (copy), toMediaItem (copy)
			local t1 = {}

			for _, v10 in (p1.getItems(p3)) do
				local v11 = toMediaItem(v10)

				if v11 ~= nil then
					table.insert(t1, v11)
				end
			end

			return t1
		end,
		getPlaybackActive = p2
	}
end

return createFeedMediaSource

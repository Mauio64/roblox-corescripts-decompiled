local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.Signals)
require(MomentsParent.MomentsCommon)
require(Moments.Components.Feed.FeedTypes)

local toMediaItem = require(script.Parent.toMediaItem)

local function createFeedMediaSource(p1, p2, p3) -- line: 31
	-- upvalues: toMediaItem (copy)
	return {
		getActiveIndex = p1.getCurrentIndex,
		getItems = function(p4) -- line: 44
			-- upvalues: p1 (copy), toMediaItem (copy)
			local t1 = {}

			for _, v11 in (p1.getItems(p4)) do
				local v12 = toMediaItem(v11)

				if v12 ~= nil then
					table.insert(t1, v12)
				end
			end

			return t1
		end,
		getPlaybackActive = p2,
		getCanAutoPlay = p3
	}
end

return createFeedMediaSource

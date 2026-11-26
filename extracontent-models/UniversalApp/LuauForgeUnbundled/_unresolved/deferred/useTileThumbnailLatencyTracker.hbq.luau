local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/hbr")

local function useTileThumbnailLatencyTracker(p2, p3)
	local v5 = module(p2)

	React.useEffect(function()
		if not (p3 ~= false and v5.trackerLoadedThumbnails ~= nil and v5.prevImpressionResults ~= v5.trackerLoadedThumbnails) then
			return
		end

		local v6 = false

		for k, trackerLoadedThumbnail in v5.trackerLoadedThumbnails do
			if trackerLoadedThumbnail == true then
				v6 = true
				break
			end
		end

		if v6 and v5.trackerStartTime and v6 and not v5.trackerEndTime then
			v5.fireTileLoadingLatencyTracker(v5, true)
		end
	end, {
		p2,
		v5.currentPageName,
		v5.trackerLoadedThumbnails,
		v5.trackerStartTime,
		v5.trackerEndTime,
		v5.coldStart,
		v5.currentCategory,
		v5.currentSubcategory,
		p3
	})
end

return useTileThumbnailLatencyTracker

local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useTileLoadingLatencyInitializer = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileLoadingLatencyInitializer)

local function useTileThumbnailLatencyTracker(s1: string, b1: boolean?) -- line: 13
	-- upvalues: useTileLoadingLatencyInitializer (copy), React (copy)
	local v8 = useTileLoadingLatencyInitializer(s1)

	React.useEffect(function() -- line: 16
		-- upvalues: b1 (copy), v8 (copy)
		if b1 == false then
			return
		end

		if v8.trackerLoadedThumbnails == nil then
			return
		end

		if v8.prevImpressionResults == v8.trackerLoadedThumbnails then
			return
		end

		local v9 = false

		for _, v11 in v8.trackerLoadedThumbnails do
			if v11 == true then
				v9 = true

				break
			end
		end

		if not v9 or not v8.trackerStartTime then
			return
		end

		if v9 and not v8.trackerEndTime then
			v8.fireTileLoadingLatencyTracker(v8, true)
		end
	end, {
		s1,
		v8.currentPageName,
		v8.trackerLoadedThumbnails,
		v8.trackerStartTime,
		v8.trackerEndTime,
		v8.coldStart,
		v8.currentCategory,
		v8.currentSubcategory,
		b1
	})
end

return useTileThumbnailLatencyTracker

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")

local MediaGalleryConstants = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants")
local useGuiObjectVisibility = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/Hooks/useGuiObjectVisibility")

local function useAutoAdvance(data)
	local intervalSeconds = data.intervalSeconds or MediaGalleryConstants.AUTO_ADVANCE_DURATION_SECONDS

	local v5, v6 = React.useBinding(0)
	local v7, v8 = React.useBinding(0)

	local v9 = React.useCallback(function()
		v6(0)
		v8(0)
	end, {})

	local v10 = React.useCallback(function()
		if not data.enabled then
			return
		end

		data.scrollRight()
	end, { data.enabled, data.scrollRight })

	local v11 = React.useCallback(function(p2)
		local v12 = v5:getValue() + p2

		if intervalSeconds <= v12 then
			v6(0)
			v8(0)
			data.scrollRight()
		else
			v6(v12)
			v8(v12 / intervalSeconds)
		end
	end, { v5, data.scrollRight, intervalSeconds })

	local v12 = data.enabled and not (data.isMediaGalleryOccluded or data.isAutoAdvanceTimerSuspended)

	useGuiObjectVisibility(data.galleryRef, v12, v11, v9)

	return {
		elapsedTimeBinding = v5,
		progressBinding = v7,
		resetProgress = v9,
		onVideoEnded = v10,
		onVideoProgressChanged = v8
	}
end

return useAutoAdvance

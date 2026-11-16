local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)

local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
local useGuiObjectVisibility = require(MediaGallery.Hooks.useGuiObjectVisibility)

local function useAutoAdvance(data)
	local intervalSeconds = data.intervalSeconds or MediaGalleryConstants.AUTO_ADVANCE_DURATION_SECONDS

	local elapsedTimeBinding, v = React.useBinding(0)
	local progressBinding, onVideoProgressChanged = React.useBinding(0)

	local resetProgress = React.useCallback(function()
		v(0)
		onVideoProgressChanged(0)
	end, {})

	local onVideoEnded = React.useCallback(function()
		if not data.enabled then
			return
		end

		data.scrollRight()
	end, { data.enabled, data.scrollRight })

	local v2 = React.useCallback(function(p: number)
		local v2 = elapsedTimeBinding:getValue() + p

		if intervalSeconds <= v2 then
			v(0)
			onVideoProgressChanged(0)
			data.scrollRight()
		else
			v(v2)
			onVideoProgressChanged(v2 / intervalSeconds)
		end
	end, { elapsedTimeBinding, data.scrollRight, intervalSeconds })

	local v3 = data.enabled and not (data.isMediaGalleryOccluded or data.isAutoAdvanceTimerSuspended)

	useGuiObjectVisibility(data.galleryRef, v3, v2, resetProgress)

	return {
		elapsedTimeBinding = elapsedTimeBinding,
		progressBinding = progressBinding,
		resetProgress = resetProgress,
		onVideoEnded = onVideoEnded,
		onVideoProgressChanged = onVideoProgressChanged
	}
end

return useAutoAdvance

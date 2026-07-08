local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)
local useGuiObjectVisibility = require(MediaGallery.Hooks.useGuiObjectVisibility)

local function useAutoAdvance(t1: {[any]: any}) -- line: 39
	-- upvalues: MediaGalleryConstants (copy), React (copy), useGuiObjectVisibility (copy)
	local v8 = t1.intervalSeconds or MediaGalleryConstants.AUTO_ADVANCE_DURATION_SECONDS
	local v9, v10 = React.useBinding(0)
	local v11, v12 = React.useBinding(0)
	local v13 = React.useCallback(function() -- line: 45
		-- upvalues: v10 (copy), v12 (copy)
		v10(0)
		v12(0)
	end, {})
	local v14 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy)
		if not t1.enabled then
			return
		end

		t1.scrollRight()
	end, {
		t1.enabled,
		t1.scrollRight
	})
	local v15 = React.useCallback(function(n1: number) -- line: 57
		-- upvalues: v9 (copy), v8 (copy), v10 (copy), v12 (copy), t1 (copy)
		local v18 = v9:getValue() + n1

		if v18 >= v8 then
			v10(0)
			v12(0)
			t1.scrollRight()

			return
		end

		v10(v18)
		v12(v18 / v8)
	end, {
		v9,
		t1.scrollRight,
		v8
	})
	local v16 = t1.enabled and (not t1.isMediaGalleryOccluded and not t1.isAutoAdvanceTimerSuspended)

	useGuiObjectVisibility(t1.galleryRef, v16, v15, v13)

	return {
		elapsedTimeBinding = v9,
		progressBinding = v11,
		resetProgress = v13,
		onVideoEnded = v14,
		onVideoProgressChanged = v12
	}
end

return useAutoAdvance

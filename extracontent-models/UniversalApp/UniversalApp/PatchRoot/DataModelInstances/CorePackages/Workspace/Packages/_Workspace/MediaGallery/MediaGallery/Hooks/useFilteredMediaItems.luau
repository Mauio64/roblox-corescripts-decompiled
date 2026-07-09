local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local VideoUtils = require(MediaGalleryParent.VideoUtils)
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local EdpVideoBlockingConfig = VideoUtils.EdpVideoBlockingConfig
local useIsVideoEligible = require(MediaGalleryParent.GameTile).useIsVideoEligible
local useAppPolicy = require(MediaGalleryParent.UniversalAppPolicy).useAppPolicy
local LoggingProtocol = require(MediaGalleryParent.LoggingProtocol)
local reportWarning = require(MediaGalleryParent.DiscoveryAnalytics).Points.reportWarning
local isYouTubeVideo = require(MediaGallery.isYouTubeVideo)
local isValidIdentifier = require(MediaGallery.isValidIdentifier)

require(MediaGallery.MediaGalleryTypes)

local FFlagLuaAppMediaGalleryNilImageIdFix = require(MediaGalleryParent.SharedFlags).FFlagLuaAppMediaGalleryNilImageIdFix

local function useFilteredMediaItems(t1: {[any]: any}, s1: string, s2: string) -- line: 41
	-- upvalues: useAppPolicy (copy), useIsVideoEligible (copy), isValidIdentifier (copy), useCanDevicePlayVideoPreview (copy), EdpVideoBlockingConfig (copy), React (copy), isYouTubeVideo (copy), FFlagLuaAppMediaGalleryNilImageIdFix (copy), reportWarning (copy), LoggingProtocol (copy)
	local v18 = useAppPolicy(function(p1) -- line: 42
		return p1.getShowVideoThumbnails()
	end)
	local v19 = useIsVideoEligible(s1)
	local v20 = not isValidIdentifier(s1) or v19
	local v21 = useCanDevicePlayVideoPreview(EdpVideoBlockingConfig, s1, s2)

	return React.useMemo(function() -- line: 52
		-- upvalues: v21 (copy), v20 (copy), t1 (copy), isValidIdentifier (copy), isYouTubeVideo (copy), v18 (copy), FFlagLuaAppMediaGalleryNilImageIdFix (copy), reportWarning (copy), LoggingProtocol (copy), s2 (copy)
		local v23 = v21() and v20
		local v24 = false

		for _, v26 in t1 do
			if isValidIdentifier(v26.videoId) and not isYouTubeVideo(v26.assetTypeId) then
				v24 = true

				break
			end
		end

		local v27 = v24 and v20
		local t2 = {}

		for _, v30 in t1 do
			if isYouTubeVideo(v30.assetTypeId) then
				if not v27 and v18 then
					table.insert(t2, v30)
				end
			elseif isValidIdentifier(v30.videoId) then
				if v23 then
					table.insert(t2, v30)
				end
			elseif FFlagLuaAppMediaGalleryNilImageIdFix and not isValidIdentifier(v30.imageId) then
				reportWarning(LoggingProtocol.default, "MediaGallery", "Dropping non-video MediaItem with invalid imageId", {
					appPage = s2,
					assetTypeId = tostring(v30.assetTypeId),
					hasVideoId = tostring(isValidIdentifier(v30.videoId)),
					hasVideoHash = tostring(isValidIdentifier(v30.videoHash)),
					hasVideoTitle = tostring(v30.videoTitle ~= nil and v30.videoTitle ~= "")
				})
			else
				table.insert(t2, v30)
			end
		end

		return t2
	end, {
		t1,
		v18,
		v20,
		v21,
		if not FFlagLuaAppMediaGalleryNilImageIdFix then nil else s2
	})
end

return useFilteredMediaItems

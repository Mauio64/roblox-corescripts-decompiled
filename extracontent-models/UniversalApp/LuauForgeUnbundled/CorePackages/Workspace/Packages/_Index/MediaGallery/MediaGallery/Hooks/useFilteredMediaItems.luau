local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/VideoUtils")
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local edpVideoBlockingConfig = VideoUtils.EdpVideoBlockingConfig

local useIsVideoEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/GameTile").useIsVideoEligible
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/UniversalAppPolicy").useAppPolicy

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/LoggingProtocol")
local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/DiscoveryAnalytics").Points.reportWarning

local isYouTubeVideo = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/isYouTubeVideo")
local isValidIdentifier = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/isValidIdentifier")

require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")

local function useFilteredMediaItems(items, p2, p3)
	local v5 = useAppPolicy(function(p4)
		return p4.getShowVideoThumbnails()
	end)

	local v6 = useIsVideoEligible(p2)
	local v7 = not isValidIdentifier(p2) or v6

	local v8 = useCanDevicePlayVideoPreview(edpVideoBlockingConfig, p2, p3)

	return React.useMemo(function()
		local v9 = v8() and v7
		local v10 = false

		for k, item in items do
			if isValidIdentifier(item.videoId) and not isYouTubeVideo(item.assetTypeId) then
				v10 = true
				break
			end
		end

		local v12 = v10 and v7
		local result = {}

		for k, item in items do
			if isYouTubeVideo(item.assetTypeId) then
				if not v12 and v5 then
					table.insert(result, item)
				end
			elseif isValidIdentifier(item.videoId) then
				if v9 then
					table.insert(result, item)
				end
			elseif isValidIdentifier(item.imageId) then
				table.insert(result, item)
			else
				local default = LoggingProtocol.default

				local v16 = {
					appPage = p3,
					assetTypeId = tostring(item.assetTypeId),
					hasVideoId = tostring(isValidIdentifier(item.videoId)),
					hasVideoHash = tostring(isValidIdentifier(item.videoHash)),
					hasVideoTitle = 0
				}
				local v17 = not (item.videoTitle == nil) and item.videoTitle ~= ""
				v16.hasVideoTitle = tostring(v17)
				reportWarning(
					default,
					"MediaGallery",
					"Dropping non-video MediaItem with invalid imageId",
					v16
				)
			end
		end

		return result
	end, { items, v5, v7, v8, p3 })
end

return useFilteredMediaItems

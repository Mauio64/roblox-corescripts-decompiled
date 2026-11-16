local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)

local VideoUtils = require(parent.VideoUtils)
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local EdpVideoBlockingConfig = VideoUtils.EdpVideoBlockingConfig

local GameTile = require(parent.GameTile)
local useIsVideoEligible = GameTile.useIsVideoEligible
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local LoggingProtocol = require(parent.LoggingProtocol)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning

local isYouTubeVideo = require(MediaGallery.isYouTubeVideo)
local isValidIdentifier = require(MediaGallery.isValidIdentifier)

require(MediaGallery.MediaGalleryTypes)

local function useFilteredMediaItems(items, p: string, appPage: string)
	local v = useAppPolicy(function(p2)
		return p2.getShowVideoThumbnails()
	end)

	local v2 = useIsVideoEligible(p)
	local v3 = not isValidIdentifier(p) or v2

	local v4 = useCanDevicePlayVideoPreview(EdpVideoBlockingConfig, p, appPage)

	return React.useMemo(function()
		local v5 = v4() and v3
		local v6 = false

		for _, item in items do
			if isValidIdentifier(item.videoId) and not isYouTubeVideo(item.assetTypeId) then
				v6 = true
				break
			end
		end

		local v7 = v6 and v3
		local result = {}

		for _, item in items do
			if isYouTubeVideo(item.assetTypeId) then
				if not v7 and v then
					table.insert(result, item)
				end
			elseif isValidIdentifier(item.videoId) then
				if v5 then
					table.insert(result, item)
				end
			elseif isValidIdentifier(item.imageId) then
				table.insert(result, item)
			else
				local default = LoggingProtocol.default

				local v8 = {
					appPage = appPage,
					assetTypeId = tostring(item.assetTypeId),
					hasVideoId = tostring(isValidIdentifier(item.videoId)),
					hasVideoHash = tostring(isValidIdentifier(item.videoHash)),
					hasVideoTitle = 0
				}
				local v9

				if item.videoTitle == nil then
					v9 = false
				else
					v9 = item.videoTitle ~= ""
				end

				v8.hasVideoTitle = tostring(v9)
				reportWarning(default, "MediaGallery", "Dropping non-video MediaItem with invalid imageId", v8)
			end
		end

		return result
	end, { items, v, v3, v4, appPage })
end

return useFilteredMediaItems

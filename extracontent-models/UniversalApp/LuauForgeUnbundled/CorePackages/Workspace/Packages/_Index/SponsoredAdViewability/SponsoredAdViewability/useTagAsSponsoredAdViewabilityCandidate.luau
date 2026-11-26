local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredAdViewability/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredAdViewability/DiscoveryTypes")

local sponsoredAdViewabilityRegistry = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityRegistry")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTypes")

local function useTagAsSponsoredAdViewabilityCandidate(p2, data)
	local encryptedAdTrackingData = if data then data.encryptedAdTrackingData else nil
	local tileType = if data then data.tileType else nil
	local mediaType = if data then data.mediaType else nil
	local videoPlaybackStateRef = if data then data.videoPlaybackStateRef else nil
	local videoSource = if data then data.videoSource else nil
	local isFullscreen = if data then data.isFullscreen else nil

	React.useEffect(function()
		if encryptedAdTrackingData == nil or tileType == nil or mediaType == nil then
			return
		end

		local current = p2.current

		if current == nil then
			return
		end

		return sponsoredAdViewabilityRegistry.bind(current, {
			encryptedAdTrackingData = encryptedAdTrackingData,
			tileType = tileType,
			mediaType = mediaType,
			videoPlaybackStateRef = videoPlaybackStateRef,
			videoSource = videoSource,
			isFullscreen = isFullscreen
		})
	end, {
		encryptedAdTrackingData,
		tileType,
		p2,
		mediaType,
		videoPlaybackStateRef,
		videoSource,
		isFullscreen
	})
end

return useTagAsSponsoredAdViewabilityCandidate

local parent = script:FindFirstAncestor("SponsoredAdViewability").Parent

local React = require(parent.React)
require(parent.DiscoveryTypes)

local sponsoredAdViewabilityRegistry = require(script.Parent.sponsoredAdViewabilityRegistry)
require(script.Parent.sponsoredAdViewabilityTypes)

local function useTagAsSponsoredAdViewabilityCandidate(p, data)
	local encryptedAdTrackingData

	if data then
		encryptedAdTrackingData = data.encryptedAdTrackingData
	else
		encryptedAdTrackingData = nil
	end

	local tileType

	if data then
		tileType = data.tileType
	else
		tileType = nil
	end

	local mediaType

	if data then
		mediaType = data.mediaType
	else
		mediaType = nil
	end

	local videoPlaybackStateRef

	if data then
		videoPlaybackStateRef = data.videoPlaybackStateRef
	else
		videoPlaybackStateRef = nil
	end

	local videoSource

	if data then
		videoSource = data.videoSource
	else
		videoSource = nil
	end

	local isFullscreen

	if data then
		isFullscreen = data.isFullscreen
	else
		isFullscreen = nil
	end

	React.useEffect(function()
		if encryptedAdTrackingData == nil or tileType == nil or mediaType == nil then
			return
		end

		local current = p.current

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
		p,
		mediaType,
		videoPlaybackStateRef,
		videoSource,
		isFullscreen
	})
end

return useTagAsSponsoredAdViewabilityCandidate

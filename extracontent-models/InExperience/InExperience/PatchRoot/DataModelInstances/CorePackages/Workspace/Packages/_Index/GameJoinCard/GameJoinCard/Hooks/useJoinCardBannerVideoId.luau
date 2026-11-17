local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local getGameMediaStore = DataHydration.Game.getGameMediaStore

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameMediaImageType = DiscoveryTypes.GameMediaImageType
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local VideoUtils = require(parent.VideoUtils)
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local EdpVideoBlockingConfig = VideoUtils.EdpVideoBlockingConfig

local function isValidVideoId(videoId): boolean -- 1 equivalent call inferred from this helper
	if videoId == nil then
		return false
	end

	local v = tostring(videoId)
	return v ~= "" and v ~= "0"
end

local function useJoinCardBannerVideoId(p: string, playabilityStatus: string?, flag: boolean)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(p)
	local v = SignalsReact.useSignalState(fetchGameMedia.data)

	local v2 = useCanDevicePlayVideoPreview(EdpVideoBlockingConfig, p, "GameJoinCard")

	return React.useMemo(function()
		if not flag or p == "" or playabilityStatus == nil or v == nil then
			return nil
		end

		if not isVideoEligibleForPlayability(true, {
			isPlayable = playabilityStatus == PlayabilityStatusEnum.Playable,
			playabilityStatus = playabilityStatus
		}) then
			return nil
		end

		local videoId = nil

		for _, v3 in v do
			if v3.assetTypeId ~= GameMediaImageType.YouTubeVideo and isValidVideoId(v3.videoId) then -- inferred equivalent call
				videoId = tostring(v3.videoId)
				break
			end
		end

		if videoId == nil or not v2() then
			return nil
		end

		return videoId
	end, { flag, p, playabilityStatus, v, v2 })
end

return useJoinCardBannerVideoId

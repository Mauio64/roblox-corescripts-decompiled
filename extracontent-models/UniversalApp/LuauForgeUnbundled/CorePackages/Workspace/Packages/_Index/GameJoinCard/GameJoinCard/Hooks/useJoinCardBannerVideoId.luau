local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SignalsReact")

local getGameMediaStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration").Game.getGameMediaStore

local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DiscoveryTypes")
local gameMediaImageType = DiscoveryTypes.GameMediaImageType
local playabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/VideoUtils")
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local edpVideoBlockingConfig = VideoUtils.EdpVideoBlockingConfig

local function isValidVideoId(p2): boolean
	if p2 == nil then
		return false
	end

	local v5 = tostring(p2)
	return v5 ~= "" and v5 ~= "0"
end

local function useJoinCardBannerVideoId(p2, p3, p4)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(p2)
	local v5 = SignalsReact.useSignalState(fetchGameMedia.data)

	local v6 = useCanDevicePlayVideoPreview(edpVideoBlockingConfig, p2, "GameJoinCard")

	return React.useMemo(function()
		if not p4 or p2 == "" or p3 == nil or v5 == nil then
			return nil
		end

		if not isVideoEligibleForPlayability(true, {
			isPlayable = p3 == playabilityStatusEnum.Playable,
			playabilityStatus = p3
		}) then
			return nil
		end

		local videoId = nil

		for k, v8 in v5 do
			if v8.assetTypeId == gameMediaImageType.YouTubeVideo then
				continue
			end

			local videoId2 = v8.videoId
			local v9

			if videoId2 == nil then
				v9 = false
			else
				local v10 = tostring(videoId2)
				v9 = not (v10 == "") and v10 ~= "0"
			end

			if v9 then
				videoId = tostring(v8.videoId)
				break
			end
		end

		if videoId == nil or not v6() then
			return nil
		end

		return videoId
	end, { p4, p2, p3, v5, v6 })
end

return useJoinCardBannerVideoId

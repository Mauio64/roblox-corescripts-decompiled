local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SignalsReact")

local gameMediaImageType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryTypes").GameMediaImageType

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")
local dataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Http").Url

local defineFastFlag = game:DefineFastFlag("ExperienceBannerImageAllowCustomDimensions", false)
local defineFastFlag2 = game:DefineFastFlag("ExperienceBannerImageDefaultFallback", false)

local v5 = {
	Loading = "Loading",
	Success = "Success",
	NotFound = "NotFound",
	Fallback = "Fallback",
	Failed = "Failed"
}

local function useExperienceBannerImage(p2, p3, p4, p5)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(p2)
	local v6 = SignalsReact.useSignalState(fetchGameMedia.data)
	local v7 = SignalsReact.useSignalState(fetchGameMedia.status)
	local v8 = defineFastFlag and p4 or 768
	local v9 = defineFastFlag and p5 or 432
	return React.useMemo(function()
		if v7 == dataStatus.NotReady then
			return { status = "Loading", url = nil }
		end

		if defineFastFlag2 then
			if v7 == dataStatus.Failed then
				return { status = "Failed", url = nil }
			end

			if v6 then
				for k, v10 in v6 do
					if v10.assetTypeId == gameMediaImageType.Image and v10.imageId then
						return {
							status = "Success",
							url = string.format(
								"rbxthumb://type=Asset&id=%s&w=%d&h=%d",
								tostring(v10.imageId),
								v8,
								v9
							)
						}
					end
				end
			end

			if p3 == nil or p3 == "" then
				return { status = "NotFound", url = nil }
			end

			return {
				status = "Fallback",
				url = url:getPlaceDefaultThumbnailUrl(p3, v8, v9)
			}
		end

		if v7 == dataStatus.Failed or not v6 then
			return { status = "NotFound", url = nil }
		end

		for k, v10 in v6 do
			if v10.assetTypeId == gameMediaImageType.Image and v10.imageId then
				return {
					status = "Success",
					url = string.format(
						"rbxthumb://type=Asset&id=%s&w=%d&h=%d",
						tostring(v10.imageId),
						v8,
						v9
					)
				}
			end
		end

		return { status = "NotFound", url = nil }
	end, { v7, v6, v8, v9, p3 })
end

return useExperienceBannerImage

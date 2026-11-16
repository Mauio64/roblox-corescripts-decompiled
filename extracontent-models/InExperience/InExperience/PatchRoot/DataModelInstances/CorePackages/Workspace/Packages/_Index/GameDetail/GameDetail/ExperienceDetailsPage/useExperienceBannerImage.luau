local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameMediaImageType = DiscoveryTypes.GameMediaImageType

local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore

local Http = require(parent.Http)
local Url = Http.Url

local defineFastFlag = game:DefineFastFlag("ExperienceBannerImageAllowCustomDimensions", false)
local defineFastFlag2 = game:DefineFastFlag("ExperienceBannerImageDefaultFallback", false)

local _ = {
	Loading = "Loading",
	Success = "Success",
	NotFound = "NotFound",
	Fallback = "Fallback",
	Failed = "Failed"
}

local function useExperienceBannerImage(p: string, p2: string?, p3: number?, p4: number?)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(p)
	local v = SignalsReact.useSignalState(fetchGameMedia.data)
	local v2 = SignalsReact.useSignalState(fetchGameMedia.status)
	local v3 = defineFastFlag and p3 or 768
	local v4 = defineFastFlag and p4 or 432
	return React.useMemo(function()
		if v2 == DataStatus.NotReady then
			return { status = "Loading", url = nil }
		end

		if defineFastFlag2 then
			if v2 == DataStatus.Failed then
				return { status = "Failed", url = nil }
			end

			if v then
				for _, v5 in v do
					if v5.assetTypeId == GameMediaImageType.Image and v5.imageId then
						return {
							status = "Success",
							url = string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d", tostring(v5.imageId), v3, v4)
						}
					end
				end
			end

			if p2 == nil or p2 == "" then
				return { status = "NotFound", url = nil }
			end

			return {
				status = "Fallback",
				url = Url:getPlaceDefaultThumbnailUrl(p2, v3, v4)
			}
		end

		if v2 == DataStatus.Failed or not v then
			return { status = "NotFound", url = nil }
		end

		for _, v5 in v do
			if v5.assetTypeId == GameMediaImageType.Image and v5.imageId then
				return {
					status = "Success",
					url = string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d", tostring(v5.imageId), v3, v4)
				}
			end
		end

		return { status = "NotFound", url = nil }
	end, { v2, v, v3, v4, p2 })
end

return useExperienceBannerImage

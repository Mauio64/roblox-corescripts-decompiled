local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local GameMediaImageType = require(Parent.DiscoveryTypes).GameMediaImageType
local DataHydration = require(Parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore
local Url = require(Parent.Http).Url
local v9 = game:DefineFastFlag("ExperienceBannerImageAllowCustomDimensions", false)
local v10 = game:DefineFastFlag("ExperienceBannerImageDefaultFallback", false)
local _ = {
	Loading = "Loading",
	Success = "Success",
	NotFound = "NotFound",
	Fallback = "Fallback",
	Failed = "Failed"
}

local function useExperienceBannerImage(s1: string, s2: string?, n1: number?, n2: number?) -- line: 37
	-- upvalues: getGameMediaStore (copy), SignalsReact (copy), v9 (copy), React (copy), DataStatus (copy), v10 (copy), GameMediaImageType (copy), Url (copy)
	local v17 = getGameMediaStore(false).getAndFetchGameMedia(s1)
	local v18 = SignalsReact.useSignalState(v17.data)
	local v19 = SignalsReact.useSignalState(v17.status)
	local v20 = not v9 and 768 or (n1 or 768)
	local v21 = not v9 and 432 or (n2 or 432)

	return React.useMemo(function() -- line: 54
		-- upvalues: v19 (copy), DataStatus (copy), v10 (copy), v18 (copy), GameMediaImageType (copy), v20 (copy), v21 (copy), s2 (copy), Url (copy)
		if v19 == DataStatus.NotReady then
			return {
				status = "Loading",
				url = nil
			}
		end

		if v10 then
			if v19 == DataStatus.Failed then
				return {
					status = "Failed",
					url = nil
				}
			end

			if v18 then
				for _, v23 in v18 do
					if v23.assetTypeId == GameMediaImageType.Image and v23.imageId then
						local v24 = string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d", tostring(v23.imageId), v20, v21)

						return {
							status = "Success",
							url = v24
						}
					end
				end
			end

			if s2 ~= nil and s2 ~= "" then
				return {
					status = "Fallback",
					url = Url:getPlaceDefaultThumbnailUrl(s2, v20, v21)
				}
			end

			return {
				status = "NotFound",
				url = nil
			}
		end

		if v19 == DataStatus.Failed or not v18 then
			return {
				status = "NotFound",
				url = nil
			}
		end

		for _, v26 in v18 do
			if v26.assetTypeId == GameMediaImageType.Image and v26.imageId then
				local v27 = string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d", tostring(v26.imageId), v20, v21)

				return {
					status = "Success",
					url = v27
				}
			end
		end

		return {
			status = "NotFound",
			url = nil
		}
	end, {
		v19,
		v18,
		v20,
		v21,
		s2
	})
end

return useExperienceBannerImage

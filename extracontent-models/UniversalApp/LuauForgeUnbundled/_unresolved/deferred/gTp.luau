local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local fetchCollectibleItemDataBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchCollectibleItemDataBatchedSuccess

local function getFetchKey(list)
	return "BatchCollectibles-" .. table.concat(list, ",")
end

return function(p2, list)
	local v5 = "BatchCollectibles-" .. table.concat(list, ",")

	return performFetch.Single(v5, function(object)
		return GetExperienceSourceLanguage.FetchCollectibleItemDetails(p2, list):andThen(function(p3)
			object:dispatch(fetchCollectibleItemDataBatchedSuccess({
				collectibleItemData = not p3 and {} or p3.responseBody
			}))
		end)
	end)
end

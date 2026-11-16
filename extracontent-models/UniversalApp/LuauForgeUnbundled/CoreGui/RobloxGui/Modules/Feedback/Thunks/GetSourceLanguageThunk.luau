local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local SetSourceLanguageName = require("@game/CoreGui/RobloxGui/Modules/Feedback/Actions/SetSourceLanguageName")

return function(p2, p3)
	return performFetch.Single(p3, function(object)
		return GetExperienceSourceLanguage.FetchCollectibleItemDetails(p2, { p3 }):andThen(function(p4)
			local responseBody = if p4 then p4.responseBody else nil
			local v5 = if responseBody then responseBody[1] else nil

			if v5 == nil then
				return
			end

			object:dispatch(SetSourceLanguageName(p3, v5))
		end)
	end)
end

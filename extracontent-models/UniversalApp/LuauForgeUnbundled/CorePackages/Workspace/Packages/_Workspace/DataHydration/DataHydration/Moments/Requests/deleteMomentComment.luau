local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")

local function commentPath(p2, p3)
	return `moment-comments-api/v1/moments/{p2}/comments/{p3}`
end

local function deleteMomentComment(p2, p3, p4)
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{p2}/comments/{p3}`)

	return HttpClient.fetch({
		method = "DELETE",
		url = v5,
		headers = v6,
		analyticsKey = "moments.delete-comment",
		network = p4,
		decode = function(p5): nil
			return nil
		end
	})
end

return deleteMomentComment

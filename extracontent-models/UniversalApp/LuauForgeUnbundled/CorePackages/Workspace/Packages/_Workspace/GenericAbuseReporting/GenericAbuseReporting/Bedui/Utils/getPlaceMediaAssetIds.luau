local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

local defineFastFlag = game:DefineFastFlag("RemoveDuplicatesPlaceMediaAssets", false)

return function(callback, p2)
	local imageIds = {}
	local imageIdSet = {}
	return callback(string.format("%sv2/games/%s/media", url.GAME_URL, p2), "GET"):andThen(function(p3)
		if p3 and p3.responseBody and p3.responseBody.data then
			for i, v5 in ipairs(p3.responseBody.data) do
				if not v5.imageId then
					continue
				end

				if defineFastFlag then
					local imageId = tostring(v5.imageId)

					if not imageIdSet[imageId] then
						imageIdSet[imageId] = true
						table.insert(imageIds, imageId)
					end
				else
					table.insert(imageIds, (tostring(v5.imageId)))
				end
			end
		end
	end):finally(function()
		return Promise.resolve(imageIds)
	end)
end

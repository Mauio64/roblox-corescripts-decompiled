local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local defineFastFlag = game:DefineFastFlag("RemoveDuplicatesPlaceMediaAssets", false)

return function(callback, p: string)
	local imageIds = {}
	local imageIdSet = {}
	return callback(string.format("%sv2/games/%s/media", Url.GAME_URL, p), "GET"):andThen(function(p2)
		if p2 and p2.responseBody and p2.responseBody.data then
			for _, v in ipairs(p2.responseBody.data) do
				if not v.imageId then
					continue
				end

				if defineFastFlag then
					local imageId = tostring(v.imageId)

					if not imageIdSet[imageId] then
						imageIdSet[imageId] = true
						table.insert(imageIds, imageId)
					end
				else
					table.insert(imageIds, (tostring(v.imageId)))
				end
			end
		end
	end):finally(function()
		return Promise.resolve(imageIds)
	end)
end

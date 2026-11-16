local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")

local GetGameMedia = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetGameMedia")

function LUAUFORGE_MODULE_GLOBALS_byX_FetchGameMedia(p2, value)
	assert(typeof(value) == "string", "universeId must be a string")
	assert(#value > 0, "universeId must be a non-empty string")

	return GetGameMedia(p2, value):andThen(function(p3)
		if not (p3 and p3.responseBody) then
			return Promise.reject()
		end

		local data = p3.responseBody.data

		if data == nil then
			return Promise.reject()
		end

		local v5 = {}

		for i, v6 in ipairs(data) do
			table.insert(v5, {
				id = v6.id,
				assetTypeId = v6.assetTypeId,
				imageId = v6.imageId
			})
		end

		return Promise.resolve(v5)
	end)
end

return LUAUFORGE_MODULE_GLOBALS_byX_FetchGameMedia

local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)

local GetGameMedia = require(AuthCommon.Http.Requests.GetGameMedia)

function FetchGameMedia(p, value: string)
	assert(typeof(value) == "string", "universeId must be a string")
	assert(#value > 0, "universeId must be a non-empty string")

	return GetGameMedia(p, value):andThen(function(p2)
		if not (p2 and p2.responseBody) then
			return Promise.reject()
		end

		local data = p2.responseBody.data

		if data == nil then
			return Promise.reject()
		end

		local v = {}

		for _, v2 in ipairs(data) do
			table.insert(v, { id = v2.id, assetTypeId = v2.assetTypeId, imageId = v2.imageId })
		end

		return Promise.resolve(v)
	end)
end

return FetchGameMedia

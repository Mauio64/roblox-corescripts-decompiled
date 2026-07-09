local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local GetGameMedia = require(AuthCommon.Http.Requests.GetGameMedia)

function FetchGameMedia(p1, s1: string) -- line: 8
	-- upvalues: GetGameMedia (copy), Promise (copy)
	assert(typeof(s1) == "string", "universeId must be a string")
	assert(#s1 > 0, "universeId must be a non-empty string")

	return GetGameMedia(p1, s1):andThen(function(p2) -- line: 12
		-- upvalues: Promise (copy)
		if p2 and p2.responseBody then
			local data = p2.responseBody.data

			if data == nil then
				return Promise.reject()
			end

			local t1 = {}

			for _, v in ipairs(data) do
				table.insert(t1, {
					id = v.id,
					assetTypeId = v.assetTypeId,
					imageId = v.imageId
				})
			end

			return Promise.resolve(t1)
		end

		return Promise.reject()
	end)
end

return FetchGameMedia

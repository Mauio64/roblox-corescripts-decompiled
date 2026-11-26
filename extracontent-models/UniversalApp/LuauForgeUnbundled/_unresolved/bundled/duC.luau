local module = require("@luauforge/bundled/dtB")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()

	v6.rootPlaceId = tostring(12345)
	v6.name = "Racing Game"
	v6.thumbnailAssetId = tostring(4948327354)
	v6.coplayUsers = {
		{ userId = tostring(4340043999), userDisplayName = "Mr Mittens" }
	}

	return v6
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	v6.rootPlaceId = tostring(data.rootPlaceId)
	v6.name = data.name
	v6.thumbnailAssetId = tostring(data.thumbnailAssetId)

	local v7 = {}

	for i = 1, #data.coplayUsers do
		local coplayUser = data.coplayUsers[i]
		table.insert(v7, {
			userId = tostring(coplayUser.userId),
			userDisplayName = coplayUser.userDisplayName
		})
	end

	v6.coplayUsers = v7

	return module.success(v6)
end

return v5

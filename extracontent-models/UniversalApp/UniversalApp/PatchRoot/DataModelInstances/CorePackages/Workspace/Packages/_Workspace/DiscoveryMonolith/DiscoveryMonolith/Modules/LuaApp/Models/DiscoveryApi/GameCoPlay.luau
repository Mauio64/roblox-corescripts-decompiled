local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 31
		return {}
	end
}

function t1.mock() -- line: 37
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.rootPlaceId = tostring(12345)
	v4.name = "Racing Game"
	v4.thumbnailAssetId = tostring(4948327354)
	v4.coplayUsers = {{
		userDisplayName = "Mr Mittens",
		userId = tostring(4340043999)
	}}

	return v4
end
function t1.fromJsonData(p1) -- line: 53
	-- upvalues: t1 (copy), Result (copy)
	local v6 = t1.new()

	v6.rootPlaceId = tostring(p1.rootPlaceId)
	v6.name = p1.name
	v6.thumbnailAssetId = tostring(p1.thumbnailAssetId)

	local t2 = {}

	for i = 1, #p1.coplayUsers do
		local v9 = p1.coplayUsers[i]

		table.insert(t2, {
			userId = tostring(v9.userId),
			userDisplayName = v9.userDisplayName
		})
	end

	v6.coplayUsers = t2

	return Result.success(v6)
end

return t1

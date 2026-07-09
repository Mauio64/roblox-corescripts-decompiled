local ContentSharingRodux = script:FindFirstAncestor("ContentSharingRodux")
local getPostsByUserId = require(ContentSharingRodux.Reducers.ContentSharing.getPostsByUserId)
local t1 = {
	byUserId = {}
}

return function(p1) -- line: 9
	-- upvalues: getPostsByUserId (copy), t1 (copy)
	local v5 = getPostsByUserId(p1)

	return function(p2, p3) -- line: 12
		-- upvalues: t1 (copy), v5 (copy)
		local v8 = p2 or t1

		return v5(v8, p3)
	end
end

local CommunityVisibility = require(script.Parent.Parent.Enums.CommunityVisibility)
local t1 = {
	new = function() -- line: 12
		-- upvalues: CommunityVisibility (copy)
		return {
			communityId = "",
			name = "",
			description = "",
			visibility = CommunityVisibility.Private
		}
	end
}

function t1.mock(p1) -- line: 21
	-- upvalues: t1 (copy), CommunityVisibility (copy)
	local v4 = p1 or {}
	local v5 = t1.new()

	v5.communityId = v4.communityId or "abcd" .. tostring(math.random(1000, 9999))
	v5.name = v4.name or "my community"
	v5.description = v4.description or "description of the community"
	v5.visibility = v4.visibility or CommunityVisibility.Public

	return v5
end
function t1.fromJsonData(p2) -- line: 33
	-- upvalues: t1 (copy)
	local v7 = t1.new()

	v7.communityId = p2.communityId
	v7.name = p2.name
	v7.description = p2.description
	v7.visibility = p2.visibility

	return v7
end

return t1

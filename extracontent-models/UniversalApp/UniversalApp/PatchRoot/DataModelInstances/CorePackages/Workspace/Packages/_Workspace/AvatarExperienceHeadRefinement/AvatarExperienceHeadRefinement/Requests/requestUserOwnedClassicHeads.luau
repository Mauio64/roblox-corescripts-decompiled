local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local Http = require(Parent.Http)

local function requestUserOwnedClassicHeads(p1, s1: string, s2: string?) -- line: 5
	-- upvalues: Http (copy)
	return p1(string.format("%sv2/users/%s/inventory?limit=100&sortOrder=Desc&assetTypes=Head&cursor=%s", Http.Url.INVENTORY_URL, s1, s2 or ""), "GET")
end

return requestUserOwnedClassicHeads

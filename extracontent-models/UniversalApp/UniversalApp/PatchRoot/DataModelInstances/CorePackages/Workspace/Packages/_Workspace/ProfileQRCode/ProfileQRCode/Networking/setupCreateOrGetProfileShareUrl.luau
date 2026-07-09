local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Http = require(Parent.Http)

local function v3(p1) -- line: 7
	-- upvalues: Http (copy)
	return p1(Http.Url.APIS_URL .. "sharelinks"):path("v1"):path("get-or-create-link"):body({
		linkType = "Profile"
	})
end

return {
	profileLinkType = "Profile",
	buildUrl = v3,
	setupRequest = function(p2) -- line: 14
		-- upvalues: v3 (copy)
		return p2.POST(script.Name, v3)
	end
}

local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Http = require(parent.Http)

local function fn(callback, _)
	return callback(Http.Url.APIS_URL .. "sharelinks"):path("v1"):path("get-or-create-link"):body({
		linkType = "Profile"
	})
end

return {
	profileLinkType = "Profile",
	buildUrl = fn,
	setupRequest = function(p)
		return p.POST(script.Name, fn)
	end
}

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Http")

local function fn(callback, p2)
	return callback(Http.Url.APIS_URL .. "sharelinks"):path("v1"):path("get-or-create-link"):body({
		linkType = "Profile"
	})
end

return {
	profileLinkType = "Profile",
	buildUrl = fn,
	setupRequest = function(p2)
		return p2.POST("setupCreateOrGetProfileShareUrl", fn)
	end
}

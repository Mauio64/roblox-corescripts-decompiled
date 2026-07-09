local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local t1 = {
	validateJson = t.interface({
		appType = t.string,
		type = t.string,
		userAccessToken = t.string,
		userOpenId = t.string
	}),
	new = function() -- line: 20
		return {}
	end
}

function t1.mock() -- line: 24
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.appType = "PlayerMobile"
	v4.type = "QQ"
	v4.userAccessToken = "userAccessTokenStringFromTencentMSDK"
	v4.userOpenId = "userOpenIDStringFromTencentMSDK"

	return v4
end
function t1.fromJsonData(p1) -- line: 33
	-- upvalues: t1 (copy)
	assert(t1.validateJson(p1), "Error: TencentAuthInfo JSON is not valid.")

	local v6 = t1.new()

	v6.appType = p1.appType
	v6.type = p1.type
	v6.userAccessToken = p1.userAccessToken
	v6.userOpenId = p1.userOpenId

	return v6
end

return t1

local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/hJE")
local module2 = require("@luauforge/bundled/hJG")
local module3 = require("@luauforge/bundled/hJI")
local module4 = require("@luauforge/bundled/hJJ")
local module5 = require("@luauforge/bundled/hJK")

return Rodux.combineReducers({
	TencentAuthInfo = module,
	TencentNotice = module2,
	TencentNoticeReadStatus = module3,
	MSDKAuth = module4,
	SignUp = module5
})

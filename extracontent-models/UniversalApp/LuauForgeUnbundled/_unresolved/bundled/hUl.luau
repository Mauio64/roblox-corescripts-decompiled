local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/hUm")
local module2 = require("@luauforge/bundled/hUo")
local module3 = require("@luauforge/bundled/hUq")
local module4 = require("@luauforge/bundled/hUr")
local module5 = require("@luauforge/bundled/hUs")

return Rodux.combineReducers({
	TencentAuthInfo = module,
	TencentNotice = module2,
	TencentNoticeReadStatus = module3,
	MSDKAuth = module4,
	SignUp = module5
})

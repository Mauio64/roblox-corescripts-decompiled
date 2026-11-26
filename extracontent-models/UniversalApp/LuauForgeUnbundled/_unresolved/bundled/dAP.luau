local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dAQ")
local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.createReducer(birthday.new(), {
	[module.name] = function(p2, p3)
		assert(birthday.is(p3.birthday), "SignUpBirthday must be a Birthday model")
		return p3.birthday
	end
})

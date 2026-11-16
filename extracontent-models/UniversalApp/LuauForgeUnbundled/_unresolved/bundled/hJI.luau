local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/fAC")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local noticeId = p3.noticeId
		return Cryo.Dictionary.join(p2, { [noticeId] = true })
	end
})

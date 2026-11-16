local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/hJH")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { noticeList = p3.noticeList })
	end
})

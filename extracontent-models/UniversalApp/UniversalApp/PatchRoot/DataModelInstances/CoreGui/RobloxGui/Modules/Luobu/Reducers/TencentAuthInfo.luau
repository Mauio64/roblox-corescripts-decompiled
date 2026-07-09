local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetTencentAuthInfo = require(Modules.Luobu.Actions.SetTencentAuthInfo)

return Rodux.createReducer({}, {
	[SetTencentAuthInfo.name] = function(p1, p2) -- line: 8
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			tencentAuthInfo = p2.tencentAuthInfo
		})
	end
})

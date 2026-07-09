local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetTencentNoticeInfo = require(Modules.Luobu.Actions.SetTencentNoticeInfo)

return Rodux.createReducer({}, {
	[SetTencentNoticeInfo.name] = function(p1, p2) -- line: 8
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			noticeList = p2.noticeList
		})
	end
})

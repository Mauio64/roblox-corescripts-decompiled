local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ReadTencentNoticeId = require(Modules.Luobu.Actions.ReadTencentNoticeId)

return Rodux.createReducer({}, {
	[ReadTencentNoticeId.name] = function(p1, p2) -- line: 8
		-- upvalues: Cryo (copy)
		local noticeId = p2.noticeId

		return Cryo.Dictionary.join(p1, {
			[noticeId] = true
		})
	end
})

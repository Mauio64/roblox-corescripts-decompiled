local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local StartedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.StartedWaitingOnLCUpdate)
local FinishedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.FinishedWaitingOnLCUpdate)

return Rodux.createReducer(false, {
	[StartedWaitingOnLCUpdate.name] = function(_, _) -- line: 17
		return true
	end,
	[FinishedWaitingOnLCUpdate.name] = function(_, _) -- line: 21
		return false
	end
})

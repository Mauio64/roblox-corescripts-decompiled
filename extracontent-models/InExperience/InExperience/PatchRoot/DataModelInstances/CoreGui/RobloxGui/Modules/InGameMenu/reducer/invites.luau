local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent.Parent

local ReceivedUserInviteStatus = require(parent.Actions.ReceivedUserInviteStatus)

return Rodux.createReducer({}, {
	[ReceivedUserInviteStatus.name] = function(p, p2)
		local userId = p2.userId
		local inviteStatus = p2.inviteStatus

		return Cryo.Dictionary.join(p, { [userId] = inviteStatus })
	end
})

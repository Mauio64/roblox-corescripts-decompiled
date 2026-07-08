local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux
local ParentParent = script.Parent.Parent
local ReceivedUserInviteStatus = require(ParentParent.Actions.ReceivedUserInviteStatus)

return Rodux.createReducer({}, {
	[ReceivedUserInviteStatus.name] = function(p1, p2) -- line: 12
		-- upvalues: Cryo (copy)
		local userId = p2.userId
		local inviteStatus = p2.inviteStatus

		return Cryo.Dictionary.join(p1, {
			[userId] = inviteStatus
		})
	end
})

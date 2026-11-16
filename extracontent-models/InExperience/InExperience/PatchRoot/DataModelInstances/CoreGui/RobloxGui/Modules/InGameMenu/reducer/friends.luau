local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent.Parent

local SetFriendStatus = require(parent.Actions.SetFriendStatus)

return Rodux.createReducer({}, {
	[SetFriendStatus.name] = function(p, p2)
		local userId = p2.userId
		local friendStatus = p2.friendStatus

		return Cryo.Dictionary.join(p, {
			[userId] = friendStatus or Cryo.None
		})
	end
})

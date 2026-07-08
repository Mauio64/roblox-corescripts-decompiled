local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux
local ParentParent = script.Parent.Parent
local SetFriendStatus = require(ParentParent.Actions.SetFriendStatus)

return Rodux.createReducer({}, {
	[SetFriendStatus.name] = function(p1, p2) -- line: 12
		-- upvalues: Cryo (copy)
		local userId = p2.userId
		local friendStatus = p2.friendStatus

		return Cryo.Dictionary.join(p1, {
			[userId] = friendStatus or Cryo.None
		})
	end
})

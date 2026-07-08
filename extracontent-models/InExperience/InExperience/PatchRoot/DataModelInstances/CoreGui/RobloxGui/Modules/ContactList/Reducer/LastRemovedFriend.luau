local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local UpdateLastFriend = require(script.Parent.Parent.Actions.UpdateLastFriend)

return Rodux.createReducer({
	lastRemovedFriendId = ""
}, {
	[UpdateLastFriend.name] = function(p1, p2) -- line: 10
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			lastRemovedFriendId = tostring(p2.lastRemovedFriendId) .. tostring(DateTime.now())
		})
	end
})

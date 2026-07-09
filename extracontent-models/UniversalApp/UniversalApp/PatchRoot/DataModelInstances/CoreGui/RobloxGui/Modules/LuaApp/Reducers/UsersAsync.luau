local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ReceivedAllFriends = require(Modules.LuaApp.Actions.ReceivedAllFriends)
local ReceivedUserPresence = require(CorePackages.Workspace.Packages.UserLib).Actions.ReceivedUserPresence
local RequestAllFriends = require(Modules.LuaApp.Actions.RequestAllFriends)
local RequestUserPresence = require(Modules.LuaApp.Actions.RequestUserPresence)
local Immutable = require(Modules.Common.Immutable)

return function(p1, p2) -- line: 12
	-- upvalues: RequestAllFriends (copy), Immutable (copy), ReceivedAllFriends (copy), RequestUserPresence (copy), ReceivedUserPresence (copy)
	local v10 = p1 or {}

	if p2.type == RequestAllFriends.name then
		return Immutable.JoinDictionaries(v10, {
			allFriendsIsFetching = true
		})
	end

	if p2.type == ReceivedAllFriends.name then
		return Immutable.JoinDictionaries(v10, {
			allFriendsIsFetching = false
		})
	end

	if p2.type == RequestUserPresence.name then
		local v11 = v10[p2.userId] or {}

		return Immutable.JoinDictionaries(v10, {
			[p2.userId] = Immutable.JoinDictionaries(v11, {
				presenceIsFetching = true
			})
		})
	end

	if p2.type == ReceivedUserPresence.name then
		local v12 = v10[p2.userId]

		if v12 then
			return Immutable.JoinDictionaries(v10, {
				[p2.userId] = Immutable.JoinDictionaries(v12, {
					presenceIsFetching = false
				})
			})
		end
	end

	return v10
end

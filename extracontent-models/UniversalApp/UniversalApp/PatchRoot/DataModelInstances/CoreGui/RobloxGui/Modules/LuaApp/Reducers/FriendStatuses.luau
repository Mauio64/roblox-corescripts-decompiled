local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local AddFriendStatus = require(Modules.LuaApp.Actions.AddFriendStatus)
local RoduxNetworking = require(CorePackages.Packages.RoduxNetworking)
local v6 = require(CorePackages.Workspace.Packages.FriendsNetworking).config({
	roduxNetworking = RoduxNetworking.mock()
})

return function(p1, p2) -- line: 12
	-- upvalues: AddFriendStatus (copy), Cryo (copy), v6 (copy)
	local v9 = p1 or {}

	if p2.type == AddFriendStatus.name then
		return (Cryo.Dictionary.join(v9, {
			[p2.id] = p2.status
		}))
	end

	if p2.type == v6.RequestFriendshipFromUserId.Succeeded.name then
		local str = tostring(p2.namedIds.users)

		return Cryo.Dictionary.join(v9, {
			[str] = Enum.FriendStatus.FriendRequestSent
		})
	end

	if p2.type == v6.AcceptFriendRequestFromUserId.Succeeded.name then
		local str = tostring(p2.ids[1])

		return Cryo.Dictionary.join(v9, {
			[str] = Enum.FriendStatus.Friend
		})
	end

	if p2.type == v6.DeclineFriendRequestFromUserId.Succeeded.name then
		local t1 = {}

		for _, v14 in p2.ids do
			t1[tostring(v14)] = Enum.FriendStatus.NotFriend
		end

		return Cryo.Dictionary.join(v9, t1)
	end

	if p2.type == v6.UnfriendTargetUserId.Succeeded.name then
		local str = tostring(p2.namedIds.users)

		return Cryo.Dictionary.join(v9, {
			[str] = Enum.FriendStatus.NotFriend
		})
	end

	return v9
end

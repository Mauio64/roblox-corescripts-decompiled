local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Result = require(Modules.LuaApp.Result)
local DEPRECATED_FriendsGetFriendStatuses = require(CorePackages.Workspace.Packages.Http).Requests.DEPRECATED_FriendsGetFriendStatuses
local AddFriendStatus = require(Modules.LuaApp.Actions.AddFriendStatus)

local function convertStringStatusToEnum(p1) -- line: 12
	if p1 == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	end

	if p1 == "Friends" then
		return Enum.FriendStatus.Friend
	end

	if p1 == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	end

	if p1 == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

return function(p2, p3) -- line: 26
	-- upvalues: Cryo (copy), PerformFetch (copy), DEPRECATED_FriendsGetFriendStatuses (copy), Result (copy), AddFriendStatus (copy), Promise (copy)
	local v13 = Cryo.Dictionary.join({}, p3)

	table.sort(v13)

	return PerformFetch.Single("luaapp.friends.statuses." .. table.concat(v13), function(p4) -- line: 30
		-- upvalues: DEPRECATED_FriendsGetFriendStatuses (copy), p2 (copy), p3 (copy), Result (copy), AddFriendStatus (copy), Promise (copy)
		return DEPRECATED_FriendsGetFriendStatuses(p2, p3):andThen(function(p5) -- line: 31
			-- upvalues: Result (copy), p4 (copy), AddFriendStatus (copy), Promise (copy)
			if p5 and (p5.responseBody and p5.responseBody.data) then
				local data = p5.responseBody.data

				if type(data) ~= "table" then
					return Result.error("ApiFetchFriendStatuses expects entries to be a table")
				end

				for i = 1, #data do
					local v18 = data[i]

					if type(v18.id) ~= "number" then
						return Result.error("ApiFetchFriendStatuses expects entry.id to be a number")
					end

					if type(v18.status) ~= "string" then
						return Result.error("ApiFetchFriendStatuses expects entry.status to be a string")
					end

					local v19 = p4
					local v20 = AddFriendStatus
					local str = tostring(v18.id)
					local status = v18.status

					v19:dispatch(v20(str, if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend))
				end

				return Promise.resolve(p5)
			end

			return Promise.reject()
		end, function(p6) -- line: 57
			-- upvalues: Promise (copy)
			return Promise.reject(p6)
		end)
	end)
end

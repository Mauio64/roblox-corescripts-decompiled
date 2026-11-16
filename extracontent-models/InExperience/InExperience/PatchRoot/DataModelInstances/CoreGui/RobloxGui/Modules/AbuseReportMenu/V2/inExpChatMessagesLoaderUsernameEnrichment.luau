local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local function collectUserIdsMissingUsername(items)
	local userIdSet = {}
	local userIds = {}

	for _, item in items do
		for _, item2 in item.items do
			local meta = item2.meta
			local userId = meta and meta.userId
			local username = meta and meta.username

			if not userId or userId == "0" or not (not username or username == "") or userIdSet[userId] then
				continue
			end

			userIdSet[userId] = true
			table.insert(userIds, userId)
		end
	end

	return userIds
end

local function enrichGroupsWithProfileUsernames(items, data)
	local usernamesByUserId = {}

	for _, item in data do
		local username = item.names.getUsername(false)

		if username and #username > 0 then
			usernamesByUserId[item.userId] = username
		end
	end

	for _, item in items do
		for _, item2 in item.items do
			local meta = item2.meta

			if not (meta and (not meta.username or meta.username == "")) then
				continue
			end

			local username = usernamesByUserId[meta.userId]

			if username then
				meta.username = username
			end
		end
	end
end

return {
	collectUserIdsMissingUsername = collectUserIdsMissingUsername,
	enrichGroupsWithProfileUsernames = enrichGroupsWithProfileUsernames,
	enrichMissingUsernames = function(p)
		local v = collectUserIdsMissingUsername(p)

		if #v == 0 then
			return Promise.resolve(p)
		end

		return Promise.new(function(callback)
			UserProfileStore.get().fetchNamesByUserIds(v, function(p2)
				if p2.status == "success" and p2.data then
					enrichGroupsWithProfileUsernames(p, p2.data)
					callback(p)
				elseif p2.status == "failed" then
					callback(p)
				end
			end)
		end)
	end
}

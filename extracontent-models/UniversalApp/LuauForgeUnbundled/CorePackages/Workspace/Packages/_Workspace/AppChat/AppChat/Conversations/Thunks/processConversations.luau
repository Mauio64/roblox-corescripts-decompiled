local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").llama
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Models.UserModel
local addUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Actions.AddUsers
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local function extractConversationsAndUsers(items, users)
	local ids = {}
	local result = {}

	for k, item in items do
		table.insert(ids, item.id)

		if item.participant_user_ids then
			for k2, participant_user_id in item.participant_user_ids do
				local v5 = tostring(participant_user_id)

				if result[v5] then
					continue
				end

				local user_data = item.user_data

				if not user_data then
					continue
				end

				local v6 = user_data[v5]

				if not v6 then
					continue
				end

				local v7 = users[v5]
				local fromDataTable = userModel.fromDataTable
				local v8 = { id = v6.id, name = v6.name, displayName = 0, isFriend = 0 }
				local v9 = if v7 then v7.displayName else v6.display_name
				v8.displayName = v9
				local v10 = if v7 then v7.isFriend else false
				v8.isFriend = v10
				local v11 = fromDataTable(v8)

				result[v11.id] = v11
			end
		else
			for i, participant in ipairs(item.participants) do
				if result[tostring(participant.targetId)] then
					continue
				end

				local v5 = users[tostring(participant.targetId)]
					or userModel.fromDataTable({
						id = participant.targetId,
						name = participant.name,
						displayName = participant.displayName,
						isFriend = false
					})

				result[v5.id] = v5
			end
		end
	end

	return ids, result, (llama.Dictionary.keys(result))
end

return function(p2)
	return function(object)
		if not p2 then
			return
		end

		local v5, v6, v7 = extractConversationsAndUsers(p2, object:getState().Users or {})

		object:dispatch(addUsers(v6))

		if not FFlagAppChatPresenceStoreMigration then
			object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v7)):catch(function(p3)
				warn("NetworkingPresence failure in processConversations, Status: " .. tostring(p3))
			end)
		end
	end
end

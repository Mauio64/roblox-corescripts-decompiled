local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel
local UserLib2 = require(parent.UserLib)
local AddUsers = UserLib2.Actions.AddUsers
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function extractConversationsAndUsers(items, users)
	local ids = {}
	local result = {}

	for _, item in items do
		table.insert(ids, item.id)

		if item.participant_user_ids then
			for _, participant_user_id in item.participant_user_ids do
				local v = tostring(participant_user_id)

				if result[v] then
					continue
				end

				local user_data = item.user_data

				if not user_data then
					continue
				end

				local v2 = user_data[v]

				if not v2 then
					continue
				end

				local v3 = users[v]
				local fromDataTable = UserModel.fromDataTable
				local v4 = { id = v2.id, name = v2.name, displayName = 0, isFriend = 0 }
				local displayName

				if v3 then
					displayName = v3.displayName
				else
					displayName = v2.display_name
				end

				v4.displayName = displayName
				local isFriend = if v3 then v3.isFriend else false
				v4.isFriend = isFriend
				local v5 = fromDataTable(v4)

				result[v5.id] = v5
			end
		else
			for _, participant in ipairs(item.participants) do
				if result[tostring(participant.targetId)] then
					continue
				end

				local v = users[tostring(participant.targetId)]
					or UserModel.fromDataTable({
						id = participant.targetId,
						name = participant.name,
						displayName = participant.displayName,
						isFriend = false
					})

				result[v.id] = v
			end
		end
	end

	return ids, result, (llama.Dictionary.keys(result))
end

return function(p)
	return function(object)
		if not p then
			return
		end

		local _, v, v2 = extractConversationsAndUsers(p, object:getState().Users or {})

		object:dispatch(AddUsers(v))

		if not FFlagAppChatPresenceStoreMigration then
			object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v2)):catch(function(p2)
				warn("NetworkingPresence failure in processConversations, Status: " .. tostring(p2))
			end)
		end
	end
end

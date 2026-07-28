local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local llama = require(AppChatParent.LuaSocialLibrariesDeps).llama
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local AddUsers = require(AppChatParent.UserLib).Actions.AddUsers
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function extractConversationsAndUsers(p1, p2) -- line: 10
	-- upvalues: UserModel (copy), llama (copy)
	local t1 = {}
	local t2 = {}

	for _, v14 in p1 do
		table.insert(t1, v14.id)

		if v14.participant_user_ids then
			for _, v16 in v14.participant_user_ids do
				local str = tostring(v16)

				if not t2[str] then
					local user_data = v14.user_data

					if user_data then
						local v19 = user_data[str]

						if v19 then
							local v20 = p2[str]
							local v21 = UserModel.fromDataTable({
								id = v19.id,
								name = v19.name,
								displayName = if not v20 then v19.display_name else v20.displayName,
								isFriend = not not v20 and v20.isFriend
							})

							t2[v21.id] = v21
						end
					end
				end
			end
		else
			for _, v in ipairs(v14.participants) do
				if not t2[tostring(v.targetId)] then
					local v24 = p2[tostring(v.targetId)] or UserModel.fromDataTable({
						isFriend = false,
						id = v.targetId,
						name = v.name,
						displayName = v.displayName
					})

					t2[v24.id] = v24
				end
			end
		end
	end

	return t1, t2, (llama.Dictionary.keys(t2))
end

return function(p3) -- line: 63
	-- upvalues: extractConversationsAndUsers (copy), AddUsers (copy), FFlagAppChatPresenceStoreMigration (copy), NetworkingPresence (copy)
	return function(p4) -- line: 64
		-- upvalues: p3 (copy), extractConversationsAndUsers (copy), AddUsers (copy), FFlagAppChatPresenceStoreMigration (copy), NetworkingPresence (copy)
		if not p3 then
			return
		end

		local v27 = p4:getState()
		local _, v29, v30 = extractConversationsAndUsers(p3, v27.Users or {})

		p4:dispatch(AddUsers(v29))

		if not FFlagAppChatPresenceStoreMigration then
			p4:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v30)):catch(function(p5) -- line: 74
				warn("NetworkingPresence failure in processConversations, Status: " .. tostring(p5))
			end)
		end
	end
end

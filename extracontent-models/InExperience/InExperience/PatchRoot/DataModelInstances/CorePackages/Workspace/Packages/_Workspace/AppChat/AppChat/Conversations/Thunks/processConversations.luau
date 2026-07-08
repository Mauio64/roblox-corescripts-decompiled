local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local llama = require(AppChatParent.LuaSocialLibrariesDeps).llama
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local AddUsers = require(AppChatParent.UserLib).Actions.AddUsers

local function extractConversationsAndUsers(p1, p2) -- line: 9
	-- upvalues: UserModel (copy), llama (copy)
	local t1 = {}
	local t2 = {}

	for _, v13 in p1 do
		table.insert(t1, v13.id)

		if v13.participant_user_ids then
			for _, v15 in v13.participant_user_ids do
				local str = tostring(v15)

				if not t2[str] then
					local user_data = v13.user_data

					if user_data then
						local v18 = user_data[str]

						if v18 then
							local v19 = p2[str]
							local v20 = UserModel.fromDataTable({
								id = v18.id,
								name = v18.name,
								displayName = if not v19 then v18.display_name else v19.displayName,
								isFriend = not not v19 and v19.isFriend
							})

							t2[v20.id] = v20
						end
					end
				end
			end
		else
			for _, v in ipairs(v13.participants) do
				if not t2[tostring(v.targetId)] then
					local v23 = p2[tostring(v.targetId)] or UserModel.fromDataTable({
						isFriend = false,
						id = v.targetId,
						name = v.name,
						displayName = v.displayName
					})

					t2[v23.id] = v23
				end
			end
		end
	end

	return t1, t2, (llama.Dictionary.keys(t2))
end

return function(p3) -- line: 62
	-- upvalues: extractConversationsAndUsers (copy), AddUsers (copy), NetworkingPresence (copy)
	return function(p4) -- line: 63
		-- upvalues: p3 (copy), extractConversationsAndUsers (copy), AddUsers (copy), NetworkingPresence (copy)
		if not p3 then
			return
		end

		local v26 = p4:getState()
		local _, v28, v29 = extractConversationsAndUsers(p3, v26.Users or {})

		p4:dispatch(AddUsers(v28))
		p4:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v29)):catch(function(p5) -- line: 72
			warn("NetworkingPresence failure in processConversations, Status: " .. tostring(p5))
		end)
	end
end

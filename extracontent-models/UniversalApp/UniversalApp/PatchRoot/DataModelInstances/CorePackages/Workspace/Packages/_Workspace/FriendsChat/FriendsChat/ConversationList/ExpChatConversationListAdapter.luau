local Parent = script:FindFirstAncestor("FriendsChat").Parent
local AppChat = require(Parent.AppChat)
local AppChatNetworking = require(Parent.AppChatNetworking)
local ConversationChannels = require(Parent.AppChat.ConversationChannels)
local createConversationFromFriendPlaceholder = require(Parent.AppChat.createConversationFromFriendPlaceholder)
local fetchConversationDetailsToSignals = require(Parent.AppChat.fetchConversationDetailsToSignals)
local fetchConversationListPageToSignals = require(Parent.AppChat.fetchConversationListPageToSignals)
local getConversationTitle = require(Parent.AppChat.getConversationTitle)
local GetConversationStore = require(Parent.AppChat.GetConversationStore)
local logger = AppChat.Components.ChatConversation.logger

local function getMessageTimestamp(p1) -- line: 70
	if type(p1.created_at) == "string" then
		local ok, result = pcall(function() -- line: 72
			-- upvalues: p1 (copy)
			return DateTime.fromIsoDate(p1.created_at)
		end)

		if ok then
			return result
		end
	end

	return nil
end
local function getUnixTime(p2) -- line: 83
	if p2 == nil then
		return nil
	end

	if typeof(p2) == "DateTime" then
		return p2.UnixTimestamp
	end

	if type(p2) == "table" and p2.GetUnixTimestamp ~= nil then
		return p2:GetUnixTimestamp()
	end

	return nil
end
local function getPreviewContent(p3) -- line: 96
	return p3.preview_content or p3.content
end
local function getMessageUnixTime(p4) -- line: 100
	local g35 = nil
	local ok = nil
	local result = nil

	repeat
		if g35 or type(p4.created_at) == "string" then
			if not g35 then
				ok, result = pcall(function() -- line: 72
					-- upvalues: p4 (copy)
					return DateTime.fromIsoDate(p4.created_at)
				end)
			end

			if g35 or ok then
				g35 = false

				if result ~= nil then
					return result.UnixTimestamp
				end

				return nil
			end
		end

		result = nil
		g35 = true
	until not g35
end
local function isPreviewableMessage(p5) -- line: 105
	return p5 ~= nil and (p5.id ~= nil and (p5.is_previewable == true and (p5.preview_content or p5.content) ~= nil))
end
local function getNewestPreviewableMessage(t1: {[any]: any}) -- line: 114
	local v40 = nil
	local v41 = nil
	local g44 = nil

	for _, v43 in t1 do
		if v43 == nil or (v43.id == nil or (v43.is_previewable ~= true or (v43.preview_content or v43.content) == nil)) then
			continue
		end

		local result

		repeat
			if not g44 and type(v43.created_at) == "string" then
				local ok

				ok, result = pcall(function() -- line: 72
					-- upvalues: v43 (copy)
					return DateTime.fromIsoDate(v43.created_at)
				end)

				if not ok then
					g44 = true
				end
			else
				g44 = false
				result = nil
			end
		until not g44

		local v47 = if result == nil then nil else result.UnixTimestamp

		if v40 == nil then
			v40 = v43
			v41 = v47
		elseif v47 ~= nil and (v41 == nil or v41 < v47) then
			v40 = v43
			v41 = v47
		end
	end

	return v40
end
local function shouldUpdatePreview(p6, p7) -- line: 133
	if p7 == nil then
		return true
	end

	local lastUpdated = p6.lastUpdated
	local v51 = if lastUpdated ~= nil then if typeof(lastUpdated) ~= "DateTime" then if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp() else lastUpdated.UnixTimestamp else nil

	if v51 == nil then
		return true
	end

	return v51 <= p7.UnixTimestamp
end
local function hasNewerUnreadMessage(t2: {[any]: any}, p8, t3: {[any]: any}?) -- line: 153
	if t3 == nil or t3.hasUnreadMessages ~= true then
		return false
	end

	local lastUpdated = p8.lastUpdated
	local v56 = ((if lastUpdated ~= nil then (if typeof(lastUpdated) ~= "DateTime" then (if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp()) else lastUpdated.UnixTimestamp) else nil)) or 0
	local g60 = nil

	for _, v58 in t2 do
		if v58 == nil or v58.is_badgeable ~= true then
			continue
		end

		local sender_user_id = v58.sender_user_id

		if sender_user_id ~= nil and (t3.localUserId == nil or tostring(sender_user_id) ~= tostring(t3.localUserId)) then
			local result

			repeat
				if not g60 and type(v58.created_at) == "string" then
					local ok

					ok, result = pcall(function() -- line: 72
						-- upvalues: v58 (copy)
						return DateTime.fromIsoDate(v58.created_at)
					end)

					if not ok then
						g60 = true
					end
				else
					g60 = false
					result = nil
				end
			until not g60

			local v63 = if result == nil then nil else result.UnixTimestamp

			if v63 == nil or not (v56 < v63) then
				continue
			end

			return true
		end
	end

	return false
end

return {
	ConversationSource = ConversationChannels.Source,
	createConversationFromFriendPlaceholder = createConversationFromFriendPlaceholder,
	fetchConversationDetailsToSignals = fetchConversationDetailsToSignals,
	fetchConversationListPageToSignals = fetchConversationListPageToSignals,
	getConversationStore = function() -- line: 27
		-- upvalues: GetConversationStore (copy)
		return GetConversationStore(false)
	end,
	getConversationTitle = getConversationTitle,
	isFriendsConversation = function(s1: string?, p9) -- line: 31
		-- upvalues: GetConversationStore (copy), ConversationChannels (copy)
		if s1 == nil or s1 == "" then
			return false
		end

		local v21 = GetConversationStore(false).getConversation(s1, p9 or false)

		return v21 ~= nil and v21.source == ConversationChannels.Source.Friends
	end,
	markConversationRead = function(s2: string, b1: boolean?) -- line: 39
		-- upvalues: GetConversationStore (copy), AppChatNetworking (copy), logger (copy)
		local v24 = GetConversationStore(false)
		local v25 = v24.getConversation(s2, false)
		local v26 = b1 == true

		if v25 == nil then
			if not v26 then
				return
			end
		elseif v25.hasUnreadMessages == true then
			local v27 = table.clone(v25)

			v27.hasUnreadMessages = false
			v24.upsertConversation(v27, false)
			v26 = true
		end

		if not v26 then
			return
		end

		return AppChatNetworking.http.MarkConversationRead(nil, s2):catch(function(p10) -- line: 58
			-- upvalues: logger (copy), s2 (copy)
			logger:warning(`Failed to mark conversation read for { s2 }: { tostring(p10) }`)
		end)
	end,
	removeConversation = function(s3: string) -- line: 66
		-- upvalues: GetConversationStore (copy)
		GetConversationStore(false).removeConversation(s3)
	end,
	updateConversationPreviewFromMessages = function(s4: string, t4: {[any]: any}, t5: {[any]: any}?) -- line: 183
		-- upvalues: GetConversationStore (copy), fetchConversationListPageToSignals (copy), logger (copy), getNewestPreviewableMessage (copy), hasNewerUnreadMessage (copy)
		local v67 = GetConversationStore(false)
		local v68 = v67.getConversation(s4, false)

		if v68 == nil then
			if t5 ~= nil and t5.refreshListOnMissingConversation == true then
				fetchConversationListPageToSignals():catch(function(p11) -- line: 192
					-- upvalues: logger (copy)
					logger:warning(`Failed to refresh conversation list after realtime update: { tostring(p11) }`)
				end)
			end

			return false, false
		end

		local v69 = nil
		local v70 = getNewestPreviewableMessage(t4)
		local g71 = nil
		local g73 = nil
		local ok = nil
		local result = nil

		repeat
			if g71 or v70 == nil then
				g71 = false

				local v72 = hasNewerUnreadMessage(t4, v68, t5)

				if v68.hasUnreadMessages ~= true and v72 then
					v69 = v69 or table.clone(v68)
					v69.hasUnreadMessages = true
				end

				if v69 == nil then
					return false, false
				end

				v67.upsertConversation(v69, false)

				return true, v72
			end

			repeat
				if g73 or type(v70.created_at) == "string" then
					if not g73 then
						ok, result = pcall(function() -- line: 72
							-- upvalues: v70 (copy)
							return DateTime.fromIsoDate(v70.created_at)
						end)
					end

					if g73 or ok then
						g73 = false

						local v76

						if result == nil then
							v76 = true
						else
							local lastUpdated = v68.lastUpdated
							local v78 = if lastUpdated ~= nil then if typeof(lastUpdated) ~= "DateTime" then if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp() else lastUpdated.UnixTimestamp else nil

							v76 = v78 == nil or v78 <= result.UnixTimestamp
						end

						if v76 then
							v69 = table.clone(v68)
							v69.previewMessageId = tostring(v70.id)
							v69.previewContent = v70.preview_content or v70.content
							v69.lastUpdated = result or DateTime.now()
						end

						g71 = true
					end
				end

				if g71 then
					break
				end

				result = nil
				g73 = true
			until not g73
		until not g71
	end
}

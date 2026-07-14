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

local function getMessageTimestamp(p1) -- line: 76
	if type(p1.created_at) == "string" then
		local ok, result = pcall(function() -- line: 78
			-- upvalues: p1 (copy)
			return DateTime.fromIsoDate(p1.created_at)
		end)

		if ok then
			return result
		end
	end

	return nil
end
local function getUnixTime(p2) -- line: 89
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
local function getPreviewContent(p3) -- line: 102
	return p3.preview_content or p3.content
end
local function getMessageUnixTime(p4) -- line: 106
	local g36 = nil
	local ok = nil
	local result = nil

	repeat
		if g36 or type(p4.created_at) == "string" then
			if not g36 then
				ok, result = pcall(function() -- line: 78
					-- upvalues: p4 (copy)
					return DateTime.fromIsoDate(p4.created_at)
				end)
			end

			if g36 or ok then
				g36 = false

				if result ~= nil then
					return result.UnixTimestamp
				end

				return nil
			end
		end

		result = nil
		g36 = true
	until not g36
end
local function isPreviewableMessage(p5) -- line: 111
	return p5 ~= nil and (p5.id ~= nil and (p5.is_previewable == true and (p5.preview_content or p5.content) ~= nil))
end
local function getNewestPreviewableMessage(t1: {[any]: any}) -- line: 120
	local v41 = nil
	local v42 = nil
	local g45 = nil

	for _, v44 in t1 do
		if v44 == nil or (v44.id == nil or (v44.is_previewable ~= true or (v44.preview_content or v44.content) == nil)) then
			continue
		end

		local result

		repeat
			if not g45 and type(v44.created_at) == "string" then
				local ok

				ok, result = pcall(function() -- line: 78
					-- upvalues: v44 (copy)
					return DateTime.fromIsoDate(v44.created_at)
				end)

				if not ok then
					g45 = true
				end
			else
				g45 = false
				result = nil
			end
		until not g45

		local v48 = if result == nil then nil else result.UnixTimestamp

		if v41 == nil then
			v41 = v44
			v42 = v48
		elseif v48 ~= nil and (v42 == nil or v42 < v48) then
			v41 = v44
			v42 = v48
		end
	end

	return v41
end
local function shouldUpdatePreview(p6, p7) -- line: 139
	if p7 == nil then
		return true
	end

	local lastUpdated = p6.lastUpdated
	local v52 = if lastUpdated ~= nil then if typeof(lastUpdated) ~= "DateTime" then if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp() else lastUpdated.UnixTimestamp else nil

	if v52 == nil then
		return true
	end

	return v52 <= p7.UnixTimestamp
end
local function isUnreadCandidateMessage(p8, t2: {[any]: any}?) -- line: 152
	if p8 == nil or p8.is_badgeable ~= true then
		return false
	end

	local sender_user_id = p8.sender_user_id

	if sender_user_id == nil then
		return false
	end

	if t2 ~= nil and t2.localUserId ~= nil and tostring(sender_user_id) == tostring(t2.localUserId) then
		return false
	end

	return true
end
local function hasNewerUnreadMessage(t3: {[any]: any}, t4: {[any]: any}?) -- line: 173
	if t4 == nil or t4.hasUnreadMessages ~= true then
		return false
	end

	local unreadFreshnessLastUpdated = t4.unreadFreshnessLastUpdated
	local v59 = ((if unreadFreshnessLastUpdated ~= nil then (if typeof(unreadFreshnessLastUpdated) ~= "DateTime" then (if type(unreadFreshnessLastUpdated) ~= "table" or unreadFreshnessLastUpdated.GetUnixTimestamp == nil then nil else unreadFreshnessLastUpdated:GetUnixTimestamp()) else unreadFreshnessLastUpdated.UnixTimestamp) else nil)) or 0
	local g64 = nil

	for _, v61 in t3 do
		local v62

		if v61 == nil or v61.is_badgeable ~= true then
			v62 = false
		else
			local sender_user_id = v61.sender_user_id

			v62 = sender_user_id ~= nil and (t4 == nil or (t4.localUserId == nil or tostring(sender_user_id) ~= tostring(t4.localUserId)))
		end

		if not v62 then
			continue
		end

		local result

		repeat
			if not g64 and type(v61.created_at) == "string" then
				local ok

				ok, result = pcall(function() -- line: 78
					-- upvalues: v61 (copy)
					return DateTime.fromIsoDate(v61.created_at)
				end)

				if not ok then
					g64 = true
				end
			else
				g64 = false
				result = nil
			end
		until not g64

		local v67 = if result == nil then nil else result.UnixTimestamp

		if v67 ~= nil and v59 < v67 then
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
	getConversationStore = function() -- line: 33
		-- upvalues: GetConversationStore (copy)
		return GetConversationStore(false)
	end,
	getConversationTitle = getConversationTitle,
	isFriendsConversation = function(s1: string?, p9) -- line: 37
		-- upvalues: GetConversationStore (copy), ConversationChannels (copy)
		if s1 == nil or s1 == "" then
			return false
		end

		local v22 = GetConversationStore(false).getConversation(s1, p9 or false)

		return v22 ~= nil and v22.source == ConversationChannels.Source.Friends
	end,
	markConversationRead = function(s2: string, b1: boolean?) -- line: 45
		-- upvalues: GetConversationStore (copy), AppChatNetworking (copy), logger (copy)
		local v25 = GetConversationStore(false)
		local v26 = v25.getConversation(s2, false)
		local v27 = b1 == true

		if v26 == nil then
			if not v27 then
				return
			end
		elseif v26.hasUnreadMessages == true then
			local v28 = table.clone(v26)

			v28.hasUnreadMessages = false
			v25.upsertConversation(v28, false)
			v27 = true
		end

		if not v27 then
			return
		end

		return AppChatNetworking.http.MarkConversationRead(nil, s2):catch(function(p10) -- line: 64
			-- upvalues: logger (copy), s2 (copy)
			logger:warning(`Failed to mark conversation read for { s2 }: { tostring(p10) }`)
		end)
	end,
	removeConversation = function(s3: string) -- line: 72
		-- upvalues: GetConversationStore (copy)
		GetConversationStore(false).removeConversation(s3)
	end,
	updateConversationPreviewFromMessages = function(s4: string, t5: {[any]: any}, t6: {[any]: any}?) -- line: 198
		-- upvalues: GetConversationStore (copy), fetchConversationListPageToSignals (copy), logger (copy), hasNewerUnreadMessage (copy), getNewestPreviewableMessage (copy)
		local v71 = GetConversationStore(false)
		local v72 = v71.getConversation(s4, false)

		if v72 == nil then
			if t6 ~= nil and t6.refreshListOnMissingConversation == true then
				fetchConversationListPageToSignals():catch(function(p11) -- line: 207
					-- upvalues: logger (copy)
					logger:warning(`Failed to refresh conversation list after realtime update: { tostring(p11) }`)
				end)
			end

			return false, (hasNewerUnreadMessage(t5, t6))
		end

		local v73 = nil
		local v74 = getNewestPreviewableMessage(t5)
		local g75 = nil
		local g77 = nil
		local ok = nil
		local result = nil

		repeat
			if g75 or v74 == nil then
				g75 = false

				local v76 = hasNewerUnreadMessage(t5, t6)

				if v72.hasUnreadMessages ~= true and v76 then
					v73 = v73 or table.clone(v72)
					v73.hasUnreadMessages = true
				end

				if v73 == nil then
					return false, v76
				end

				v71.upsertConversation(v73, false)

				return true, v76
			end

			repeat
				if g77 or type(v74.created_at) == "string" then
					if not g77 then
						ok, result = pcall(function() -- line: 78
							-- upvalues: v74 (copy)
							return DateTime.fromIsoDate(v74.created_at)
						end)
					end

					if g77 or ok then
						g77 = false

						local v80

						if result == nil then
							v80 = true
						else
							local lastUpdated = v72.lastUpdated
							local v82 = if lastUpdated ~= nil then if typeof(lastUpdated) ~= "DateTime" then if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp() else lastUpdated.UnixTimestamp else nil

							v80 = v82 == nil or v82 <= result.UnixTimestamp
						end

						if v80 then
							v73 = table.clone(v72)
							v73.previewMessageId = tostring(v74.id)
							v73.previewContent = v74.preview_content or v74.content
							v73.lastUpdated = result or DateTime.now()
						end

						g75 = true
					end
				end

				if g75 then
					break
				end

				result = nil
				g77 = true
			until not g77
		until not g75
	end
}

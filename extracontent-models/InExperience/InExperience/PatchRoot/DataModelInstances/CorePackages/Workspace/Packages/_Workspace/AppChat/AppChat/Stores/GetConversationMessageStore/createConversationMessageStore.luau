local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local createProxy = require(AppChatParent.SignalsExperimental).createProxy
local InlineRichText = require(AppChatParent.InlineRichText)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab

require(AppChat.MessageData.Types)

local escapeRichFormatting = InlineRichText.escapeRichFormatting

local function withRichContent(p1) -- line: 31
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), Cryo (copy), escapeRichFormatting (copy)
	if not FFlagExpChatEnableFriendsTab then
		return p1
	end

	local content = p1.content

	if content == nil then
		return p1
	end

	return Cryo.Dictionary.join(p1, {
		richContent = escapeRichFormatting(content)
	})
end
local function createConversationMessageStore() -- line: 51
	-- upvalues: createProxy (copy), FFlagExpChatEnableFriendsTab (copy), Cryo (copy), escapeRichFormatting (copy)
	local v12 = createProxy({})

	return {
		messages = v12,
		getMessage = function(s1: string, p2) -- line: 55
			-- upvalues: v12 (copy)
			return v12(p2)[s1]
		end,
		upsertMessages = function(t1: {[any]: any}) -- line: 59
			-- upvalues: v12 (copy), FFlagExpChatEnableFriendsTab (copy), Cryo (copy), escapeRichFormatting (copy)
			for v16, v17 in t1 do
				local v18 = v12
				local v19

				if FFlagExpChatEnableFriendsTab then
					if not FFlagExpChatEnableFriendsTab then
						v19 = v17
					else
						local content = v17.content

						v19 = if content ~= nil then Cryo.Dictionary.join(v17, {
							richContent = escapeRichFormatting(content)
						}) else v17
					end
				else
					v19 = v17
				end

				v18[v16] = v19
			end
		end,
		updateMessage = function(s2: string, t2: {[any]: any}) -- line: 65
			-- upvalues: v12 (copy), Cryo (copy), FFlagExpChatEnableFriendsTab (copy), escapeRichFormatting (copy)
			local v23 = v12[s2]

			if v23 ~= nil then
				local v24 = Cryo.Dictionary.join(v23, t2)
				local v25 = v12

				if FFlagExpChatEnableFriendsTab then
					if not FFlagExpChatEnableFriendsTab then
					else
						local content = v24.content

						v24 = if content ~= nil then Cryo.Dictionary.join(v24, {
							richContent = escapeRichFormatting(content)
						}) else v24
					end
				end

				v25[s2] = v24
			end
		end,
		removeMessage = function(s3: string) -- line: 73
			-- upvalues: v12 (copy)
			v12[s3] = nil
		end,
		clear = function() -- line: 77
			-- upvalues: v12 (copy)
			for v28 in v12 do
				v12[v28] = nil
			end
		end
	}
end

return createConversationMessageStore

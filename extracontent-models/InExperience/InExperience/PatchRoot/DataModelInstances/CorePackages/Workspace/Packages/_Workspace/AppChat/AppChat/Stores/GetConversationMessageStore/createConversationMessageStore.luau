local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local createProxy = require(AppChatParent.SignalsExperimental).createProxy

require(AppChat.MessageData.Types)

local function createConversationMessageStore() -- line: 31
	-- upvalues: createProxy (copy), Cryo (copy)
	local v6 = createProxy({})

	return {
		messages = v6,
		getMessage = function(s1: string, p1) -- line: 35
			-- upvalues: v6 (copy)
			return v6(p1)[s1]
		end,
		upsertMessages = function(t1: {[any]: any}) -- line: 39
			-- upvalues: v6 (copy)
			for v10, v11 in t1 do
				v6[v10] = v11
			end
		end,
		updateMessage = function(s2: string, t2: {[any]: any}) -- line: 45
			-- upvalues: v6 (copy), Cryo (copy)
			local v14 = v6[s2]

			if v14 ~= nil then
				v6[s2] = Cryo.Dictionary.join(v14, t2)
			end
		end,
		removeMessage = function(s3: string) -- line: 52
			-- upvalues: v6 (copy)
			v6[s3] = nil
		end,
		clear = function() -- line: 56
			-- upvalues: v6 (copy)
			for v16 in v6 do
				v6[v16] = nil
			end
		end
	}
end

return createConversationMessageStore

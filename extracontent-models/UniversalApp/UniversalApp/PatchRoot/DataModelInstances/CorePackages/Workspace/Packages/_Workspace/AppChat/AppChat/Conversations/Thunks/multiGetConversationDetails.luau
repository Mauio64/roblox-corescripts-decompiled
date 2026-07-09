local Parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(Parent.AppChatNetworking)
local Cryo = require(Parent.Cryo)
local Promise = require(Parent.Promise)
local processConversations = require(script.Parent.processConversations)

return function(p1) -- line: 15
	-- upvalues: Promise (copy), AppChatNetworking (copy), Cryo (copy), processConversations (copy)
	return function(p2) -- line: 16
		-- upvalues: p1 (copy), Promise (copy), AppChatNetworking (copy), Cryo (copy), processConversations (copy)
		if not p1 or #p1 == 0 then
			return Promise.resolve({})
		end

		local t1 = {}
		local GET_CONVERSATIONS = AppChatNetworking.Constants.PageSize.GET_CONVERSATIONS

		for i = 1, #p1, GET_CONVERSATIONS do
			local v11 = Cryo.List.getRange(p1, i, i + GET_CONVERSATIONS - 1)

			table.insert(t1, p2:dispatch(AppChatNetworking.rodux.MultiGetConversationDetails.API(v11)))
		end

		return Promise.all(t1):andThen(function(p3) -- line: 26
			-- upvalues: Cryo (copy)
			return Cryo.List.foldLeft(p3, function(p4, p5) -- line: 27
				-- upvalues: Cryo (copy)
				local v16 = p5 and (p5.responseBody and p5.responseBody.conversations)

				if not v16 then
					return p4
				end

				return Cryo.List.join(p4, v16)
			end, {})
		end):tap(function(p6) -- line: 35
			-- upvalues: p2 (copy), processConversations (copy)
			p2:dispatch(processConversations(p6))
		end)
	end
end

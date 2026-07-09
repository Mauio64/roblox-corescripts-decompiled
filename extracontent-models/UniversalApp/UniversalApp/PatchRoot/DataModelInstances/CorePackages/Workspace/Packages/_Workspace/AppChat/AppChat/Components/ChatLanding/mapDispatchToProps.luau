local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactPaginator = require(AppChat.SocialLibraries).RoactPaginator
local Promise = require(AppChatParent.Promise)
local fetchConversationsByPage = require(AppChat.Conversations.Thunks.fetchConversationsByPage)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)

return function(p1: ((...any) -> ...any)) -- line: 11
	-- upvalues: RoactPaginator (copy), fetchConversationsByPage (copy), Promise (copy), NetworkingChat (copy), createConversation (copy)
	return {
		[RoactPaginator.fetchInit] = function() -- line: 13
			-- upvalues: p1 (copy), fetchConversationsByPage (copy)
			return p1(fetchConversationsByPage())
		end,
		[RoactPaginator.fetchWithCursor] = function(p2) -- line: 17
			-- upvalues: Promise (copy), p1 (copy), fetchConversationsByPage (copy)
			return Promise.new(function(resolve) -- line: 18
				-- upvalues: p1 (copy), fetchConversationsByPage (copy), p2 (copy)
				coroutine.wrap(function() -- line: 19
					-- upvalues: p1 (copy), fetchConversationsByPage (copy), p2 (copy), resolve (copy)
					local v13, v14, v15 = p1(fetchConversationsByPage(p2)):await()

					if v13 then
						resolve(v14, v15)

						return
					end

					resolve(nil, p2)
				end)()
			end)
		end,
		startOneToOneConversation = function(p3) -- line: 30
			-- upvalues: p1 (copy), NetworkingChat (copy)
			return p1(NetworkingChat.StartOneToOneConversation.API(p3))
		end,
		createOneToOneConversation = function(p4) -- line: 34
			-- upvalues: p1 (copy), createConversation (copy)
			return p1(createConversation("one_to_one", { p4 }))
		end
	}
end

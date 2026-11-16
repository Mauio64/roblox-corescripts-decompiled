local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)
local RoactPaginator = SocialLibraries.RoactPaginator
local Promise = require(parent.Promise)

local fetchConversationsByPage = require(AppChat.Conversations.Thunks.fetchConversationsByPage)

return function(callback)
	return {
		[RoactPaginator.fetchInit] = function()
			return callback(fetchConversationsByPage())
		end,
		[RoactPaginator.fetchWithCursor] = function(p)
			return Promise.new(function(callback2)
				coroutine.wrap(function()
					local v, v2, v3 = callback(fetchConversationsByPage(p)):await()

					if v then
						callback2(v2, v3)
					else
						callback2(nil, p)
					end
				end)()
			end)
		end
	}
end

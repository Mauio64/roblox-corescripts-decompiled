local roactPaginator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").RoactPaginator
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local fetchConversationsByPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchConversationsByPage")

return function(callback)
	return {
		[roactPaginator.fetchInit] = function()
			return callback(fetchConversationsByPage())
		end,
		[roactPaginator.fetchWithCursor] = function(p2)
			return Promise.new(function(callback2)
				coroutine.wrap(function()
					local v6, v7, v8 = callback(fetchConversationsByPage(p2)):await()

					if v6 then
						callback2(v7, v8)
					else
						callback2(nil, p2)
					end
				end)()
			end)
		end
	}
end

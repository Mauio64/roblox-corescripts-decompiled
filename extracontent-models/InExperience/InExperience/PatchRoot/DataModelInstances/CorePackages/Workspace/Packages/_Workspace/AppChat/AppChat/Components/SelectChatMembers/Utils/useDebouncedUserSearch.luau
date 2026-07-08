local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.Models.ConversationChannels)

local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local List = require(AppChatParent.Cryo).List
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local LuauPolyfill = require(AppChatParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local isUserInConversation = require(script.Parent.isUserInConversation)
local Logger = require(script.Parent.Parent.Logger)

local function useDebouncedUserSearch(p1) -- line: 22
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), setTimeout (copy), NetworkingFriends (copy), List (copy), Cryo (copy), isUserInConversation (copy), Logger (copy), clearTimeout (copy)
	local v16 = useDispatch()
	local v17 = useLocalUserId()
	local v18 = React.useRef(setTimeout(function() -- line: 25
	end, 250))
	local v19 = React.useRef("")
	local v20, v21 = React.useState({})
	local v22 = React.useCallback(function(p2) -- line: 29
		-- upvalues: v16 (copy), NetworkingFriends (copy), v17 (copy), List (copy), p1 (copy), v21 (copy), Cryo (copy), isUserInConversation (copy), Logger (copy)
		v16(NetworkingFriends.SearchFriendsByQuery.API(v17, {
			limit = 20,
			query = p2
		})):andThen(function(p3) -- line: 34
			-- upvalues: List (copy), p1 (copy), v21 (copy), Cryo (copy), isUserInConversation (copy)
			local v27 = List.map(p3.responseBody.PageItems, function(p4) -- line: 35
				return (tostring(p4.id))
			end)
			local v28 = p1 or {
				participants = {}
			}

			v21(Cryo.List.filter(v27, function(p5) -- line: 39
				-- upvalues: isUserInConversation (copy), v28 (copy)
				return not isUserInConversation(p5, v28)
			end))
		end):catch(function(p6) -- line: 43
			-- upvalues: Logger (copy), v21 (copy)
			Logger:error("Error searching friends:", p6)
			v21({})
		end)
	end, {
		v16,
		v17,
		p1
	})
	local v23 = React.useCallback(function(s1: string) -- line: 49
		-- upvalues: clearTimeout (copy), v18 (copy), v19 (copy), setTimeout (copy), v22 (copy), v21 (copy)
		clearTimeout(v18.current)
		v19.current = s1
		v18.current = setTimeout(function() -- line: 52
			-- upvalues: s1 (copy), v22 (copy), v21 (copy)
			if s1 ~= "" then
				v22(s1)

				return
			end

			v21({})
		end, 250)
	end, { v22 })

	React.useEffect(function() -- line: 62
		-- upvalues: clearTimeout (copy), v18 (copy)
		return function() -- line: 63
			-- upvalues: clearTimeout (copy), v18 (copy)
			clearTimeout(v18.current)
		end
	end, {})

	return v20, v23, v19.current
end

return useDebouncedUserSearch

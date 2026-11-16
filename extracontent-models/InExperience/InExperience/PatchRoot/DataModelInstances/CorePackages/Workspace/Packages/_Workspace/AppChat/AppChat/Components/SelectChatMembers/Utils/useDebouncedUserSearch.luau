local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
require(AppChat.Models.ConversationChannels)

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Cryo2 = require(parent.Cryo)
local List = Cryo2.List
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

local isUserInConversation = require(script.Parent.isUserInConversation)
local Logger = require(script.Parent.Parent.Logger)

local function useDebouncedUserSearch(p)
	local v = useDispatch()
	local v2 = useLocalUserId()
	local ref = React.useRef(setTimeout(function() end, 250))
	local ref2 = React.useRef("")
	local state, setState = React.useState({})

	local v3 = React.useCallback(function(query)
		v(NetworkingFriends.SearchFriendsByQuery.API(v2, { query = query, limit = 20 })):andThen(function(p2)
			local mapped = List.map(p2.responseBody.PageItems, function(p3)
				return (tostring(p3.id))
			end)

			local v3 = p or { participants = {} }
			setState(Cryo.List.filter(mapped, function(p3): boolean
				return not isUserInConversation(p3, v3)
			end))
		end):catch(function(p2)
			Logger:error("Error searching friends:", p2)
			setState({})
		end)
	end, { v, v2, p })

	local v4 = React.useCallback(function(current: string)
		clearTimeout(ref.current)
		ref2.current = current
		ref.current = setTimeout(function()
			if current == "" then
				setState({})
			else
				v3(current)
			end
		end, 250)
	end, { v3 })

	React.useEffect(function()
		return function()
			clearTimeout(ref.current)
		end
	end, {})

	return state, v4, ref2.current
end

return useDebouncedUserSearch

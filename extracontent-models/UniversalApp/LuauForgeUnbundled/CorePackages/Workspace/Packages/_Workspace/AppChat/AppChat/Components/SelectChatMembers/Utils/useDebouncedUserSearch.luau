require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local list = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo").List
local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

local isUserInConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Utils/isUserInConversation")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Logger")

local function useDebouncedUserSearch(p2)
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local ref = React.useRef(setTimeout(function() end, 250))
	local ref2 = React.useRef("")
	local state, setState = React.useState({})

	local v7 = React.useCallback(function(p3)
		v5(NetworkingBlocking.SearchFriendsByQuery.API(v6, { query = p3, limit = 20 })):andThen(function(p4)
			local mapped = list.map(p4.responseBody.PageItems, function(p5)
				return (tostring(p5.id))
			end)

			local v8 = p2 or { participants = {} }
			setState(Cryo.List.filter(mapped, function(p5): boolean
				return not isUserInConversation(p5, v8)
			end))
		end):catch(function(p4)
			Logger:error("Error searching friends:", p4)
			setState({})
		end)
	end, { v5, v6, p2 })

	local v8 = React.useCallback(function(current)
		clearTimeout(ref.current)
		ref2.current = current
		ref.current = setTimeout(function()
			if current == "" then
				setState({})
			else
				v7(current)
			end
		end, 250)
	end, { v7 })

	React.useEffect(function()
		return function()
			clearTimeout(ref.current)
		end
	end, {})

	return state, v8, ref2.current
end

return useDebouncedUserSearch

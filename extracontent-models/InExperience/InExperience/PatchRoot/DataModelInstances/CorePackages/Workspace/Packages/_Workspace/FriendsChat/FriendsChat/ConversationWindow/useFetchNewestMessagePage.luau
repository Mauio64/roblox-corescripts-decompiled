local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local fetchMessagePage = require(parent.AppChat.fetchMessagePage)
local fetchOlderMessages = require(parent.AppChat.fetchOlderMessages)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)

local FFlagFriendsChatPaginateOlderMessages = require(FriendsChat.Flags.FFlagFriendsChatPaginateOlderMessages)

local v = ExpChatShared.Logger:new(script.Name)

local function hasStartedPagination(p: string) -- 1 equivalent call inferred from this helper
	local metadata = GetConversationMessageListStore(false).getMetadata(p, false)
	return metadata ~= nil and (metadata.isLoading or metadata.nextPageCursor ~= nil or metadata.fetchedOldest)
end

local function useFetchNewestMessagePage(p: string, flag: boolean, flag2: boolean): boolean
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not flag then
			return
		end

		local v2 = false
		local v3

		if FFlagFriendsChatPaginateOlderMessages then
			if hasStartedPagination(p) then -- inferred equivalent call
				v3 = fetchMessagePage(p, nil)
			else
				v3 = fetchOlderMessages(p)
			end
		else
			v3 = fetchMessagePage(p, nil)
		end

		v3:catch(function(p2)
			if not v2 then
				v:warning(`Failed to fetch conversation messages for {p}: {tostring(p2)}`)
			end
		end):finally(function()
			if not v2 and flag2 then
				setState(p)
			end
		end)
		return function()
			v2 = true
		end
	end, { p, flag, flag2 })

	return not (flag and flag2) or state == p
end

return useFetchNewestMessagePage

local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local Promise = require(parent.Promise)
local fetchOlderMessages = require(parent.AppChat.fetchOlderMessages)
local FIntAppChatGetAllMessagesDepth = require(parent.AppChat.FIntAppChatGetAllMessagesDepth)

local v = ExpChatShared.Logger:new(script.Name)

local function useFetchAllOlderMessages(p: string, flag: boolean): boolean
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not flag then
			return
		end

		local v2 = false
		local function fetchFrom(p2: number)
			if v2 or FIntAppChatGetAllMessagesDepth <= p2 then
				return Promise.resolve()
			end

			return fetchOlderMessages(p):andThen(function(p3)
				if p3.response == nil then
					return nil
				end

				return fetchFrom(p2 + 1)
			end)
		end

		local v3

		if v2 or FIntAppChatGetAllMessagesDepth <= 0 then
			v3 = Promise.resolve()
		else
			local v4 = 0
			v3 = fetchOlderMessages(p):andThen(function(p2)
				if p2.response == nil then
					return nil
				end

				return fetchFrom(v4 + 1)
			end)
		end

		v3:catch(function(p2)
			if not v2 then
				v:warning(`Failed to fetch older messages for {p}: {tostring(p2)}`)
			end
		end):finally(function()
			if not v2 then
				setState(p)
			end
		end)
		return function()
			v2 = true
		end
	end, { p, flag })

	return not flag or state == p
end

return useFetchAllOlderMessages

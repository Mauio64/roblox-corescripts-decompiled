local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Promise = require(parent.Promise)
local ChatSessionRefCount = require(AppChat.Hooks.ChatSessionRefCount)

local function createOpenFriendsChatConversation(data)
	local v = nil

	local count = 0

	return function(p: string)
		ChatSessionRefCount.reserve()

		if v ~= nil then
			v:cancel()
		end

		count += 1
		local v2 = count

		local v3 = true
		local function cancelReservation() -- 1 equivalent call inferred from this helper
			if not v3 then
				return
			end

			v3 = false

			ChatSessionRefCount.acquire()
			ChatSessionRefCount.release()
		end

		local v4 = Promise.resolve():andThen(function()
			if data.isChatAvailable() then
				return data.openConversation(p)
			end

			return false
		end):andThen(function(p2)
			if p2 then
				return data.requestSelectFriendsTab()
			end

			return false
		end):andThen(function(p2): boolean
			if not p2 then
				return false
			end

			data.ensureOpenChat(function(): boolean
				return v2 == count
			end)

			v3 = false
			return true
		end):catch(function(): boolean
			return false
		end):andThen(function(p2)
			if p2 or not v3 then
				return p2
			end

			v3 = false

			ChatSessionRefCount.acquire()
			ChatSessionRefCount.release()

			return p2
		end)

		local v5 = Promise.new(function(p2, p3, callback)
			callback(function()
				cancelReservation() -- inferred equivalent call
				v4:cancel()
			end)
			v4:andThen(p2, p3)
		end)
		v4:finally(function()
			if v4:getStatus() == Promise.Status.Cancelled then
				v5:cancel()
			end
		end)

		v = v5
		return v5
	end
end

return createOpenFriendsChatConversation

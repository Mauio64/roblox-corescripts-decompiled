local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local ChatSessionRefCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/ChatSessionRefCount")

local function createOpenFriendsChatConversation(data)
	local v5 = nil

	local count = 0

	return function(p2)
		ChatSessionRefCount.reserve()

		if v5 ~= nil then
			v5:cancel()
		end

		count += 1
		local v6 = count

		local flag = true
		local function cancelReservation()
			if not flag then
				return
			end

			flag = false

			ChatSessionRefCount.acquire()
			ChatSessionRefCount.release()
		end

		local v7 = Promise.resolve():andThen(function()
			if data.isChatAvailable() then
				return data.openConversation(p2)
			end

			return false
		end):andThen(function(p3)
			if p3 then
				return data.requestSelectFriendsTab()
			end

			return false
		end):andThen(function(p3): boolean
			if not p3 then
				return false
			end

			data.ensureOpenChat(function(): boolean
				return v6 == count
			end)

			flag = false
			return true
		end):catch(function(): boolean
			return false
		end):andThen(function(p3)
			if p3 or not flag then
				return p3
			end

			flag = false

			ChatSessionRefCount.acquire()
			ChatSessionRefCount.release()

			return p3
		end)

		local v8 = Promise.new(function(p3, p4, callback)
			callback(function()
				if flag then
					flag = false

					ChatSessionRefCount.acquire()
					ChatSessionRefCount.release()
				end

				v7:cancel()
			end)
			v7:andThen(p3, p4)
		end)
		v7:finally(function()
			if v7:getStatus() == Promise.Status.Cancelled then
				v8:cancel()
			end
		end)

		v5 = v8
		return v8
	end
end

return createOpenFriendsChatConversation

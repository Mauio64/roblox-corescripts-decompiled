local parent = script:FindFirstAncestor("AppChat").Parent

local AppChatNetworking = require(parent.AppChatNetworking)
require(parent.Http)
require(parent.LuauPolyfill)

local function createHttpPort(callback)
	local http = AppChatNetworking.http

	local function requestFor(p: string)
		if callback == nil then
			return nil
		end

		return function(p2: string, p3: string, p4)
			return callback(p, p2, p3, p4)
		end
	end

	return {
		SendChatTextMessage = function(p, p2, p3)
			local sendChatTextMessage = http.SendChatTextMessage
			local fn

			if callback ~= nil then
				local v = "SendChatTextMessage"
				fn = function(p4: string, p5: string, p6)
					return callback(v, p4, p5, p6)
				end
			end

			return sendChatTextMessage(fn, p, p2, p3)
		end,
		GetConversationMessages = function(p, p2)
			local getConversationMessages = http.GetConversationMessages
			local fn

			if callback ~= nil then
				local v = "GetConversationMessages"
				fn = function(p3: string, p4: string, p5)
					return callback(v, p3, p4, p5)
				end
			end

			return getConversationMessages(fn, p, p2)
		end,
		GetUserConversations = function(p)
			local getUserConversations = http.GetUserConversations
			local fn

			if callback ~= nil then
				local v = "GetUserConversations"
				fn = function(p2: string, p3: string, p4)
					return callback(v, p2, p3, p4)
				end
			end

			return getUserConversations(fn, p)
		end,
		GetConversations = function(p, p2)
			local getConversations = http.GetConversations
			local fn

			if callback ~= nil then
				local v = "GetConversations"
				fn = function(p3: string, p4: string, p5)
					return callback(v, p3, p4, p5)
				end
			end

			return getConversations(fn, p, p2)
		end,
		SearchConversations = function(p, p2, p3)
			local searchConversations = http.SearchConversations
			local fn

			if callback ~= nil then
				local v = "SearchConversations"
				fn = function(p4: string, p5: string, p6)
					return callback(v, p4, p5, p6)
				end
			end

			return searchConversations(fn, p, p2, p3)
		end,
		CreateConversation = function(p, p2, p3)
			local createConversation = http.CreateConversation
			local fn

			if callback ~= nil then
				local v = "CreateConversation"
				fn = function(p4: string, p5: string, p6)
					return callback(v, p4, p5, p6)
				end
			end

			return createConversation(fn, p, p2, p3)
		end,
		MarkConversationRead = function(p)
			local markConversationRead = http.MarkConversationRead
			local fn

			if callback ~= nil then
				local v = "MarkConversationRead"
				fn = function(p2: string, p3: string, p4)
					return callback(v, p2, p3, p4)
				end
			end

			return markConversationRead(fn, p)
		end,
		ClearGlobalUnreadCount = function()
			local clearGlobalUnreadCount = http.ClearGlobalUnreadCount
			local fn

			if callback ~= nil then
				local v = "ClearGlobalUnreadCount"
				fn = function(p: string, p2: string, p3)
					return callback(v, p, p2, p3)
				end
			end

			return clearGlobalUnreadCount(fn)
		end,
		RecordModalSequenceResponse = function(p)
			local recordModalSequenceResponse = http.RecordModalSequenceResponse
			local fn

			if callback ~= nil then
				local v = "RecordModalSequenceResponse"
				fn = function(p2: string, p3: string, p4)
					return callback(v, p2, p3, p4)
				end
			end

			return recordModalSequenceResponse(fn, p)
		end,
		GetMetadata = function()
			local getMetadata = http.GetMetadata
			local fn

			if callback ~= nil then
				local v = "GetMetadata"
				fn = function(p: string, p2: string, p3)
					return callback(v, p, p2, p3)
				end
			end

			return getMetadata(fn)
		end
	}
end

return createHttpPort

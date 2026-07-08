local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local FFlagExpChatScrollPerfTracking = require(ChatUIPrimitives.Flags.FFlagExpChatScrollPerfTracking)
local u3 = nil
local t1 = {}
local t2 = {}
local t3 = {
	TTI = "TTI",
	Interval = "Interval"
}
local t4 = {
	ChatWindowMountTTI = "ChatWindowMountTTI",
	ChatWindowTabSwitchTTI = "ChatWindowTabSwitchTTI",
	MessageSendToWindowRenderInterval = "MessageSendToWindowRenderInterval",
	MessageReceiveToWindowRenderInterval = "MessageReceiveToWindowRenderInterval",
	ChatWindowScrollInterval = "ChatWindowScrollInterval"
}
local t5 = {
	[t4.ChatWindowMountTTI] = {
		baseName = "ExpChat_ChatWindowMountTTI",
		type = t3.TTI,
		canFinish = function(_) -- line: 59
			return true
		end,
		onStart = function(_) -- line: 62
		end
	},
	[t4.ChatWindowTabSwitchTTI] = {
		baseName = "ExpChat_ChatWindowTabSwitchTTI",
		type = t3.TTI,
		canFinish = function(p3) -- line: 67
			-- upvalues: u3 (ref)
			return (p3 and p3.tabId) == u3
		end,
		onStart = function(p4) -- line: 71
			-- upvalues: u3 (ref)
			u3 = if not p4 then nil else p4.tabId
		end
	},
	[t4.MessageSendToWindowRenderInterval] = {
		name = "ExpChat_MessageSendToWindowRenderInterval",
		type = t3.Interval,
		intervalMetrics = {
			"duration",
			"averageFPS",
			"longestFrameTime"
		},
		canStart = function(_) -- line: 79
			-- upvalues: t2 (ref)
			local v14 = t2.timestamp or 0

			return t2.id == nil or v14 + 5 < os.clock()
		end,
		canFinish = function(p6) -- line: 83
			-- upvalues: t2 (ref)
			return p6 and p6.messageId == t2.id
		end,
		onStart = function(p7) -- line: 86
			-- upvalues: t2 (ref)
			if p7 then
				t2 = {
					id = p7.messageId,
					timestamp = os.clock()
				}
			end
		end,
		onFinish = function(_) -- line: 94
			-- upvalues: t2 (ref)
			t2 = {}
		end
	},
	[t4.MessageReceiveToWindowRenderInterval] = {
		name = "ExpChat_MessageReceiveToWindowRenderInterval",
		type = t3.Interval,
		intervalMetrics = {
			"duration",
			"averageFPS",
			"longestFrameTime"
		},
		canStart = function(_) -- line: 102
			-- upvalues: t1 (ref)
			local v19 = t1.timestamp or 0

			return t1.id == nil or v19 + 5 < os.clock()
		end,
		canFinish = function(p10) -- line: 106
			-- upvalues: t1 (ref)
			return p10 and p10.messageId == t1.id
		end,
		onStart = function(p11) -- line: 109
			-- upvalues: t1 (ref)
			if p11 then
				t1 = {
					id = p11.messageId,
					timestamp = os.clock()
				}
			end
		end,
		onFinish = function(_) -- line: 117
			-- upvalues: t1 (ref)
			t1 = {}
		end
	}
}

if FFlagExpChatScrollPerfTracking then
	t5[t4.ChatWindowScrollInterval] = {
		name = "ExpChat_ChatWindowScrollInterval",
		type = t3.Interval,
		intervalMetrics = {
			"averageFPS",
			"longestFrameTime"
		},
		canStart = function() -- line: 128
			return true
		end,
		canFinish = function() -- line: 131
			return true
		end,
		onStart = function() -- line: 134
		end,
		onFinish = function() -- line: 135
		end
	}
end

return {
	EventTypes = t3,
	Events = t4,
	EventConfig = t5
}

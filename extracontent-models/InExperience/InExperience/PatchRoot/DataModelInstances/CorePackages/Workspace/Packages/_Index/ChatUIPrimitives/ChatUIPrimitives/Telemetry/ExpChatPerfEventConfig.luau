local v = nil
local v2 = {}
local v3 = {}

local eventTypes = { TTI = "TTI", Interval = "Interval" }

local events = {
	ChatWindowMountTTI = "ChatWindowMountTTI",
	ChatWindowTabSwitchTTI = "ChatWindowTabSwitchTTI",
	MessageSendToWindowRenderInterval = "MessageSendToWindowRenderInterval",
	MessageReceiveToWindowRenderInterval = "MessageReceiveToWindowRenderInterval",
	ChatWindowScrollInterval = "ChatWindowScrollInterval"
}

local eventConfig = {
	[events.ChatWindowMountTTI] = {
		type = eventTypes.TTI,
		baseName = "ExpChat_ChatWindowMountTTI",
		canFinish = function(_): boolean
			return true
		end,
		onStart = function(_) end
	},
	[events.ChatWindowTabSwitchTTI] = {
		type = eventTypes.TTI,
		baseName = "ExpChat_ChatWindowTabSwitchTTI",
		canFinish = function(p): boolean
			return (p and p.tabId) == v
		end,
		onStart = function(p)
			local v4

			if p then
				v4 = p.tabId
			end

			v = v4
		end
	},
	[events.MessageSendToWindowRenderInterval] = {
		type = eventTypes.Interval,
		name = "ExpChat_MessageSendToWindowRenderInterval",
		intervalMetrics = { "duration", "averageFPS", "longestFrameTime" },
		canStart = function(_): boolean
			local timestamp = v3.timestamp or 0
			return v3.id == nil or timestamp + 5 < os.clock()
		end,
		canFinish = function(p)
			return p and p.messageId == v3.id
		end,
		onStart = function(p)
			if p then
				v3 = { id = p.messageId, timestamp = os.clock() }
			end
		end,
		onFinish = function(_)
			v3 = {}
		end
	},
	[events.MessageReceiveToWindowRenderInterval] = {
		type = eventTypes.Interval,
		name = "ExpChat_MessageReceiveToWindowRenderInterval",
		intervalMetrics = { "duration", "averageFPS", "longestFrameTime" },
		canStart = function(_): boolean
			local timestamp = v2.timestamp or 0
			return v2.id == nil or timestamp + 5 < os.clock()
		end,
		canFinish = function(p)
			return p and p.messageId == v2.id
		end,
		onStart = function(p)
			if p then
				v2 = { id = p.messageId, timestamp = os.clock() }
			end
		end,
		onFinish = function(_)
			v2 = {}
		end
	}
}

eventConfig[events.ChatWindowScrollInterval] = {
	type = eventTypes.Interval,
	name = "ExpChat_ChatWindowScrollInterval",
	intervalMetrics = { "averageFPS", "longestFrameTime" },
	canStart = function(): boolean
		return true
	end,
	canFinish = function(): boolean
		return true
	end,
	onStart = function() end,
	onFinish = function() end
}

return { EventTypes = eventTypes, Events = events, EventConfig = eventConfig }

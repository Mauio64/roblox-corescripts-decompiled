local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local Signal = require(Modules.Common.Signal)
local t1 = {}

t1.__index = t1

function t1.onLaunched(p1, p2) -- line: 14
	-- upvalues: MessageBus (copy)
	local v9 = MessageBus.getMessageId("Game", "launchSuccess")

	return p1.subscribe(v9, p2)
end
function t1.onLeft(p3, p4) -- line: 19
	-- upvalues: MessageBus (copy)
	local v12 = MessageBus.getMessageId("Game", "onGameLeave")

	return p3.subscribe(v12, p4)
end
function t1.UnsubscribeFromAllMessages(p5) -- line: 24
	p5.subscriber:unsubscribeFromAllMessages()
end
function t1.new() -- line: 28
	-- upvalues: MessageBus (copy), Signal (copy), t1 (copy)
	local t2 = {
		signalTable = {},
		subscriber = MessageBus.Subscriber.new()
	}

	function t2.subscribe(p6, p7) -- line: 33
		-- upvalues: t2 (copy), Signal (copy)
		assert(type(p7) == "function", "Expected callback to be a function")

		local u17 = t2.signalTable[p6]

		if u17 == nil then
			u17 = Signal.new()
			t2.signalTable[p6] = u17
			t2.subscriber:subscribe({
				mid = p6
			}, function(p8) -- line: 42
				-- upvalues: u17 (ref)
				u17:fire(p8)
			end)
		end

		return u17:connect(p7)
	end

	setmetatable(t2, t1)

	return t2
end

return t1

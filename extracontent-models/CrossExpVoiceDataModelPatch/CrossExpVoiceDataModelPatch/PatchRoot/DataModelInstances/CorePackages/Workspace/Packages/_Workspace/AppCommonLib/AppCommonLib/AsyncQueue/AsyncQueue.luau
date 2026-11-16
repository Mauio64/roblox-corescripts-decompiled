local parent = script:FindFirstAncestor("AppCommonLib").Parent
local Promise = require(parent.Promise)

require(script.Parent.AsyncQueueTypes)

local AsyncQueue = {}

AsyncQueue.__index = AsyncQueue

function AsyncQueue.new()
	local v = { head = Promise.resolve() }

	setmetatable(v, AsyncQueue)
	return v
end

function AsyncQueue:request(callback)
	local bindableEvent = Instance.new("BindableEvent")
	local v = false
	local flag = false

	self.head = self.head:andThen(function()
		return Promise.new(function(callback2)
			if not v then
				pcall(callback)
			end

			if not v then
				flag = true
				bindableEvent.Event:Wait()
			end

			bindableEvent:Destroy()
			callback2()
		end)
	end)

	local function release()
		if flag then
			bindableEvent:Fire()
		else
			v = true
		end
	end

	return release
end

return AsyncQueue

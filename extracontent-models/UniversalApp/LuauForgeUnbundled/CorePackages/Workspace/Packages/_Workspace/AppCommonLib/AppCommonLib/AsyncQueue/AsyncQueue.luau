local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/AsyncQueue/AsyncQueueTypes")

local class = {}

class.__index = class

function class.new()
	local v5 = { head = Promise.resolve() }

	setmetatable(v5, class)
	return v5
end

function class:request(callback)
	local bindableEvent = Instance.new("BindableEvent")
	local v5 = false
	local flag = false

	self.head = self.head:andThen(function()
		return Promise.new(function(callback2)
			if not v5 then
				pcall(callback)
			end

			if not v5 then
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
			v5 = true
		end
	end

	return release
end

return class

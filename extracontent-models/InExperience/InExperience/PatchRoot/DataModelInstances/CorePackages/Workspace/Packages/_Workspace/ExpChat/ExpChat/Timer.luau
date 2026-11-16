local parent = script:FindFirstAncestor("ExpChat").Parent
local Promise = require(parent.Promise)

local Timer = {}
Timer.__index = Timer

function Timer.new(goalTime)
	return (setmetatable({ goalTime = goalTime }, Timer))
end

function Timer:start()
	self:stop()

	self.promise = Promise.delay(self.goalTime)
	return self.promise
end

function Timer:stop()
	if self.promise then
		self.promise:cancel()
	end
end

return Timer

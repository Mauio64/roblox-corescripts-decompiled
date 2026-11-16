local class = {}
class.__index = class

function class.new()
	return (setmetatable({ _inProgress = false }, class))
end

function class:isBlocked()
	return self._inProgress
end

function class:setInProgress(inProgress)
	self._inProgress = inProgress
end

return class

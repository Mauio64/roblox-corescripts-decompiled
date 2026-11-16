local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local v = {
	runAfterInteractions = function(self, callback): nil
		callback()
		return nil
	end
}

local Batchinator = {}
Batchinator.__index = Batchinator

function Batchinator.new(callback, delay: number)
	local self = setmetatable({}, Batchinator)
	self._delay = delay
	self._callback = callback
	return self
end

function Batchinator:dispose(p)
	local v2 = p or { abort = false }

	if self._taskHandle then
		self._taskHandle.cancel()

		if not v2.abort then
			self._callback()
		end

		self._taskHandle = nil
	end
end

function Batchinator:schedule()
	if self._taskHandle then
		return
	end

	local v2 = setTimeout(function()
		self._taskHandle = v:runAfterInteractions(function()
			self._taskHandle = nil
			self._callback()
		end)
	end, self._delay)

	self._taskHandle = {
		cancel = function()
			return clearTimeout(v2)
		end
	}
end

return Batchinator

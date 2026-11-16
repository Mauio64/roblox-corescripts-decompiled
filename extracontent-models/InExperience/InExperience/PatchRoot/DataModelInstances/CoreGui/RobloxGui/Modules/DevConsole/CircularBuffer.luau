local GetFFlagVoiceDebugConsoleV2 = require(script.Parent.Components.VoiceDebug.GetFFlagVoiceDebugConsoleV2)

local CircularBuffer = {}
CircularBuffer.__index = CircularBuffer

function CircularBuffer.new(maxSize)
	assert(maxSize, "Cannot initialize CircularBuffer with nil")
	assert(maxSize > 0, "Cannot initialize CircularBuffer to size < 1")

	local v = {}
	setmetatable(v, CircularBuffer)

	v._data = {}
	v._backIndex = 0
	v._maxSize = maxSize

	return v
end

function CircularBuffer:reset()
	self._data = {}
	self._backIndex = 0
end

function CircularBuffer:getSize()
	return #self._data
end

function CircularBuffer:getMaxSize()
	return self._maxSize
end

function CircularBuffer:setSize(maxSize)
	assert(maxSize, "Cannot set CircularBuffer with nil")
	assert(maxSize > 0, "Cannot set CircularBuffer to size < 1")

	if maxSize == self._maxSize then
		return
	end

	local iterator = self:iterator()
	local entry = iterator:next()
	local backIndex = 0
	local v = {}

	while entry and backIndex < maxSize do
		local v2 = backIndex + 1

		v[v2] = { entry = entry }

		if v[backIndex] then
			v[backIndex]._next = v[v2]
		end

		entry = iterator:next()
		backIndex = v2
	end

	self._data = v
	self._backIndex = backIndex
	self._maxSize = maxSize
end

function CircularBuffer:getFrontIndex()
	local v = self._backIndex + 1
	return if self._data[v] then v else 1
end

function CircularBuffer:front()
	local frontIndex = self:getFrontIndex()

	if self._data[frontIndex] then
		return self._data[frontIndex].entry
	end

	return nil
end

function CircularBuffer:back()
	if self._data[self._backIndex] then
		return self._data[self._backIndex].entry
	end

	return nil
end

function CircularBuffer:iterator()
	return {
		data = self._data[self:getFrontIndex()],
		next = function(self)
			local data = self.data

			if data then
				self.data = self.data._next
			end

			return data and data.entry
		end
	}
end

function CircularBuffer:getData()
	return self._data
end

if GetFFlagVoiceDebugConsoleV2() then
	function CircularBuffer:clone()
		local v = CircularBuffer.new(self._maxSize)
		local v2 = {}

		for k, v3 in self._data do
			v2[k] = { entry = v3.entry }
		end

		for k, v3 in self._data do
			if not v3._next then
				continue
			end

			local v4 = k % self._maxSize + 1
			v2[k]._next = v2[v4]
		end

		v._data = v2
		v._backIndex = self._backIndex
		return v
	end
end

function CircularBuffer:at(p)
	assert(p, "Cannot index CircularBuffer with nil")

	local v = (self:getFrontIndex() + p - 2) % self._maxSize + 1

	if self._data[v] then
		return self._data[v].entry
	end

	return nil
end

function CircularBuffer:reverseAt(p)
	local v = (self._backIndex - p) % self._maxSize + 1

	if self._data[v] then
		return self._data[v].entry
	end

	return nil
end

function CircularBuffer:push_back(entry)
	local backIndex = self._backIndex
	local v = self._backIndex + 1
	local backIndex2 = self._maxSize < v and 1 or v

	local v2 = self._data[backIndex2]
	self._data[backIndex2] = { entry = entry }

	if backIndex > 0 then
		self._data[backIndex]._next = self._data[backIndex2]

		if v2 then
			v2._next = nil
		end
	end

	self._backIndex = backIndex2
	return v2 and v2.entry
end

return CircularBuffer

local class = {}
class.__index = class

function class.new(p2)
	return (setmetatable({ capacity = p2, buffer = {}, writeIndex = 1, count = 0 }, class))
end

function class:push(p2)
	local capacity = self.capacity

	if capacity <= 0 then
		return
	end

	self.buffer[self.writeIndex] = p2
	self.writeIndex = self.writeIndex % capacity + 1

	if self.count < capacity then
		self.count += 1
	end
end

function class:toArray(value)
	local capacity = self.capacity
	local count = self.count
	local v5 = if value == nil then count else math.clamp(value, 0, count)

	local array = table.create(v5)

	local v6 = count ~= capacity and 1 or self.writeIndex
	local v7 = count - v5

	for i = 0, v5 - 1 do
		local v8 = (v6 - 1 + v7 + i) % capacity + 1
		array[i + 1] = self.buffer[v8]
	end

	return array
end

return class

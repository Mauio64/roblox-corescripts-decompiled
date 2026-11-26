local class = {}
class.__index = class

function class.new()
	local object = setmetatable({}, class)
	object.connections = {}
	return object
end

function class.connect(p2, p3, object, p4)
	if p2.connections[p3] then
		p2.connections[p3]()
	end

	local connection = object:Connect(p4)

	p2.connections[p3] = function()
		connection:Disconnect()
	end
end

function class.connectManual(p2, p3, p4)
	if p2.connections[p3] then
		p2.connections[p3]()
	end

	p2.connections[p3] = p4
end

function class.disconnect(p2, p3)
	if p2.connections[p3] then
		p2.connections[p3]()
		p2.connections[p3] = nil
	end
end

function class:disconnectAll()
	for k, connection in pairs(self.connections) do
		connection()
	end

	self.connections = {}
end

return class

local ConnectionUtil = {}
ConnectionUtil.__index = ConnectionUtil

function ConnectionUtil.new()
	local self = setmetatable({}, ConnectionUtil)
	self.connections = {}
	return self
end

function ConnectionUtil.connect(p, p2, object, p3)
	if p.connections[p2] then
		p.connections[p2]()
	end

	local connection = object:Connect(p3)

	p.connections[p2] = function()
		connection:Disconnect()
	end
end

function ConnectionUtil.connectManual(p, p2, p3)
	if p.connections[p2] then
		p.connections[p2]()
	end

	p.connections[p2] = p3
end

function ConnectionUtil.disconnect(p, p2)
	if p.connections[p2] then
		p.connections[p2]()
		p.connections[p2] = nil
	end
end

function ConnectionUtil:disconnectAll()
	for _, connection in pairs(self.connections) do
		connection()
	end

	self.connections = {}
end

return ConnectionUtil

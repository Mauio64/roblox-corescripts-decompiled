local t1 = {}

t1.__index = t1

function t1.new() -- line: 21
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.connections = {}

	return self
end
function t1.connect(p1, p2, p3, p4) -- line: 27
	if p1.connections[p2] then
		p1.connections[p2]()
	end

	local connection = p3:Connect(p4)

	p1.connections[p2] = function() -- line: 33
		-- upvalues: connection (copy)
		connection:Disconnect()
	end
end
function t1.connectManual(p5, p6, p7) -- line: 38
	if p5.connections[p6] then
		p5.connections[p6]()
	end

	p5.connections[p6] = p7
end
function t1.disconnect(p8, p9) -- line: 45
	if p8.connections[p9] then
		p8.connections[p9]()
		p8.connections[p9] = nil
	end
end
function t1.disconnectAll(p10) -- line: 52
	for _, v in pairs(p10.connections) do
		v()
	end

	p10.connections = {}
end

return t1

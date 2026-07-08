local t1 = {}
local t2 = {}

t2.__index = t2

function t2.GetInstance(p1, p2) -- line: 14
	if p1.InstancePoolsByClass[p2] == nil then
		p1.InstancePoolsByClass[p2] = {}
	end

	local v5 = #p1.InstancePoolsByClass[p2]

	if v5 > 0 then
		local v6 = p1.InstancePoolsByClass[p2][v5]

		table.remove(p1.InstancePoolsByClass[p2])

		return v6
	end

	return Instance.new(p2)
end
function t2.ReturnInstance(p3, p4) -- line: 27
	if p3.InstancePoolsByClass[p4.ClassName] == nil then
		p3.InstancePoolsByClass[p4.ClassName] = {}
	end

	if #p3.InstancePoolsByClass[p4.ClassName] < p3.PoolSizePerType then
		table.insert(p3.InstancePoolsByClass[p4.ClassName], p4)

		return
	end

	p4:Destroy()
end
function t1.new(p5) -- line: 41
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.InstancePoolsByClass = {}
	self.Name = "ObjectPool"
	self.PoolSizePerType = p5

	return self
end

return t1

local ObjectPool = {}

local class = {}
class.__index = class

function class.GetInstance(p, className)
	if p.InstancePoolsByClass[className] == nil then
		p.InstancePoolsByClass[className] = {}
	end

	local count = #p.InstancePoolsByClass[className]

	if count > 0 then
		local v = p.InstancePoolsByClass[className][count]
		table.remove(p.InstancePoolsByClass[className])
		return v
	end

	return Instance.new(className)
end

function class.ReturnInstance(p, instance)
	if p.InstancePoolsByClass[instance.ClassName] == nil then
		p.InstancePoolsByClass[instance.ClassName] = {}
	end

	if #p.InstancePoolsByClass[instance.ClassName] < p.PoolSizePerType then
		table.insert(p.InstancePoolsByClass[instance.ClassName], instance)
	else
		instance:Destroy()
	end
end

function ObjectPool.new(poolSizePerType)
	local objectPool = setmetatable({}, class)
	objectPool.InstancePoolsByClass = {}
	objectPool.Name = "ObjectPool"
	objectPool.PoolSizePerType = poolSizePerType

	return objectPool
end

return ObjectPool

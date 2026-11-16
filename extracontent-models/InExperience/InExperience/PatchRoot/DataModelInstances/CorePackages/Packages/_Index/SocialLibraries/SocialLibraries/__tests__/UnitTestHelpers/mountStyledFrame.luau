local dependencies = require(script.Parent.Parent.Parent.dependencies)
local roact = dependencies.Roact

local mockProviders = require(script.Parent.mockProviders)

return function(p, instance)
	if instance == nil then
		instance = Instance.new("Frame")
	end

	local v = mockProviders(p)

	local v2 = roact.mount(v, instance)
	return instance, function()
		roact.unmount(v2)
		instance:Destroy()
	end
end

local HttpService = game:GetService("HttpService")
local dependencies = require(script.Parent.Parent.Parent.dependencies)
local roact = dependencies.Roact

local mockProviders = require(script.Parent.mockProviders)

return function(p, options)
	options = options or {}
	local v = options.parent

	if v == nil then
		v = Instance.new("Frame")
		v.Name = HttpService:GenerateGUID(false)
	end

	local v2 = mockProviders(p, options)
	local v3 = roact.mount(v2, v)
	return v, function()
		roact.unmount(v3)
		v:Destroy()
	end
end

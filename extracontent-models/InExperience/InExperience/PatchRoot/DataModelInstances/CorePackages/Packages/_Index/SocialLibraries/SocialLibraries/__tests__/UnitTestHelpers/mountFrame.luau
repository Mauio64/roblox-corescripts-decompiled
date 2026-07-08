local HttpService = game:GetService("HttpService")
local Roact = require(script.Parent.Parent.Parent.dependencies).Roact
local mockProviders = require(script.Parent.mockProviders)

return function(p1, p2) -- line: 17
	-- upvalues: HttpService (copy), mockProviders (copy), Roact (copy)
	local v6 = p2 or {}
	local parent = v6.parent

	if parent == nil then
		parent = Instance.new("Frame")
		parent.Name = HttpService:GenerateGUID(false)
	end

	local v8 = mockProviders(p1, v6)
	local v9 = Roact.mount(v8, parent)

	return parent, function() -- line: 28
		-- upvalues: Roact (copy), v9 (copy), parent (ref)
		Roact.unmount(v9)
		parent:Destroy()
	end
end

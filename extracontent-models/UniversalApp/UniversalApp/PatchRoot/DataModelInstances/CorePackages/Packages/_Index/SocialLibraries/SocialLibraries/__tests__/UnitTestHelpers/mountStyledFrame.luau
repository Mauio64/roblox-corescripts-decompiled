local Roact = require(script.Parent.Parent.Parent.dependencies).Roact
local mockProviders = require(script.Parent.mockProviders)

return function(p1, p2) -- line: 7
	-- upvalues: mockProviders (copy), Roact (copy)
	if p2 == nil then
		p2 = Instance.new("Frame")
	end

	local v6 = mockProviders(p1)
	local v7 = Roact.mount(v6, p2)

	return p2, function() -- line: 14
		-- upvalues: Roact (copy), v7 (copy), p2 (ref)
		Roact.unmount(v7)
		p2:Destroy()
	end
end

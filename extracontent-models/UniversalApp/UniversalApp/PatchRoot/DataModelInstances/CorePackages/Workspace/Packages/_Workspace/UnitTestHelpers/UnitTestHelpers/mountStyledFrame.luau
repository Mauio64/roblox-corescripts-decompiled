local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local mockProviders = require(script.Parent.mockProviders)

return function(p1, p2) -- line: 9
	-- upvalues: mockProviders (copy), Roact (copy)
	if p2 == nil then
		p2 = Instance.new("Frame")
	end

	local v7 = mockProviders(p1)
	local v8 = Roact.mount(v7, p2)

	return p2, function() -- line: 16
		-- upvalues: Roact (copy), v8 (copy), p2 (ref)
		Roact.unmount(v8)
		p2:Destroy()
	end
end

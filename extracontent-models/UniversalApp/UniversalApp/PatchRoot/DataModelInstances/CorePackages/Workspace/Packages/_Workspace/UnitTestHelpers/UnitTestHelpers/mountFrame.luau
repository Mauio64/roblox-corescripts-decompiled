local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local mockProviders = require(script.Parent.mockProviders)

return function(p1, p2) -- line: 20
	-- upvalues: HttpService (copy), mockProviders (copy), Roact (copy)
	local v7 = p2 or {}
	local parent = v7.parent

	if parent == nil then
		parent = Instance.new("Frame")
		parent.Size = UDim2.fromScale(1, 1)
		parent.Name = HttpService:GenerateGUID(false)
	end

	local v9 = mockProviders(p1, v7)
	local v10 = Roact.mount(v9, parent)

	return parent, function() -- line: 32
		-- upvalues: Roact (copy), v10 (copy), parent (ref)
		Roact.unmount(v10)
		parent:Destroy()
	end
end

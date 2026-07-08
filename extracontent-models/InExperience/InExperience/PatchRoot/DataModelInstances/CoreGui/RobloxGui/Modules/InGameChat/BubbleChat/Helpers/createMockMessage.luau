local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local n1 = 0

local function createMockMessage(p1) -- line: 7
	-- upvalues: n1 (ref), Cryo (copy)
	n1 += 1

	return Cryo.Dictionary.join({
		name = "Foo",
		userId = "1",
		text = "Hello, World!",
		id = tostring(n1),
		timestamp = n1
	}, p1)
end

return createMockMessage

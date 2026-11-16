local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local count = 0

local function createMockMessage(p)
	count += 1

	return Cryo.Dictionary.join({
		name = "Foo",
		id = tostring(count),
		userId = "1",
		text = "Hello, World!",
		timestamp = count
	}, p)
end

return createMockMessage

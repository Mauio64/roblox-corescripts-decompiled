local Parent = script:FindFirstAncestor("ExpChat").Parent
local Dictionary = require(Parent.llama).Dictionary
local n1 = 0

local function createMockMessage(p1) -- line: 7
	-- upvalues: n1 (ref), Dictionary (copy)
	n1 += 1

	return Dictionary.join({
		name = "Foo",
		userId = "1",
		text = "Hello, World!",
		id = tostring(n1),
		timestamp = n1
	}, p1)
end

return createMockMessage

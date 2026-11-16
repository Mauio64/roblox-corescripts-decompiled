local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local count = 0

local function createMockMessage(p)
	count += 1

	return dictionary.join({
		name = "Foo",
		id = tostring(count),
		userId = "1",
		text = "Hello, World!",
		timestamp = count
	}, p)
end

return createMockMessage

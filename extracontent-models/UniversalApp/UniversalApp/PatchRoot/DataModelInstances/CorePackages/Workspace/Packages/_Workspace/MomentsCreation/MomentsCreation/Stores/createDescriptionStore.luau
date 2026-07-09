local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local createSignal = require(Parent.Signals).createSignal

local function createDescriptionStore() -- line: 18
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal("")

	return {
		getDescription = v4,
		setDescription = v5
	}
end

return createDescriptionStore

local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local RoduxContacts = dependencies.RoduxContacts
local llama = dependencies.llama
local v5 = RoduxContacts.installReducer()

return function(p1, p2) -- line: 9
	-- upvalues: llama (copy), v5 (copy)
	return llama.List.reduce({ p2 }, v5, p1)
end

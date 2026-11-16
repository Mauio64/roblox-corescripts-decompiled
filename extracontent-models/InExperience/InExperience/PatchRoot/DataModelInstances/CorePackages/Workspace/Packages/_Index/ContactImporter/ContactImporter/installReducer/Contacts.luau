local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local roduxContacts = dependencies.RoduxContacts
local llama = dependencies.llama

local v = roduxContacts.installReducer()

return function(p, p2)
	return llama.List.reduce({ p2 }, v, p)
end

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roduxContacts = dependencies.RoduxContacts
local llama = dependencies.llama

local v5 = roduxContacts.installReducer()

return function(p2, p3)
	return llama.List.reduce({ p3 }, v5, p2)
end

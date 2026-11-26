local module = require("@luauforge/deferred/eko")

local module2 = require("@luauforge/deferred/fbJ")

local context = module.createContext(module2.AddFriends)

return {
	Context = context,
	Provider = context.Provider,
	useSchoolsEntrySource = function()
		return module.useContext(context)
	end
}

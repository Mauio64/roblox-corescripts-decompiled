local module = require("@luauforge/deferred/egU")

local module2 = require("@luauforge/deferred/eUK")

local context = module.createContext(module2.AddFriends)

return {
	Context = context,
	Provider = context.Provider,
	useSchoolsEntrySource = function()
		return module.useContext(context)
	end
}

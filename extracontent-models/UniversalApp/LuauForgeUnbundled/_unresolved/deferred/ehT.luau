local module = require("@luauforge/deferred/egU")

require("@luauforge/deferred/ehU")

local context = module.createContext(nil)

return {
	Context = context,
	Provider = context.Provider,
	useSchoolVerificationFlow = function()
		local v5 = module.useContext(context)

		if v5 == nil then
			error("useSchoolVerificationFlow must be used within a SchoolVerificationFlowContext.Provider")
		end

		return v5
	end,
	useSchoolVerificationFlowOptional = function()
		return module.useContext(context)
	end
}

local module = require("@luauforge/deferred/eko")

local ampApiProvider = require("@luauforge/deferred/ekT").AmpApiProvider
local accessResponseEnum = require("@luauforge/deferred/ekT").AmpEnums.AccessResponseEnum

local function useCanAccessSchools()
	local state, setState = module.useState(nil)

	module.useEffect(function()
		local success, result = pcall(function()
			return ampApiProvider.upsellFeatureAccess(
				"CanAccessSchools",
				{},
				"connection_graph_core/ConnectionGraphSchools"
			)
		end)

		if not success then
			setState(false)
		elseif not result then
			setState(false)
		elseif result.access == accessResponseEnum.Granted then
			setState(true)
		else
			setState(false)
		end
	end, {})

	return state
end

return useCanAccessSchools

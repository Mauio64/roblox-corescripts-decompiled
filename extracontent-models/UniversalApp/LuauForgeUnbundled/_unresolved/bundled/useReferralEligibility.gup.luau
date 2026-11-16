local module = require("@luauforge/bundled/grg")

local module2 = require("@luauforge/bundled/guq")

local function useReferralEligibility(p2, p3)
	local state, setState = module.useState({ eligible = false, hasResolved = false })

	module.useEffect(function()
		if not p2 then
			setState({ eligible = false, hasResolved = false })
			return
		end

		setState({ eligible = false, hasResolved = false })

		module2(p3, function(p4)
			setState({ eligible = p4, hasResolved = true })
		end)
	end, { p2, p3 })

	return {
		eligible = state.eligible,
		isLoading = p2 and not state.hasResolved
	}
end

return useReferralEligibility

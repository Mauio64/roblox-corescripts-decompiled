local module = require("@luauforge/bundled/gVG")

local module2 = require("@luauforge/bundled/gWt")

local function useHasPendingReferral(p2)
	local state, setState = module.useState({
		hasPending = false,
		referrerId = nil,
		isLoading = p2
	})

	module.useEffect(function()
		if not p2 then
			return
		end

		module2(function(p3)
			if p3.hasPending then
				setState({
					hasPending = true,
					referrerId = p3.referrerId,
					isLoading = false
				})
			else
				setState({ hasPending = false, referrerId = nil, isLoading = false })
			end
		end)
	end, { p2 })

	return state
end

return useHasPendingReferral

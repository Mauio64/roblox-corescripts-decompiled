local module = require("@luauforge/bundled/hMW")
local module2 = require("@luauforge/bundled/hMV")
local module3 = require("@luauforge/bundled/hMO")
local module4 = require("@luauforge/bundled/hMM")
local module5 = require("@luauforge/bundled/hMR")

local module6 = require("@luauforge/bundled/hNn")
require("@luauforge/bundled/hMS")
require("@luauforge/bundled/hMP")

return function(p2)
	local v5 = module6(p2)
	local v6 = module.useContext(module2)

	return module.useCallback(function(p3)
		if p3 and not v6.activationFrameworkState.isLoading then
			v6.dispatch({
				type = module4.SetIsLoading,
				data = { isLoading = true }
			})

			local v7 = p3.onButtonClicked()

			if v7 ~= nil then
				local payloadAddendum = v7.payloadAddendum
				local status = v7.status

				if status == module5.Success then
					if payloadAddendum ~= nil then
						v6.dispatch({
							type = module4.SetMergePayload,
							data = { payloadTable = payloadAddendum }
						})
					end

					v5(module3.Next, payloadAddendum)
				elseif status == module5.NeedsReset then
					v6.dispatch({ type = module4.ClearPayload })

					v5(module3.Reset)
				end
			end

			v6.dispatch({
				type = module4.SetIsLoading,
				data = { isLoading = false }
			})
		end
	end, { p2, v5, v6 })
end

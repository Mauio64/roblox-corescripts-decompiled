local module = require("@luauforge/bundled/hHY")
local module2 = require("@luauforge/bundled/hHu")

local module3 = require("@luauforge/bundled/hHI")
local module4 = require("@luauforge/bundled/hJG")
local module5 = require("@luauforge/bundled/hJH")
local module6 = require("@luauforge/bundled/hIc")

local pageScopeFieldRobuxBalance = module3.PageScopeFieldRobuxBalance
local pageScopeFieldRobuxBalanceFetchSettled = module3.PageScopeFieldRobuxBalanceFetchSettled

local function useRobuxBalancePageScope()
	module2.useEffect(function()
		local v5 = module6()
		local flag = true
		v5.set(pageScopeFieldRobuxBalanceFetchSettled, false)

		local function refresh()
			local localPlayerUserId = module.DataHydrationUtils.getLocalPlayerUserId()

			if localPlayerUserId == nil then
				v5.set(pageScopeFieldRobuxBalanceFetchSettled, true)
			else
				module5(localPlayerUserId):andThen(function(p2)
					if flag then
						if p2 ~= nil then
							v5.set(pageScopeFieldRobuxBalance, p2)
						end

						v5.set(pageScopeFieldRobuxBalanceFetchSettled, true)
					end
				end)
			end
		end

		refresh()
		local v6 = module4(refresh)

		return function()
			flag = false
			v6()
			v5.set(pageScopeFieldRobuxBalance, nil)
			v5.set(pageScopeFieldRobuxBalanceFetchSettled, nil)
		end
	end, {})
end

return useRobuxBalancePageScope

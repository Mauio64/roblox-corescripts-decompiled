local module = require("@luauforge/bundled/hHI")
local module2 = require("@luauforge/bundled/hIh")
local module3 = require("@luauforge/bundled/hHZ")
local module4 = require("@luauforge/bundled/hIc")
local module5 = require("@luauforge/bundled/hIi")

local v5 = {}

return {
	get = function(p2, p3)
		local v6 = v5[p2]

		if v6 ~= nil then
			v6.setEventIngest(p3)

			return v6
		end

		local v7 = module5({
			purchaseFlowUuid = p2,
			eventIngest = p3,
			pageStartedAt = module4().get(module.PageScopeFieldPageStartedAt),
			getContextMetadata = function()
				local v8 = module3()
				local v9 = module4().get(module.PageScopeFieldRobuxBalance)

				if v8 and v8.purchase_flow_id ~= p2 then
					return module2(nil, nil)
				end

				return module2(v8, v9)
			end
		})

		v5[p2] = v7
		return v7
	end,
	remove = function(p2)
		local v6 = v5[p2]

		if v6 ~= nil then
			v6.destroy()
			v5[p2] = nil
		end
	end,
	debug_clear = function()
		for k in v5 do
			local v6 = v5[k]

			if v6 == nil then
				continue
			end

			v6.destroy()
			v5[k] = nil
		end
	end
}

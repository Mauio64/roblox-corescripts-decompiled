local module = require("@luauforge/bundled/hHu")

local module2 = require("@luauforge/bundled/hHI")
local module3 = require("@luauforge/bundled/hIc")

local module4 = require("@luauforge/bundled/hHJ")

local pageScopeFieldPageVisit = module2.PageScopeFieldPageVisit

local function usePageVisit()
	local v5 = module.useMemo(os.clock, {})
	module.useEffect(function()
		local v6 = module3()

		if module4 then
			v6.set(module2.PageScopeFieldHasRenderedSduiContent, false)
		end

		v6.set(pageScopeFieldPageVisit, {})
		v6.set(module2.PageScopeFieldPageStartedAt, v5)
		return function()
			if module4 then
				v6.set(module2.PageScopeFieldHasRenderedSduiContent, nil)
			end

			v6.set(pageScopeFieldPageVisit, nil)
			v6.set(module2.PageScopeFieldPageStartedAt, nil)
		end
	end, { v5 })
end

return usePageVisit

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local module2 = require("@luauforge/bundled/hwC")
local module3 = require("@luauforge/bundled/hwU")

local pageScopeFieldPageVisit = module2.PageScopeFieldPageVisit

local function usePageVisit()
	local v5 = React.useMemo(os.clock, {})
	React.useEffect(function()
		local v6 = module3()
		v6.set(pageScopeFieldPageVisit, {})
		v6.set(module2.PageScopeFieldPageStartedAt, v5)
		return function()
			v6.set(pageScopeFieldPageVisit, nil)
			v6.set(module2.PageScopeFieldPageStartedAt, nil)
		end
	end, { v5 })
end

return usePageVisit

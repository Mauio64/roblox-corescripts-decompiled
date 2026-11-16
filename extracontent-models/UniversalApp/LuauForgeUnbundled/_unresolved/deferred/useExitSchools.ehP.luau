local module = require("@luauforge/deferred/egU")
local getRootNavigation = require("@luauforge/deferred/egV").getRootNavigation
local appPage = require("@luauforge/deferred/ehQ").AppPage

local function useExitSchools(p2)
	return module.useCallback(function()
		getRootNavigation(p2).clearAppScreens({ appPage.Schools })
	end, { p2 })
end

return useExitSchools

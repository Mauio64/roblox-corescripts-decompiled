local module = require("@luauforge/deferred/eko")
local getRootNavigation = require("@luauforge/deferred/ekp").getRootNavigation
local appPage = require("@luauforge/deferred/elk").AppPage

local function useExitSchools(p2)
	return module.useCallback(function()
		getRootNavigation(p2).clearAppScreens({ appPage.Schools })
	end, { p2 })
end

return useExitSchools

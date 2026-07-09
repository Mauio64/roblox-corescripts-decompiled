local CorePackages = game:GetService("CorePackages")
local OmniFeedService = require(CorePackages.Workspace.Packages.OmniFeedService).OmniFeedService
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OmniFeedItemMap = require(Modules.Personalization.OmniFeed.OmniFeedItemMap)

local function makeOmniFeedService() -- line: 7
	-- upvalues: OmniFeedService (copy), OmniFeedItemMap (copy)
	local v6 = OmniFeedService.get()

	v6:initialize(OmniFeedItemMap)

	return v6
end

return makeOmniFeedService

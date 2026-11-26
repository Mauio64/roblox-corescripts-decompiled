local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local function ClearSelectedTopics()
	return {}
end

return Rodux.makeActionCreator("Catalog-ClearSelectedTopics", ClearSelectedTopics)

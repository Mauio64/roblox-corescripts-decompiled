local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local function SetSelectedTopics(p2)
	return { selectedTopics = p2 }
end

return Rodux.makeActionCreator("Catalog-SetSelectedTopics", SetSelectedTopics)

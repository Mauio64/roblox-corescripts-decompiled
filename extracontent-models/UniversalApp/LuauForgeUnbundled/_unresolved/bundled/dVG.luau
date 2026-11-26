local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local function SetTopics(p2, p3, p4, p5)
	return {
		selectedTopics = p2,
		initialItems = p3,
		searchKeyword = p4,
		newTopics = p5
	}
end

return Rodux.makeActionCreator("Catalog-SetTopics", SetTopics)

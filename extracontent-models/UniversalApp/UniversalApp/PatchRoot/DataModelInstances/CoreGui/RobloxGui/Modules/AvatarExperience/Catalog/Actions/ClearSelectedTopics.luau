local CorePackages = game:GetService("CorePackages")

local function ClearSelectedTopics() -- line: 13
	return {}
end

return require(CorePackages.Packages.Rodux).makeActionCreator("Catalog-" .. script.Name, ClearSelectedTopics)

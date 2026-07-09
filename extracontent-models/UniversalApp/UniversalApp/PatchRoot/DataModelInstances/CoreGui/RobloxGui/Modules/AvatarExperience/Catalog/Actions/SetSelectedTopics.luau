local CorePackages = game:GetService("CorePackages")

local function SetSelectedTopics(t1: {[any]: any}) -- line: 15
	return {
		selectedTopics = t1
	}
end

return require(CorePackages.Packages.Rodux).makeActionCreator("Catalog-" .. script.Name, SetSelectedTopics)

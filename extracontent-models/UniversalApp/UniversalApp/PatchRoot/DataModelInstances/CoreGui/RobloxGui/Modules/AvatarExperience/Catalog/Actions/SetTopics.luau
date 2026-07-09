local CorePackages = game:GetService("CorePackages")

local function SetTopics(t1: {[any]: any}, t2: {[any]: any}?, s1: string?, t3: {[any]: any}) -- line: 27
	return {
		selectedTopics = t1,
		initialItems = t2,
		searchKeyword = s1,
		newTopics = t3
	}
end

return require(CorePackages.Packages.Rodux).makeActionCreator("Catalog-" .. script.Name, SetTopics)

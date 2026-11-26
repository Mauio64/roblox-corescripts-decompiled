return require("@luauforge/bundled/dtw").makeActionCreator("AddSearchResultsOmniFeed", function(p2, p3, p4, p5, p6)
	return {
		searchUuid = p2,
		topicId = p3,
		treatmentType = p4,
		sortIndex = p5,
		topicLayoutData = p6
	}
end)

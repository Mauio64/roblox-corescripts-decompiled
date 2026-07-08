local ParentParent = script.Parent.Parent

return require(ParentParent.dependencies).Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 14
	assert(type(t1) == "table", string.format("SetContactImporterDisplayLogic action expects params to be a table, was %s", (type(t1))))

	return t1
end)

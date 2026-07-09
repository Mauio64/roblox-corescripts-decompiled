local ParentParent = script.Parent.Parent

return require(ParentParent.dependencies).Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 9
	assert(type(t1) == "table", string.format("SetIsPhoneVerified action expects params to be a table, was %s", (type(t1))))

	return t1
end)

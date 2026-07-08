local Parent = script:FindFirstAncestor("SocialModalsCommon").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 9
	assert(type(t1) == "table", string.format("UpdateIsDiscoverabilityUnset action expects params to be a table, was %s", (type(t1))))

	return t1
end)

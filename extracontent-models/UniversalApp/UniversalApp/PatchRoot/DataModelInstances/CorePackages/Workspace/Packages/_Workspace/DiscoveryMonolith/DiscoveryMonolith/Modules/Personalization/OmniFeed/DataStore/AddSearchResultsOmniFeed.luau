local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, s3: string?, n1: number?, t1: {[any]: any}?) -- line: 7
	return {
		searchUuid = s1,
		topicId = s2,
		treatmentType = s3,
		sortIndex = n1,
		topicLayoutData = t1
	}
end)

local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 13
	return {
		comment_added = t1.comment_added
	}
end)

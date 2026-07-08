local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 13
	return {
		reason_selection = t1.reason_selection
	}
end)

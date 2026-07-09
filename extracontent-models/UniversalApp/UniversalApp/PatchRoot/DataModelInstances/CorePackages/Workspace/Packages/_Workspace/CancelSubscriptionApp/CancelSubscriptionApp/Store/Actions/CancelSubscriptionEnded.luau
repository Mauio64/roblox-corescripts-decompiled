local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent

return require(Parent.Rodux).makeActionCreator("CancelSubscriptionEnded", function() -- line: 9
	return {}
end)

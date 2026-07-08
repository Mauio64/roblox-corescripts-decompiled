local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent

return require(Parent.Rodux).makeActionCreator("CancelSubscriptionSucceeded", function(s1: string) -- line: 10
	return {
		subscriptionId = s1
	}
end)

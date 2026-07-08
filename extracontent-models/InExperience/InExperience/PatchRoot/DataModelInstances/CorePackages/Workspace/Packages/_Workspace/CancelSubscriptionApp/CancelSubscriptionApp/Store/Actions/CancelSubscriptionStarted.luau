local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent

return require(Parent.Rodux).makeActionCreator("CancelSubscriptionStarted", function(s1: string, s2: string) -- line: 11
	return {
		subscriptionId = s1,
		expirationDate = s2
	}
end)

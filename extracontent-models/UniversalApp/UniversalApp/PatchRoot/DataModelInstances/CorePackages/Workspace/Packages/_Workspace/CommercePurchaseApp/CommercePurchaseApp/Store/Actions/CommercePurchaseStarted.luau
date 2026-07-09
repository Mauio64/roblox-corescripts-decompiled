local Parent = script:FindFirstAncestor("CommercePurchaseApp").Parent

return require(Parent.Rodux).makeActionCreator("CommercePurchaseStarted", function(s1: string) -- line: 10
	return {
		commerceProductId = s1
	}
end)

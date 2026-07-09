local Parent = script:FindFirstAncestor("CommercePurchaseApp").Parent

return require(Parent.Rodux).makeActionCreator("CommercePurchaseCheckout", function(s1: string) -- line: 10
	return {
		checkoutSessionId = s1
	}
end)

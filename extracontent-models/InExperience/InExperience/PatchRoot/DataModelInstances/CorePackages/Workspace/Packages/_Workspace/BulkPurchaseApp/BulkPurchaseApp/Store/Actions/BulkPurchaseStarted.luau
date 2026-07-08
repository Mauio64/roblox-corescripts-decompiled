local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent

return require(Parent.Rodux).makeActionCreator("BulkPurchaseStarted", function(n1: number) -- line: 10
	return {
		balance = n1
	}
end)

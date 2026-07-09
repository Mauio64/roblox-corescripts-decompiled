local Parent = script:FindFirstAncestor("PaymentsProtocol").Parent

return require(Parent.enumerate)(script.Name, {
	BrowseProductStart = "BrowseProductStart",
	BrowseProductEnd = "BrowseProductEnd",
	ProductNotAvailable = "ProductNotAvailable"
})

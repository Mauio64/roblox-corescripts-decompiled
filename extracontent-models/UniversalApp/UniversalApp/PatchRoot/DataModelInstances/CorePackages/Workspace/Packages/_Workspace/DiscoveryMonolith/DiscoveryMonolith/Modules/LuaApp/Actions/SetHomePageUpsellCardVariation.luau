local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 14
	return {
		upsellCardType = p1,
		titleTextOverride = p2,
		bodyTextOverride = p3,
		upsellCardV2Config = p4
	}
end)

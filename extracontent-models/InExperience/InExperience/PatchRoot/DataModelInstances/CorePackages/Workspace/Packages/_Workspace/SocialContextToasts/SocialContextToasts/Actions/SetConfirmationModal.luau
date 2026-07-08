local Parent = script:FindFirstAncestor("SocialContextToasts").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		isConfirmationModalOpen = p1,
		closeCallback = p2
	}
end)

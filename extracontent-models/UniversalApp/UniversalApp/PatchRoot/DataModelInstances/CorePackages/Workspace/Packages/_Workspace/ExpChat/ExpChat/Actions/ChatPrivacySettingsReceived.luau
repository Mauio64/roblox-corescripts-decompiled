local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 10
	return {
		canUserChat = b1
	}
end)

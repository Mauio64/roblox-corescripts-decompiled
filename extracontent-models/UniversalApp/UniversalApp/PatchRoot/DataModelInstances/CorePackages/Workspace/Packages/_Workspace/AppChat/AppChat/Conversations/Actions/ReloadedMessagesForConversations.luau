local Parent = script:FindFirstAncestor("AppChat").Parent

return (require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 12
	return {
		conversationIds = t1
	}
end))

local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 17
	return {
		newConversationId = t1.newConversationId,
		oldFriendConversationId = t1.oldFriendConversationId
	}
end)

local Parent = script:FindFirstAncestor("SocialChatToast").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		toast = p1
	}
end)

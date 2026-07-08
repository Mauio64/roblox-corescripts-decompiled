local Parent = script:FindFirstAncestor("RoduxSquads").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 5
	return {
		payload = {
			notificationId = s1
		}
	}
end)

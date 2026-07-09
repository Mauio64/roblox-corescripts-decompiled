local Parent = script:FindFirstAncestor("RoduxSquads").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, s3: string, b1: boolean) -- line: 7
	return {
		payload = {
			experienceInviteId = s1,
			membershipEntityId = s2,
			notificationId = s3,
			isInviter = b1
		}
	}
end)

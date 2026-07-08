local ChatIntervention = script:FindFirstAncestor("ChatIntervention")

return require(ChatIntervention.Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 9
	return {
		isShow = b1
	}
end)

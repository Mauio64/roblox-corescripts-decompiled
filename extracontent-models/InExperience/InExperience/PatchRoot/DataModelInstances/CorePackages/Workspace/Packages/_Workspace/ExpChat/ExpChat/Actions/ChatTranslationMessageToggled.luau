local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean, s1: string) -- line: 10
	return {
		useTranslation = b1,
		messageId = s1
	}
end)

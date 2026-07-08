local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

require(Parent.MomentsCommon)

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 13
	return {
		textOverlayEdits = t1
	}
end)

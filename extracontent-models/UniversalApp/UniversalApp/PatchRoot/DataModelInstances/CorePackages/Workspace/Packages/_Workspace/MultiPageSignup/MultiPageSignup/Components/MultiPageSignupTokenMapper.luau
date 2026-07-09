local Parent = script:FindFirstAncestor("MultiPageSignup").Parent

require(Parent.RobloxAppHooks)
require(Parent.Style)

return function(_, p2) -- line: 17
	return {
		EnterUserIdentifier = {
			SmallPaddingPx = p2.Size.Size_200
		}
	}
end

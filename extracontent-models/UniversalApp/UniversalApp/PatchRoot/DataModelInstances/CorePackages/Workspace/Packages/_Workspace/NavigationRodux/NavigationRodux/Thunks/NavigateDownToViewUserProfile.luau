local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local AppPage = require(NavigationRoduxParent.RobloxAppEnums).AppPage

return function(p1, p2) -- line: 10
	-- upvalues: ArgCheck (copy), NavigateDown (copy), AppPage (copy)
	ArgCheck.isInTypes(p1, {
		"string",
		"number"
	}, "userId")
	ArgCheck.isTypeOrNil(p2, "function", "onClose")

	return NavigateDown({
		name = AppPage.ViewUserProfile,
		detail = p1,
		extraProps = {
			onClose = p2
		}
	})
end

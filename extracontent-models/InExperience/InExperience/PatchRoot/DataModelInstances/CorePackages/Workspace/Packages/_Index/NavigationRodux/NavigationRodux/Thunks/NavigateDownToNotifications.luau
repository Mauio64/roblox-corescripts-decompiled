local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local AppPage = require(NavigationRoduxParent.RobloxAppEnums).AppPage

return function(p1) -- line: 10
	-- upvalues: ArgCheck (copy), NavigateDown (copy), AppPage (copy)
	ArgCheck.isTypeOrNil(p1, "function", "onClose")

	return NavigateDown({
		name = AppPage.Notifications,
		extraProps = {
			onClose = p1
		}
	})
end

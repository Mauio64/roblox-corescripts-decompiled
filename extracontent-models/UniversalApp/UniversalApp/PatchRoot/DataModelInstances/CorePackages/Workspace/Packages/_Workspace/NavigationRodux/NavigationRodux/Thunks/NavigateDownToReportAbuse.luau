local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local ArgCheck = require(NavigationRoduxParent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(NavigationRoduxParent.RobloxAppEnums)
local UrlBuilder = require(NavigationRoduxParent.UrlBuilder)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder2 = UrlBuilder.UrlBuilder

return function(p1, p2, p3) -- line: 12
	-- upvalues: ArgCheck (copy), NavigateDown (copy), AppPage (copy), UrlBuilder2 (copy)
	ArgCheck.isInTypes(p1, {
		"string",
		"number"
	}, "userId")
	ArgCheck.isInTypes(p2, {
		"string",
		"number"
	}, "conversationId")
	ArgCheck.isTypeOrNil(p3, "function", "onClose")

	return NavigateDown({
		name = AppPage.ReportAbuse,
		detail = UrlBuilder2.user.report({
			userId = p1,
			conversationId = p2
		}),
		extraProps = {
			onClose = p3
		}
	})
end

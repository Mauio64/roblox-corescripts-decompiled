local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBase
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")

local function useCompletionCallbackWithReturnPage(p2, callback, p3)
	return React.useCallback(function(p4, p5)
		if not (p3 and p3.returnPage) then
			callback(p4, p5)

			return
		end

		local v5 = urlBase.new("www") .. "/" .. p3.returnPage
		p2.pop()
		p2.push(AppScreens.GenericWebPage, {
			detail = v5,
			extraProps = { titleKey = "CommonUI.Features.Label.Settings" }
		})
	end, { p3, callback, p2 })
end

return useCompletionCallbackWithReturnPage

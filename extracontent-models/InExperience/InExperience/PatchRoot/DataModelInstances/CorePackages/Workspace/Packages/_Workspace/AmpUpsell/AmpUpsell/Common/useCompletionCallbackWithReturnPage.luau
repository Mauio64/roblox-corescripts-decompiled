local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase
local AppScreens = require(AmpUpsell.Common.AppScreens)
require(AmpUpsell.Common.Enums)

local function useCompletionCallbackWithReturnPage(p, callback, p2)
	return React.useCallback(function(p3, p4)
		if not (p2 and p2.returnPage) then
			callback(p3, p4)

			return
		end

		local detail = UrlBase.new("www") .. "/" .. p2.returnPage
		p.pop()
		p.push(AppScreens.GenericWebPage, {
			detail = detail,
			extraProps = { titleKey = "CommonUI.Features.Label.Settings" }
		})
	end, { p2, callback, p })
end

return useCompletionCallbackWithReturnPage

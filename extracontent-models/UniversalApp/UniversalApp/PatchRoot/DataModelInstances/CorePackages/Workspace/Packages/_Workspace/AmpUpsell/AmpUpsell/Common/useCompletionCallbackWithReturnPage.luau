local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local UrlBase = require(AmpUpsellParent.UrlBuilder).UrlBase
local AppScreens = require(AmpUpsell.Common.AppScreens)

require(AmpUpsell.Common.Enums)

local function useCompletionCallbackWithReturnPage(p1, p2: ((...any) -> ...any), p3) -- line: 15
	-- upvalues: React (copy), UrlBase (copy), AppScreens (copy)
	return React.useCallback(function(p4, p5) -- line: 20
		-- upvalues: p3 (copy), UrlBase (copy), p1 (copy), AppScreens (copy), p2 (copy)
		if p3 and p3.returnPage then
			local v12 = UrlBase.new("www") .. "/" .. p3.returnPage

			p1.pop()
			p1.push(AppScreens.GenericWebPage, {
				detail = v12,
				extraProps = {
					titleKey = "CommonUI.Features.Label.Settings"
				}
			})

			return
		end

		p2(p4, p5)
	end, {
		p3,
		p2,
		p1
	})
end

return useCompletionCallbackWithReturnPage

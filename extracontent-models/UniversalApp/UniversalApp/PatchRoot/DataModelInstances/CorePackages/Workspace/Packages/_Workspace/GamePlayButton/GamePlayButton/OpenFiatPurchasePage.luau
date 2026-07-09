local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function openFiatPurchasePage(p1, p2) -- line: 12
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	return function(p3) -- line: 13
		-- upvalues: AppPage (copy), p1 (copy), p2 (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = p1,
			extraProps = {
				titleKey = "Feature.PaidAccessPurchases.Webview.Title.Checkout",
				onClose = p2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v5.down(v5.fromLegacyPage(t1))

			return
		end

		p3:dispatch(NavigateDown(t1))
	end
end

return openFiatPurchasePage

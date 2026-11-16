local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")
local module3 = require("@luauforge/bundled/ftm")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local module4 = require("@luauforge/bundled/ftp")
local module5 = require("@luauforge/bundled/ftq")
local module6 = require("@luauforge/bundled/ftu")

local module7 = require("@luauforge/bundled/ftw")
local buyRobuxPageTTIManager = module7.BuyRobuxPageTTIManager
local fFlagEnableBuyRobuxPageTTI = module7.Flags.FFlagEnableBuyRobuxPageTTI

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

return function(p2, p3, p4)
	return function(object)
		local v5 = module5()

		if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() and v5 == module6.Web then
			object:dispatch(module4(function()
				object:dispatch(module3(p2, p3))
			end))
			return
		end

		if fFlagEnableBuyRobuxPageTTI then
			buyRobuxPageTTIManager.startTracking()
		end

		local v6 = {
			name = module.PurchaseRobux,
			extraProps = { analyticId = p4 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			object:dispatch(module2(v6))
		end
	end
end

local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/fBh")
local module3 = require("@luauforge/bundled/dwH")

local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage
local getSiteMessageStore = require("@luauforge/bundled/frA").GetSiteMessageStore

return function(p2)
	return function(object)
		return module2(p2):andThen(function(p3)
			local joined = Cryo.Dictionary.join(p3.responseBody or {}, {
				timestamp = os.time()
			})

			if not fFlagUseSignalsForSiteMessage then
				return object:dispatch(module3(joined))
			end

			getSiteMessageStore(false).processSiteAlertInfoPayload(module3(joined))
			return nil
		end, function(p3)
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).processSiteAlertInfoPayload(module3({
					timestamp = os.time()
				}))
			else
				object:dispatch(module3({ timestamp = os.time() }))
			end

			return module.reject(p3)
		end)
	end
end

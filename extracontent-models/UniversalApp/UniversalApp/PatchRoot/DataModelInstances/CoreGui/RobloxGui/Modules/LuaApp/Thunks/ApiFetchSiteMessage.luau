local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local AlertsGetAlertInfo = require(Modules.LuaApp.Http.Requests.AlertsGetAlertInfo)
local ProcessSiteAlertInfoPayload = require(Modules.LuaApp.Actions.ProcessSiteAlertInfoPayload)

return function(p1) -- line: 9
	-- upvalues: AlertsGetAlertInfo (copy), Cryo (copy), ProcessSiteAlertInfoPayload (copy), Promise (copy)
	return function(p2) -- line: 10
		-- upvalues: AlertsGetAlertInfo (copy), p1 (copy), Cryo (copy), ProcessSiteAlertInfoPayload (copy), Promise (copy)
		return AlertsGetAlertInfo(p1):andThen(function(p3) -- line: 11
			-- upvalues: Cryo (copy), p2 (copy), ProcessSiteAlertInfoPayload (copy)
			local v10 = Cryo.Dictionary.join(p3.responseBody or {}, {
				timestamp = os.time()
			})

			return p2:dispatch(ProcessSiteAlertInfoPayload(v10))
		end, function(p4) -- line: 16
			-- upvalues: p2 (copy), ProcessSiteAlertInfoPayload (copy), Promise (copy)
			p2:dispatch(ProcessSiteAlertInfoPayload({
				timestamp = os.time()
			}))

			return Promise.reject(p4)
		end)
	end
end

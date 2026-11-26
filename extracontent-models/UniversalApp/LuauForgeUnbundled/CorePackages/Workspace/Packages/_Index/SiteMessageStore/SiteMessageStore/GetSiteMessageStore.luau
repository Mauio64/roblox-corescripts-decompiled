local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SiteMessageStore/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/SiteMessageStore/SignalsExperimental")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SiteMessageStore/SignalsUtils")

return Signals.createComputed(function()
	local sessionScopedSignal, v5 = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal2, v6 = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal3, v7 = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal4, v8 = SignalsUtils.createSessionScopedSignal(false)

	return {
		getText = sessionScopedSignal,
		getLink = sessionScopedSignal2,
		getTimestamp = sessionScopedSignal3,
		getUpdateRequested = sessionScopedSignal4,
		processSiteAlertInfoPayload = function(data)
			SignalsExperimental.batch(function()
				v5(data.visible and data.text or nil)
				v6(data.visible and data.link or nil)
				v7(data.timestamp or nil)
				v8(false)
			end)
		end,
		refreshSiteAlertInfo = function(p2)
			v8(p2 == nil or p2)
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v5(nil)
				v6(nil)
				v7(nil)
				v8(false)
			end)
		end
	}
end)

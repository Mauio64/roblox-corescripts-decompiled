local parent = script:FindFirstAncestor("SiteMessageStore").Parent
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SignalsUtils = require(parent.SignalsUtils)

return Signals.createComputed(function()
	local sessionScopedSignal, v = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal2, v2 = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal3, v3 = SignalsUtils.createSessionScopedSignal(nil)
	local sessionScopedSignal4, v4 = SignalsUtils.createSessionScopedSignal(false)

	return {
		getText = sessionScopedSignal,
		getLink = sessionScopedSignal2,
		getTimestamp = sessionScopedSignal3,
		getUpdateRequested = sessionScopedSignal4,
		processSiteAlertInfoPayload = function(data)
			SignalsExperimental.batch(function()
				v(data.visible and data.text or nil)
				v2(data.visible and data.link or nil)
				v3(data.timestamp or nil)
				v4(false)
			end)
		end,
		refreshSiteAlertInfo = function(flag: boolean?)
			v4(flag == nil or flag)
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v(nil)
				v2(nil)
				v3(nil)
				v4(false)
			end)
		end
	}
end)

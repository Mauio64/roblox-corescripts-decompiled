require("@luauforge/bundled/gvc")
local v5 = {
	TextScreen = { component = require("@luauforge/bundled/gvi") },
	OdpHandoff = { component = require("@luauforge/bundled/gvq"), fillsViewport = true },
	CreateOdpSession = { component = require("@luauforge/bundled/gvu"), ownsLoadingState = true },
	PinEntry = { component = require("@luauforge/bundled/gvA"), fillsViewport = true },
	UserAgreement = { component = require("@luauforge/bundled/gvD"), fillsViewport = true },
	AgreementConsents = { component = require("@luauforge/bundled/gvE"), fillsViewport = true },
	VerificationMethodSelection = {
		component = require("@luauforge/bundled/gvF"),
		fillsViewport = true
	},
	SessionPolling = { component = require("@luauforge/bundled/gvG"), ownsLoadingState = true },
	Redirect = { component = require("@luauforge/bundled/gvN"), ownsLoadingState = true },
	RemoteParentRequest = { component = require("@luauforge/bundled/gvR"), ownsLoadingState = true },
	OdpAgeEstimation = { component = require("@luauforge/bundled/gvV"), ownsLoadingState = true },
	OdpGovernmentId = { component = require("@luauforge/bundled/gwi"), ownsLoadingState = true }
}

return {
	["default"] = v5,
	get = function(p2, p3)
		local v6 = p2[p3]

		if v6 then
			return v6.component
		end

		return nil
	end,
	ownsLoadingState = function(p2, p3): boolean
		local v6 = p2[p3]
		return v6 ~= nil and v6.ownsLoadingState == true
	end,
	fillsViewport = function(p2, p3): boolean
		local v6 = p2[p3]
		return v6 ~= nil and v6.fillsViewport == true
	end,
	capabilities = function(p2)
		local result = {}

		for k in p2 or v5 do
			table.insert(result, k)
		end

		table.sort(result)
		return result
	end
}

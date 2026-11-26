local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getUserAccessStore = require("@luauforge/bundled/gin").GetUserAccessStore

local v5 = {}

local function getIsRestrictedBySource(p2)
	if v5[p2] == nil then
		v5[p2] = Signals.createComputed(function(p3)
			local userAccessRestrictionDetail = getUserAccessStore(false).getUserAccessRestrictionDetail(p3)
			return userAccessRestrictionDetail and userAccessRestrictionDetail.source == p2
		end)
	end

	return v5[p2]
end

return {
	useIsRestrictedBySource = function(p2)
		if v5[p2] == nil then
			v5[p2] = Signals.createComputed(function(p3)
				local userAccessRestrictionDetail = getUserAccessStore(false).getUserAccessRestrictionDetail(p3)
				return userAccessRestrictionDetail and userAccessRestrictionDetail.source == p2
			end)
		end

		return useSignalState(v5[p2])
	end,
	isRestrictedBySource = function(p2)
		if v5[p2] == nil then
			v5[p2] = Signals.createComputed(function(p3)
				local userAccessRestrictionDetail = getUserAccessStore(false).getUserAccessRestrictionDetail(p3)
				return userAccessRestrictionDetail and userAccessRestrictionDetail.source == p2
			end)
		end

		return v5[p2](false)
	end
}

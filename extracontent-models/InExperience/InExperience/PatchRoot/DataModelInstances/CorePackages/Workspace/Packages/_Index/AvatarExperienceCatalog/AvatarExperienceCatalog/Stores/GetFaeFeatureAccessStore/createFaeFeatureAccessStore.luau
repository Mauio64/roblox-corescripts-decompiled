local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)
require(parent.LuauPolyfill)

local getFaeStatus = require(AvatarExperienceCatalog.Api.GetFaeStatus.getFaeStatus)
local getFaeStatus2 = getFaeStatus.getFaeStatus

local function createFaeFeatureAccessStore()
	local signal, v = Signals.createSignal(false)
	local signal2, v2 = Signals.createSignal(false)

	local signal3, v3 = Signals.createSignal("idle")

	return {
		getCanClaimFaeItem = signal,
		getShowFaeUpsell = signal2,
		getFetchStatus = signal3,
		fetch = function(p)
			v3("pending")
			local faeStatus, _ = getFaeStatus2(p)
			return Promise.resolve(faeStatus):andThen(function(p2)
				if not p2 then
					return Promise.reject()
				end

				local v4 = false
				local v5 = false

				for _, feature in p2.features do
					if feature.featureName == "AllowFaeItemToBeClaimed" then
						v4 = feature.access == "Granted"
					elseif feature.featureName == "ShowFaeUpsellInMarketplace" then
						v5 = feature.access == "Granted"
					end
				end

				v(v4)
				v2(v5)
				v3("success")
				return Promise.resolve()
			end):catch(function(p2)
				v3("idle")
				return Promise.reject(p2)
			end)
		end,
		reset = function()
			v(false)
			v2(false)
			v3("idle")
		end
	}
end

return createFaeFeatureAccessStore

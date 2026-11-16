local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local getFaeStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetFaeStatus/getFaeStatus").getFaeStatus

local function createFaeFeatureAccessStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(false)

	local signal3, v7 = Signals.createSignal("idle")

	return {
		getCanClaimFaeItem = signal,
		getShowFaeUpsell = signal2,
		getFetchStatus = signal3,
		fetch = function(p2)
			v7("pending")
			local faeStatus, v8 = getFaeStatus(p2)
			return Promise.resolve(faeStatus):andThen(function(p3)
				if not p3 then
					return Promise.reject()
				end

				local v9 = false
				local v10 = false

				for k, feature in p3.features do
					if feature.featureName == "AllowFaeItemToBeClaimed" then
						v9 = feature.access == "Granted"
					elseif feature.featureName == "ShowFaeUpsellInMarketplace" then
						v10 = feature.access == "Granted"
					end
				end

				v5(v9)
				v6(v10)
				v7("success")
				return Promise.resolve()
			end):catch(function(p3)
				v7("idle")
				return Promise.reject(p3)
			end)
		end,
		reset = function()
			v5(false)
			v6(false)
			v7("idle")
		end
	}
end

return createFaeFeatureAccessStore

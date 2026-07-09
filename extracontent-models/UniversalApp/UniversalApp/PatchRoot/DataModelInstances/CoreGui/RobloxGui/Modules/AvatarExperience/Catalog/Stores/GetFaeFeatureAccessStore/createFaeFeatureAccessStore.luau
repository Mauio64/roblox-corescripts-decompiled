local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local Promise = require(CorePackages.Packages.Promise)

require(CorePackages.Packages.LuauPolyfill)

local Api = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Api

local function createFaeFeatureAccessStore() -- line: 21
	-- upvalues: Signals (copy), Api (copy), Promise (copy)
	local v6, v7 = Signals.createSignal(false)
	local v8, v9 = Signals.createSignal(false)
	local v10, v11 = Signals.createSignal("idle")

	return {
		getCanClaimFaeItem = v6,
		getShowFaeUpsell = v8,
		getFetchStatus = v10,
		fetch = function(p1) -- line: 27
			-- upvalues: v11 (copy), Api (copy), Promise (copy), v7 (copy), v9 (copy)
			v11("pending")

			local v13, _ = Api.getFaeStatus(p1)

			return Promise.resolve(v13):andThen(function(p2) -- line: 31
				-- upvalues: Promise (copy), v7 (copy), v9 (copy), v11 (copy)
				if not p2 then
					return Promise.reject()
				end

				local v16 = false
				local v17 = false

				for _, v19 in p2.features do
					if v19.featureName == "AllowFaeItemToBeClaimed" then
						v16 = v19.access == "Granted"
					elseif v19.featureName == "ShowFaeUpsellInMarketplace" then
						v17 = v19.access == "Granted"
					end
				end

				v7(v16)
				v9(v17)
				v11("success")

				return Promise.resolve()
			end):catch(function(p3) -- line: 48
				-- upvalues: v11 (copy), Promise (copy)
				v11("idle")

				return Promise.reject(p3)
			end)
		end,
		reset = function() -- line: 54
			-- upvalues: v7 (copy), v9 (copy), v11 (copy)
			v7(false)
			v9(false)
			v11("idle")
		end
	}
end

return createFaeFeatureAccessStore

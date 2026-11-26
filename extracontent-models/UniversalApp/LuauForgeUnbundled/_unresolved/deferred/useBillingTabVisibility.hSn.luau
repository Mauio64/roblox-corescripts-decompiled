local module = require("@luauforge/deferred/hSo")
local module2 = require("@luauforge/deferred/hSp")
local ampApiProvider = module2.AmpApiProvider
local accessResponseEnum = module2.AmpEnums.AccessResponseEnum
local urlBuilder = require("@luauforge/deferred/hSq").UrlBuilder
local fetch = require("@luauforge/deferred/hSr").fetch

local function useBillingTabVisibility()
	local state, setState = module.useState(false)

	module.useEffect(function()
		task.spawn(function()
			local featureAccess = ampApiProvider.getFeatureAccess({ "ShouldHideSpendingSettingsTab" })
			local v5

			if featureAccess.featureAccessList then
				v5 = featureAccess.featureAccessList

				if v5 then
					if #featureAccess.featureAccessList > 0 then
						v5 = featureAccess.featureAccessList[1].access == accessResponseEnum.Granted
					else
						v5 = false
					end
				end
			else
				v5 = true
			end

			if not v5 then
				setState(true)
				return
			end

			fetch(urlBuilder.fromString("apis:payments-gateway/v1/payment-profiles")(), {
				method = "GET"
			}):andThen(function(object)
				local json = object:json()

				local v7 = if json and json._values and json._values[1] then #json._values[1] > 0 else false

				setState(v7)
			end):catch(function()
				setState(true)
			end)
		end)
	end, {})

	return { showBillingTab = state }
end

return useBillingTabVisibility

local Parent = script:FindFirstAncestor("SettingsTabVisibility").Parent
local React = require(Parent.React)
local AmpUpsell = require(Parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local fetch = require(Parent.Fetch).fetch

local function useBillingTabVisibility() -- line: 19
	-- upvalues: React (copy), AmpApiProvider (copy), AccessResponseEnum (copy), UrlBuilder (copy), fetch (copy)
	local v9, v10 = React.useState(false)

	React.useEffect(function() -- line: 23
		-- upvalues: AmpApiProvider (copy), AccessResponseEnum (copy), v10 (copy), UrlBuilder (copy), fetch (copy)
		task.spawn(function() -- line: 26
			-- upvalues: AmpApiProvider (copy), AccessResponseEnum (copy), v10 (copy), UrlBuilder (copy), fetch (copy)
			local v11 = AmpApiProvider.getFeatureAccess({ "ShouldHideSpendingSettingsTab" })

			if v11.featureAccessList and (not v11.featureAccessList or (not (#v11.featureAccessList > 0) or v11.featureAccessList[1].access ~= AccessResponseEnum.Granted)) then
				v10(true)

				return
			end

			local v12 = UrlBuilder.fromString("apis:payments-gateway/v1/payment-profiles")()

			fetch(v12, {
				method = "GET"
			}):andThen(function(p1) -- line: 47
				-- upvalues: v10 (copy)
				local v14 = p1:json()
				local v15 = false

				if v14 and (v14._values and v14._values[1]) then
					v15 = #v14._values[1] > 0
				end

				v10(v15)
			end):catch(function() -- line: 58
				-- upvalues: v10 (copy)
				v10(true)
			end)
		end)
	end, {})

	return {
		showBillingTab = v9
	}
end

return useBillingTabVisibility

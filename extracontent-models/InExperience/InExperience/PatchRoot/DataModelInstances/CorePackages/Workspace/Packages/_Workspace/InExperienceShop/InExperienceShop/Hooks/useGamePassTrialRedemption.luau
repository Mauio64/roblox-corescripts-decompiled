local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local FFlagEnableFreeTrialTopBarChip = require(InExperienceShop.Flags.FFlagEnableFreeTrialTopBarChip)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
require(InExperienceShop.Types)

local function useGamePassTrialRedemption(p: string, p2, p3: string?)
	local v = SignalsReact.useSignalState(getInExperienceShopStore)

	local isActionLoading = SignalsReact.useSignalState(function(p4): boolean
		if FFlagLuaAppEnableGamePassFreeTrials then
			return v.getTrialRedemptionInFlight(p4)[p] == true
		end

		return false
	end)

	local isActionDisabled = SignalsReact.useSignalState(function(p4): boolean
		if FFlagLuaAppEnableGamePassFreeTrials then
			return next(v.getTrialRedemptionInFlight(p4)) ~= nil
		end

		return false
	end)

	local useCallback = React.useCallback
	local function fn()
		if FFlagLuaAppEnableGamePassFreeTrials then
			local redeemGamePassTrial = v.redeemGamePassTrial
			local v2

			if FFlagEnableFreeTrialTopBarChip then
				v2 = p3
			end

			redeemGamePassTrial(p, p2, v2)
		end
	end

	local v2

	if FFlagEnableFreeTrialTopBarChip then
		v2 = p3
	end

	return {
		isActionLoading = isActionLoading,
		isActionDisabled = isActionDisabled,
		onTryActivated = useCallback(fn, { p, p2, v2, v.redeemGamePassTrial })
	}
end

return useGamePassTrialRedemption

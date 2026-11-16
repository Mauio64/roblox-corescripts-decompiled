local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
require(InExperienceShop.Types)

local function useGamePassTrialRedemption(p: string, p2)
	local v = SignalsReact.useSignalState(getInExperienceShopStore)

	return {
		isActionLoading = SignalsReact.useSignalState(function(p3): boolean
			if FFlagLuaAppEnableGamePassFreeTrials then
				return v.getTrialRedemptionInFlight(p3)[p] == true
			end

			return false
		end),
		isActionDisabled = SignalsReact.useSignalState(function(p3): boolean
			if FFlagLuaAppEnableGamePassFreeTrials then
				return next(v.getTrialRedemptionInFlight(p3)) ~= nil
			end

			return false
		end),
		onTryActivated = React.useCallback(function()
			if FFlagLuaAppEnableGamePassFreeTrials then
				v.redeemGamePassTrial(p, p2)
			end
		end, { p, p2, v.redeemGamePassTrial })
	}
end

return useGamePassTrialRedemption

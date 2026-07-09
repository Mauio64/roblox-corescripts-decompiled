local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local FAEUpsellBannerDismissalCache = require(script.Parent.FAEUpsellBannerDismissalCache)
local AmpApiProvider = require(Parent.AmpUpsell).AmpApiProvider
local AmpEnums = require(Parent.AmpUpsell).AmpEnums
local SharedFlags = require(Parent.SharedFlags)
local v7 = if not SharedFlags.FFlagAddFriendsPageUpdateAmpRules then SharedFlags.FStringEligibleForFacialAgeEstimationAmpFeature else SharedFlags.FStringEligibleToAgeVerifyAmpFeature
local FStringAgeCheckAmpNameSpace = SharedFlags.FStringAgeCheckAmpNameSpace

local function useShowFAEEligibleBanner() -- line: 18
	-- upvalues: React (copy), FAEUpsellBannerDismissalCache (copy), AmpApiProvider (copy), v7 (copy), FStringAgeCheckAmpNameSpace (copy), AmpEnums (copy)
	local v10, v11 = React.useState(FAEUpsellBannerDismissalCache.isDismissed)
	local v12, v13 = React.useState(false)

	React.useEffect(function() -- line: 22
		-- upvalues: AmpApiProvider (copy), v7 (copy), FStringAgeCheckAmpNameSpace (copy), AmpEnums (copy), v13 (copy)
		if AmpApiProvider.upsellFeatureAccess(v7, {}, FStringAgeCheckAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
			v13(true)
		end
	end, {})

	return not v10 and v12, (React.useCallback(function() -- line: 31
		-- upvalues: v11 (copy), FAEUpsellBannerDismissalCache (copy)
		v11(true)
		FAEUpsellBannerDismissalCache.markDismissed()
	end, { v11 }))
end

return useShowFAEEligibleBanner

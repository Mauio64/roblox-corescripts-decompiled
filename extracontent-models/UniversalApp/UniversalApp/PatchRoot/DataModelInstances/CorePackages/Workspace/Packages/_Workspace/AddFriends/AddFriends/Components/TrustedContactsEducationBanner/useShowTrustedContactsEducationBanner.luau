local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local TCBannerImpressionCache = require(script.Parent.TCBannerImpressionCache)
local FIntAddFriendsTrustedContactsImpressionCap = require(script.Parent.FIntAddFriendsTrustedContactsImpressionCap)
local AmpApiProvider = require(Parent.AmpUpsell).AmpApiProvider
local AmpEnums = require(Parent.AmpUpsell).AmpEnums
local FStringCanAccessTrustedContactsAmpFeature = require(Parent.SharedFlags).FStringCanAccessTrustedContactsAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(Parent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace

local function isBannerHiddenInitState() -- line: 16
	-- upvalues: TCBannerImpressionCache (copy), FIntAddFriendsTrustedContactsImpressionCap (copy)
	local v11 = TCBannerImpressionCache.getValue()

	return v11 < 0 or v11 >= FIntAddFriendsTrustedContactsImpressionCap
end
local function useShowTrustedContactsEducationBanner() -- line: 21
	-- upvalues: React (copy), isBannerHiddenInitState (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), TCBannerImpressionCache (copy)
	local v12, v13 = React.useState(isBannerHiddenInitState)
	local v14, v15 = React.useState(false)

	React.useEffect(function() -- line: 25
		-- upvalues: AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), v15 (copy)
		if AmpApiProvider.upsellFeatureAccess(FStringCanAccessTrustedContactsAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
			v15(true)
		end
	end, {})

	return not v12 and v14, React.useCallback(function() -- line: 34
		-- upvalues: v13 (copy), TCBannerImpressionCache (copy)
		v13(true)
		TCBannerImpressionCache.dismissValue()
	end, { v13 }), (React.useCallback(function() -- line: 39
		-- upvalues: TCBannerImpressionCache (copy)
		TCBannerImpressionCache.incrementValue()
	end, {}))
end

return useShowTrustedContactsEducationBanner

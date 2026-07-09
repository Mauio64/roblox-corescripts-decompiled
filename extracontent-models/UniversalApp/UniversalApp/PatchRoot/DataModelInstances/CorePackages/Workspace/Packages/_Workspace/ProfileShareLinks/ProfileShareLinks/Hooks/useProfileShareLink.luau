local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local default = require(ProfileShareLinksParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local React = require(ProfileShareLinksParent.React)
local RoactUtils = require(ProfileShareLinksParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local SetCurrentToastMessage = require(ProfileShareLinksParent.ToastRodux).Actions.SetCurrentToastMessage

require(ProfileShareLinksParent.SocialLuaAnalytics)

local ProfileSharePolicyEnum = require(ProfileShareLinks.Enums.ProfileSharePolicyEnum)
local useGetOrGenerateLinkUrl = require(ProfileShareLinks.Hooks.useGetOrGenerateLinkUrl)
local useShortUrl = require(ProfileShareLinks.Hooks.useShortUrl)
local useProfileSharePolicy = require(ProfileShareLinks.Hooks.useProfileSharePolicy)
local useAnalytics = require(ProfileShareLinks.Analytics.useAnalytics)
local EventNames = require(ProfileShareLinks.Analytics.EventNames)
local TextKeys = require(ProfileShareLinks.Common.TextKeys)

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useAnalytics (copy), useDispatch (copy), useProfileSharePolicy (copy), useGetOrGenerateLinkUrl (copy), useShortUrl (copy), useEffectOnce (copy), ProfileSharePolicyEnum (copy), React (copy), EventNames (copy), default (copy), SetCurrentToastMessage (copy), TextKeys (copy)
	local v17 = t1.enableFetch == nil or t1.enableFetch
	local v18 = useAnalytics()
	local v19 = useDispatch()
	local v20 = useProfileSharePolicy()
	local v21 = useGetOrGenerateLinkUrl()
	local v22 = useShortUrl()
	local v23 = v22 ~= nil

	useEffectOnce(v21, not v23 and (v20 ~= ProfileSharePolicyEnum.Disabled and v17))

	local v24 = React.useCallback(function() -- line: 45
		-- upvalues: v20 (copy), ProfileSharePolicyEnum (copy), v22 (copy), v18 (copy), EventNames (copy), t1 (copy), default (copy), v19 (copy), SetCurrentToastMessage (copy), TextKeys (copy)
		if v20 == ProfileSharePolicyEnum.Disabled or v22 == nil then
			return
		end

		local str = tostring(DateTime.now().UnixTimestampMillis)
		local v26 = `{ v22 }&source=ProfileShare&stamp={ str }`

		v18.fireAnalyticsEvent(EventNames.ProfileShareLinkActivated, {
			context = t1.context,
			shareType = v20,
			stamp = str
		})
		default:shareUrl({
			context = t1.context,
			url = v26
		})

		if v20 == ProfileSharePolicyEnum.Copy then
			v19(SetCurrentToastMessage({
				toastMessage = TextKeys.LinkCopied
			}))
		end
	end, {
		v20,
		v22,
		t1.context,
		v18,
		v19
	})

	return {
		hasLoaded = v23,
		policy = v20,
		onActivated = v24
	}
end

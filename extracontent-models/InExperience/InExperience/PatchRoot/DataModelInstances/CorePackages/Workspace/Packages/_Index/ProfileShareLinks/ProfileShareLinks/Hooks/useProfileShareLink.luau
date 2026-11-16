local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
require(parent.SocialLuaAnalytics)

local ProfileSharePolicyEnum = require(ProfileShareLinks.Enums.ProfileSharePolicyEnum)
local useGetOrGenerateLinkUrl = require(ProfileShareLinks.Hooks.useGetOrGenerateLinkUrl)
local useShortUrl = require(ProfileShareLinks.Hooks.useShortUrl)
local useProfileSharePolicy = require(ProfileShareLinks.Hooks.useProfileSharePolicy)
local useAnalytics = require(ProfileShareLinks.Analytics.useAnalytics)
local EventNames = require(ProfileShareLinks.Analytics.EventNames)
local TextKeys = require(ProfileShareLinks.Common.TextKeys)

return function(p)
	local v = p.enableFetch == nil or p.enableFetch
	local v2 = useAnalytics()
	local v3 = useDispatch()
	local v4 = useProfileSharePolicy()
	local v5 = useGetOrGenerateLinkUrl()
	local v6 = useShortUrl()
	local hasLoaded = v6 ~= nil
	local v7 = not hasLoaded

	if v7 then
		v7 = not (v4 == ProfileSharePolicyEnum.Disabled) and v
	end

	useEffectOnce(v5, v7)

	return {
		hasLoaded = hasLoaded,
		policy = v4,
		onActivated = React.useCallback(function()
			if v4 == ProfileSharePolicyEnum.Disabled or v6 == nil then
				return
			end

			local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
			local formatted = `{v6}&source=ProfileShare&stamp={unixTimestampMillis}`
			v2.fireAnalyticsEvent(EventNames.ProfileShareLinkActivated, {
				context = p.context,
				shareType = v4,
				stamp = unixTimestampMillis
			})

			default:shareUrl({ context = p.context, url = formatted })

			if v4 == ProfileSharePolicyEnum.Copy then
				v3(SetCurrentToastMessage({ toastMessage = TextKeys.LinkCopied }))
			end
		end, { v4, v6, p.context, v2, v3 })
	}
end

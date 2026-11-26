local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ToastRodux").Actions.SetCurrentToastMessage
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/SocialLuaAnalytics")

local ProfileSharePolicyEnum = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Enums/ProfileSharePolicyEnum")
local useGetOrGenerateLinkUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Hooks/useGetOrGenerateLinkUrl")
local useShortUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Hooks/useShortUrl")
local useProfileSharePolicy = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Hooks/useProfileSharePolicy")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/EventNames")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Common/TextKeys")

return function(p2)
	local v5 = p2.enableFetch == nil or p2.enableFetch
	local v6 = useAnalytics()
	local v7 = useDispatch()
	local v8 = useProfileSharePolicy()
	local v9 = useGetOrGenerateLinkUrl()
	local v10 = useShortUrl()
	local v11 = v10 ~= nil
	local v13 = not v11

	if v13 then
		v13 = not (v8 == ProfileSharePolicyEnum.Disabled) and v5
	end

	useEffectOnce(v9, v13)

	return {
		hasLoaded = v11,
		policy = v8,
		onActivated = React.useCallback(function()
			if v8 == ProfileSharePolicyEnum.Disabled or v10 == nil then
				return
			end

			local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
			local formatted = `{v10}&source=ProfileShare&stamp={unixTimestampMillis}`
			v6.fireAnalyticsEvent(EventNames.ProfileShareLinkActivated, {
				context = p2.context,
				shareType = v8,
				stamp = unixTimestampMillis
			})

			default:shareUrl({ context = p2.context, url = formatted })

			if v8 == ProfileSharePolicyEnum.Copy then
				v7(setCurrentToastMessage({ toastMessage = TextKeys.LinkCopied }))
			end
		end, { v8, v10, p2.context, v6, v7 })
	}
end

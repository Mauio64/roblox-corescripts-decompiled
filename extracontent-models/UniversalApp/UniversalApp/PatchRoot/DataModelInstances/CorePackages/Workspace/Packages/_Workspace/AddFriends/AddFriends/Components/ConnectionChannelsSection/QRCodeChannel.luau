local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useAppPolicy = require(AddFriendsParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local AppPage = require(AddFriendsParent.RobloxAppEnums).AppPage
local Contexts = require(AddFriendsParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local EventNames = require(AddFriends.Analytics).EventNames
local FFlagAddFriendsBannersNewUI_IXP = require(AddFriendsParent.SharedFlags).FFlagAddFriendsBannersNewUI_IXP

require(script.Parent.Types)

local function QRCodeChannel(t1: {[any]: any}) -- line: 32
	-- upvalues: useAppPolicy (copy), React (copy), EventNames (copy), AppPage (copy), Contexts (copy), useLocalization (copy), FFlagAddFriendsBannersNewUI_IXP (copy)
	local component = t1.component
	local componentUIProps = t1.componentUIProps
	local fireAnalyticsEvent = t1.fireAnalyticsEvent
	local v15 = useAppPolicy(function(p1) -- line: 37
		return p1.getEnableProfileQrCode()
	end)
	local v16 = React.useCallback(function() -- line: 42
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), AppPage (copy), Contexts (copy)
		fireAnalyticsEvent(EventNames.QRCodeBtnClick)
		t1.navigateToLuaAppPages[AppPage.ProfileQRCodePage]({
			source = Contexts.AddFriends
		})
	end, {
		t1.navigateToLuaAppPages,
		fireAnalyticsEvent
	})
	local v17 = React.useCallback(function() -- line: 50
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.QRCodeBtnImpression)
	end, { fireAnalyticsEvent })
	local v18 = useLocalization({
		qrCodeBannerTitle = not FFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Title.ShareQRCode" or nil,
		qrCodeBannerText = not FFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Label.ShareQRCodeAddConnection" or nil,
		qrCodeTitle = if not FFlagAddFriendsBannersNewUI_IXP then nil else "Feature.AddFriends.Label.MyQRTile"
	})

	if v15 then
		return (React.createElement(component, {
			icon = "icons/graphic/scanqr_large",
			title = if not FFlagAddFriendsBannersNewUI_IXP then v18.qrCodeBannerTitle else v18.qrCodeTitle,
			text = if not FFlagAddFriendsBannersNewUI_IXP then v18.qrCodeBannerText else nil,
			onActivated = v16,
			onMounted = v17,
			componentUIProps = componentUIProps
		}))
	end

	return nil
end

return QRCodeChannel

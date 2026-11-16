local module = require("@luauforge/deferred/eeO")

local useAppPolicy = require("@luauforge/deferred/egN").useAppPolicy
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local appPage = require("@luauforge/deferred/eeR").AppPage

local contexts = require("@luauforge/deferred/eeZ").Analytics.Enums.Contexts

local eventNames = require("@luauforge/deferred/eeX").EventNames

local fFlagAddFriendsBannersNewUI_IXP = require("@luauforge/deferred/efc").FFlagAddFriendsBannersNewUI_IXP
local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/efc").FFlagConnectionChannelsTileSize
local module2 = require("@luauforge/deferred/egH")

require("@luauforge/deferred/egL")

local function QRCodeChannel(props)
	local component = props.component
	local componentUIProps = props.componentUIProps
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v5 = useAppPolicy(function(p2)
		return p2.getEnableProfileQrCode()
	end)

	local v6 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.QRCodeBtnClick)

		props.navigateToLuaAppPages[appPage.ProfileQRCodePage]({
			source = contexts.AddFriends
		})
	end, { props.navigateToLuaAppPages, fireAnalyticsEvent })

	local v7 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.QRCodeBtnImpression)
	end, { fireAnalyticsEvent })

	local v8 = useLocalization({
		qrCodeBannerTitle = not fFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Title.ShareQRCode" or nil,
		qrCodeBannerText = not fFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Label.ShareQRCodeAddConnection" or nil,
		qrCodeTitle = fFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Label.QRCodeTitle" or nil
	})

	if not (v5 or module2) then
		return nil
	end

	local createElement = module.createElement
	local v9 = {
		icon = fFlagConnectionChannelsTileSize and "squares-grid-qr" or "icons/graphic/scanqr_large",
		title = 0,
		text = 0,
		onActivated = 0,
		onMounted = 0,
		componentUIProps = 0,
		isVisible = 0
	}

	local v10 = if fFlagAddFriendsBannersNewUI_IXP then v8.qrCodeTitle else v8.qrCodeBannerTitle
	v9.title = v10
	local v11 = if not fFlagAddFriendsBannersNewUI_IXP then v8.qrCodeBannerText else nil
	v9.text = v11
	v9.onActivated = v6
	v9.onMounted = v7
	v9.componentUIProps = componentUIProps

	if not module2 then
		v5 = nil
	end

	v9.isVisible = v5
	return (createElement(component, v9))
end

return QRCodeChannel

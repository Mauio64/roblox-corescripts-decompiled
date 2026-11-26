local module = require("@luauforge/deferred/eil")

local useAppPolicy = require("@luauforge/deferred/ekh").useAppPolicy
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local appPage = require("@luauforge/deferred/eio").AppPage

local contexts = require("@luauforge/deferred/eiw").Analytics.Enums.Contexts

local eventNames = require("@luauforge/deferred/eiu").EventNames

local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/eiz").FFlagConnectionChannelsTileSize

require("@luauforge/deferred/ekf")

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

	local v8 = useLocalization({ qrCodeTitle = "Feature.AddFriends.Label.QRCodeTitle" })

	return module.createElement(component, {
		icon = fFlagConnectionChannelsTileSize and "squares-grid-qr" or "icons/graphic/scanqr_large",
		title = v8.qrCodeTitle,
		text = nil,
		onActivated = v6,
		onMounted = v7,
		componentUIProps = componentUIProps,
		isVisible = v5
	})
end

return QRCodeChannel

local module = require("@luauforge/deferred/eeO")

local useBeginContactImporter = require("@luauforge/deferred/egJ").useBeginContactImporter
local analytics = require("@luauforge/deferred/egK").Analytics

local eventNames = require("@luauforge/deferred/eeX").EventNames

local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local fFlagAddFriendsBannersNewUI_IXP = require("@luauforge/deferred/efc").FFlagAddFriendsBannersNewUI_IXP
local fFlagAddFriendsCINewIcon_exp = require("@luauforge/deferred/efc").FFlagAddFriendsCINewIcon_exp
local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/efc").FFlagConnectionChannelsTileSize
local module2 = require("@luauforge/deferred/egH")

require("@luauforge/deferred/egL")

local function ContactImporterChannel(props)
	local component = props.component
	local componentUIProps = props.componentUIProps
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v5, v6 = useBeginContactImporter({
		entryPoint = analytics.EntryPoints.AddFriends
	})
	local v7 = v6 and true or false
	local v8 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.CIBtnClick)
		v6()
	end, { fireAnalyticsEvent, v6 })

	local v9 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.CIBtnImpression)
	end, { fireAnalyticsEvent })

	local v10 = useLocalization({
		contactImporterBannerTitle = not fFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Title.ConnectWithContacts" or nil,
		contactImporterBannerText = not fFlagAddFriendsBannersNewUI_IXP and (v5 and "Feature.AddFriends.Label.ConnectWithContacts" or "Feature.AddFriends.Label.SyncContactsInvitePeople") or nil,
		contactTitle = fFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Label.ContactsTile" or nil
	})

	if not (v7 or module2) then
		return nil
	end

	local createElement = module.createElement
	local v11 = {
		icon = fFlagAddFriendsBannersNewUI_IXP and fFlagAddFriendsCINewIcon_exp and (fFlagConnectionChannelsTileSize and "square-person" or "icons/menu/contacts_large") or "icons/graphic/contacts_large",
		title = 0,
		text = 0,
		onActivated = 0,
		onMounted = 0,
		componentUIProps = 0,
		isVisible = 0
	}

	local v12 = if fFlagAddFriendsBannersNewUI_IXP then v10.contactTitle else v10.contactImporterBannerTitle
	v11.title = v12

	local v13 = if not fFlagAddFriendsBannersNewUI_IXP then v10.contactImporterBannerText else nil
	v11.text = v13
	v11.onActivated = v8
	v11.onMounted = v9
	v11.componentUIProps = componentUIProps

	if not module2 then
		v7 = nil
	end

	v11.isVisible = v7
	return (createElement(component, v11))
end

return ContactImporterChannel

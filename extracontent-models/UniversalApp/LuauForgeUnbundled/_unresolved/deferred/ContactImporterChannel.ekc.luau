local module = require("@luauforge/deferred/eil")

local useBeginContactImporter = require("@luauforge/deferred/ekd").useBeginContactImporter
local analytics = require("@luauforge/deferred/eke").Analytics

local eventNames = require("@luauforge/deferred/eiu").EventNames

local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/eiz").FFlagConnectionChannelsTileSize

require("@luauforge/deferred/ekf")

local function ContactImporterChannel(props)
	local component = props.component
	local componentUIProps = props.componentUIProps
	local fireAnalyticsEvent = props.fireAnalyticsEvent

	local v5, v6 = useBeginContactImporter({
		entryPoint = analytics.EntryPoints.AddFriends
	})

	local v7 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.CIBtnClick)
		v6()
	end, { fireAnalyticsEvent, v6 })

	local v8 = module.useCallback(function()
		fireAnalyticsEvent(eventNames.CIBtnImpression)
	end, { fireAnalyticsEvent })

	local v9 = useLocalization({
		contactTitle = "Feature.AddFriends.Label.ContactsTile"
	})

	return module.createElement(component, {
		icon = fFlagConnectionChannelsTileSize and "square-person" or "icons/menu/contacts_large",
		title = v9.contactTitle,
		text = nil,
		onActivated = v7,
		onMounted = v8,
		componentUIProps = componentUIProps,
		isVisible = v6 and true or false
	})
end

return ContactImporterChannel

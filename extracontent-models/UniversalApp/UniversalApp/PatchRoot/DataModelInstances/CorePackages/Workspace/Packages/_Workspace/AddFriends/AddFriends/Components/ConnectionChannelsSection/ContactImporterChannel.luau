local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useBeginContactImporter = require(AddFriendsParent.ContactImporter).useBeginContactImporter
local Analytics = require(AddFriendsParent.DiscoverabilityModal).Analytics
local EventNames = require(AddFriends.Analytics).EventNames
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local FFlagAddFriendsBannersNewUI_IXP = require(AddFriendsParent.SharedFlags).FFlagAddFriendsBannersNewUI_IXP
local FFlagAddFriendsCINewIcon_exp = require(AddFriendsParent.SharedFlags).FFlagAddFriendsCINewIcon_exp

require(script.Parent.Types)

local function ContactImporterChannel(t1: {[any]: any}) -- line: 26
	-- upvalues: useBeginContactImporter (copy), Analytics (copy), React (copy), EventNames (copy), useLocalization (copy), FFlagAddFriendsBannersNewUI_IXP (copy), FFlagAddFriendsCINewIcon_exp (copy)
	local component = t1.component
	local componentUIProps = t1.componentUIProps
	local fireAnalyticsEvent = t1.fireAnalyticsEvent
	local v15, v16 = useBeginContactImporter({
		entryPoint = Analytics.EntryPoints.AddFriends
	})
	local v17 = React.useCallback(function() -- line: 35
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v16 (copy)
		fireAnalyticsEvent(EventNames.CIBtnClick)
		v16()
	end, {
		fireAnalyticsEvent,
		v16
	})
	local v18 = React.useCallback(function() -- line: 40
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.CIBtnImpression)
	end, { fireAnalyticsEvent })
	local v19 = not v15 and "Feature.AddFriends.Label.SyncContactsInvitePeople" or "Feature.AddFriends.Label.ConnectWithContacts"
	local v20 = useLocalization({
		contactImporterBannerTitle = not FFlagAddFriendsBannersNewUI_IXP and "Feature.AddFriends.Title.ConnectWithContacts" or nil,
		contactImporterBannerText = if not FFlagAddFriendsBannersNewUI_IXP then v19 else nil,
		contactTitle = if not FFlagAddFriendsBannersNewUI_IXP then nil else "Feature.AddFriends.Label.ContactsTile"
	})

	if not not v16 then
		return (React.createElement(component, {
			icon = (not FFlagAddFriendsBannersNewUI_IXP or not FFlagAddFriendsCINewIcon_exp) and "icons/graphic/contacts_large" or "icons/menu/contacts_large",
			title = if not FFlagAddFriendsBannersNewUI_IXP then v20.contactImporterBannerTitle else v20.contactTitle,
			text = if not FFlagAddFriendsBannersNewUI_IXP then v20.contactImporterBannerText else nil,
			onActivated = v17,
			onMounted = v18,
			componentUIProps = componentUIProps
		}))
	end

	return nil
end

return ContactImporterChannel

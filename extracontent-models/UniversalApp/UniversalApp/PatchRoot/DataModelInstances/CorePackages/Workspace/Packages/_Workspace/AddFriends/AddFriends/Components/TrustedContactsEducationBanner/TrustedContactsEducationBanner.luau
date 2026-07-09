local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useNavigation = require(AddFriendsParent.Navigation).useNavigation
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local AppPage = require(AddFriendsParent.RobloxAppEnums).AppPage
local Foundation = require(AddFriendsParent.Foundation)
local AmpApiProvider = require(AddFriendsParent.AmpUpsell).AmpApiProvider
local AccessResponseEnum = require(AddFriendsParent.AmpUpsell).AmpEnums.AccessResponseEnum
local AddFriendsGenericBanner = require(AddFriends.Components.AddFriendsGenericBanner)
local EventNames = require(AddFriends.Analytics.EventNames)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local useShowTrustedContactsEducationBanner = require(script.Parent.useShowTrustedContactsEducationBanner)
local SharedFlags = require(AddFriendsParent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags.FStringCanAccessTrustedContactsAmpNameSpace
local FStringIsVerified18PlusAmpFeature = SharedFlags.FStringIsVerified18PlusAmpFeature

local function TrustedContactsEducationBanner(t1: {[any]: any}) -- line: 32
	-- upvalues: useFireAnalyticsEvent (copy), useNavigation (copy), useShowTrustedContactsEducationBanner (copy), React (copy), AccessResponseEnum (copy), AmpApiProvider (copy), FStringIsVerified18PlusAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), EventNames (copy), AppPage (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), AddFriendsGenericBanner (copy), Foundation (copy)
	local v20 = useFireAnalyticsEvent()
	local v21 = useNavigation()
	local v22, v23, v24 = useShowTrustedContactsEducationBanner()
	local v25, v26 = React.useState(AccessResponseEnum.Pending)
	local u27 = v26

	React.useEffect(function() -- line: 40
		-- upvalues: AmpApiProvider (copy), FStringIsVerified18PlusAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), u27 (ref)
		local v32 = AmpApiProvider.upsellFeatureAccess(FStringIsVerified18PlusAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace)

		u27(v32.access)
	end, {})

	local v28 = React.useCallback(function() -- line: 45
		-- upvalues: v20 (copy), EventNames (copy), v21 (copy), AppPage (copy), v23 (copy)
		v20(EventNames.TrustedContactsEducationalBannerClick)
		v21.push(AppPage.TrustedContactsEducationModal)
		v23()
	end, {
		v21,
		v23,
		v20
	})
	local v29 = React.useCallback(function() -- line: 52
		-- upvalues: v20 (copy), EventNames (copy), v23 (copy)
		v20(EventNames.TrustedContactsEducationalBannerClose)
		v23()
	end, {
		v23,
		v20
	})
	local v30 = React.useCallback(function() -- line: 58
		-- upvalues: v20 (copy), EventNames (copy), v24 (copy)
		v20(EventNames.TrustedContactsEducationalBannerImpression)
		v24()
	end, {
		v24,
		v20
	})
	local v31 = useLocalization({
		title = "Feature.Friends.TCEducation.Title",
		learnMoreLink = "Feature.Friends.LinkText.LearnMore",
		bodyText = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Banner.Text" or "Feature.Friends.TFEducation.Banner.Text",
		bodyText18Plus = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Modal.TextIntro.EighteenPlus" or "Feature.Friends.TFEducation.Modal.TextIntro.EighteenPlus"
	})

	return if not v22 then nil else React.createElement(AddFriendsGenericBanner, {
		titleFont = "text-heading-small",
		textFont = "text-body-medium",
		layoutOrder = t1.layoutOrder,
		maxWidth = t1.maxWidth,
		onBannerMounted = v30,
		isLoading = v25 == AccessResponseEnum.Pending,
		bannerTitle = v31.title,
		bannerText = if v25 ~= AccessResponseEnum.Granted then v31.bodyText else v31.bodyText18Plus,
		rightCornerButtonIcon = Foundation.Enums.IconName.X,
		rightCornerButtonActivated = v29,
		bigBottomButton = {
			text = v31.learnMoreLink,
			onActivated = v28
		}
	})
end

return TrustedContactsEducationBanner

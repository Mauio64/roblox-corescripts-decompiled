local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local SocialBlockingModalParent = SocialBlockingModal.Parent
local React = require(SocialBlockingModalParent.React)
local RobloxAppHooks = require(SocialBlockingModalParent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLocalization = require(SocialBlockingModalParent.Localization).Hooks.useLocalization
local useNavigation = require(SocialBlockingModalParent.Navigation).useNavigation
local useDispatch = require(SocialBlockingModalParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(SocialBlockingModalParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialBlockingModalParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialBlockingModalParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(SocialBlockingModalParent.RobloxAppEnums).AppPage
local Url = require(SocialBlockingModalParent.Http).Url
local UIBlox = require(SocialBlockingModalParent.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local UserProfiles = require(SocialBlockingModalParent.UserProfiles)
local AbuseVector = require(SocialBlockingModalParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(SocialBlockingModalParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local CloseCentralOverlay = require(SocialBlockingModalParent.CentralOverlay).Thunks.CloseCentralOverlay
local myUserBlockingNetworking = require(SocialBlockingModal.Networking.myUserBlockingNetworking)
local useShowToastOnError = require(script.Parent.useShowToastOnError)
local Analytics = require(script.Parent.Parent.Analytics)
local useSocialBlockingModalAnalytics = Analytics.useSocialBlockingModalAnalytics
local EventNames = Analytics.EventNames
local FocusNavigationUtils = require(SocialBlockingModalParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FFlagEnableAbuseReportRevampFlow = require(SocialBlockingModalParent.SharedFlags).FFlagEnableAbuseReportRevampFlow
local FFlagDisableBlockAndReport = require(SocialBlockingModalParent.SharedFlags).FFlagDisableBlockAndReport
local FFlagConnectionsToFriendsRename = require(SocialBlockingModalParent.SharedFlags).FFlagConnectionsToFriendsRename
local v34 = game:DefineFastFlag("SocialBlockingModalFocusNavSupport", false)

local function BlockingModal() -- line: 55
	-- upvalues: useNavigation (copy), FFlagDisableBlockAndReport (copy), useLocalUserId (copy), useDispatch (copy), useScreenSize (copy), useLayerCollector (copy), React (copy), useSocialBlockingModalAnalytics (copy), EventNames (copy), useShowToastOnError (copy), myUserBlockingNetworking (copy), FFlagEnableAbuseReportRevampFlow (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy), UserProfiles (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), ButtonType (copy), v34 (copy), InteractiveAlert (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v36 = useNavigation()
	local v37 = v36.getParam("navProps")
	local userId = v37.userId
	local onBlockSuccess = v37.onBlockSuccess
	local openReportUser = v37.openReportUser
	local v41 = if not FFlagDisableBlockAndReport then nil else v37.disableReportOption
	local v42 = useLocalUserId()
	local v43 = useDispatch()
	local v44 = useScreenSize()
	local v45 = useLayerCollector()

	if not v44 and (v45 and v45.absoluteSize) then
		v44 = v45.absoluteSize
	end

	local v46 = React.useCallback(function() -- line: 73
		-- upvalues: v36 (copy)
		v36.pop()
	end, { v36 })
	local fireAnalyticsEvent = useSocialBlockingModalAnalytics({
		userId = userId
	}).fireAnalyticsEvent

	React.useEffect(function() -- line: 79
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.SocialBlockingModalSeen)
	end, { userId })

	local v48 = useShowToastOnError()
	local v49 = React.useCallback(function() -- line: 85
		-- upvalues: v43 (copy), myUserBlockingNetworking (copy), userId (copy), v42 (copy), onBlockSuccess (copy), v48 (copy), v46 (copy)
		v43(myUserBlockingNetworking.BlockUserById.API({
			userId = userId,
			currentUserId = v42
		})):andThen(function() -- line: 90
			-- upvalues: onBlockSuccess (copy)
			if onBlockSuccess then
				onBlockSuccess()
			end
		end):catch(function(p1) -- line: 95
			-- upvalues: v48 (copy)
			v48(p1)
		end)
		v46()
	end, {
		onBlockSuccess,
		v46,
		userId,
		v42,
		v43,
		v48
	})
	local v50 = React.useCallback(function() -- line: 102
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v49 (copy)
		fireAnalyticsEvent(EventNames.SocialBlockingModalBlockPressed)
		v49()
	end, {
		v49,
		userId,
		fireAnalyticsEvent
	})
	local v51 = React.useCallback(function() -- line: 108
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v49 (copy), openReportUser (copy), FFlagEnableAbuseReportRevampFlow (copy), v43 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), userId (copy), CloseCentralOverlay (copy), AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy)
		fireAnalyticsEvent(EventNames.SocialBlockingModalBlockAndReportPressed)
		v49()

		if openReportUser then
			openReportUser()

			return
		end

		if FFlagEnableAbuseReportRevampFlow then
			v43(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = userId,
				onClose = function() -- line: 119
					-- upvalues: v43 (copy), CloseCentralOverlay (copy)
					v43(CloseCentralOverlay())
				end
			}))

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = `{ Url.BASE_URL }abusereport/userprofile?id={ userId }`,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v12.down(v12.fromLegacyPage(t1))

			return
		end

		v43(NavigateDown(t1))
	end, {
		v49,
		v43,
		userId,
		fireAnalyticsEvent,
		openReportUser
	})
	local v52 = React.useCallback(function() -- line: 148
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v46 (copy)
		fireAnalyticsEvent(EventNames.SocialBlockingModalCancelPressed)
		v46()
	end, {
		v46,
		fireAnalyticsEvent
	})
	local v53 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local v54 = if not v53.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v53.data, userId)
	local v55 = useLocalization({
		cancelBtnText = "Feature.BlockingModal.Action.Cancel",
		blockBtnText = "Feature.BlockingModal.Action.Block",
		blockAndReportBtnText = "Feature.BlockingModal.Action.BlockAndReport",
		title = {
			"Feature.BlockingModal.Heading.BlockUser",
			DisplayName = v54
		},
		bodyText = not FFlagConnectionsToFriendsRename and "Feature.BlockingModal.Message.BlockConfirmation" or "Feature.BlockingModal.Message.BlockConfirmation.FriendsRename"
	})
	local v56 = React.useMemo(function() -- line: 176
		-- upvalues: ButtonType (copy), v55 (copy), v52 (copy), FFlagDisableBlockAndReport (copy), v41 (copy), v51 (copy), v50 (copy)
		local t2 = {}

		table.insert(t2, {
			buttonType = ButtonType.Secondary,
			props = {
				text = v55.cancelBtnText,
				onActivated = v52
			}
		})

		if not FFlagDisableBlockAndReport or not v41 then
			table.insert(t2, {
				buttonType = ButtonType.Alert,
				props = {
					text = v55.blockAndReportBtnText,
					onActivated = v51
				}
			})
		end

		table.insert(t2, {
			buttonType = ButtonType.Alert,
			props = {
				text = v55.blockBtnText,
				onActivated = v50
			}
		})

		return t2
	end, {
		v55,
		v52,
		v51,
		v41,
		v50
	})

	if v34 then
		local v57 = React.createElement(InteractiveAlert, {
			richText = true,
			isRoactGamepadEnabled = false,
			screenSize = v44,
			title = v55.title,
			bodyText = v55.bodyText,
			buttonStackInfo = {
				buttons = v56 or {}
			}
		})

		return React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			BlockingModalScreen = v57
		})
	end

	return React.createElement(InteractiveAlert, {
		richText = true,
		screenSize = v44,
		title = v55.title,
		bodyText = v55.bodyText,
		buttonStackInfo = {
			buttons = v56 or {}
		}
	})
end

return BlockingModal

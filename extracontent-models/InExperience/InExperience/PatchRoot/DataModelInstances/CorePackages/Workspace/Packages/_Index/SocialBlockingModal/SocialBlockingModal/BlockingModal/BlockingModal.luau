local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local parent = SocialBlockingModal.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useLocalUserId = RobloxAppHooks.useLocalUserId

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Http = require(parent.Http)
local Url = Http.Url

local UIBlox = require(parent.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local UserProfiles = require(parent.UserProfiles)
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local myUserBlockingNetworking = require(SocialBlockingModal.Networking.myUserBlockingNetworking)
local useShowToastOnError = require(script.Parent.useShowToastOnError)

local Analytics = require(script.Parent.Parent.Analytics)
local useSocialBlockingModalAnalytics = Analytics.useSocialBlockingModalAnalytics
local EventNames = Analytics.EventNames

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableAbuseReportRevampFlow = SharedFlags2.FFlagEnableAbuseReportRevampFlow
local SharedFlags3 = require(parent.SharedFlags)
local FFlagDisableBlockAndReport = SharedFlags3.FFlagDisableBlockAndReport
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableMomentsCommentBlocking = SharedFlags4.FFlagEnableMomentsCommentBlocking
local SharedFlags5 = require(parent.SharedFlags)
local FFlagMomentsBlockingModalInOverlay = SharedFlags5.FFlagMomentsBlockingModalInOverlay

local function BlockingModal()
	local v = useNavigation()

	local param = v.getParam("navProps")
	local userId = param.userId
	local onBlockSuccess = param.onBlockSuccess
	local openReportUser = param.openReportUser
	local disableReportOption

	if FFlagDisableBlockAndReport then
		disableReportOption = param.disableReportOption
	else
		disableReportOption = nil
	end

	local currentUserId = useLocalUserId()
	local v2 = useDispatch()
	local screenSize = useScreenSize()

	local v3 = useLayerCollector()

	if not screenSize and v3 and v3.absoluteSize then
		screenSize = v3.absoluteSize
	end

	local v4 = React.useCallback(function()
		v.pop()
	end, { v })

	local fireAnalyticsEvent = useSocialBlockingModalAnalytics({ userId = userId }).fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(EventNames.SocialBlockingModalSeen)
	end, { userId })

	local v5 = useShowToastOnError()

	local v6 = React.useCallback(function()
		if FFlagEnableMomentsCommentBlocking and param.onBlockConfirmed then
			param.onBlockConfirmed()
		end

		v2(myUserBlockingNetworking.BlockUserById.API({
			userId = userId,
			currentUserId = currentUserId
		})):andThen(function()
			if onBlockSuccess then
				onBlockSuccess()
			end
		end):catch(function(p)
			v5(p)

			if FFlagEnableMomentsCommentBlocking and param.onBlockFailed then
				param.onBlockFailed()
			end
		end)

		v4()
	end, { onBlockSuccess, param, v4, userId, currentUserId, v2, v5 })

	local onActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.SocialBlockingModalBlockPressed)
		v6()
	end, { v6, userId, fireAnalyticsEvent })

	local onActivated2 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.SocialBlockingModalBlockAndReportPressed)
		v6()

		if openReportUser then
			openReportUser()
			return
		end

		if FFlagEnableAbuseReportRevampFlow then
			v2(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = userId,
				onClose = function()
					v2(CloseCentralOverlay())
				end
			}))
			return
		end

		local v7 = {
			name = AppPage.GenericWebPage,
			detail = `{Url.BASE_URL}abusereport/userprofile?id={userId}`,
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v2(NavigateDown(v7))
		end
	end, { v6, v2, userId, fireAnalyticsEvent, openReportUser })

	local onActivated3 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.SocialBlockingModalCancelPressed)
		v4()
	end, { v4, fireAnalyticsEvent })

	local v7 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local displayName

	if v7.data then
		displayName = UserProfiles.Selectors.getCombinedNameFromId(v7.data, userId)
	end

	local v8 = useLocalization({
		title = {
			"Feature.BlockingModal.Heading.BlockUser",
			DisplayName = displayName
		},
		bodyText = "Feature.BlockingModal.Message.BlockConfirmation.FriendsRename",
		cancelBtnText = "Feature.BlockingModal.Action.Cancel",
		blockBtnText = "Feature.BlockingModal.Action.Block",
		blockAndReportBtnText = "Feature.BlockingModal.Action.BlockAndReport"
	})

	local v9 = React.useMemo(function()
		local v9 = {}
		table.insert(v9, {
			buttonType = ButtonType.Secondary,
			props = { text = v8.cancelBtnText, onActivated = onActivated3 }
		})

		if not (FFlagDisableBlockAndReport and disableReportOption) then
			table.insert(v9, {
				buttonType = ButtonType.Alert,
				props = { text = v8.blockAndReportBtnText, onActivated = onActivated2 }
			})
		end

		table.insert(v9, {
			buttonType = ButtonType.Alert,
			props = { text = v8.blockBtnText, onActivated = onActivated }
		})

		return v9
	end, { v8, onActivated3, onActivated2, disableReportOption, onActivated })

	local element = React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v8.title,
		bodyText = v8.bodyText,
		richText = true,
		isRoactGamepadEnabled = false,
		buttonStackInfo = {
			buttons = v9 or {}
		}
	})

	local element2 = React.createElement(
		FocusRoot,
		{
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true
		},
		{ BlockingModalScreen = element }
	)

	if not (FFlagMomentsBlockingModalInOverlay and param.presentInOverlay) then
		return element2
	end

	local v10 = useOverlay()

	local v11 = useTokens()

	if v10 == nil then
		return element2
	end

	return ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = 300,
		backgroundStyle = v11.Color.Common.Backdrop,
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = function() end
	}, { BlockingModal = element2 }), v10)
end

return BlockingModal

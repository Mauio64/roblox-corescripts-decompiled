local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Foundation")
local view = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RobloxAppHooks")
local useScreenSize = RobloxAppHooks.useScreenSize
local useLocalUserId = RobloxAppHooks.useLocalUserId

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RobloxAppEnums").AppPage
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Http").Url

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/UIBlox")
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/UserProfiles")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/GenericAbuseReporting/OpenDynamicAbuseReport")

local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/CentralOverlay").Thunks.CloseCentralOverlay

local myUserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Networking/myUserBlockingNetworking")
local useShowToastOnError = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/BlockingModal/useShowToastOnError")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Analytics")
local useSocialBlockingModalAnalytics = Analytics.useSocialBlockingModalAnalytics
local eventNames = Analytics.EventNames

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SharedFlags").FFlagEnableAbuseReportRevampFlow
local fFlagDisableBlockAndReport = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SharedFlags").FFlagDisableBlockAndReport
local fFlagEnableMomentsCommentBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SharedFlags").FFlagEnableMomentsCommentBlocking
local fFlagMomentsBlockingModalInOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SharedFlags").FFlagMomentsBlockingModalInOverlay

local function BlockingModal()
	local v5 = useNavigation()

	local param = v5.getParam("navProps")
	local userId = param.userId
	local onBlockSuccess = param.onBlockSuccess
	local openReportUser = param.openReportUser
	local disableReportOption = if fFlagDisableBlockAndReport then param.disableReportOption else nil

	local v6 = useLocalUserId()
	local v7 = useDispatch()
	local v8 = useScreenSize()

	local v9 = useLayerCollector()

	if not v8 and v9 and v9.absoluteSize then
		v8 = v9.absoluteSize
	end

	local v10 = React.useCallback(function()
		v5.pop()
	end, { v5 })

	local fireAnalyticsEvent = useSocialBlockingModalAnalytics({ userId = userId }).fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.SocialBlockingModalSeen)
	end, { userId })

	local v11 = useShowToastOnError()

	local v12 = React.useCallback(function()
		if fFlagEnableMomentsCommentBlocking and param.onBlockConfirmed then
			param.onBlockConfirmed()
		end

		v7(myUserBlockingNetworking.BlockUserById.API({ userId = userId, currentUserId = v6 })):andThen(function()
			if onBlockSuccess then
				onBlockSuccess()
			end
		end):catch(function(p2)
			v11(p2)

			if fFlagEnableMomentsCommentBlocking and param.onBlockFailed then
				param.onBlockFailed()
			end
		end)

		v10()
	end, { onBlockSuccess, param, v10, userId, v6, v7, v11 })

	local v13 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.SocialBlockingModalBlockPressed)
		v12()
	end, { v12, userId, fireAnalyticsEvent })

	local v14 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.SocialBlockingModalBlockAndReportPressed)
		v12()

		if openReportUser then
			openReportUser()
			return
		end

		if fFlagEnableAbuseReportRevampFlow then
			v7(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = userId,
				onClose = function()
					v7(closeCentralOverlay())
				end
			}))
			return
		end

		local v15 = {
			name = appPage.GenericWebPage,
			detail = `{url.BASE_URL}abusereport/userprofile?id={userId}`,
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v7(navigateDown(v15))
		end
	end, { v12, v7, userId, fireAnalyticsEvent, openReportUser })

	local v15 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.SocialBlockingModalCancelPressed)
		v10()
	end, { v10, fireAnalyticsEvent })

	local v16 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v17 = if v16.data then UserProfiles.Selectors.getCombinedNameFromId(v16.data, userId) else nil

	local v18 = useLocalization({
		title = {
			"Feature.BlockingModal.Heading.BlockUser",
			DisplayName = v17
		},
		bodyText = "Feature.BlockingModal.Message.BlockConfirmation.FriendsRename",
		cancelBtnText = "Feature.BlockingModal.Action.Cancel",
		blockBtnText = "Feature.BlockingModal.Action.Block",
		blockAndReportBtnText = "Feature.BlockingModal.Action.BlockAndReport"
	})

	local v19 = React.useMemo(function()
		local v20 = {}
		table.insert(v20, {
			buttonType = buttonType.Secondary,
			props = { text = v18.cancelBtnText, onActivated = v15 }
		})

		if not (fFlagDisableBlockAndReport and disableReportOption) then
			table.insert(v20, {
				buttonType = buttonType.Alert,
				props = { text = v18.blockAndReportBtnText, onActivated = v14 }
			})
		end

		table.insert(v20, {
			buttonType = buttonType.Alert,
			props = { text = v18.blockBtnText, onActivated = v13 }
		})

		return v20
	end, { v18, v15, v14, disableReportOption, v13 })

	local element = React.createElement(interactiveAlert, {
		screenSize = v8,
		title = v18.title,
		bodyText = v18.bodyText,
		richText = true,
		isRoactGamepadEnabled = false,
		buttonStackInfo = {
			buttons = v19 or {}
		}
	})

	local element2 = React.createElement(
		focusRoot,
		{
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true
		},
		{ BlockingModalScreen = element }
	)

	if not (fFlagMomentsBlockingModalInOverlay and param.presentInOverlay) then
		return element2
	end

	local v20 = useOverlay()

	local v21 = useTokens()

	if v20 == nil then
		return element2
	end

	return ReactRoblox.createPortal(React.createElement(view, {
		tag = "size-full",
		ZIndex = 300,
		backgroundStyle = v21.Color.Common.Backdrop,
		stateLayer = { affordance = stateLayerAffordance.None },
		onActivated = function() end
	}, { BlockingModal = element2 }), v20)
end

return BlockingModal

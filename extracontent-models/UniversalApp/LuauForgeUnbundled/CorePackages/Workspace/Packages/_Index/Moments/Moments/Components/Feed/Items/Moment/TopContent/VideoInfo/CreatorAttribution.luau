local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagSocialFollowAttribution = SharedFlags.FFlagSocialFollowAttribution

local v5 = if fFlagSocialFollowAttribution then require("@game/CorePackages/Workspace/Packages/_Index/Moments/SocialCommon/FollowAttribution") else nil

local analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local eventNames = analytics.EventNames
local useLocalization = Localization.Hooks.useLocalization

local makeFeedActionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeFeedActionFields")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")

local dialog = Foundation.Dialog
local loading = Foundation.Loading
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize
local controlState = Foundation.Enums.ControlState
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getRbxThumb = Foundation.Utility.getRbxThumb
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useTokens = Foundation.Hooks.useTokens

local useUsername = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useUsername")
local useCreatorVerified = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useCreatorVerified")
local fFlagMomentsCreatorFollow = SharedFlags.FFlagMomentsCreatorFollow
local FFlagMomentsFlushDwellBeforeNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFlushDwellBeforeNavigation")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")
local SignalActionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/SignalActionType")

local Following = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/Following")
local followingStore = Following.FollowingStore
local followingUpdateErrorTypeEnum = Following.FollowingUpdateErrorTypeEnum
local ImageWithSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ImageWithSkeleton")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")

local vector2 = Vector2.new(120, 16)
local v6 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local v7 = utf8.char(57344)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v8 = {
	cancel = "Feature.Groups.Action.Cancel",
	follow = "Feature.Groups.Action.Follow",
	followed = "Feature.Friends.Label.Followed",
	following = "Feature.Friends.Label.Following",
	somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
	unfollow = "Feature.Groups.Action.Unfollow",
	unfollowed = "Feature.Friends.Label.Unfollowed",
	userNotPassedCaptchaError = "Feature.Friends.Error.UserNotPassedCaptcha"
}

local function showFollowToast(p2)
	GetToastStore(false).triggerToast({ title = p2, text = "" })
end

local creatorFollowLogger = nil
local function getCreatorFollowLogger()
	if creatorFollowLogger == nil then
		creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
	end

	return creatorFollowLogger
end

local function createLoggedChallengeNetwork(p2)
	local middleware = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/GenericChallenges").Middleware
	return middleware.createChallengeNetwork(function(p3)
		if creatorFollowLogger == nil then
			creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
		end

		creatorFollowLogger:debug("captcha required creatorId={}", p2)
		local interceptChallenge = middleware.InterceptChallenge(p3)

		if creatorFollowLogger == nil then
			creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
		end

		creatorFollowLogger:debug("captcha opened creatorId={}", p2)
		return interceptChallenge:andThen(function(p4)
			if creatorFollowLogger == nil then
				creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
			end

			creatorFollowLogger:debug("captcha completed creatorId={}", p2)
			return p4
		end, function(message)
			if creatorFollowLogger == nil then
				creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
			end

			creatorFollowLogger:warning("captcha failed creatorId={} error={}", p2, (tostring(message)))
			error(message)
		end)
	end)
end

local function UnfollowConfirmationDialog(props)
	local v9 = useLocalization({
		title = {
			"Feature.Moments.Title.UnfollowConfirmationDialog",
			username = props.creatorUsername
		}
	})

	local onCancel = props.onCancel
	local v10 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })
	local v11 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v10
	})

	return React.createElement(dialog.Root, {
		ref = v11,
		disablePortal = false,
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true,
		testId = "moments-creator-unfollow-dialog"
	}, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v9.title,
			LayoutOrder = 1
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 2,
			actions = {
				{
					text = props.unfollowText,
					variant = buttonVariant.Alert,
					onActivated = props.onConfirm,
					testId = "moments-creator-unfollow-confirm"
				},
				{
					text = props.cancelText,
					variant = buttonVariant.Standard,
					onActivated = props.onCancel,
					testId = "moments-creator-unfollow-cancel"
				}
			}
		})
	})
end

local function CreatorAttribution(p2)
	local v9 = useTokens()
	local v10 = MomentContext.useMoment()

	local data = v10.store.getData(false)
	local v11, v12, v13, state, setState, state2, setState2, state3, setState3, ref

	if fFlagMomentsCreatorFollow then
		v11 = useLocalization(v8)

		local v14 = React.useMemo(function()
			return followingStore.get().GetIsFollowing((tostring(data.creatorId)))
		end, { data.creatorId })

		v12 = SignalsReact.useSignalState(v14.data) == true

		v13 = SignalsReact.useSignalState(v14.status) == "NotReady"

		state, setState = React.useState(false)

		state2, setState2 = React.useState(nil)

		state3, setState3 = React.useState(false)

		ref = React.useRef(false)
	else
		ref = nil
		v11 = nil
		setState2 = nil
		setState = nil
		v12 = nil
		setState3 = nil
	end

	local state4, setState4 = React.useState(false)
	local v14, v15 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		v15(ReactOtter.ease(state4 and 0.6 or 0, {
			duration = state4 and 0.05 or 0.03,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { state4 })

	local v16 = { v10.animationRatio, v14 }
	local mapped = React.joinBindings(v16):map(function(list)
		return 1 - (1 - list[1]) * (1 - list[2])
	end)

	local v17 = useUsername(data.creatorId)

	local v18 = useCreatorVerified(data.creatorId)

	local openProfile = useMomentsHost().openProfile

	local v19 = if fFlagMomentsCreatorFollow or FFlagMomentsFlushDwellBeforeNavigation then FeedContext.useFeedOptional() else nil

	local useCallback = React.useCallback
	local function fn()
		if openProfile ~= nil then
			local v20 = makeFeedActionFields(data.momentId, data.feedItemId, data.feedSessionId)

			if v20 ~= nil then
				fireAnalyticsEvent(eventNames.ProfileCreatorInfoTapped, v20)
			end

			if FFlagMomentsFlushDwellBeforeNavigation and v19 ~= nil then
				local flushView = v19.flushView
				local v21 = if FFlagMomentsNavigationEvent then NavigationDestinationType.CreatorProfile else nil
				flushView(v21)
			end

			openProfile(data.creatorId)
		end
	end

	local v20

	if FFlagMomentsFlushDwellBeforeNavigation then
		v20 = {
			openProfile,
			v19,
			data.creatorId,
			data.momentId,
			data.feedItemId,
			data.feedSessionId
		}
	else
		v20 = {
			openProfile,
			data.creatorId,
			data.momentId,
			data.feedItemId,
			data.feedSessionId
		}
	end

	local v21 = useCallback(fn, v20)

	local size_800 = v9.Size.Size_800

	local v22 = if v17 and v18 then `{v17} {v7}` else v17
	local v23

	if fFlagMomentsCreatorFollow then
		v23 = React.useCallback(function(p3)
			if ref.current then
				return
			end

			local v24 = v11
			ref.current = true
			setState2(p3)
			setState(true)

			if creatorFollowLogger == nil then
				creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
			end

			creatorFollowLogger:debug("request started creatorId={}", data.creatorId)

			local success, result = pcall(function()
				local creatorId = data.creatorId
				local middleware = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/GenericChallenges").Middleware
				local challengeNetwork = middleware.createChallengeNetwork(function(p4)
					if creatorFollowLogger == nil then
						creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
					end

					creatorFollowLogger:debug("captcha required creatorId={}", creatorId)
					local interceptChallenge = middleware.InterceptChallenge(p4)

					if creatorFollowLogger == nil then
						creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
					end

					creatorFollowLogger:debug("captcha opened creatorId={}", creatorId)
					return interceptChallenge:andThen(function(p5)
						if creatorFollowLogger == nil then
							creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
						end

						creatorFollowLogger:debug("captcha completed creatorId={}", creatorId)
						return p5
					end, function(message)
						if creatorFollowLogger == nil then
							creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
						end

						creatorFollowLogger:warning(
							"captcha failed creatorId={} error={}",
							creatorId,
							(tostring(message))
						)
						error(message)
					end)
				end)

				if creatorFollowLogger == nil then
					creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
				end

				creatorFollowLogger:debug("challenge network ready creatorId={}", data.creatorId)
				local v25 = followingStore.get()
				local v26

				if p3 then
					v26 = v25.Follow(tostring(data.creatorId), challengeNetwork)
				else
					v26 = v25.Unfollow(tostring(data.creatorId), challengeNetwork)
				end

				if creatorFollowLogger == nil then
					creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
				end

				creatorFollowLogger:debug("request dispatched creatorId={}", data.creatorId)
				return v26
			end)

			if success then
				return result:andThen(function()
					ref.current = false
					setState2(nil)
					setState(false)

					if fFlagSocialFollowAttribution and p3 then
						v5.reportFollowSuccess({
							surface = v5.Surface.Moments,
							source = v5.Source.MomentsFeed
						})
					end

					local feedItemId = data.feedItemId

					if v19 ~= nil and feedItemId ~= nil and feedItemId ~= "" then
						local success2, result2 = pcall(function()
							local logAction = v19.logAction
							local v25 = if p3 then SignalActionType.AddFollow else SignalActionType.RemoveFollow
							logAction(v25, {
								itemId = feedItemId,
								tracingId = data.feedSessionId
							}, {})
						end)

						if not success2 then
							if creatorFollowLogger == nil then
								creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
							end

							creatorFollowLogger:warning(
								"preference signal failed creatorId={} error={}",
								data.creatorId,
								(tostring(result2))
							)
						end
					end

					if creatorFollowLogger == nil then
						creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
					end

					creatorFollowLogger:debug("request succeeded creatorId={}", data.creatorId)
					local v25 = if p3 then v24.followed else v24.unfollowed
					GetToastStore(false).triggerToast({ title = v25, text = "" })
				end, function(p4)
					ref.current = false
					setState2(nil)
					setState(false)
					local v25 = (type(p4) ~= "table" or p4.errorType == nil) and "Unknown"
						or tostring(p4.errorType)

					local v26 = (type(p4) ~= "table" or p4.responseCode == nil) and "Unknown"
						or tostring(p4.responseCode)

					if creatorFollowLogger == nil then
						creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
					end

					creatorFollowLogger:warning(
						"request failed creatorId={} errorType={} responseCode={}",
						data.creatorId,
						v25,
						v26
					)

					local v27 = if v25 == followingUpdateErrorTypeEnum.Captcha then v24.userNotPassedCaptchaError else v24.somethingIsWrong
					GetToastStore(false).triggerToast({ title = v27, text = "" })
				end)
			end

			ref.current = false
			setState2(nil)
			setState(false)

			if creatorFollowLogger == nil then
				creatorFollowLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.CreatorFollow")
			end

			creatorFollowLogger:warning(
				"request setup failed creatorId={} error={}",
				data.creatorId,
				(tostring(result))
			)

			local somethingIsWrong = v24.somethingIsWrong
			GetToastStore(false).triggerToast({ title = somethingIsWrong, text = "" })
		end, { data.creatorId, data.feedItemId, data.feedSessionId, v19, v11 })
	else
		v23 = nil
	end

	local v24

	if fFlagMomentsCreatorFollow then
		v24 = React.useCallback(function()
			if not v12 then
				return v23(true)
			end

			setState3(true)
		end, { v12, v23 })
	end

	local v25

	if fFlagMomentsCreatorFollow then
		v25 = React.useCallback(function()
			setState3(false)
			return v23(false)
		end, { v23 })
	end

	local v26 = if fFlagMomentsCreatorFollow then (if state2 == nil then v12 else not state2) else nil
	local v27 = if fFlagMomentsCreatorFollow then v13 or state else nil
	local createElement = React.createElement
	local v29 = {
		LayoutOrder = p2.LayoutOrder,
		testId = FFlagMomentsFlushDwellBeforeNavigation and "--moments-creator-attribution" or nil,
		tag = "row align-x-left align-y-center gap-small auto-xy",
		stateLayer = { affordance = stateLayerAffordance.None },
		onActivated = 0,
		onStateChanged = 0
	}

	if openProfile == nil then
		v21 = nil
	end

	v29.onActivated = v21
	function v29.onStateChanged(p3)
		setState4(p3 == controlState.Pressed or p3 == controlState.SelectedPressed)
	end
	local v30 = {
		Avatar = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = getRbxThumb(thumbnailType.AvatarHeadShot, data.creatorId, thumbnailSize.Medium),
			Size = UDim2.fromOffset(size_800, size_800),
			radius = radius.Circle,
			backgroundStyle = mapped:map(function(p3)
				return getColorStyleWithTransparency(v9.Color.Shift.Shift_300, p3)
			end),
			imageStyle = mapped:map(function(p3)
				return getColorStyleWithTransparency(v6, p3)
			end)
		}),
		Username = 0,
		FollowAction = 0,
		UnfollowDialog = 0
	}
	local v31

	if v22 then
		v31 = React.createElement(text, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-large text-align-x-left text-align-y-center text-truncate-end content-emphasis",
			Text = v22,
			textStyle = mapped:map(function(p3)
				return getColorStyleWithTransparency(v9.Color.Content.Emphasis, p3)
			end)
		})
	else
		v31 = React.createElement(skeleton, {
			LayoutOrder = 2,
			radius = radius.Medium,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		})
	end

	v30.Username = v31
	local v32

	if fFlagMomentsCreatorFollow and data.creatorId ~= getLocalUserId() then
		local createElement2 = React.createElement
		local v34 = {
			LayoutOrder = 3,
			tag = "row align-x-center align-y-center size-0-600 auto-x padding-x-small radius-small",
			backgroundStyle = mapped:map(function(p3)
				return getColorStyleWithTransparency(v9.Color.ActionStandard.Background, p3)
			end),
			isDisabled = v27,
			onActivated = v24,
			stroke = {
				Color = v9.Color.Content.Emphasis.Color3,
				Transparency = mapped:map(function(p3)
					return getColorStyleWithTransparency(v9.Color.Content.Emphasis, p3).Transparency or 0
				end),
				Thickness = v27 and 0 or v9.Stroke.Standard,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			},
			testId = "moments-creator-follow-button"
		}

		local createElement3 = React.createElement
		local v38 = if v26 then v11.following else v11.follow
		local v37 = {
			Text = v38,
			tag = "auto-xy text-label-small content-system-contrast",
			testId = "moments-creator-follow-button--text",
			textStyle = mapped:map(function(p3)
				return getColorStyleWithTransparency(v9.Color.System.Contrast, v27 and 1 or p3)
			end)
		}

		local v40 = if v27 then React.createElement(loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = iconSize.XSmall
		}) else nil
		v32 = createElement2(view, v34, {
			Label = createElement3(text, v37, { Loading = v40 })
		})
	end

	v30.FollowAction = v32
	local v33

	if fFlagMomentsCreatorFollow and state3 then
		v33 = React.createElement(UnfollowConfirmationDialog, {
			cancelText = v11.cancel,
			creatorUsername = v17 or tostring(data.creatorId),
			onCancel = function()
				setState3(false)
			end,
			onConfirm = v25,
			unfollowText = v11.unfollow
		})
	end

	v30.UnfollowDialog = v33
	return createElement(view, v29, v30)
end

return React.memo(CreatorAttribution)

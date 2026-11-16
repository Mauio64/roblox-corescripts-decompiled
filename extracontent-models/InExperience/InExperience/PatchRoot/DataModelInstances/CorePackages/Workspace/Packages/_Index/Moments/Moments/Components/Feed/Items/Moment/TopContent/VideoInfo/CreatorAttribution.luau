local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
require(parent.ReactFocusNavigation)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)
local Localization = require(parent.Localization)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialFollowAttribution = SharedFlags.FFlagSocialFollowAttribution
local FollowAttribution

if FFlagSocialFollowAttribution then
	FollowAttribution = require(parent.SocialCommon.FollowAttribution)
else
	FollowAttribution = nil
end

local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local useLocalization = Localization.Hooks.useLocalization

local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)

local Foundation = require(parent.Foundation)

local Dialog = Foundation.Dialog
local Loading = Foundation.Loading
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getRbxThumb = Foundation.Utility.getRbxThumb
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useTokens = Foundation.Hooks.useTokens

local useUsername = require(Moments.Hooks.useUsername)
local useCreatorVerified = require(Moments.Hooks.useCreatorVerified)
local FFlagMomentsCreatorFollow = SharedFlags.FFlagMomentsCreatorFollow
local FFlagMomentsFlushDwellBeforeNavigation = require(Moments.Flags.FFlagMomentsFlushDwellBeforeNavigation)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)
local SignalActionType = require(Moments.Enums.SignalActionType)

local Following = require(parent.DataHydration.Following)
local FollowingStore = Following.FollowingStore
local FollowingUpdateErrorTypeEnum = Following.FollowingUpdateErrorTypeEnum
local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local GetToastStore = require(Moments.Stores.GetToastStore)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
require(script.Parent.Parent.Parent.createMomentStore)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local getLocalUserId = require(Moments.Utils.getLocalUserId)

local vector2 = Vector2.new(120, 16)
local v = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local v2 = utf8.char(57344)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local v3 = {
	cancel = "Feature.Groups.Action.Cancel",
	follow = "Feature.Groups.Action.Follow",
	followed = "Feature.Friends.Label.Followed",
	following = "Feature.Friends.Label.Following",
	somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
	unfollow = "Feature.Groups.Action.Unfollow",
	unfollowed = "Feature.Friends.Label.Unfollowed",
	userNotPassedCaptchaError = "Feature.Friends.Error.UserNotPassedCaptcha"
}

local function showFollowToast(title: string) -- 3 equivalent calls inferred from this helper
	GetToastStore(false).triggerToast({ title = title, text = "" })
end

local creatorFollowLogger = nil
local function getCreatorFollowLogger() -- 11 equivalent calls inferred from this helper
	if creatorFollowLogger == nil then
		local Loggers = require(parent.Loggers)
		creatorFollowLogger = Loggers.Logger:new("Moments.CreatorFollow")
	end

	return creatorFollowLogger
end

local function createLoggedChallengeNetwork(creatorId: number) -- 1 equivalent call inferred from this helper
	local GenericChallenges = require(parent.GenericChallenges)
	local middleware = GenericChallenges.Middleware
	return middleware.createChallengeNetwork(function(p)
		getCreatorFollowLogger():debug("captcha required creatorId={}", creatorId) -- inferred equivalent call
		local interceptChallenge = middleware.InterceptChallenge(p)
		getCreatorFollowLogger():debug("captcha opened creatorId={}", creatorId) -- inferred equivalent call
		return interceptChallenge:andThen(function(p2)
			getCreatorFollowLogger():debug("captcha completed creatorId={}", creatorId) -- inferred equivalent call
			return p2
		end, function(message)
			getCreatorFollowLogger():warning("captcha failed creatorId={} error={}", creatorId, (tostring(message))) -- inferred equivalent call
			error(message)
		end)
	end)
end

local function UnfollowConfirmationDialog(props)
	local v4 = useLocalization({
		title = {
			"Feature.Moments.Title.UnfollowConfirmationDialog",
			username = props.creatorUsername
		}
	})

	local onCancel = props.onCancel
	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })
	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	return React.createElement(Dialog.Root, {
		ref = ref,
		disablePortal = false,
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true,
		testId = "moments-creator-unfollow-dialog"
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v4.title, LayoutOrder = 1 }),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			actions = {
				{
					text = props.unfollowText,
					variant = ButtonVariant.Alert,
					onActivated = props.onConfirm,
					testId = "moments-creator-unfollow-confirm"
				},
				{
					text = props.cancelText,
					variant = ButtonVariant.Standard,
					onActivated = props.onCancel,
					testId = "moments-creator-unfollow-cancel"
				}
			}
		})
	})
end

local function CreatorAttribution(p)
	local v4 = useTokens()
	local v5 = MomentContext.useMoment()

	local data = v5.store.getData(false)
	local v6, v7, v8, state, setState, state2, setState2, state3, setState3, ref

	if FFlagMomentsCreatorFollow then
		v6 = useLocalization(v3)

		local v9 = React.useMemo(function()
			return FollowingStore.get().GetIsFollowing((tostring(data.creatorId)))
		end, { data.creatorId })

		v7 = SignalsReact.useSignalState(v9.data) == true

		v8 = SignalsReact.useSignalState(v9.status) == "NotReady"

		state, setState = React.useState(false)

		state2, setState2 = React.useState(nil)

		state3, setState3 = React.useState(false)

		ref = React.useRef(false)
	else
		ref = nil
		v6 = nil
		setState2 = nil
		setState = nil
		v7 = nil
		setState3 = nil
	end

	local state4, setState4 = React.useState(false)
	local v9, v10 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		v10(ReactOtter.ease(state4 and 0.6 or 0, {
			duration = state4 and 0.05 or 0.03,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { state4 })

	local v11 = { v5.animationRatio, v9 }
	local mapped = React.joinBindings(v11):map(function(list)
		return 1 - (1 - list[1]) * (1 - list[2])
	end)

	local v12 = useUsername(data.creatorId)

	local v13 = useCreatorVerified(data.creatorId)

	local openProfile = useMomentsHost().openProfile
	local v14

	if FFlagMomentsCreatorFollow or FFlagMomentsFlushDwellBeforeNavigation then
		v14 = FeedContext.useFeedOptional()
	else
		v14 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if openProfile ~= nil then
			local feedActionFields = makeFeedActionFields(data.momentId, data.feedItemId, data.feedSessionId)

			if feedActionFields ~= nil then
				fireAnalyticsEvent(EventNames.ProfileCreatorInfoTapped, feedActionFields)
			end

			if FFlagMomentsFlushDwellBeforeNavigation and v14 ~= nil then
				local flushView = v14.flushView
				local v15

				if FFlagMomentsNavigationEvent then
					v15 = NavigationDestinationType.CreatorProfile
				end

				flushView(v15)
			end

			openProfile(data.creatorId)
		end
	end

	local v15

	if FFlagMomentsFlushDwellBeforeNavigation then
		v15 = {
			openProfile,
			v14,
			data.creatorId,
			data.momentId,
			data.feedItemId,
			data.feedSessionId
		}
	else
		v15 = { openProfile, data.creatorId, data.momentId, data.feedItemId, data.feedSessionId }
	end

	local onActivated = useCallback(fn, v15)

	local size_800 = v4.Size.Size_800
	local text

	if v12 and v13 then
		text = `{v12} {v2}`
	else
		text = v12
	end

	local v16

	if FFlagMomentsCreatorFollow then
		v16 = React.useCallback(function(flag: boolean)
			if ref.current then
				return
			end

			local v17 = v6
			ref.current = true
			setState2(flag)
			setState(true)
			getCreatorFollowLogger():debug("request started creatorId={}", data.creatorId) -- inferred equivalent call

			local success, result = pcall(function()
				local loggedChallengeNetwork = createLoggedChallengeNetwork(data.creatorId) -- inferred equivalent call
				getCreatorFollowLogger():debug("challenge network ready creatorId={}", data.creatorId) -- inferred equivalent call
				local v18 = FollowingStore.get()
				local v19

				if flag then
					v19 = v18.Follow(tostring(data.creatorId), loggedChallengeNetwork)
				else
					v19 = v18.Unfollow(tostring(data.creatorId), loggedChallengeNetwork)
				end

				getCreatorFollowLogger():debug("request dispatched creatorId={}", data.creatorId) -- inferred equivalent call
				return v19
			end)

			if success then
				return result:andThen(function()
					ref.current = false
					setState2(nil)
					setState(false)

					if FFlagSocialFollowAttribution and flag then
						FollowAttribution.reportFollowSuccess({
							surface = FollowAttribution.Surface.Moments,
							source = FollowAttribution.Source.MomentsFeed
						})
					end

					local feedItemId = data.feedItemId

					if v14 ~= nil and feedItemId ~= nil and feedItemId ~= "" then
						local success2, result2 = pcall(function()
							local logAction = v14.logAction
							local v18

							if flag then
								v18 = SignalActionType.AddFollow
							else
								v18 = SignalActionType.RemoveFollow
							end

							logAction(v18, { itemId = feedItemId, tracingId = data.feedSessionId }, {})
						end)

						if not success2 then
							getCreatorFollowLogger():warning( -- inferred equivalent call
								"preference signal failed creatorId={} error={}",
								data.creatorId,
								(tostring(result2))
							)
						end
					end

					getCreatorFollowLogger():debug("request succeeded creatorId={}", data.creatorId) -- inferred equivalent call
					local v18

					if flag then
						v18 = v17.followed
					else
						v18 = v17.unfollowed
					end

					showFollowToast(v18) -- inferred equivalent call
				end, function(p2)
					ref.current = false
					setState2(nil)
					setState(false)
					local v18 = (type(p2) ~= "table" or p2.errorType == nil) and "Unknown" or tostring(p2.errorType)

					local v19 = (type(p2) ~= "table" or p2.responseCode == nil) and "Unknown"
						or tostring(p2.responseCode)

					getCreatorFollowLogger():warning( -- inferred equivalent call
						"request failed creatorId={} errorType={} responseCode={}",
						data.creatorId,
						v18,
						v19
					)
					local v20

					if v18 == FollowingUpdateErrorTypeEnum.Captcha then
						v20 = v17.userNotPassedCaptchaError
					else
						v20 = v17.somethingIsWrong
					end

					showFollowToast(v20) -- inferred equivalent call
				end)
			end

			ref.current = false
			setState2(nil)
			setState(false)
			getCreatorFollowLogger():warning( -- inferred equivalent call
				"request setup failed creatorId={} error={}",
				data.creatorId,
				(tostring(result))
			)

			showFollowToast(v17.somethingIsWrong) -- inferred equivalent call
		end, { data.creatorId, data.feedItemId, data.feedSessionId, v14, v6 })
	else
		v16 = nil
	end

	local onActivated2

	if FFlagMomentsCreatorFollow then
		onActivated2 = React.useCallback(function()
			if not v7 then
				return v16(true)
			end

			setState3(true)
		end, { v7, v16 })
	end

	local onConfirm

	if FFlagMomentsCreatorFollow then
		onConfirm = React.useCallback(function()
			setState3(false)
			return v16(false)
		end, { v16 })
	end

	local v17

	if FFlagMomentsCreatorFollow then
		if state2 == nil then
			v17 = v7
		else
			v17 = not state2
		end
	end

	local isDisabled

	if FFlagMomentsCreatorFollow then
		isDisabled = v8 or state
	else
		isDisabled = nil
	end

	local createElement = React.createElement
	local v18 = {
		LayoutOrder = p.LayoutOrder,
		testId = FFlagMomentsFlushDwellBeforeNavigation and "--moments-creator-attribution" or nil,
		tag = "row align-x-left align-y-center gap-small auto-xy",
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = 0,
		onStateChanged = 0
	}

	if openProfile == nil then
		onActivated = nil
	end

	v18.onActivated = onActivated
	function v18.onStateChanged(p2)
		setState4(p2 == ControlState.Pressed or p2 == ControlState.SelectedPressed)
	end
	local v19 = {
		Avatar = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = getRbxThumb(ThumbnailType.AvatarHeadShot, data.creatorId, ThumbnailSize.Medium),
			Size = UDim2.fromOffset(size_800, size_800),
			radius = Radius.Circle,
			backgroundStyle = mapped:map(function(p2: number)
				return getColorStyleWithTransparency(v4.Color.Shift.Shift_300, p2)
			end),
			imageStyle = mapped:map(function(p2: number)
				return getColorStyleWithTransparency(v, p2)
			end)
		}),
		Username = 0,
		FollowAction = 0,
		UnfollowDialog = 0
	}
	local username

	if text then
		username = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-large text-align-x-left text-align-y-center text-truncate-end content-emphasis",
			Text = text,
			textStyle = mapped:map(function(p2: number)
				return getColorStyleWithTransparency(v4.Color.Content.Emphasis, p2)
			end)
		})
	else
		username = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = Radius.Medium,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		})
	end

	v19.Username = username
	local followAction

	if FFlagMomentsCreatorFollow and data.creatorId ~= getLocalUserId() then
		local createElement2 = React.createElement
		local v20 = {
			LayoutOrder = 3,
			tag = "row align-x-center align-y-center size-0-600 auto-x padding-x-small radius-small",
			backgroundStyle = mapped:map(function(p2: number)
				return getColorStyleWithTransparency(v4.Color.ActionStandard.Background, p2)
			end),
			isDisabled = isDisabled,
			onActivated = onActivated2,
			stroke = {
				Color = v4.Color.Content.Emphasis.Color3,
				Transparency = mapped:map(function(p2: number)
					return getColorStyleWithTransparency(v4.Color.Content.Emphasis, p2).Transparency or 0
				end),
				Thickness = isDisabled and 0 or v4.Stroke.Standard,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			},
			testId = "moments-creator-follow-button"
		}

		local createElement3 = React.createElement
		local text2 = if v17 then v6.following else v6.follow
		local v21 = {
			Text = text2,
			tag = "auto-xy text-label-small content-system-contrast",
			testId = "moments-creator-follow-button--text",
			textStyle = mapped:map(function(p2: number)
				return getColorStyleWithTransparency(v4.Color.System.Contrast, isDisabled and 1 or p2)
			end)
		}
		local loading

		if isDisabled then
			loading = React.createElement(Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = IconSize.XSmall
			})
		end

		followAction = createElement2(View, v20, {
			Label = createElement3(Text, v21, { Loading = loading })
		})
	end

	v19.FollowAction = followAction
	local unfollowDialog

	if FFlagMomentsCreatorFollow and state3 then
		unfollowDialog = React.createElement(UnfollowConfirmationDialog, {
			cancelText = v6.cancel,
			creatorUsername = v12 or tostring(data.creatorId),
			onCancel = function()
				setState3(false)
			end,
			onConfirm = onConfirm,
			unfollowText = v6.unfollow
		})
	end

	v19.UnfollowDialog = unfollowDialog
	return createElement(View, v18, v19)
end

return React.memo(CreatorAttribution)

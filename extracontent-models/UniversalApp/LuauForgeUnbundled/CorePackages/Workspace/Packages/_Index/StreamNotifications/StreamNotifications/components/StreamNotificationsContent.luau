local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Cryo")
local eventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Analytics").AnalyticsReporters.EventIngest
local EventIngestService = game:GetService("EventIngestService")
local v5 = eventIngest.new(EventIngestService)
local SessionService = game:GetService("SessionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/EmptyNotifications")
local MetaActionsMenu = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/MetaActionsMenu")
local StreamNotificationAnimationWrapper = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationAnimationWrapper")
local StreamNotificationBundleWrapper = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationBundleWrapper")
local StreamNotificationsContentPage = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationsContentPage")
local fetchStreamNotificationsContentPage = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/ContentPage/fetchStreamNotificationsContentPage")
local usePushPermissionClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/ContentPage/usePushPermissionClientAttributes")
local StreamPromptsBannerSlot = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamPromptsBannerSlot")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon")
local joinExperience = NotificationsCommon.JoinExperience
local kind = NotificationsCommon.type
local notificationHelper = NotificationsCommon.NotificationHelper

local EnumStreamNotificationsDisplayState = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/EnumStreamNotificationsDisplayState")
local EnumStreamNotificationsLoadingMoreState = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/EnumStreamNotificationsLoadingMoreState")

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/HttpRequest")
local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").FFlagLuaAppDefaultHttpRetry
local config = HttpRequest.config
local v6 = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"StreamNotificationsContentHttpRetryCount",
	4
) else nil
v6.maxRetryCount = v7
local v8 = config(v6)

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/RoactUtils").Hooks.RoactRodux.useDispatch

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local useStyle = UIBlox.Core.Style.useStyle

local useClientTriggerEventHandler = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/eventHandler/useClientTriggerEventHandler")

local getStreamNotifications = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/getStreamNotifications")
local clearUnreadNotifications = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/clearUnreadNotifications")
local postNotificationsApi = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/postNotificationsApi")
local postReportNotification = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/postReportNotification")
local reportEvent = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/reportEvent")
local sortNotifications = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/utils/sortNotifications")

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")

local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/CentralOverlay").Thunks.CloseCentralOverlay
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/GenericAbuseReporting/OpenDynamicAbuseReport")

local defineFastFlag = game:DefineFastFlag("LuaAppNewStreamNotificationsLogFix", false)
local defineFastFlag2 = game:DefineFastFlag("StreamNotificationFixInitialPageFill", false)
local FFlagStreamNotificationsSduiContentPage = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/Flags/FFlagStreamNotificationsSduiContentPage")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags")
local getFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes
local fFlagStreamNotificationsStandardizeClickEvents = SharedFlags.FFlagStreamNotificationsStandardizeClickEvents

local fFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging
local fFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled
local frameBoundsImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Impressions").FrameBoundsImpressionsTracker

local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local StreamNotificationDropdownExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationDropdownExperimentation")

local function createImpressionSignal()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		connect = function(p2, onEvent)
			return bindableEvent.Event:Connect(onEvent)
		end,
		fire = function()
			bindableEvent:Fire()
		end,
		destroy = function()
			bindableEvent:Destroy()
		end
	}
end

return function(props)
	local v9 = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v10 = useDispatch()
	local v11 = useClientTriggerEventHandler()

	local state, setState = React.useState({})

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(EnumStreamNotificationsDisplayState.Initializing)

	local fn

	local fn2

	local fn3

	local showOverlay = props.showOverlay or function(p2) end

	local ref = React.useRef(EnumStreamNotificationsLoadingMoreState.Loading)
	local state4, setState4 = React.useState(EnumStreamNotificationsLoadingMoreState.Loading)
	local ref2 = React.useRef(0)

	local ref3 = React.useRef({})
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(nil)
	local useRef = React.useRef
	local v12 = if fFlagStreamNotificationImpressionLogging then createImpressionSignal() else nil
	local v13 = useRef(v12)

	local v14 = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y
	local v15 = constants.Modal.HeaderHeight + v14

	local v16 = React.useMemo(function()
		if not fFlagStreamNotificationImpressionLogging then
			return { byNotificationId = {}, byIndex = {} }
		end

		local v17 = {}
		local v18 = {}

		local v19 = {}

		for i, v20 in ipairs(state) do
			if v20.notificationSourceType ~= "Sendr" then
				continue
			end

			local bundleKey = v20.content.bundleKey
			local v21

			if bundleKey and bundleKey ~= "" then
				v21 = (v19[bundleKey] or 0) + 1
				v19[bundleKey] = v21
			end

			local v22 = {
				impressionIndex = i,
				bundlePosition = v21,
				notification = v20
			}

			v17[i] = v22

			if v20.id then
				v18[v20.id] = v22
			end
		end

		return { byNotificationId = v18, byIndex = v17 }
	end, { state })

	local v17 = if FFlagStreamNotificationsSduiContentPage or fFlagNotificationStreamPromptsHandlerEnabled then usePushPermissionClientAttributes() else nil

	React.useEffect(function()
		fn()
	end, {})

	React.useEffect(function()
		if not FFlagStreamNotificationsSduiContentPage or v17 == nil then
			return
		end

		fetchStreamNotificationsContentPage(v17)
	end, { v17 })

	React.useEffect(function()
		if fFlagStreamNotificationImpressionLogging then
			return function()
				if v13.current then
					v13.current:destroy()
				end
			end
		end
	end, {})

	fn = function()
		if ref.current == EnumStreamNotificationsLoadingMoreState.NoMoreNotifications then
			return
		end

		local loading2 = EnumStreamNotificationsLoadingMoreState.Loading
		ref.current = loading2
		setState4(loading2)

		getStreamNotifications(v8, constants.DefaultMaxRows, ref2.current):andThen(function(p2)
			local v18 = sortNotifications(p2)
			local fStringPCGDKFilteredNotificationTypes = getFStringPCGDKFilteredNotificationTypes()
			local v19 = {}

			for i, v20 in ipairs(v18) do
				if not (not fStringPCGDKFilteredNotificationTypes[v20.content.notificationType] or not ThirdPartyUserService or not ThirdPartyUserService:IsChatRestrictionSupported() or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted) then
					continue
				end

				table.insert(v19, v20)
			end

			if v19 and #v19 > 0 then
				if defineFastFlag2 then
					for i, v20 in ipairs(v19) do
						if v20.notificationSourceType ~= "Sendr" then
							continue
						end

						local v21 = v20.content.bundleKey

						if not v21 or v21 == "" then
							v21 = v20.id
						end

						if not v21 or ref3.current[v21] then
							continue
						end

						ref3.current[v21] = true
						ref4.current += 1
					end
				end

				setState(function(p3)
					return (Cryo.List.join(p3, v19))
				end)

				local default = EnumStreamNotificationsLoadingMoreState.Default
				ref.current = default
				setState4(default)

				for i, v20 in ipairs(v19) do
					local fireEvent = notificationHelper.fireEvent

					local fetched = analyticsConstants.Context.fetched
					local notificationRetrieved = analyticsConstants.EventNames.notificationRetrieved
					local join = Cryo.Dictionary.join
					local clientEventsPayload = v20.content.clientEventsPayload or {}
					local v22 = {
						sendrVersion = constants.SENDRVersion,
						notificationType = v20.content.notificationType or nil,
						notificationId = v20.id or nil,
						notificationState = 0
					}

					local v23 = if fFlagStreamNotificationsStandardizeClickEvents then v20.content.currentState or nil else nil
					v22.notificationState = v23
					fireEvent(eventStream, fetched, notificationRetrieved, join(clientEventsPayload, v22))
				end
			else
				local noMoreNotifications = EnumStreamNotificationsLoadingMoreState.NoMoreNotifications
				ref.current = noMoreNotifications
				setState4(noMoreNotifications)
			end

			setState3(EnumStreamNotificationsDisplayState.Default)
			clearUnreadNotifications(v8)
			local current = tonumber(ref2.current) or 0
			ref2.current = current + constants.DefaultMaxRows

			if defineFastFlag2 then
				if ref4.current < constants.DefaultMaxRows then
					fn()
				end
			elseif state and #state < constants.DefaultMaxRows then
				fn()
			end
		end):catch(function(p2)
			setState3(EnumStreamNotificationsDisplayState.ErrorRetrieving)
		end)
	end

	local function fn4(nextState, p2)
		if dropdownEnabled then
			props.displayStream(false)
		end

		local function onSubmit()
			postReportNotification(v8, p2.id):andThen(function(p3) end):catch(function(p3) end)

			fn2(nextState, p2)

			if not dropdownEnabled then
				props.setDisplayScreenGuiEnabled(true)
			end

			setState3(EnumStreamNotificationsDisplayState.Default)
		end

		v10(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Notifications,
			targetId = p2.id,
			onSubmit = onSubmit,
			onClose = function()
				v10(closeCentralOverlay())

				if dropdownEnabled then
					props.displayStream(true)
				else
					props.setDisplayScreenGuiEnabled(true)
				end

				setState3(EnumStreamNotificationsDisplayState.Default)
			end
		}))
	end

	local v18 = React.useCallback(function(p2)
		if state and p2 then
			setState((Cryo.List.filter(state, function(p3): boolean
				return p3.id ~= p2 and p3.dismiss ~= true
			end)))
		end
	end)

	local v19 = React.useCallback(function(list)
		if not fFlagStreamNotificationImpressionLogging then
			return
		end

		for i, item in ipairs(list) do
			local v20 = v16.byIndex[item]
			local notification = if v20 then v20.notification else nil

			if not notification then
				continue
			end

			local fireEvent = notificationHelper.fireEvent

			local impression = analyticsConstants.Context.impression
			local notificationImpression = analyticsConstants.EventNames.notificationImpression
			local join = Cryo.Dictionary.join
			local clientEventsPayload = notification.content.clientEventsPayload or {}
			local v22 = {
				sendrVersion = constants.SENDRVersion,
				notificationType = notification.content.notificationType or nil,
				notificationId = notification.id or nil,
				notificationState = 0,
				bundlePosition = 0,
				bundleKey = 0
			}

			local v23 = if fFlagStreamNotificationsStandardizeClickEvents then notification.content.currentState or nil else nil
			v22.notificationState = v23

			v22.bundlePosition = v20.bundlePosition or nil
			v22.bundleKey = notification.content.bundleKey or nil
			fireEvent(eventStream, impression, notificationImpression, join(clientEventsPayload, v22))
		end
	end, { v16 })

	local v20 = React.useCallback(function(data, p2)
		local v21 = p2 or state2
		setState2(v21)
		local fireEvent = notificationHelper.fireEvent

		local click = analyticsConstants.Context.click
		local eventName = data.eventName or ""
		local join = Cryo.Dictionary.join
		local clientEventsPayload = data.clientEventsPayload or {}

		local v24 = if not (fFlagStreamNotificationsStandardizeClickEvents or not defineFastFlag) then v21 and v21.content and v21.content.notificationType else nil

		local v25 = if not (fFlagStreamNotificationsStandardizeClickEvents or not defineFastFlag) then v21 and v21.id else nil

		local v26 = if fFlagStreamNotificationsStandardizeClickEvents then v21 and v21.content and v21.content.notificationType else nil

		local v27 = if fFlagStreamNotificationsStandardizeClickEvents then v21 and v21.id else nil

		local v28 = if fFlagStreamNotificationsStandardizeClickEvents then v21 and v21.content and v21.content.currentState else nil
		fireEvent(eventStream, click, eventName, join(clientEventsPayload, {
			notifType = v24,
			notifId = v25,
			notificationType = v26,
			notificationId = v27,
			notificationState = v28,
			visualItemType = data.visualItemType or nil,
			visualItemName = data.visualItemName or nil,
			sendrVersion = constants.SENDRVersion
		}))

		if data.actions and #data.actions > 0 and v21 then
			for i, action in ipairs(data.actions) do
				if not action.actionType then
					continue
				end

				if action.actionType == kind.ActionTypeEnum.Deeplink then
					if joinExperience(action.path, false) then
						props.displayStream(false)
						SessionService:SetSession(
							constants.StreamSessionStructuralIdentifier.Level1,
							constants.StreamSessionStructuralIdentifier.StreamNotification,
							constants.StreamSessionStructuralIdentifier.StreamNotification
						)

						SessionService:SetMetadata(
							constants.StreamSessionStructuralIdentifier.StreamNotification,
							constants.StreamSessionStructuralIdentifier.DeleteOnGameLeave,
							"True"
						)

						reportEvent(v5, {
							action_type = action.actionType,
							delivery_channel = constants.DeliveryChannel,
							notification_type = v21.notificationSourceType,
							notification_id = v21.id
						})
					end
				elseif action.actionType == kind.ActionTypeEnum.NotificationApi then
					local id = if v21 then v21.id or nil else nil
					local path = action.path or nil
					postNotificationsApi(v8, id, path):andThen(function(p3)
						if action.nextState ~= nil and action.nextState ~= "" then
							fn2(action.nextState, v21)
						end
					end):catch(function(p3) end)
					fn3()
				elseif action.actionType == kind.ActionTypeEnum.Report then
					setState3(EnumStreamNotificationsDisplayState.AbuseReport)
					fn4(action.nextState, v21)
				elseif action.actionType == kind.ActionTypeEnum.Dismiss then
					local id = v21.id
					fn3()

					if state and id then
						setState((Cryo.List.map(state, function(p3)
							if p3.id == id then
								p3.dismiss = true
							end

							return p3
						end)))
					end
				elseif action.actionType == kind.ActionTypeEnum.ClientTrigger then
					if action.path == "TrustedContactsDoubleOptInModal" then
						props.displayStream(false)
					end

					v11(action.path, {
						clientEventsPayload = v21.content.clientEventsPayload,
						callback = function()
							fn2(action.nextState, v21)
						end
					})
				end
			end
		end
	end)

	local function fn5(p2)
		setState2(p2)
		setState3(EnumStreamNotificationsDisplayState.MetaActions)
		local fireEvent = notificationHelper.fireEvent

		local click = analyticsConstants.Context.click
		local openMetaActions = analyticsConstants.EventNames.openMetaActions
		local v22 = {
			visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
			sendrVersion = constants.SENDRVersion,
			notificationState = 0
		}

		local v23 = if fFlagStreamNotificationsStandardizeClickEvents then p2 and p2.content and p2.content.currentState or nil else nil
		v22.notificationState = v23
		fireEvent(eventStream, click, openMetaActions, v22)
	end

	fn3 = function()
		showOverlay(true)
		setState2(nil)

		if state3 == EnumStreamNotificationsDisplayState.MetaActions then
			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeMetaActions,
				{
					visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
					sendrVersion = constants.SENDRVersion
				}
			)
		end

		setState3(EnumStreamNotificationsDisplayState.Default)
	end

	fn2 = function(currentState, p2)
		local v21 = {}

		if state and p2 then
			for i, v22 in ipairs(state) do
				if v22.id == p2.id then
					v22.content.currentState = currentState
				end

				table.insert(v21, v22)
			end
		end

		setState(v21)
	end

	local v21 = React.useMemo(function()
		return React.createElement(MetaActionsMenu, {
			displayState = state3,
			activeNotification = state2,
			isSmallScreen = props.isSmallScreen,
			handleActions = v20,
			closeNotificationDisplay = fn3
		})
	end, { state3, state2 })

	local v22 = React.useMemo(function()
		if state3 == EnumStreamNotificationsDisplayState.Initializing then
			return React.createElement(loading, {
				size = iconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		end

		if state and #state > 0 then
			local children = {}
			local createElement = React.createElement
			local v24 = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = 0
			}
			local v25 = if dropdownEnabled then UDim.new(0, constants.Dropdown.CardGap) else nil
			v24.Padding = v25
			children.UIListLayout = createElement("UIListLayout", v24)

			if dropdownEnabled then
				children.UIPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, constants.Dropdown.ScrollBarThickness)
				})
			end

			if FFlagStreamNotificationsSduiContentPage then
				children.SduiContentPage = React.createElement(StreamNotificationsContentPage, {
					LayoutOrder = 0
				})
			end

			local v26 = {}
			local flag = false

			for i, v27 in ipairs(state) do
				if v27.notificationSourceType ~= "Sendr" then
					continue
				end

				flag = true

				local bundleKey = v27.content.bundleKey

				if not (bundleKey and bundleKey ~= "") then
					continue
				end

				if v26[bundleKey] then
					table.insert(v26[bundleKey], v27)
				else
					v26[bundleKey] = { v27 }
				end
			end

			for i, v27 in ipairs(state) do
				if v27.notificationSourceType ~= "Sendr" then
					continue
				end

				local bundleKey = v27.content.bundleKey

				if bundleKey and bundleKey ~= "" and #v26[bundleKey] > 1 then
					if not children[bundleKey] then
						local createElement2 = React.createElement
						local v29 = {
							layoutOrder = i,
							notifications = v26[bundleKey],
							finishDismissNotification = v18,
							handleActions = v20,
							openMetaActions = fn5,
							impressionsTag = fFlagStreamNotificationImpressionLogging and "StreamNotificationImpression" or nil,
							impressionMetadataByNotificationId = 0
						}

						local v30 = if fFlagStreamNotificationImpressionLogging then v16.byNotificationId else nil
						v29.impressionMetadataByNotificationId = v30
						children[bundleKey] = createElement2(StreamNotificationBundleWrapper, v29, {})
					end
				else
					local v28 = if fFlagStreamNotificationImpressionLogging then v16.byNotificationId[v27.id] else nil

					local id = v27.id
					local createElement2 = React.createElement
					local v30 = {
						layoutOrder = i,
						notification = v27,
						finishDismissNotification = v18,
						handleActions = v20,
						openMetaActions = fn5,
						collapsed = false,
						impressionsTag = fFlagStreamNotificationImpressionLogging and "StreamNotificationImpression" or nil,
						impressionIndex = 0
					}

					local v31 = if fFlagStreamNotificationImpressionLogging then v28 and v28.impressionIndex or nil else nil
					v30.impressionIndex = v31
					children[id] = createElement2(StreamNotificationAnimationWrapper, v30, {})
				end
			end

			if ref.current == EnumStreamNotificationsLoadingMoreState.Loading then
				children.LoadingMore = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, constants.LoadingMoreNotifications.Size),
						BackgroundTransparency = 1,
						LayoutOrder = 1e999
					},
					{
						LoadingMoreSpinner = React.createElement(loading, {
							size = iconSize.Small,
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					}
				)
			end

			if flag then
				local createElement2 = React.createElement
				local v29 = if dropdownEnabled then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0, -v15)
				return createElement2(
					"Frame",
					{
						Size = v29,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					},
					children
				)
			end
		end

		if FFlagStreamNotificationsSduiContentPage then
			return React.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					SduiContentPage = React.createElement(StreamNotificationsContentPage, {
						LayoutOrder = 1
					}),
					EmptyState = React.createElement(
						"Frame",
						{
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 2
						},
						{
							UIFlexItem = React.createElement("UIFlexItem", {
								FlexMode = Enum.UIFlexMode.Fill
							}),
							EmptyNotifications = React.createElement(module3)
						}
					)
				}
			)
		end

		return React.createElement(module3)
	end, { state, state3, state4, dropdownEnabled, v16 })

	local function fn6(data)
		local y = data.AbsoluteCanvasSize.Y
		local y2 = data.AbsoluteWindowSize.Y
		local y3 = data.CanvasPosition.Y

		if y2 == 0 or y == 0 or state3 ~= EnumStreamNotificationsDisplayState.Default then
			return
		end

		if fFlagStreamNotificationImpressionLogging and v13.current then
			v13.current:fire()
		end

		if
			y - y2 - constants.LoadingMoreNotifications.TriggerDistance <= y3
			and ref.current == EnumStreamNotificationsLoadingMoreState.Default
		then
			fn()
		end
	end

	if fFlagNotificationStreamPromptsHandlerEnabled then
		local createElement = React.createElement
		local v24 = {
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local children = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			PromptsBanner = 0,
			Content = 0
		}

		local createElement2 = React.createElement
		local v26 = {
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local createElement3 = React.createElement
		local v28 = StreamPromptsBannerSlot.get()
		local v29 = { clientAttributes = v17, bottomPadding = 0 }

		local v30 = if dropdownEnabled then constants.Dropdown.CardGap else constants.DefaultPadding
		v29.bottomPadding = v30
		children.PromptsBanner = createElement2("Frame", v26, {
			Banner = createElement3(v28, v29)
		})

		children.Content = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				Notifications = v22
			}
		)
		v22 = createElement("Frame", v24, children)
	end

	local v23 = not UserInputService.BottomBarSize and 0 or UserInputService.BottomBarSize.Y
	local v24 = not GuiService:GetSafeZoneOffsets() and 0 or GuiService:GetSafeZoneOffsets().bottom
	local v25 = not props.isSmallScreen and 0 or math.max(v23, v24)

	if dropdownEnabled then
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ClipsDescendants = true
		}, {
			MetaActionsOpen = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Visible = state3 == EnumStreamNotificationsDisplayState.MetaActions,
				BackgroundTransparency = v9.Theme.Overlay.Transparency,
				BackgroundColor3 = v9.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = fn3,
				BorderSizePixel = 0,
				Selectable = false
			}, { v21 }),
			NotificationsList = React.createElement("ScrollingFrame", {
				Size = UDim2.new(
					1,
					0,
					0,
					(props.dropdownHeight or constants.Dropdown.MaxHeight) - constants.Dropdown.HeaderMinHeight - constants.Dropdown.HeaderBodyGap
				),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = constants.Dropdown.ScrollBarThickness,
				BorderSizePixel = 0,
				VerticalScrollBarInset = Enum.ScrollBarInset.None,
				VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
				ScrollBarImageColor3 = v9.Theme.UIEmphasis.Color,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingEnabled = state3 == EnumStreamNotificationsDisplayState.Default,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				[React.Change.CanvasPosition] = fn6,
				Selectable = false
			}, v22)
		})
	else
		local createElement = React.createElement
		local v27 = {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1
		}

		local children = {
			MetaActionsOpen = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Visible = state3 == EnumStreamNotificationsDisplayState.MetaActions,
				BackgroundTransparency = v9.Theme.Overlay.Transparency,
				BackgroundColor3 = v9.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = fn3,
				BorderSizePixel = 0,
				Selectable = false
			}, { v21 }),
			NotificationsList = React.createElement("ScrollingFrame", {
				ref = if fFlagStreamNotificationImpressionLogging then ref5 else nil,
				Size = UDim2.new(1, 0, 1, -(v15 + constants.DefaultPadding + v25)),
				CanvasSize = UDim2.new(1, 0, 1, -(v15 + constants.DefaultPadding + v25)),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, v15),
				AnchorPoint = Vector2.new(0, 0),
				ScrollBarThickness = 4,
				BorderSizePixel = 0,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
				ScrollBarImageColor3 = v9.Theme.UIEmphasis.Color,
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingEnabled = state3 == EnumStreamNotificationsDisplayState.Default,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				[React.Change.CanvasPosition] = fn6,
				Selectable = false
			}, v22),
			ImpressionTracker = 0
		}

		local v32 = if fFlagStreamNotificationImpressionLogging then React.createElement(frameBoundsImpressionsTracker, {
			parentRef = ref5,
			pageContext = nil,
			impressionsTag = "StreamNotificationImpression",
			scrollViewPositionChangedSignal = v13.current,
			sendImpressions = v19
		}) else nil
		children.ImpressionTracker = v32
		return createElement("Frame", v27, children)
	end
end

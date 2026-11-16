local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local components = StreamNotifications.components

local parent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local Cryo = require(parent.Cryo)
local Analytics = require(parent.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local EventIngestService = game:GetService("EventIngestService")
local v = EventIngest.new(EventIngestService)
local SessionService = game:GetService("SessionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local EmptyNotifications = require(components.EmptyNotifications)
local MetaActionsMenu = require(components.MetaActionsMenu)
local StreamNotificationAnimationWrapper = require(components.StreamNotificationAnimationWrapper)
local StreamNotificationBundleWrapper = require(components.StreamNotificationBundleWrapper)
local StreamNotificationsContentPage = require(components.StreamNotificationsContentPage)
local fetchStreamNotificationsContentPage = require(StreamNotifications.ContentPage.fetchStreamNotificationsContentPage)
local usePushPermissionClientAttributes = require(StreamNotifications.ContentPage.usePushPermissionClientAttributes)
local StreamPromptsBannerSlot = require(StreamNotifications.StreamPromptsBannerSlot)

local React = require(parent.React)
local NotificationsCommon = require(parent.NotificationsCommon)
local JoinExperience = NotificationsCommon.JoinExperience
local kind = NotificationsCommon.type
local NotificationHelper = NotificationsCommon.NotificationHelper

local EnumStreamNotificationsDisplayState = require(StreamNotifications.EnumStreamNotificationsDisplayState)
local EnumStreamNotificationsLoadingMoreState = require(StreamNotifications.EnumStreamNotificationsLoadingMoreState)

local HttpRequest = require(parent.HttpRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local config = HttpRequest.config
local v2 = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("StreamNotificationsContentHttpRetryCount", 4)
end

v2.maxRetryCount = maxRetryCount
local v3 = config(v2)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local useStyle = UIBlox.Core.Style.useStyle

local useClientTriggerEventHandler = require(StreamNotifications.eventHandler.useClientTriggerEventHandler)

local getStreamNotifications = require(StreamNotifications.utils.getStreamNotifications)
local clearUnreadNotifications = require(StreamNotifications.utils.clearUnreadNotifications)
local postNotificationsApi = require(StreamNotifications.utils.postNotificationsApi)
local postReportNotification = require(StreamNotifications.utils.postReportNotification)
local reportEvent = require(StreamNotifications.utils.reportEvent)
local sortNotifications = require(StreamNotifications.utils.sortNotifications)

local analyticsService = require(StreamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)

local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local defineFastFlag = game:DefineFastFlag("LuaAppNewStreamNotificationsLogFix", false)
local defineFastFlag2 = game:DefineFastFlag("StreamNotificationFixInitialPageFill", false)
local FFlagStreamNotificationsSduiContentPage = require(StreamNotifications.Flags.FFlagStreamNotificationsSduiContentPage)

local SharedFlags2 = require(parent.SharedFlags)
local GetFStringPCGDKFilteredNotificationTypes = SharedFlags2.GetFStringPCGDKFilteredNotificationTypes
local FFlagStreamNotificationsStandardizeClickEvents = SharedFlags2.FFlagStreamNotificationsStandardizeClickEvents

local FFlagStreamNotificationImpressionLogging = SharedFlags2.FFlagStreamNotificationImpressionLogging
local FFlagNotificationStreamPromptsHandlerEnabled = SharedFlags2.FFlagNotificationStreamPromptsHandlerEnabled
local Impressions = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker

local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

local function createImpressionSignal()
	local bindableEvent = Instance.new("BindableEvent")
	return {
		connect = function(_, onEvent)
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
	local v4 = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v5 = useDispatch()
	local v6 = useClientTriggerEventHandler()

	local state, setState = React.useState({})

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(EnumStreamNotificationsDisplayState.Initializing)

	local fn

	local fn2

	local fn3

	local showOverlay = props.showOverlay or function(_: boolean) end

	local ref = React.useRef(EnumStreamNotificationsLoadingMoreState.Loading)
	local state4, setState4 = React.useState(EnumStreamNotificationsLoadingMoreState.Loading)
	local ref2 = React.useRef(0)

	local ref3 = React.useRef({})
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(nil)
	local useRef = React.useRef
	local v7

	if FFlagStreamNotificationImpressionLogging then
		v7 = createImpressionSignal()
	end

	local v8 = useRef(v7)

	local v9 = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y
	local v10 = constants.Modal.HeaderHeight + v9

	local v11 = React.useMemo(function()
		if not FFlagStreamNotificationImpressionLogging then
			return { byNotificationId = {}, byIndex = {} }
		end

		local byIndex = {}
		local byNotificationId = {}

		local v11 = {}

		for i, notification in ipairs(state) do
			if notification.notificationSourceType ~= "Sendr" then
				continue
			end

			local bundleKey = notification.content.bundleKey
			local bundlePosition

			if bundleKey and bundleKey ~= "" then
				bundlePosition = (v11[bundleKey] or 0) + 1
				v11[bundleKey] = bundlePosition
			end

			local v12 = {
				impressionIndex = i,
				bundlePosition = bundlePosition,
				notification = notification
			}

			byIndex[i] = v12

			if notification.id then
				byNotificationId[notification.id] = v12
			end
		end

		return { byNotificationId = byNotificationId, byIndex = byIndex }
	end, { state })
	local clientAttributes

	if FFlagStreamNotificationsSduiContentPage or FFlagNotificationStreamPromptsHandlerEnabled then
		clientAttributes = usePushPermissionClientAttributes()
	else
		clientAttributes = nil
	end

	React.useEffect(function()
		fn()
	end, {})

	React.useEffect(function()
		if not FFlagStreamNotificationsSduiContentPage or clientAttributes == nil then
			return
		end

		fetchStreamNotificationsContentPage(clientAttributes)
	end, { clientAttributes })

	React.useEffect(function()
		if FFlagStreamNotificationImpressionLogging then
			return function()
				if v8.current then
					v8.current:destroy()
				end
			end
		end
	end, {})

	local function fn4(current: string) -- 3 equivalent calls inferred from this helper
		ref.current = current
		setState4(current)
	end

	fn = function()
		if ref.current == EnumStreamNotificationsLoadingMoreState.NoMoreNotifications then
			return
		end

		fn4(EnumStreamNotificationsLoadingMoreState.Loading) -- inferred equivalent call
		getStreamNotifications(v3, constants.DefaultMaxRows, ref2.current):andThen(function(p)
			local v12 = sortNotifications(p)
			local fStringPCGDKFilteredNotificationTypes = GetFStringPCGDKFilteredNotificationTypes()
			local v13 = {}

			for _, v14 in ipairs(v12) do
				if not (not fStringPCGDKFilteredNotificationTypes[v14.content.notificationType] or not ThirdPartyUserService or not ThirdPartyUserService:IsChatRestrictionSupported() or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted) then
					continue
				end

				table.insert(v13, v14)
			end

			if v13 and #v13 > 0 then
				if defineFastFlag2 then
					for _, v14 in ipairs(v13) do
						if v14.notificationSourceType ~= "Sendr" then
							continue
						end

						local v15 = v14.content.bundleKey

						if not v15 or v15 == "" then
							v15 = v14.id
						end

						if not v15 or ref3.current[v15] then
							continue
						end

						ref3.current[v15] = true
						ref4.current += 1
					end
				end

				setState(function(p2)
					return (Cryo.List.join(p2, v13))
				end)

				fn4(EnumStreamNotificationsLoadingMoreState.Default) -- inferred equivalent call

				for _, v14 in ipairs(v13) do
					local fireEvent = NotificationHelper.fireEvent

					local fetched = analyticsConstants.Context.fetched
					local notificationRetrieved = analyticsConstants.EventNames.notificationRetrieved
					local join = Cryo.Dictionary.join
					local clientEventsPayload = v14.content.clientEventsPayload or {}
					local v15 = {
						sendrVersion = constants.SENDRVersion,
						notificationType = v14.content.notificationType or nil,
						notificationId = v14.id or nil,
						notificationState = 0
					}
					local notificationState

					if FFlagStreamNotificationsStandardizeClickEvents then
						notificationState = v14.content.currentState or nil
					end

					v15.notificationState = notificationState
					fireEvent(eventStream, fetched, notificationRetrieved, join(clientEventsPayload, v15))
				end
			else
				fn4(EnumStreamNotificationsLoadingMoreState.NoMoreNotifications) -- inferred equivalent call
			end

			setState3(EnumStreamNotificationsDisplayState.Default)
			clearUnreadNotifications(v3)
			ref2.current = (tonumber(ref2.current) or 0) + constants.DefaultMaxRows

			if defineFastFlag2 then
				if ref4.current < constants.DefaultMaxRows then
					fn()
				end
			elseif state and #state < constants.DefaultMaxRows then
				fn()
			end
		end):catch(function(_)
			setState3(EnumStreamNotificationsDisplayState.ErrorRetrieving)
		end)
	end

	local function fn5(nextState: string, p)
		if dropdownEnabled then
			props.displayStream(false)
		end

		local function onSubmit()
			postReportNotification(v3, p.id):andThen(function(_) end):catch(function(_) end)

			fn2(nextState, p)

			if not dropdownEnabled then
				props.setDisplayScreenGuiEnabled(true)
			end

			setState3(EnumStreamNotificationsDisplayState.Default)
		end

		local function fn6() -- 1 equivalent call inferred from this helper
			if dropdownEnabled then
				props.displayStream(true)
			else
				props.setDisplayScreenGuiEnabled(true)
			end

			setState3(EnumStreamNotificationsDisplayState.Default)
		end
		v5(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Notifications,
			targetId = p.id,
			onSubmit = onSubmit,
			onClose = function()
				v5(CloseCentralOverlay())
				fn6() -- inferred equivalent call
			end
		}))
	end

	local finishDismissNotification = React.useCallback(function(p: string)
		if state and p then
			setState((Cryo.List.filter(state, function(p2): boolean
				return p2.id ~= p and p2.dismiss ~= true
			end)))
		end
	end)

	local sendImpressions = React.useCallback(function(list)
		if not FFlagStreamNotificationImpressionLogging then
			return
		end

		for _, item in ipairs(list) do
			local v12 = v11.byIndex[item]
			local notification

			if v12 then
				notification = v12.notification
			end

			if not notification then
				continue
			end

			local fireEvent = NotificationHelper.fireEvent

			local impression = analyticsConstants.Context.impression
			local notificationImpression = analyticsConstants.EventNames.notificationImpression
			local join = Cryo.Dictionary.join
			local clientEventsPayload = notification.content.clientEventsPayload or {}
			local v13 = {
				sendrVersion = constants.SENDRVersion,
				notificationType = notification.content.notificationType or nil,
				notificationId = notification.id or nil,
				notificationState = 0,
				bundlePosition = 0,
				bundleKey = 0
			}
			local notificationState

			if FFlagStreamNotificationsStandardizeClickEvents then
				notificationState = notification.content.currentState or nil
			end

			v13.notificationState = notificationState

			v13.bundlePosition = v12.bundlePosition or nil
			v13.bundleKey = notification.content.bundleKey or nil
			fireEvent(eventStream, impression, notificationImpression, join(clientEventsPayload, v13))
		end
	end, { v11 })

	local function fn6(id: string?) -- 1 equivalent call inferred from this helper
		fn3()

		if state and id then
			setState((Cryo.List.map(state, function(p)
				if p.id == id then
					p.dismiss = true
				end

				return p
			end)))
		end
	end

	local handleActions = React.useCallback(function(data, p)
		local v12 = p or state2
		setState2(v12)
		local fireEvent = NotificationHelper.fireEvent

		local click = analyticsConstants.Context.click
		local eventName = data.eventName or ""
		local join = Cryo.Dictionary.join
		local clientEventsPayload = data.clientEventsPayload or {}
		local notifType

		if not (FFlagStreamNotificationsStandardizeClickEvents or not defineFastFlag) then
			notifType = v12 and v12.content and v12.content.notificationType
		end

		local notifId

		if not (FFlagStreamNotificationsStandardizeClickEvents or not defineFastFlag) then
			notifId = v12 and v12.id
		end

		local notificationType

		if FFlagStreamNotificationsStandardizeClickEvents then
			notificationType = v12 and v12.content and v12.content.notificationType
		end

		local notificationId

		if FFlagStreamNotificationsStandardizeClickEvents then
			notificationId = v12 and v12.id
		end

		local notificationState

		if FFlagStreamNotificationsStandardizeClickEvents then
			notificationState = v12 and v12.content and v12.content.currentState
		end

		fireEvent(eventStream, click, eventName, join(clientEventsPayload, {
			notifType = notifType,
			notifId = notifId,
			notificationType = notificationType,
			notificationId = notificationId,
			notificationState = notificationState,
			visualItemType = data.visualItemType or nil,
			visualItemName = data.visualItemName or nil,
			sendrVersion = constants.SENDRVersion
		}))

		if data.actions and #data.actions > 0 and v12 then
			for _, action in ipairs(data.actions) do
				if not action.actionType then
					continue
				end

				if action.actionType == kind.ActionTypeEnum.Deeplink then
					if JoinExperience(action.path, false) then
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

						reportEvent(v, {
							action_type = action.actionType,
							delivery_channel = constants.DeliveryChannel,
							notification_type = v12.notificationSourceType,
							notification_id = v12.id
						})
					end
				elseif action.actionType == kind.ActionTypeEnum.NotificationApi then
					local v13

					if v12 then
						v13 = v12.id or nil
					end

					postNotificationsApi(v3, v13, action.path or nil):andThen(function(_)
						if action.nextState ~= nil and action.nextState ~= "" then
							fn2(action.nextState, v12)
						end
					end):catch(function(_) end)
					fn3()
				elseif action.actionType == kind.ActionTypeEnum.Report then
					setState3(EnumStreamNotificationsDisplayState.AbuseReport)
					fn5(action.nextState, v12)
				elseif action.actionType == kind.ActionTypeEnum.Dismiss then
					fn6(v12.id) -- inferred equivalent call
				elseif action.actionType == kind.ActionTypeEnum.ClientTrigger then
					if action.path == "TrustedContactsDoubleOptInModal" then
						props.displayStream(false)
					end

					v6(action.path, {
						clientEventsPayload = v12.content.clientEventsPayload,
						callback = function()
							fn2(action.nextState, v12)
						end
					})
				end
			end
		end
	end)

	local function fn7(p)
		setState2(p)
		setState3(EnumStreamNotificationsDisplayState.MetaActions)
		local fireEvent = NotificationHelper.fireEvent

		local click = analyticsConstants.Context.click
		local openMetaActions = analyticsConstants.EventNames.openMetaActions
		local v12 = {
			visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
			sendrVersion = constants.SENDRVersion,
			notificationState = 0
		}
		local notificationState

		if FFlagStreamNotificationsStandardizeClickEvents then
			notificationState = p and p.content and p.content.currentState or nil
		end

		v12.notificationState = notificationState
		fireEvent(eventStream, click, openMetaActions, v12)
	end

	fn3 = function()
		showOverlay(true)
		setState2(nil)

		if state3 == EnumStreamNotificationsDisplayState.MetaActions then
			NotificationHelper.fireEvent(
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

	fn2 = function(currentState: string, p)
		local v12 = {}

		if state and p then
			for _, v13 in ipairs(state) do
				if v13.id == p.id then
					v13.content.currentState = currentState
				end

				table.insert(v12, v13)
			end
		end

		setState(v12)
	end

	local v12 = React.useMemo(function()
		return React.createElement(MetaActionsMenu, {
			displayState = state3,
			activeNotification = state2,
			isSmallScreen = props.isSmallScreen,
			handleActions = handleActions,
			closeNotificationDisplay = fn3
		})
	end, { state3, state2 })

	local notifications = React.useMemo(function()
		if state3 == EnumStreamNotificationsDisplayState.Initializing then
			return React.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		end

		if state and #state > 0 then
			local children = {}
			local createElement = React.createElement
			local v13 = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = 0
			}
			local padding

			if dropdownEnabled then
				padding = UDim.new(0, constants.Dropdown.CardGap)
			end

			v13.Padding = padding
			children.UIListLayout = createElement("UIListLayout", v13)

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

			local v14 = {}
			local flag = false

			for _, v15 in ipairs(state) do
				if v15.notificationSourceType ~= "Sendr" then
					continue
				end

				flag = true

				local bundleKey = v15.content.bundleKey

				if not (bundleKey and bundleKey ~= "") then
					continue
				end

				if v14[bundleKey] then
					table.insert(v14[bundleKey], v15)
				else
					v14[bundleKey] = { v15 }
				end
			end

			for i, notification in ipairs(state) do
				if notification.notificationSourceType ~= "Sendr" then
					continue
				end

				local bundleKey = notification.content.bundleKey

				if bundleKey and bundleKey ~= "" and #v14[bundleKey] > 1 then
					if not children[bundleKey] then
						local createElement2 = React.createElement
						local v15 = {
							layoutOrder = i,
							notifications = v14[bundleKey],
							finishDismissNotification = finishDismissNotification,
							handleActions = handleActions,
							openMetaActions = fn7,
							impressionsTag = FFlagStreamNotificationImpressionLogging and "StreamNotificationImpression" or nil,
							impressionMetadataByNotificationId = 0
						}
						local impressionMetadataByNotificationId

						if FFlagStreamNotificationImpressionLogging then
							impressionMetadataByNotificationId = v11.byNotificationId
						end

						v15.impressionMetadataByNotificationId = impressionMetadataByNotificationId
						children[bundleKey] = createElement2(StreamNotificationBundleWrapper, v15, {})
					end
				else
					local v15

					if FFlagStreamNotificationImpressionLogging then
						v15 = v11.byNotificationId[notification.id]
					end

					local id = notification.id
					local createElement2 = React.createElement
					local v16 = {
						layoutOrder = i,
						notification = notification,
						finishDismissNotification = finishDismissNotification,
						handleActions = handleActions,
						openMetaActions = fn7,
						collapsed = false,
						impressionsTag = FFlagStreamNotificationImpressionLogging and "StreamNotificationImpression" or nil,
						impressionIndex = 0
					}
					local impressionIndex

					if FFlagStreamNotificationImpressionLogging then
						impressionIndex = v15 and v15.impressionIndex or nil
					end

					v16.impressionIndex = impressionIndex
					children[id] = createElement2(StreamNotificationAnimationWrapper, v16, {})
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
						LoadingMoreSpinner = React.createElement(Loading, {
							size = IconSize.Small,
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					}
				)
			end

			if flag then
				local createElement2 = React.createElement
				local size

				if dropdownEnabled then
					size = UDim2.new(1, 0, 0, 0)
				else
					size = UDim2.new(1, 0, 0, -v10)
				end

				return createElement2(
					"Frame",
					{
						Size = size,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					},
					children
				)
			end
		end

		if FFlagStreamNotificationsSduiContentPage then
			return React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1
			}, {
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
					{ Size = UDim2.fromScale(1, 0), BackgroundTransparency = 1, LayoutOrder = 2 },
					{
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Fill
						}),
						EmptyNotifications = React.createElement(EmptyNotifications)
					}
				)
			})
		end

		return React.createElement(EmptyNotifications)
	end, { state, state3, state4, dropdownEnabled, v11 })

	local function fn8(data)
		local y = data.AbsoluteCanvasSize.Y
		local y2 = data.AbsoluteWindowSize.Y
		local y3 = data.CanvasPosition.Y

		if y2 == 0 or y == 0 or state3 ~= EnumStreamNotificationsDisplayState.Default then
			return
		end

		if FFlagStreamNotificationImpressionLogging and v8.current then
			v8.current:fire()
		end

		if
			y - y2 - constants.LoadingMoreNotifications.TriggerDistance <= y3
			and ref.current == EnumStreamNotificationsLoadingMoreState.Default
		then
			fn()
		end
	end

	if FFlagNotificationStreamPromptsHandlerEnabled then
		local createElement = React.createElement
		local v13 = {
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
		local v14 = {
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local createElement3 = React.createElement
		local v15 = StreamPromptsBannerSlot.get()
		local v16 = { clientAttributes = clientAttributes, bottomPadding = 0 }
		local bottomPadding

		if dropdownEnabled then
			bottomPadding = constants.Dropdown.CardGap
		else
			bottomPadding = constants.DefaultPadding
		end

		v16.bottomPadding = bottomPadding
		children.PromptsBanner = createElement2("Frame", v14, { Banner = createElement3(v15, v16) })

		children.Content = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
				Notifications = notifications
			}
		)
		notifications = createElement("Frame", v13, children)
	end

	local v13 = not UserInputService.BottomBarSize and 0 or UserInputService.BottomBarSize.Y
	local v14 = not GuiService:GetSafeZoneOffsets() and 0 or GuiService:GetSafeZoneOffsets().bottom
	local v15 = not props.isSmallScreen and 0 or math.max(v13, v14)

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
				BackgroundTransparency = v4.Theme.Overlay.Transparency,
				BackgroundColor3 = v4.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = fn3,
				BorderSizePixel = 0,
				Selectable = false
			}, { v12 }),
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
				ScrollBarImageColor3 = v4.Theme.UIEmphasis.Color,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingEnabled = state3 == EnumStreamNotificationsDisplayState.Default,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				[React.Change.CanvasPosition] = fn8,
				Selectable = false
			}, notifications)
		})
	else
		local createElement = React.createElement
		local v16 = {
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
				BackgroundTransparency = v4.Theme.Overlay.Transparency,
				BackgroundColor3 = v4.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = fn3,
				BorderSizePixel = 0,
				Selectable = false
			}, { v12 }),
			NotificationsList = 0,
			ImpressionTracker = 0
		}

		local createElement2 = React.createElement
		local ref6

		if FFlagStreamNotificationImpressionLogging then
			ref6 = ref5
		end

		children.NotificationsList = createElement2("ScrollingFrame", {
			ref = ref6,
			Size = UDim2.new(1, 0, 1, -(v10 + constants.DefaultPadding + v15)),
			CanvasSize = UDim2.new(1, 0, 1, -(v10 + constants.DefaultPadding + v15)),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, v10),
			AnchorPoint = Vector2.new(0, 0),
			ScrollBarThickness = 4,
			BorderSizePixel = 0,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
			ScrollBarImageColor3 = v4.Theme.UIEmphasis.Color,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingEnabled = state3 == EnumStreamNotificationsDisplayState.Default,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Change.CanvasPosition] = fn8,
			Selectable = false
		}, notifications)
		local impressionTracker

		if FFlagStreamNotificationImpressionLogging then
			impressionTracker = React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = ref5,
				pageContext = nil,
				impressionsTag = "StreamNotificationImpression",
				scrollViewPositionChangedSignal = v8.current,
				sendImpressions = sendImpressions
			})
		end

		children.ImpressionTracker = impressionTracker
		return createElement("Frame", v16, children)
	end
end

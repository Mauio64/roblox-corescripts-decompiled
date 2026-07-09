local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local components = StreamNotifications.components
local Players = game:GetService("Players")
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local Cryo = require(StreamNotificationsParent.Cryo)
local EventIngest = require(StreamNotificationsParent.Analytics).AnalyticsReporters.EventIngest
local EventIngestService = game:GetService("EventIngestService")
local v9 = EventIngest.new(EventIngestService)
local SessionService = game:GetService("SessionService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local EmptyNotifications = require(components.EmptyNotifications)
local MetaActionsMenu = require(components.MetaActionsMenu)
local StreamNotificationAnimationWrapper = require(components.StreamNotificationAnimationWrapper)
local StreamNotificationBundleWrapper = require(components.StreamNotificationBundleWrapper)
local React = require(StreamNotificationsParent.React)
local NotificationsCommon = require(StreamNotificationsParent.NotificationsCommon)
local JoinExperience = NotificationsCommon.JoinExperience
local type = NotificationsCommon.type
local NotificationHelper = NotificationsCommon.NotificationHelper
local EnumStreamNotificationsDisplayState = require(StreamNotifications.EnumStreamNotificationsDisplayState)
local EnumStreamNotificationsLoadingMoreState = require(StreamNotifications.EnumStreamNotificationsLoadingMoreState)
local HttpRequest = require(StreamNotificationsParent.HttpRequest)
local FFlagLuaAppDefaultHttpRetry = require(StreamNotificationsParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v27 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("StreamNotificationsContentHttpRetryCount", 4)
})
local useDispatch = require(StreamNotificationsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useDeviceType = require(StreamNotificationsParent.RobloxAppHooks).useDeviceType
local AppPage = require(StreamNotificationsParent.RobloxAppEnums).AppPage
local UIBlox = require(StreamNotificationsParent.UIBlox)
local Foundation = require(StreamNotificationsParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useStyle = UIBlox.Core.Style.useStyle
local NavigateDown = require(StreamNotificationsParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(StreamNotificationsParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v38 = if not FFlagSignalsNavP3Dispatch then nil else require(StreamNotificationsParent.RobloxAppNavigation).NavigationCommands
local useClientTriggerEventHandler = require(StreamNotifications.eventHandler.useClientTriggerEventHandler)
local getStreamNotifications = require(StreamNotifications.utils.getStreamNotifications)
local clearUnreadNotifications = require(StreamNotifications.utils.clearUnreadNotifications)
local postNotificationsApi = require(StreamNotifications.utils.postNotificationsApi)
local postReportNotification = require(StreamNotifications.utils.postReportNotification)
local reportEvent = require(StreamNotifications.utils.reportEvent)
local sortNotifications = require(StreamNotifications.utils.sortNotifications)
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local CloseCentralOverlay = require(StreamNotificationsParent.CentralOverlay).Thunks.CloseCentralOverlay
local AbuseVector = require(StreamNotificationsParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(StreamNotificationsParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local v51 = game:DefineFastFlag("LuaAppNewStreamNotificationsLogFix", false)
local SharedFlags = require(StreamNotificationsParent.SharedFlags)
local GetFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes
local FFlagFixNotificationReportsMobile = SharedFlags.FFlagFixNotificationReportsMobile
local FFlagStreamNotificationsStandardizeClickEvents = SharedFlags.FFlagStreamNotificationsStandardizeClickEvents
local FFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging
local FrameBoundsImpressionsTracker = require(StreamNotificationsParent.Impressions).FrameBoundsImpressionsTracker

local function GetIsFriendCommunicationRestricted() -- line: 87
	-- upvalues: ThirdPartyUserService (copy)
	return ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)
end

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

local function createImpressionSignal() -- line: 123
	local BindableEvent = Instance.new("BindableEvent")

	return {
		connect = function(_, p2) -- line: 126
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event:Connect(p2)
		end,
		fire = function() -- line: 129
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end,
		destroy = function() -- line: 132
			-- upvalues: BindableEvent (copy)
			BindableEvent:Destroy()
		end
	}
end

return function(t1: {[any]: any}) -- line: 138
	-- upvalues: useStyle (copy), StreamNotificationDropdownExperimentation (copy), useDispatch (copy), useDeviceType (copy), useClientTriggerEventHandler (copy), React (copy), EnumStreamNotificationsDisplayState (copy), EnumStreamNotificationsLoadingMoreState (copy), FFlagStreamNotificationImpressionLogging (copy), createImpressionSignal (copy), UserInputService (copy), constants (copy), getStreamNotifications (copy), v27 (copy), sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), Cryo (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), clearUnreadNotifications (copy), postReportNotification (copy), FFlagFixNotificationReportsMobile (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), Players (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v38 (copy), NavigateDown (copy), v51 (copy), type (copy), JoinExperience (copy), SessionService (copy), reportEvent (copy), v9 (copy), postNotificationsApi (copy), NotificationsCommon (copy), MetaActionsMenu (copy), Loading (copy), IconSize (copy), StreamNotificationBundleWrapper (copy), StreamNotificationAnimationWrapper (copy), EmptyNotifications (copy), GuiService (copy), FrameBoundsImpressionsTracker (copy)
	local v63 = useStyle()
	local v64 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v65 = useDispatch()
	local v66 = useDeviceType()
	local v67 = useClientTriggerEventHandler()
	local v68, v69 = React.useState({})
	local v70, v71 = React.useState(nil)
	local v72, v73 = React.useState(EnumStreamNotificationsDisplayState.Initializing)
	local u74 = nil
	local u75 = nil
	local u76 = nil
	local v77 = t1.showOverlay or function(_: boolean) -- line: 160
	end
	local v78 = React.useRef(EnumStreamNotificationsLoadingMoreState.Loading)
	local v79, v80 = React.useState(EnumStreamNotificationsLoadingMoreState.Loading)
	local v81 = React.useRef(0)
	local v82 = React.useRef(nil)
	local v83 = React.useRef(if not FFlagStreamNotificationImpressionLogging then nil else createImpressionSignal())
	local v84 = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y
	local v85 = constants.Modal.HeaderHeight + v84
	local v86 = React.useMemo(function() -- line: 176
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v68 (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return {
				byNotificationId = {},
				byIndex = {}
			}
		end

		local t2 = {}
		local t3 = {}
		local t4 = {}

		for i, v in ipairs(v68) do
			if v.notificationSourceType == "Sendr" then
				local bundleKey = v.content.bundleKey
				local v107 = nil

				if bundleKey and bundleKey ~= "" then
					v107 = (t4[bundleKey] or 0) + 1
					t4[bundleKey] = v107
				end

				local t5 = {
					impressionIndex = i,
					bundlePosition = v107,
					notification = v
				}

				t3[i] = t5

				if v.id then
					t2[v.id] = t5
				end
			end
		end

		return {
			byNotificationId = t2,
			byIndex = t3
		}
	end, { v68 })

	React.useEffect(function() -- line: 213
		-- upvalues: u74 (ref)
		u74()
	end, {})
	React.useEffect(function() -- line: 217
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v83 (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return
		end

		return function() -- line: 221
			-- upvalues: v83 (copy)
			if v83.current then
				v83.current:destroy()
			end
		end
	end, {})

	function u74() -- line: 233
		-- upvalues: v78 (copy), EnumStreamNotificationsLoadingMoreState (copy), v80 (copy), getStreamNotifications (copy), v27 (copy), constants (copy), v81 (copy), sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), v69 (copy), Cryo (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy), clearUnreadNotifications (copy), v68 (copy), u74 (ref)
		if v78.current == EnumStreamNotificationsLoadingMoreState.NoMoreNotifications then
			return
		end

		local Loading2 = EnumStreamNotificationsLoadingMoreState.Loading

		v78.current = Loading2
		v80(Loading2)
		getStreamNotifications(v27, constants.DefaultMaxRows, v81.current):andThen(function(p3) -- line: 241
			-- upvalues: sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), v69 (copy), Cryo (copy), EnumStreamNotificationsLoadingMoreState (copy), v78 (copy), v80 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy), clearUnreadNotifications (copy), v27 (copy), v81 (copy), v68 (copy), u74 (ref)
			local v155 = sortNotifications(p3)
			local v156 = GetFStringPCGDKFilteredNotificationTypes()
			local t6 = {}

			for _, v in ipairs(v155) do
				if not v156[v.content.notificationType] or (not ThirdPartyUserService or (not ThirdPartyUserService:IsChatRestrictionSupported() or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted)) then
					table.insert(t6, v)
				end
			end

			local u160 = t6

			if u160 and #u160 > 0 then
				v69(function(p4) -- line: 263
					-- upvalues: Cryo (copy), u160 (ref)
					return (Cryo.List.join(p4, u160))
				end)

				local Default = EnumStreamNotificationsLoadingMoreState.Default

				v78.current = Default
				v80(Default)

				for _, v in ipairs(u160) do
					NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.fetched, analyticsConstants.EventNames.notificationRetrieved, Cryo.Dictionary.join(v.content.clientEventsPayload or {}, {
						sendrVersion = constants.SENDRVersion,
						notificationType = v.content.notificationType or nil,
						notificationId = v.id or nil,
						notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v.content.currentState or nil
					}))
				end
			else
				local NoMoreNotifications = EnumStreamNotificationsLoadingMoreState.NoMoreNotifications

				v78.current = NoMoreNotifications
				v80(NoMoreNotifications)
			end

			v73(EnumStreamNotificationsDisplayState.Default)
			clearUnreadNotifications(v27)
			v81.current = (tonumber(v81.current) or 0) + constants.DefaultMaxRows

			if v68 and #v68 < constants.DefaultMaxRows then
				u74()
			end
		end):catch(function(_) -- line: 296
			-- upvalues: v73 (copy), EnumStreamNotificationsDisplayState (copy)
			v73(EnumStreamNotificationsDisplayState.ErrorRetrieving)
		end)
	end

	local function v87(s1: string, p6) -- line: 301
		-- upvalues: v64 (copy), t1 (copy), postReportNotification (copy), v27 (copy), u75 (ref), v73 (copy), EnumStreamNotificationsDisplayState (copy), FFlagFixNotificationReportsMobile (copy), v65 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), v66 (copy), Players (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v38 (copy), NavigateDown (copy)
		if v64 then
			t1.displayStream(false)
		end

		local function v113() -- line: 313
			-- upvalues: postReportNotification (copy), v27 (copy), p6 (copy), u75 (ref), s1 (copy), v64 (copy), t1 (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy)
			postReportNotification(v27, p6.id):andThen(function(_) -- line: 315
			end):catch(function(_) -- line: 316
			end)
			u75(s1, p6)

			if not v64 then
				t1.setDisplayScreenGuiEnabled(true)
			end

			v73(EnumStreamNotificationsDisplayState.Default)
		end

		if FFlagFixNotificationReportsMobile then
			v65(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Notifications,
				targetId = p6.id,
				onSubmit = v113,
				onClose = function() -- line: 341
					-- upvalues: v65 (copy), CloseCentralOverlay (copy), v64 (copy), t1 (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy)
					v65(CloseCentralOverlay())

					if v64 then
						t1.displayStream(true)
					else
						t1.setDisplayScreenGuiEnabled(true)
					end

					v73(EnumStreamNotificationsDisplayState.Default)
				end
			}))

			return
		end

		t1.setDisplayScreenGuiEnabled(false)

		local t7 = {
			reportEntryPoint = "Notification",
			assetId = p6.id,
			reportSurface = string.lower(v66),
			submissionEntryPoint = string.lower(v66),
			submitterUserId = if not Players.LocalPlayer then nil else tostring(Players.LocalPlayer.UserId),
			onSubmitReportCallback = v113,
			onCloseCallback = function() -- line: 327
				-- upvalues: v64 (copy), t1 (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy)
				if v64 then
					t1.displayStream(true)
				else
					t1.setDisplayScreenGuiEnabled(true)
				end

				v73(EnumStreamNotificationsDisplayState.Default)
			end
		}
		local t8 = {
			name = AppPage.ReportDialog,
			reportData = t7
		}

		if FFlagSignalsNavP3Dispatch then
			v38.down(v38.fromLegacyPage(t8))

			return
		end

		v65(NavigateDown(t8))
	end

	local v88 = React.useCallback(function(s2: string) -- line: 385
		-- upvalues: v68 (copy), Cryo (copy), v69 (copy)
		if v68 and s2 then
			local v119 = Cryo.List.filter(v68, function(p9) -- line: 387
				-- upvalues: s2 (copy)
				return p9.id ~= s2 and p9.dismiss ~= true
			end)

			v69(v119)
		end
	end)
	local v89 = React.useCallback(function(t9: {[any]: any}) -- line: 396
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v86 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), Cryo (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return
		end

		for _, v in ipairs(t9) do
			local v123 = v86.byIndex[v]
			local v124 = if not v123 then nil else v123.notification

			if v124 then
				NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.impression, analyticsConstants.EventNames.notificationImpression, Cryo.Dictionary.join(v124.content.clientEventsPayload or {}, {
					sendrVersion = constants.SENDRVersion,
					notificationType = v124.content.notificationType or nil,
					notificationId = v124.id or nil,
					notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v124.content.currentState or nil,
					bundlePosition = v123.bundlePosition or nil,
					bundleKey = v124.content.bundleKey or nil
				}))
			end
		end
	end, { v86 })
	local v90 = React.useCallback(function(p10, p11) -- line: 426
		-- upvalues: v70 (copy), v71 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), Cryo (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v51 (copy), constants (copy), type (copy), JoinExperience (copy), t1 (copy), SessionService (copy), reportEvent (copy), v9 (copy), postNotificationsApi (copy), v27 (copy), u75 (ref), u76 (ref), v73 (copy), EnumStreamNotificationsDisplayState (copy), v87 (copy), v68 (copy), v69 (copy), v67 (copy)
		local v127 = p11 or v70

		v71(v127)
		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, p10.eventName or "", Cryo.Dictionary.join(p10.clientEventsPayload or {}, {
			notifType = if not FFlagStreamNotificationsStandardizeClickEvents then if not v51 then nil else v127 and (v127.content and v127.content.notificationType) else nil,
			notifId = if not FFlagStreamNotificationsStandardizeClickEvents then if not v51 then nil else v127 and v127.id else nil,
			notificationType = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v127 and (v127.content and v127.content.notificationType),
			notificationId = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v127 and v127.id,
			notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v127 and (v127.content and v127.content.currentState),
			visualItemType = p10.visualItemType or nil,
			visualItemName = p10.visualItemName or nil,
			sendrVersion = constants.SENDRVersion
		}))

		if p10.actions and (#p10.actions > 0 and v127) then
			for _, v in ipairs(p10.actions) do
				if v.actionType then
					if v.actionType == type.ActionTypeEnum.Deeplink then
						if JoinExperience(v.path, false) then
							t1.displayStream(false)
							SessionService:SetSession(constants.StreamSessionStructuralIdentifier.Level1, constants.StreamSessionStructuralIdentifier.StreamNotification, constants.StreamSessionStructuralIdentifier.StreamNotification)
							SessionService:SetMetadata(constants.StreamSessionStructuralIdentifier.StreamNotification, constants.StreamSessionStructuralIdentifier.DeleteOnGameLeave, "True")
							reportEvent(v9, {
								action_type = v.actionType,
								delivery_channel = constants.DeliveryChannel,
								notification_type = v127.notificationSourceType,
								notification_id = v127.id
							})
						end
					elseif v.actionType == type.ActionTypeEnum.NotificationApi then
						local v130 = v127 and v127.id or nil
						local v131 = v.path or nil

						postNotificationsApi(v27, v130, v131):andThen(function(_) -- line: 499
							-- upvalues: v (copy), u75 (ref), v127 (copy)
							if v.nextState ~= nil and v.nextState ~= "" then
								u75(v.nextState, v127)
							end
						end):catch(function(_) -- line: 504
						end)
						u76()
					elseif v.actionType == type.ActionTypeEnum.Report then
						v73(EnumStreamNotificationsDisplayState.AbuseReport)
						v87(v.nextState, v127)
					elseif v.actionType == type.ActionTypeEnum.Dismiss then
						local id = v127.id

						u76()

						if v68 and id then
							local v133 = Cryo.List.map(v68, function(p14) -- line: 374
								-- upvalues: id (copy)
								if p14.id == id then
									p14.dismiss = true
								end

								return p14
							end)

							v69(v133)
						end
					elseif v.actionType == type.ActionTypeEnum.ClientTrigger then
						if v.path == "TrustedContactsDoubleOptInModal" then
							t1.displayStream(false)
						end

						v67(v.path, {
							clientEventsPayload = v127.content.clientEventsPayload,
							callback = function() -- line: 525
								-- upvalues: u75 (ref), v (copy), v127 (copy)
								u75(v.nextState, v127)
							end
						})
					end
				end
			end
		end
	end)

	local function v91(p15) -- line: 536
		-- upvalues: v71 (copy), v73 (copy), EnumStreamNotificationsDisplayState (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), NotificationsCommon (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy)
		v71(p15)
		v73(EnumStreamNotificationsDisplayState.MetaActions)
		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openMetaActions, {
			visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
			sendrVersion = constants.SENDRVersion,
			notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else p15 and (not not p15.content and p15.content.currentState) or nil
		})
	end

	function u76() -- line: 558
		-- upvalues: v77 (copy), v71 (copy), v72 (copy), EnumStreamNotificationsDisplayState (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), NotificationsCommon (copy), constants (copy), v73 (copy)
		v77(true)
		v71(nil)

		if v72 == EnumStreamNotificationsDisplayState.MetaActions then
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeMetaActions, {
				visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
				sendrVersion = constants.SENDRVersion
			})
		end

		v73(EnumStreamNotificationsDisplayState.Default)
	end
	function u75(s3: string, p16) -- line: 575
		-- upvalues: v68 (copy), v69 (copy)
		local t10 = {}

		if v68 and p16 then
			for _, v in ipairs(v68) do
				if v.id == p16.id then
					v.content.currentState = s3
				end

				table.insert(t10, v)
			end
		end

		v69(t10)
	end

	local v92 = React.useMemo(function() -- line: 591
		-- upvalues: React (copy), MetaActionsMenu (copy), v72 (copy), v70 (copy), t1 (copy), v90 (copy), u76 (ref)
		return React.createElement(MetaActionsMenu, {
			displayState = v72,
			activeNotification = v70,
			isSmallScreen = t1.isSmallScreen,
			handleActions = v90,
			closeNotificationDisplay = u76
		})
	end, {
		v72,
		v70
	})
	local v93 = React.useMemo(function() -- line: 601
		-- upvalues: v72 (copy), EnumStreamNotificationsDisplayState (copy), React (copy), Loading (copy), IconSize (copy), v68 (copy), v64 (copy), constants (copy), StreamNotificationBundleWrapper (copy), v88 (copy), v90 (copy), v91 (copy), FFlagStreamNotificationImpressionLogging (copy), v86 (copy), StreamNotificationAnimationWrapper (copy), v78 (copy), EnumStreamNotificationsLoadingMoreState (copy), v85 (copy), EmptyNotifications (copy)
		if v72 == EnumStreamNotificationsDisplayState.Initializing then
			return React.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		end

		if v68 and #v68 > 0 then
			local t11 = {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = if not v64 then nil else UDim.new(0, constants.Dropdown.CardGap)
				})
			}

			if v64 then
				t11.UIPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, constants.Dropdown.ScrollBarThickness)
				})
			end

			local v141 = false
			local t12 = {}

			for _, v in ipairs(v68) do
				if v.notificationSourceType == "Sendr" then
					v141 = true

					local bundleKey = v.content.bundleKey

					if bundleKey and bundleKey ~= "" then
						if t12[bundleKey] then
							table.insert(t12[bundleKey], v)
						else
							t12[bundleKey] = { v }
						end
					end
				end
			end

			for i, v in ipairs(v68) do
				if v.notificationSourceType == "Sendr" then
					local bundleKey = v.content.bundleKey

					if bundleKey and bundleKey ~= "" and #t12[bundleKey] > 1 then
						if not t11[bundleKey] then
							t11[bundleKey] = React.createElement(StreamNotificationBundleWrapper, {
								layoutOrder = i,
								notifications = t12[bundleKey],
								finishDismissNotification = v88,
								handleActions = v90,
								openMetaActions = v91,
								impressionsTag = if not FFlagStreamNotificationImpressionLogging then nil else "StreamNotificationImpression",
								impressionMetadataByNotificationId = if not FFlagStreamNotificationImpressionLogging then nil else v86.byNotificationId
							}, {})
						end
					else
						local v149 = if not FFlagStreamNotificationImpressionLogging then nil else v86.byNotificationId[v.id]

						t11[v.id] = React.createElement(StreamNotificationAnimationWrapper, {
							collapsed = false,
							layoutOrder = i,
							notification = v,
							finishDismissNotification = v88,
							handleActions = v90,
							openMetaActions = v91,
							impressionsTag = if not FFlagStreamNotificationImpressionLogging then nil else "StreamNotificationImpression",
							impressionIndex = if not FFlagStreamNotificationImpressionLogging then nil else v149 and v149.impressionIndex or nil
						}, {})
					end
				end
			end

			if v78.current == EnumStreamNotificationsLoadingMoreState.Loading then
				t11.LoadingMore = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1e999,
					Size = UDim2.new(1, 0, 0, constants.LoadingMoreNotifications.Size)
				}, {
					LoadingMoreSpinner = React.createElement(Loading, {
						size = IconSize.Small,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				})
			end

			if v141 then
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = if not v64 then UDim2.new(1, 0, 0, -v85) else UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, t11)
			end
		end

		return React.createElement(EmptyNotifications)
	end, {
		v68,
		v72,
		v79,
		v64,
		v86
	})

	local function v94(p17) -- line: 742
		-- upvalues: v72 (copy), EnumStreamNotificationsDisplayState (copy), FFlagStreamNotificationImpressionLogging (copy), v83 (copy), constants (copy), v78 (copy), EnumStreamNotificationsLoadingMoreState (copy), u74 (ref)
		local AbsoluteCanvasSizeY = p17.AbsoluteCanvasSize.Y
		local AbsoluteWindowSizeY = p17.AbsoluteWindowSize.Y
		local CanvasPositionY = p17.CanvasPosition.Y

		if AbsoluteWindowSizeY == 0 or (AbsoluteCanvasSizeY == 0 or v72 ~= EnumStreamNotificationsDisplayState.Default) then
			return
		end

		if FFlagStreamNotificationImpressionLogging and v83.current then
			v83.current:fire()
		end

		if CanvasPositionY >= AbsoluteCanvasSizeY - AbsoluteWindowSizeY - constants.LoadingMoreNotifications.TriggerDistance and v78.current == EnumStreamNotificationsLoadingMoreState.Default then
			u74()
		end
	end

	local v95 = not UserInputService.BottomBarSize and 0 or UserInputService.BottomBarSize.Y
	local v96 = not GuiService:GetSafeZoneOffsets() and 0 or GuiService:GetSafeZoneOffsets().bottom
	local v97 = not t1.isSmallScreen and 0 or math.max(v95, v96)

	if v64 then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			MetaActionsOpen = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Visible = v72 == EnumStreamNotificationsDisplayState.MetaActions,
				BackgroundTransparency = v63.Theme.Overlay.Transparency,
				BackgroundColor3 = v63.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = u76,
				BorderSizePixel = 0,
				Selectable = false
			}, { v92 }),
			NotificationsList = React.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 0, (t1.dropdownHeight or constants.Dropdown.MaxHeight) - constants.Dropdown.HeaderMinHeight - constants.Dropdown.HeaderBodyGap),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = constants.Dropdown.ScrollBarThickness,
				BorderSizePixel = 0,
				VerticalScrollBarInset = Enum.ScrollBarInset.None,
				VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
				ScrollBarImageColor3 = v63.Theme.UIEmphasis.Color,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingEnabled = v72 == EnumStreamNotificationsDisplayState.Default,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				[React.Change.CanvasPosition] = v94,
				Selectable = false
			}, v93)
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}, {
		MetaActionsOpen = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Visible = v72 == EnumStreamNotificationsDisplayState.MetaActions,
			BackgroundTransparency = v63.Theme.Overlay.Transparency,
			BackgroundColor3 = v63.Theme.Overlay.Color,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2,
			[React.Event.Activated] = u76,
			BorderSizePixel = 0,
			Selectable = false
		}, { v92 }),
		NotificationsList = React.createElement("ScrollingFrame", {
			ref = if not FFlagStreamNotificationImpressionLogging then nil else v82,
			Size = UDim2.new(1, 0, 1, -(v85 + constants.DefaultPadding + v97)),
			CanvasSize = UDim2.new(1, 0, 1, -(v85 + constants.DefaultPadding + v97)),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, v85),
			AnchorPoint = Vector2.new(0, 0),
			ScrollBarThickness = 4,
			BorderSizePixel = 0,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
			ScrollBarImageColor3 = v63.Theme.UIEmphasis.Color,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingEnabled = v72 == EnumStreamNotificationsDisplayState.Default,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Change.CanvasPosition] = v94,
			Selectable = false
		}, v93),
		ImpressionTracker = if not FFlagStreamNotificationImpressionLogging then nil else React.createElement(FrameBoundsImpressionsTracker, {
			pageContext = nil,
			impressionsTag = "StreamNotificationImpression",
			parentRef = v82,
			scrollViewPositionChangedSignal = v83.current,
			sendImpressions = v89
		})
	})
end

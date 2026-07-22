local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local components = StreamNotifications.components
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local Cryo = require(StreamNotificationsParent.Cryo)
local EventIngest = require(StreamNotificationsParent.Analytics).AnalyticsReporters.EventIngest
local EventIngestService = game:GetService("EventIngestService")
local v8 = EventIngest.new(EventIngestService)
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
local v26 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("StreamNotificationsContentHttpRetryCount", 4)
})
local useDispatch = require(StreamNotificationsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local UIBlox = require(StreamNotificationsParent.UIBlox)
local Foundation = require(StreamNotificationsParent.Foundation)
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
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local CloseCentralOverlay = require(StreamNotificationsParent.CentralOverlay).Thunks.CloseCentralOverlay
local AbuseVector = require(StreamNotificationsParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(StreamNotificationsParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local v45 = game:DefineFastFlag("LuaAppNewStreamNotificationsLogFix", false)
local SharedFlags = require(StreamNotificationsParent.SharedFlags)
local GetFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes
local FFlagStreamNotificationsStandardizeClickEvents = SharedFlags.FFlagStreamNotificationsStandardizeClickEvents
local FFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging
local FrameBoundsImpressionsTracker = require(StreamNotificationsParent.Impressions).FrameBoundsImpressionsTracker

local function GetIsFriendCommunicationRestricted() -- line: 76
	-- upvalues: ThirdPartyUserService (copy)
	return ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)
end

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

local function createImpressionSignal() -- line: 112
	local BindableEvent = Instance.new("BindableEvent")

	return {
		connect = function(_, p2) -- line: 115
			-- upvalues: BindableEvent (copy)
			return BindableEvent.Event:Connect(p2)
		end,
		fire = function() -- line: 118
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire()
		end,
		destroy = function() -- line: 121
			-- upvalues: BindableEvent (copy)
			BindableEvent:Destroy()
		end
	}
end

return function(t1: {[any]: any}) -- line: 127
	-- upvalues: useStyle (copy), StreamNotificationDropdownExperimentation (copy), useDispatch (copy), useClientTriggerEventHandler (copy), React (copy), EnumStreamNotificationsDisplayState (copy), EnumStreamNotificationsLoadingMoreState (copy), FFlagStreamNotificationImpressionLogging (copy), createImpressionSignal (copy), UserInputService (copy), constants (copy), getStreamNotifications (copy), v26 (copy), sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), Cryo (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), clearUnreadNotifications (copy), postReportNotification (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), v45 (copy), type (copy), JoinExperience (copy), SessionService (copy), reportEvent (copy), v8 (copy), postNotificationsApi (copy), NotificationsCommon (copy), MetaActionsMenu (copy), Loading (copy), IconSize (copy), StreamNotificationBundleWrapper (copy), StreamNotificationAnimationWrapper (copy), EmptyNotifications (copy), GuiService (copy), FrameBoundsImpressionsTracker (copy)
	local v56 = useStyle()
	local v57 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v58 = useDispatch()
	local v59 = useClientTriggerEventHandler()
	local v60, v61 = React.useState({})
	local v62, v63 = React.useState(nil)
	local v64, v65 = React.useState(EnumStreamNotificationsDisplayState.Initializing)
	local u66 = nil
	local u67 = nil
	local u68 = nil
	local v69 = t1.showOverlay or function(_: boolean) -- line: 148
	end
	local v70 = React.useRef(EnumStreamNotificationsLoadingMoreState.Loading)
	local v71, v72 = React.useState(EnumStreamNotificationsLoadingMoreState.Loading)
	local v73 = React.useRef(0)
	local v74 = React.useRef(nil)
	local v75 = React.useRef(if not FFlagStreamNotificationImpressionLogging then nil else createImpressionSignal())
	local v76 = not UserInputService.StatusBarSize and 0 or UserInputService.StatusBarSize.Y
	local v77 = constants.Modal.HeaderHeight + v76
	local v78 = React.useMemo(function() -- line: 164
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v60 (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return {
				byNotificationId = {},
				byIndex = {}
			}
		end

		local t2 = {}
		local t3 = {}
		local t4 = {}

		for i, v in ipairs(v60) do
			if v.notificationSourceType == "Sendr" then
				local bundleKey = v.content.bundleKey
				local v99 = nil

				if bundleKey and bundleKey ~= "" then
					v99 = (t4[bundleKey] or 0) + 1
					t4[bundleKey] = v99
				end

				local t5 = {
					impressionIndex = i,
					bundlePosition = v99,
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
	end, { v60 })

	React.useEffect(function() -- line: 201
		-- upvalues: u66 (ref)
		u66()
	end, {})
	React.useEffect(function() -- line: 205
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v75 (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return
		end

		return function() -- line: 209
			-- upvalues: v75 (copy)
			if v75.current then
				v75.current:destroy()
			end
		end
	end, {})

	function u66() -- line: 221
		-- upvalues: v70 (copy), EnumStreamNotificationsLoadingMoreState (copy), v72 (copy), getStreamNotifications (copy), v26 (copy), constants (copy), v73 (copy), sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), v61 (copy), Cryo (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v65 (copy), EnumStreamNotificationsDisplayState (copy), clearUnreadNotifications (copy), v60 (copy), u66 (ref)
		if v70.current == EnumStreamNotificationsLoadingMoreState.NoMoreNotifications then
			return
		end

		local Loading2 = EnumStreamNotificationsLoadingMoreState.Loading

		v70.current = Loading2
		v72(Loading2)
		getStreamNotifications(v26, constants.DefaultMaxRows, v73.current):andThen(function(p3) -- line: 229
			-- upvalues: sortNotifications (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), v61 (copy), Cryo (copy), EnumStreamNotificationsLoadingMoreState (copy), v70 (copy), v72 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v65 (copy), EnumStreamNotificationsDisplayState (copy), clearUnreadNotifications (copy), v26 (copy), v73 (copy), v60 (copy), u66 (ref)
			local v144 = sortNotifications(p3)
			local v145 = GetFStringPCGDKFilteredNotificationTypes()
			local t6 = {}

			for _, v in ipairs(v144) do
				if not v145[v.content.notificationType] or (not ThirdPartyUserService or (not ThirdPartyUserService:IsChatRestrictionSupported() or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted)) then
					table.insert(t6, v)
				end
			end

			local u149 = t6

			if u149 and #u149 > 0 then
				v61(function(p4) -- line: 251
					-- upvalues: Cryo (copy), u149 (ref)
					return (Cryo.List.join(p4, u149))
				end)

				local Default = EnumStreamNotificationsLoadingMoreState.Default

				v70.current = Default
				v72(Default)

				for _, v in ipairs(u149) do
					NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.fetched, analyticsConstants.EventNames.notificationRetrieved, Cryo.Dictionary.join(v.content.clientEventsPayload or {}, {
						sendrVersion = constants.SENDRVersion,
						notificationType = v.content.notificationType or nil,
						notificationId = v.id or nil,
						notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v.content.currentState or nil
					}))
				end
			else
				local NoMoreNotifications = EnumStreamNotificationsLoadingMoreState.NoMoreNotifications

				v70.current = NoMoreNotifications
				v72(NoMoreNotifications)
			end

			v65(EnumStreamNotificationsDisplayState.Default)
			clearUnreadNotifications(v26)
			v73.current = (tonumber(v73.current) or 0) + constants.DefaultMaxRows

			if v60 and #v60 < constants.DefaultMaxRows then
				u66()
			end
		end):catch(function(_) -- line: 284
			-- upvalues: v65 (copy), EnumStreamNotificationsDisplayState (copy)
			v65(EnumStreamNotificationsDisplayState.ErrorRetrieving)
		end)
	end

	local function v79(s1: string, p6) -- line: 289
		-- upvalues: v57 (copy), t1 (copy), postReportNotification (copy), v26 (copy), u67 (ref), v65 (copy), EnumStreamNotificationsDisplayState (copy), v58 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy)
		if v57 then
			t1.displayStream(false)
		end

		v58(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Notifications,
			targetId = p6.id,
			onSubmit = function() -- line: 301
				-- upvalues: postReportNotification (copy), v26 (copy), p6 (copy), u67 (ref), s1 (copy), v57 (copy), t1 (copy), v65 (copy), EnumStreamNotificationsDisplayState (copy)
				postReportNotification(v26, p6.id):andThen(function(_) -- line: 303
				end):catch(function(_) -- line: 304
				end)
				u67(s1, p6)

				if not v57 then
					t1.setDisplayScreenGuiEnabled(true)
				end

				v65(EnumStreamNotificationsDisplayState.Default)
			end,
			onClose = function() -- line: 327
				-- upvalues: v58 (copy), CloseCentralOverlay (copy), v57 (copy), t1 (copy), v65 (copy), EnumStreamNotificationsDisplayState (copy)
				v58(CloseCentralOverlay())

				if v57 then
					t1.displayStream(true)
				else
					t1.setDisplayScreenGuiEnabled(true)
				end

				v65(EnumStreamNotificationsDisplayState.Default)
			end
		}))
	end

	local v80 = React.useCallback(function(s2: string) -- line: 349
		-- upvalues: v60 (copy), Cryo (copy), v61 (copy)
		if v60 and s2 then
			local v108 = Cryo.List.filter(v60, function(p9) -- line: 351
				-- upvalues: s2 (copy)
				return p9.id ~= s2 and p9.dismiss ~= true
			end)

			v61(v108)
		end
	end)
	local v81 = React.useCallback(function(t7: {[any]: any}) -- line: 360
		-- upvalues: FFlagStreamNotificationImpressionLogging (copy), v78 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), Cryo (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy)
		if not FFlagStreamNotificationImpressionLogging then
			return
		end

		for _, v in ipairs(t7) do
			local v112 = v78.byIndex[v]
			local v113 = if not v112 then nil else v112.notification

			if v113 then
				NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.impression, analyticsConstants.EventNames.notificationImpression, Cryo.Dictionary.join(v113.content.clientEventsPayload or {}, {
					sendrVersion = constants.SENDRVersion,
					notificationType = v113.content.notificationType or nil,
					notificationId = v113.id or nil,
					notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v113.content.currentState or nil,
					bundlePosition = v112.bundlePosition or nil,
					bundleKey = v113.content.bundleKey or nil
				}))
			end
		end
	end, { v78 })
	local v82 = React.useCallback(function(p10, p11) -- line: 390
		-- upvalues: v62 (copy), v63 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), Cryo (copy), FFlagStreamNotificationsStandardizeClickEvents (copy), v45 (copy), constants (copy), type (copy), JoinExperience (copy), t1 (copy), SessionService (copy), reportEvent (copy), v8 (copy), postNotificationsApi (copy), v26 (copy), u67 (ref), u68 (ref), v65 (copy), EnumStreamNotificationsDisplayState (copy), v79 (copy), v60 (copy), v61 (copy), v59 (copy)
		local v116 = p11 or v62

		v63(v116)
		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, p10.eventName or "", Cryo.Dictionary.join(p10.clientEventsPayload or {}, {
			notifType = if not FFlagStreamNotificationsStandardizeClickEvents then if not v45 then nil else v116 and (v116.content and v116.content.notificationType) else nil,
			notifId = if not FFlagStreamNotificationsStandardizeClickEvents then if not v45 then nil else v116 and v116.id else nil,
			notificationType = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v116 and (v116.content and v116.content.notificationType),
			notificationId = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v116 and v116.id,
			notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else v116 and (v116.content and v116.content.currentState),
			visualItemType = p10.visualItemType or nil,
			visualItemName = p10.visualItemName or nil,
			sendrVersion = constants.SENDRVersion
		}))

		if p10.actions and (#p10.actions > 0 and v116) then
			for _, v in ipairs(p10.actions) do
				if v.actionType then
					if v.actionType == type.ActionTypeEnum.Deeplink then
						if JoinExperience(v.path, false) then
							t1.displayStream(false)
							SessionService:SetSession(constants.StreamSessionStructuralIdentifier.Level1, constants.StreamSessionStructuralIdentifier.StreamNotification, constants.StreamSessionStructuralIdentifier.StreamNotification)
							SessionService:SetMetadata(constants.StreamSessionStructuralIdentifier.StreamNotification, constants.StreamSessionStructuralIdentifier.DeleteOnGameLeave, "True")
							reportEvent(v8, {
								action_type = v.actionType,
								delivery_channel = constants.DeliveryChannel,
								notification_type = v116.notificationSourceType,
								notification_id = v116.id
							})
						end
					elseif v.actionType == type.ActionTypeEnum.NotificationApi then
						local v119 = v116 and v116.id or nil
						local v120 = v.path or nil

						postNotificationsApi(v26, v119, v120):andThen(function(_) -- line: 463
							-- upvalues: v (copy), u67 (ref), v116 (copy)
							if v.nextState ~= nil and v.nextState ~= "" then
								u67(v.nextState, v116)
							end
						end):catch(function(_) -- line: 468
						end)
						u68()
					elseif v.actionType == type.ActionTypeEnum.Report then
						v65(EnumStreamNotificationsDisplayState.AbuseReport)
						v79(v.nextState, v116)
					elseif v.actionType == type.ActionTypeEnum.Dismiss then
						local id = v116.id

						u68()

						if v60 and id then
							local v122 = Cryo.List.map(v60, function(p14) -- line: 338
								-- upvalues: id (copy)
								if p14.id == id then
									p14.dismiss = true
								end

								return p14
							end)

							v61(v122)
						end
					elseif v.actionType == type.ActionTypeEnum.ClientTrigger then
						if v.path == "TrustedContactsDoubleOptInModal" then
							t1.displayStream(false)
						end

						v59(v.path, {
							clientEventsPayload = v116.content.clientEventsPayload,
							callback = function() -- line: 489
								-- upvalues: u67 (ref), v (copy), v116 (copy)
								u67(v.nextState, v116)
							end
						})
					end
				end
			end
		end
	end)

	local function v83(p15) -- line: 500
		-- upvalues: v63 (copy), v65 (copy), EnumStreamNotificationsDisplayState (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), NotificationsCommon (copy), constants (copy), FFlagStreamNotificationsStandardizeClickEvents (copy)
		v63(p15)
		v65(EnumStreamNotificationsDisplayState.MetaActions)
		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openMetaActions, {
			visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
			sendrVersion = constants.SENDRVersion,
			notificationState = if not FFlagStreamNotificationsStandardizeClickEvents then nil else p15 and (not not p15.content and p15.content.currentState) or nil
		})
	end

	function u68() -- line: 522
		-- upvalues: v69 (copy), v63 (copy), v64 (copy), EnumStreamNotificationsDisplayState (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), NotificationsCommon (copy), constants (copy), v65 (copy)
		v69(true)
		v63(nil)

		if v64 == EnumStreamNotificationsDisplayState.MetaActions then
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeMetaActions, {
				visualItemType = NotificationsCommon.type.VisualItemTypeEnum.MetaAction,
				sendrVersion = constants.SENDRVersion
			})
		end

		v65(EnumStreamNotificationsDisplayState.Default)
	end
	function u67(s3: string, p16) -- line: 539
		-- upvalues: v60 (copy), v61 (copy)
		local t8 = {}

		if v60 and p16 then
			for _, v in ipairs(v60) do
				if v.id == p16.id then
					v.content.currentState = s3
				end

				table.insert(t8, v)
			end
		end

		v61(t8)
	end

	local v84 = React.useMemo(function() -- line: 555
		-- upvalues: React (copy), MetaActionsMenu (copy), v64 (copy), v62 (copy), t1 (copy), v82 (copy), u68 (ref)
		return React.createElement(MetaActionsMenu, {
			displayState = v64,
			activeNotification = v62,
			isSmallScreen = t1.isSmallScreen,
			handleActions = v82,
			closeNotificationDisplay = u68
		})
	end, {
		v64,
		v62
	})
	local v85 = React.useMemo(function() -- line: 565
		-- upvalues: v64 (copy), EnumStreamNotificationsDisplayState (copy), React (copy), Loading (copy), IconSize (copy), v60 (copy), v57 (copy), constants (copy), StreamNotificationBundleWrapper (copy), v80 (copy), v82 (copy), v83 (copy), FFlagStreamNotificationImpressionLogging (copy), v78 (copy), StreamNotificationAnimationWrapper (copy), v70 (copy), EnumStreamNotificationsLoadingMoreState (copy), v77 (copy), EmptyNotifications (copy)
		if v64 == EnumStreamNotificationsDisplayState.Initializing then
			return React.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		end

		if v60 and #v60 > 0 then
			local t9 = {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = if not v57 then nil else UDim.new(0, constants.Dropdown.CardGap)
				})
			}

			if v57 then
				t9.UIPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, constants.Dropdown.ScrollBarThickness)
				})
			end

			local v130 = false
			local t10 = {}

			for _, v in ipairs(v60) do
				if v.notificationSourceType == "Sendr" then
					v130 = true

					local bundleKey = v.content.bundleKey

					if bundleKey and bundleKey ~= "" then
						if t10[bundleKey] then
							table.insert(t10[bundleKey], v)
						else
							t10[bundleKey] = { v }
						end
					end
				end
			end

			for i, v in ipairs(v60) do
				if v.notificationSourceType == "Sendr" then
					local bundleKey = v.content.bundleKey

					if bundleKey and bundleKey ~= "" and #t10[bundleKey] > 1 then
						if not t9[bundleKey] then
							t9[bundleKey] = React.createElement(StreamNotificationBundleWrapper, {
								layoutOrder = i,
								notifications = t10[bundleKey],
								finishDismissNotification = v80,
								handleActions = v82,
								openMetaActions = v83,
								impressionsTag = if not FFlagStreamNotificationImpressionLogging then nil else "StreamNotificationImpression",
								impressionMetadataByNotificationId = if not FFlagStreamNotificationImpressionLogging then nil else v78.byNotificationId
							}, {})
						end
					else
						local v138 = if not FFlagStreamNotificationImpressionLogging then nil else v78.byNotificationId[v.id]

						t9[v.id] = React.createElement(StreamNotificationAnimationWrapper, {
							collapsed = false,
							layoutOrder = i,
							notification = v,
							finishDismissNotification = v80,
							handleActions = v82,
							openMetaActions = v83,
							impressionsTag = if not FFlagStreamNotificationImpressionLogging then nil else "StreamNotificationImpression",
							impressionIndex = if not FFlagStreamNotificationImpressionLogging then nil else v138 and v138.impressionIndex or nil
						}, {})
					end
				end
			end

			if v70.current == EnumStreamNotificationsLoadingMoreState.Loading then
				t9.LoadingMore = React.createElement("Frame", {
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

			if v130 then
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = if not v57 then UDim2.new(1, 0, 0, -v77) else UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, t9)
			end
		end

		return React.createElement(EmptyNotifications)
	end, {
		v60,
		v64,
		v71,
		v57,
		v78
	})

	local function v86(p17) -- line: 706
		-- upvalues: v64 (copy), EnumStreamNotificationsDisplayState (copy), FFlagStreamNotificationImpressionLogging (copy), v75 (copy), constants (copy), v70 (copy), EnumStreamNotificationsLoadingMoreState (copy), u66 (ref)
		local AbsoluteCanvasSizeY = p17.AbsoluteCanvasSize.Y
		local AbsoluteWindowSizeY = p17.AbsoluteWindowSize.Y
		local CanvasPositionY = p17.CanvasPosition.Y

		if AbsoluteWindowSizeY == 0 or (AbsoluteCanvasSizeY == 0 or v64 ~= EnumStreamNotificationsDisplayState.Default) then
			return
		end

		if FFlagStreamNotificationImpressionLogging and v75.current then
			v75.current:fire()
		end

		if CanvasPositionY >= AbsoluteCanvasSizeY - AbsoluteWindowSizeY - constants.LoadingMoreNotifications.TriggerDistance and v70.current == EnumStreamNotificationsLoadingMoreState.Default then
			u66()
		end
	end

	local v87 = not UserInputService.BottomBarSize and 0 or UserInputService.BottomBarSize.Y
	local v88 = not GuiService:GetSafeZoneOffsets() and 0 or GuiService:GetSafeZoneOffsets().bottom
	local v89 = not t1.isSmallScreen and 0 or math.max(v87, v88)

	if v57 then
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
				Visible = v64 == EnumStreamNotificationsDisplayState.MetaActions,
				BackgroundTransparency = v56.Theme.Overlay.Transparency,
				BackgroundColor3 = v56.Theme.Overlay.Color,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.Activated] = u68,
				BorderSizePixel = 0,
				Selectable = false
			}, { v84 }),
			NotificationsList = React.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 0, (t1.dropdownHeight or constants.Dropdown.MaxHeight) - constants.Dropdown.HeaderMinHeight - constants.Dropdown.HeaderBodyGap),
				CanvasSize = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = constants.Dropdown.ScrollBarThickness,
				BorderSizePixel = 0,
				VerticalScrollBarInset = Enum.ScrollBarInset.None,
				VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
				ScrollBarImageColor3 = v56.Theme.UIEmphasis.Color,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingEnabled = v64 == EnumStreamNotificationsDisplayState.Default,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				[React.Change.CanvasPosition] = v86,
				Selectable = false
			}, v85)
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
			Visible = v64 == EnumStreamNotificationsDisplayState.MetaActions,
			BackgroundTransparency = v56.Theme.Overlay.Transparency,
			BackgroundColor3 = v56.Theme.Overlay.Color,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2,
			[React.Event.Activated] = u68,
			BorderSizePixel = 0,
			Selectable = false
		}, { v84 }),
		NotificationsList = React.createElement("ScrollingFrame", {
			ref = if not FFlagStreamNotificationImpressionLogging then nil else v74,
			Size = UDim2.new(1, 0, 1, -(v77 + constants.DefaultPadding + v89)),
			CanvasSize = UDim2.new(1, 0, 1, -(v77 + constants.DefaultPadding + v89)),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, v77),
			AnchorPoint = Vector2.new(0, 0),
			ScrollBarThickness = 4,
			BorderSizePixel = 0,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
			ScrollBarImageColor3 = v56.Theme.UIEmphasis.Color,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingEnabled = v64 == EnumStreamNotificationsDisplayState.Default,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Change.CanvasPosition] = v86,
			Selectable = false
		}, v85),
		ImpressionTracker = if not FFlagStreamNotificationImpressionLogging then nil else React.createElement(FrameBoundsImpressionsTracker, {
			pageContext = nil,
			impressionsTag = "StreamNotificationImpression",
			parentRef = v74,
			scrollViewPositionChangedSignal = v75.current,
			sendImpressions = v81
		})
	})
end

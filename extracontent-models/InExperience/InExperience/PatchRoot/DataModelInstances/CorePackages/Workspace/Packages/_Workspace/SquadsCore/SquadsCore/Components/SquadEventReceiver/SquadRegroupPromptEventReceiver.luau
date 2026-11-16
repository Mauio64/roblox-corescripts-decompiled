local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

require(parent.RoduxSquads)
local React = require(parent.React)
local Dash = require(parent.Dash)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(parent.UserLib)
local Constants = UserLib2.Utils.Constants
local RealtimeDelivery = require(parent.RealtimeDelivery)
local NetworkingPresence = require(SquadsCore.Http.NetworkingPresence)
local Constants2 = require(SquadsCore.Common.Constants)
local Cryo = require(parent.Cryo)

local SocialExperiments = require(parent.SocialExperiments)
local SquadRegroupExperimentation = SocialExperiments.SquadRegroupExperimentation
local RoduxPresence = require(SquadsCore.Http.RoduxPresence)
local SquadExperienceInviteSource = require(SquadsCore.Enums.SquadExperienceInviteSource)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local EventNames = require(SquadsCore.Analytics.EventNames)
local PresenceType = RoduxPresence.Enums.PresenceType
local SquadRegroupEntryPoint = require(SquadsCore.Enums.SquadRegroupEntryPoint)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local RegroupPromptNotificationState = require(SquadsCore.Utils.RegroupPromptNotificationState)

local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)

local setRegroupPromptShown = require(SquadsCore.Thunks.setRegroupPromptShown)
local GetSquadExperienceInviteStore = require(SquadsCore.Stores.GetSquadExperienceInviteStore)
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local defineFastInt = game:DefineFastInt("SquadRegroupPromptDebounceTimeMs", 20000)

local FFlagSquadsPresenceStoreMigration = require(SquadsCore.Flags.FFlagSquadsPresenceStoreMigration)
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local DataHydration

if FFlagSquadsPresenceStoreMigration then
	DataHydration = require(parent.DataHydration)
end

local Signals

if FFlagSquadsPresenceStoreMigration then
	Signals = require(parent.Signals)
else
	Signals = nil
end

local SignalsReact

if FFlagSquadsPresenceStoreMigration then
	SignalsReact = require(parent.SignalsReact)
end

local v

if FFlagSquadsPresenceStoreMigration then
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local normalizePresenceRawData

if FFlagSquadsPresenceStoreMigration then
	normalizePresenceRawData = DataHydration.Presence.normalizePresenceRawData
else
	normalizePresenceRawData = nil
end

local presenceType

if FFlagSquadsPresenceStoreMigration then
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local useSignalState

if FFlagSquadsPresenceStoreMigration then
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

return function(p): nil
	local v2 = React.useContext(SquadExternalContractContext)
	local v3 = useLocalization({
		RegroupPromptTitle = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		RegroupPromptBody = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Dismiss = "Notifications.SquadRegroupPrompt.ToastAction.Dismiss",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})

	local v4 = useDispatch()
	local v5 = tonumber(useLocalUserId()) or 0

	local ref = React.useRef(false)

	local v6 = React.useMemo(function()
		return Cryo.List.map(p.currentSquadMembers, function(p2)
			return p2.userId
		end)
	end, { p.currentSquadMembers })

	local v7 = React.useMemo(function()
		local userIdSet = {}

		for _, currentSquadMember in ipairs(p.currentSquadMembers) do
			userIdSet[tostring(currentSquadMember.userId)] = true
		end

		return userIdSet
	end, { p.currentSquadMembers })
	local v8

	if FFlagSquadsPresenceStoreMigration then
		v8 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local result = {}

				for _, v9 in ipairs(v6) do
					local v10 = tostring(v9)
					result[v10] = v.GetPresenceByUserId(v10).data(p2)
				end

				return result
			end)
		end, { v6 })
	end

	local setState = nil
	local state

	if FFlagSquadsPresenceStoreMigration then
		state = useSignalState(v8)
	else
		state, setState = React.useState({})
	end

	local v9 = React.useCallback(function()
		if not FFlagSquadsPresenceStoreMigration then
			v4(NetworkingPresence.GetPresencesFromUserIds.API(v6)):andThen(function(p2)
				local userPresences = p2 and p2.responseBody and p2.responseBody.userPresences or {}
				local values = {}

				for _, userPresence in pairs(userPresences) do
					if userPresence.userId and userPresence.userPresenceType then
						values[tostring(userPresence.userId)] = Cryo.Dictionary.join(userPresence, {
							userPresenceType = PresenceType.fromRawValue(userPresence.userPresenceType)
						})
					end
				end

				setState(function(options)
					return Cryo.Dictionary.join(options or {}, values)
				end)
			end):catch(function(p2)
				Logger:warning(
					"SquadRegroupPromptEventReceiver: initial presence fetch failed. err={}",
					serializeTable(p2)
				)
			end)

			return
		end

		for _, v9 in ipairs(v6) do
			v.RefreshPresenceByUserId((tostring(v9)))
		end
	end, { v4, v6, v5 })

	local ref2 = React.useRef(true)
	React.useEffect(function()
		ref2.current = true

		v9()
		return function()
			ref2.current = false
		end
	end, {})

	local v10 = React.useCallback(function(p2)
		if p2.Squad and p2.Squad.Squad then
			return p2.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local current

	if not FFlagUseSignalsForSquadExperienceInvite then
		current = useSelector(v10)
	end

	local ref3 = React.useRef(nil)
	ref3.current = current

	local v11 = defineFastInt / 1000
	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = Dash.debounce(function(items, initiatorId, squadId, icon: string)
			if ref2.current and not ref.current then
				local v12

				if FFlagUseSignalsForSquadExperienceInvite then
					v12 = GetSquadExperienceInviteStore(false).getHasCurrentExperienceInvite(false)
				else
					v12 = ref3.current ~= nil
				end

				if not v12 then
					local item = items[tostring(initiatorId)]

					if item == nil then
						return
					end

					for _, item2 in pairs(items) do
						local v13

						if item2 then
							v13 = true
							local userPresenceType = item2.userPresenceType
							local v14

							if FFlagSquadsPresenceStoreMigration then
								v14 = presenceType.Online
							else
								v14 = PresenceType.Online
							end

							if userPresenceType ~= v14 then
								v13 = false
								local userPresenceType2 = item2.userPresenceType
								local v15

								if FFlagSquadsPresenceStoreMigration then
									v15 = presenceType.InGame
								else
									v15 = PresenceType.InGame
								end

								if userPresenceType2 == v15 then
									if
										item.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
										or item2.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
									then
										v13 = false
									else
										v13 = item.gameId ~= item2.gameId
									end
								end
							end
						else
							v13 = item2
						end

						if v13 then
							SquadRegroupExperimentation.logExposure()

							if not SquadRegroupExperimentation.getSquadRegroupEnabled() then
								return
							end

							local v14 = nil
							v14 = GuiService:SendNotification({
								Title = v3.RegroupPromptTitle,
								Text = v3.RegroupPromptBody,
								Icon = icon,
								Buttons = {
									{
										Text = v3.Dismiss,
										ButtonType = Enum.NotificationButtonType.Secondary,
										OnActivated = function()
											v2.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
												clientTimestamp = os.time(),
												squadId = squadId,
												initiatorId = initiatorId,
												gameInstanceId = item.gameId,
												rootPlaceId = item.rootPlaceId,
												placeId = item.placeId,
												universeId = item.universeId,
												playSessionId = RbxAnalyticsService:GetPlaySessionId(),
												button = SquadToastActionsAndStates.RegroupDismiss,
												entryPoint = SquadRegroupEntryPoint.ToastPrompt
											})

											RegroupPromptNotificationState.dismissNotification(v14)
											ref.current = false
										end
									},
									{
										Text = v3.Join,
										ButtonType = Enum.NotificationButtonType.Primary,
										OnActivated = function()
											local rootPlaceId = item.rootPlaceId

											if v2.createExperienceInvite == nil then
												Logger:warning("SquadRegroupEventReceiver: Join clicked but createExperienceInvite was not supplied in the external contract")
											elseif
												rootPlaceId == nil
												or FFlagSquadsPresenceStoreMigration and rootPlaceId == ""
											then
												Logger:warning(
													"SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence. localPresence={}",
													serializeTable(item)
												)
											else
												v4(v2.createExperienceInvite(
													tostring(rootPlaceId),
													SquadExperienceInviteSource.Regroup
												)):andThen(function(experienceInviteId)
													v2.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
														clientTimestamp = os.time(),
														squadId = squadId,
														initiatorId = initiatorId,
														gameInstanceId = item.gameId,
														rootPlaceId = item.rootPlaceId,
														placeId = item.placeId,
														universeId = item.universeId,
														playSessionId = RbxAnalyticsService:GetPlaySessionId(),
														experienceInviteId = experienceInviteId,
														button = SquadToastActionsAndStates.RegroupJoin,
														entryPoint = SquadRegroupEntryPoint.ToastPrompt
													})
												end):catch(function(p2)
													Logger:warning(
														"SquadRegroupEventReceiver: createExperienceInvite failed. err={}",
														serializeTable(p2)
													)
												end)
											end

											RegroupPromptNotificationState.dismissNotification(v14)
											ref.current = false
										end
									}
								}
							})

							ref.current = true
							RegroupPromptNotificationState.setActive(v14, squadId)
							v2.fireSquadAnalytics(EventNames.SquadRegroupPromptShown, {
								clientTimestamp = os.time(),
								squadId = squadId,
								initiatorId = initiatorId,
								gameInstanceId = item.gameId,
								rootPlaceId = item.rootPlaceId,
								placeId = item.placeId,
								universeId = item.universeId,
								playSessionId = RbxAnalyticsService:GetPlaySessionId(),
								entryPoint = SquadRegroupEntryPoint.ToastPrompt
							})

							if squadId then
								v4(setRegroupPromptShown(squadId))
							end

							return
						end
					end
				end
			end
		end, v11, { leading = false, trailing = true })
	end

	RealtimeDelivery.useRealtimeNamespace(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(list)
		if type(list) ~= "table" then
			return
		end

		local presenceReports = nil

		for _, item in ipairs(list) do
			local userId = item and item.UserId

			if userId == nil then
				continue
			end

			local v12 = tostring(userId)

			if not v7[v12] then
				continue
			end

			local presenceReport = item and item.PresenceReport

			if presenceReport == nil then
				continue
			end

			if FFlagSquadsPresenceStoreMigration then
				v.UpdateUserPresence(v12, normalizePresenceRawData(presenceReport), {
					isUpdatedRealtime = true
				})
			else
				presenceReport.userPresenceType = PresenceType.fromRawValue(presenceReport.userPresenceType)
				presenceReports = presenceReports or {}
				presenceReports[v12] = presenceReport
			end
		end

		if not FFlagSquadsPresenceStoreMigration and presenceReports ~= nil then
			setState(function(options)
				local clone = table.clone(options or {})

				for k, v12 in pairs(presenceReports) do
					clone[k] = v12
				end

				return clone
			end)
		end
	end, { v4, p.currentSquadId, v7 })

	RealtimeDelivery.useRealtimeConnectionStateChanged(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			Logger:info("Connection re-established, fetching squad presences.")
			v9()
		end
	end, { v9 })

	React.useEffect(function()
		if not ref.current then
			local v12 = state[tostring(v5)]
			local v13

			if FFlagSquadsPresenceStoreMigration then
				v13 = v12 and v12.universeId ~= "" and v12.universeId

				if not v13 then
					if v12 then
						v13 = v12.gameId ~= "" and v12.gameId or nil
					else
						v13 = nil
					end
				end
			elseif v12 then
				v13 = v12.universeId or v12.gameId or nil
			end

			local v14

			if v13 ~= nil then
				v14 = getRbxthumbWithTypeSizeAndOptions(tostring(v13), Constants.RbxthumbTypes.GameIcon, 128, false)
			end

			ref4.current(state, v5, p.currentSquadId, v14)
		end
	end, { state, v5, p.currentSquadId })

	return nil
end

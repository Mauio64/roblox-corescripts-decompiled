require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Dash")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Localization").Hooks.useLocalization
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId
local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserLib").Utils.Constants
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingPresence")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")

local squadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SocialExperiments").SquadRegroupExperimentation
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxPresence")
local SquadExperienceInviteSource = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadExperienceInviteSource")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
local presenceType = RoduxPresence.Enums.PresenceType
local SquadRegroupEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRegroupEntryPoint")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local RegroupPromptNotificationState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/RegroupPromptNotificationState")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")

local setRegroupPromptShown = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/setRegroupPromptShown")
local GetSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetSquadExperienceInviteStore")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local defineFastInt = game:DefineFastInt("SquadRegroupPromptDebounceTimeMs", 20000)

local FFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/FFlagSquadsPresenceStoreMigration")
local fFlagUseSignalsForSquadExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagUseSignalsForSquadExperienceInvite
local v5 = if FFlagSquadsPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/DataHydration") else nil
local v6 = if FFlagSquadsPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals") else nil
local v7 = if FFlagSquadsPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SignalsReact") else nil

local v8 = if FFlagSquadsPresenceStoreMigration then v5.Presence.PresenceStore.get() else nil

local normalizePresenceRawData = if FFlagSquadsPresenceStoreMigration then v5.Presence.normalizePresenceRawData else nil

local presenceType2 = if FFlagSquadsPresenceStoreMigration then v5.Presence.PresenceEnums.PresenceType else nil

local useSignalState = if FFlagSquadsPresenceStoreMigration then v7.useSignalState else nil

return function(p2): nil
	local v9 = React.useContext(SquadExternalContractContext)
	local v10 = useLocalization({
		RegroupPromptTitle = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		RegroupPromptBody = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Dismiss = "Notifications.SquadRegroupPrompt.ToastAction.Dismiss",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})

	local v11 = useDispatch()
	local v12 = tonumber(useLocalUserId()) or 0

	local ref = React.useRef(false)

	local v13 = React.useMemo(function()
		return Cryo.List.map(p2.currentSquadMembers, function(p3)
			return p3.userId
		end)
	end, { p2.currentSquadMembers })

	local v14 = React.useMemo(function()
		local userIdSet = {}

		for i, currentSquadMember in ipairs(p2.currentSquadMembers) do
			userIdSet[tostring(currentSquadMember.userId)] = true
		end

		return userIdSet
	end, { p2.currentSquadMembers })
	local v15

	if FFlagSquadsPresenceStoreMigration then
		v15 = React.useMemo(function()
			return v6.createComputed(function(p3)
				local result = {}

				for i, v16 in ipairs(v13) do
					local v17 = tostring(v16)
					result[v17] = v8.GetPresenceByUserId(v17).data(p3)
				end

				return result
			end)
		end, { v13 })
	end

	local setState = nil
	local state

	if FFlagSquadsPresenceStoreMigration then
		state = useSignalState(v15)
	else
		state, setState = React.useState({})
	end

	local v16 = React.useCallback(function()
		if not FFlagSquadsPresenceStoreMigration then
			v11(NetworkingPresence.GetPresencesFromUserIds.API(v13)):andThen(function(p3)
				local userPresences = p3 and p3.responseBody and p3.responseBody.userPresences or {}
				local values = {}

				for k, userPresence in pairs(userPresences) do
					if userPresence.userId and userPresence.userPresenceType then
						values[tostring(userPresence.userId)] = Cryo.Dictionary.join(userPresence, {
							userPresenceType = presenceType.fromRawValue(userPresence.userPresenceType)
						})
					end
				end

				setState(function(options)
					return Cryo.Dictionary.join(options or {}, values)
				end)
			end):catch(function(p3)
				Logger:warning(
					"SquadRegroupPromptEventReceiver: initial presence fetch failed. err={}",
					serializeTable(p3)
				)
			end)

			return
		end

		for i, v17 in ipairs(v13) do
			v8.RefreshPresenceByUserId((tostring(v17)))
		end
	end, { v11, v13, v12 })

	local ref2 = React.useRef(true)
	React.useEffect(function()
		ref2.current = true

		v16()
		return function()
			ref2.current = false
		end
	end, {})

	local v17 = React.useCallback(function(p3)
		if p3.Squad and p3.Squad.Squad then
			return p3.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})

	local v18 = if not fFlagUseSignalsForSquadExperienceInvite then useSelector(v17) else nil
	local ref3 = React.useRef(nil)
	ref3.current = v18

	local v19 = defineFastInt / 1000
	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = Dash.debounce(function(items, p3, p4, p5)
			if ref2.current and not ref.current then
				local v20

				if fFlagUseSignalsForSquadExperienceInvite then
					v20 = GetSquadExperienceInviteStore(false).getHasCurrentExperienceInvite(false)
				else
					v20 = ref3.current ~= nil
				end

				if not v20 then
					local item = items[tostring(p3)]

					if item == nil then
						return
					end

					for k, item2 in pairs(items) do
						local v21

						if item2 then
							v21 = true
							local userPresenceType = item2.userPresenceType

							local v22 = if FFlagSquadsPresenceStoreMigration then presenceType2.Online else presenceType.Online

							if userPresenceType ~= v22 then
								v21 = false
								local userPresenceType2 = item2.userPresenceType

								local v23 = if FFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame

								if userPresenceType2 == v23 then
									if
										item.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
										or item2.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
									then
										v21 = false
									else
										v21 = item.gameId ~= item2.gameId
									end
								end
							end
						else
							v21 = item2
						end

						if v21 then
							squadRegroupExperimentation.logExposure()

							if not squadRegroupExperimentation.getSquadRegroupEnabled() then
								return
							end

							local v22 = nil
							v22 = GuiService:SendNotification({
								Title = v10.RegroupPromptTitle,
								Text = v10.RegroupPromptBody,
								Icon = p5,
								Buttons = {
									{
										Text = v10.Dismiss,
										ButtonType = Enum.NotificationButtonType.Secondary,
										OnActivated = function()
											v9.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
												clientTimestamp = os.time(),
												squadId = p4,
												initiatorId = p3,
												gameInstanceId = item.gameId,
												rootPlaceId = item.rootPlaceId,
												placeId = item.placeId,
												universeId = item.universeId,
												playSessionId = RbxAnalyticsService:GetPlaySessionId(),
												button = SquadToastActionsAndStates.RegroupDismiss,
												entryPoint = SquadRegroupEntryPoint.ToastPrompt
											})

											RegroupPromptNotificationState.dismissNotification(v22)
											ref.current = false
										end
									},
									{
										Text = v10.Join,
										ButtonType = Enum.NotificationButtonType.Primary,
										OnActivated = function()
											local rootPlaceId = item.rootPlaceId

											if v9.createExperienceInvite == nil then
												Logger:warning("SquadRegroupEventReceiver: Join clicked but createExperienceInvite was not supplied in the external contract")
											elseif rootPlaceId == nil or FFlagSquadsPresenceStoreMigration and rootPlaceId == "" then
												Logger:warning(
													"SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence. localPresence={}",
													serializeTable(item)
												)
											else
												v11(v9.createExperienceInvite(
													tostring(rootPlaceId),
													SquadExperienceInviteSource.Regroup
												)):andThen(function(p6)
													v9.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
														clientTimestamp = os.time(),
														squadId = p4,
														initiatorId = p3,
														gameInstanceId = item.gameId,
														rootPlaceId = item.rootPlaceId,
														placeId = item.placeId,
														universeId = item.universeId,
														playSessionId = RbxAnalyticsService:GetPlaySessionId(),
														experienceInviteId = p6,
														button = SquadToastActionsAndStates.RegroupJoin,
														entryPoint = SquadRegroupEntryPoint.ToastPrompt
													})
												end):catch(function(p6)
													Logger:warning(
														"SquadRegroupEventReceiver: createExperienceInvite failed. err={}",
														serializeTable(p6)
													)
												end)
											end

											RegroupPromptNotificationState.dismissNotification(v22)
											ref.current = false
										end
									}
								}
							})

							ref.current = true
							RegroupPromptNotificationState.setActive(v22, p4)
							v9.fireSquadAnalytics(EventNames.SquadRegroupPromptShown, {
								clientTimestamp = os.time(),
								squadId = p4,
								initiatorId = p3,
								gameInstanceId = item.gameId,
								rootPlaceId = item.rootPlaceId,
								placeId = item.placeId,
								universeId = item.universeId,
								playSessionId = RbxAnalyticsService:GetPlaySessionId(),
								entryPoint = SquadRegroupEntryPoint.ToastPrompt
							})

							if p4 then
								v11(setRegroupPromptShown(p4))
							end

							return
						end
					end
				end
			end
		end, v19, { leading = false, trailing = true })
	end

	RealtimeDelivery.useRealtimeNamespace(Constants.PRESENCE_BULK_RTN_NAMESPACE, function(list)
		if type(list) ~= "table" then
			return
		end

		local presenceReports = nil

		for i, item in ipairs(list) do
			local userId = item and item.UserId

			if userId == nil then
				continue
			end

			local v20 = tostring(userId)

			if not v14[v20] then
				continue
			end

			local presenceReport = item and item.PresenceReport

			if presenceReport == nil then
				continue
			end

			if FFlagSquadsPresenceStoreMigration then
				v8.UpdateUserPresence(v20, normalizePresenceRawData(presenceReport), {
					isUpdatedRealtime = true
				})
			else
				presenceReport.userPresenceType = presenceType.fromRawValue(presenceReport.userPresenceType)
				presenceReports = presenceReports or {}
				presenceReports[v20] = presenceReport
			end
		end

		if not FFlagSquadsPresenceStoreMigration and presenceReports ~= nil then
			setState(function(options)
				local clone = table.clone(options or {})

				for k, v20 in pairs(presenceReports) do
					clone[k] = v20
				end

				return clone
			end)
		end
	end, { v11, p2.currentSquadId, v14 })

	RealtimeDelivery.useRealtimeConnectionStateChanged(Constants.PRESENCE_BULK_RTN_NAMESPACE, function(p3, p4)
		if p3 == Enum.ConnectionState.Connected and p4 then
			Logger:info("Connection re-established, fetching squad presences.")
			v16()
		end
	end, { v16 })

	React.useEffect(function()
		if not ref.current then
			local v20 = state[tostring(v12)]
			local v21

			if FFlagSquadsPresenceStoreMigration then
				v21 = v20 and v20.universeId ~= "" and v20.universeId

				if not v21 then
					v21 = if v20 then v20.gameId ~= "" and v20.gameId or nil else nil
				end
			elseif v20 then
				v21 = v20.universeId or v20.gameId or nil
			end

			local v22 = if v21 ~= nil then getRbxthumbWithTypeSizeAndOptions(
				tostring(v21),
				constants.RbxthumbTypes.GameIcon,
				128,
				false
			) else nil

			ref4.current(state, v12, p2.currentSquadId, v22)
		end
	end, { state, v12, p2.currentSquadId })

	return nil
end

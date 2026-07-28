local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent

require(SquadsCoreParent.RoduxSquads)

local React = require(SquadsCoreParent.React)
local Dash = require(SquadsCoreParent.Dash)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(SquadsCoreParent.Localization).Hooks.useLocalization
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local getRbxthumbWithTypeSizeAndOptions = require(SquadsCoreParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(SquadsCoreParent.UserLib).Utils.Constants
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local NetworkingPresence = require(SquadsCore.Http.NetworkingPresence)
local Constants2 = require(SquadsCore.Common.Constants)
local Cryo = require(SquadsCoreParent.Cryo)
local SquadRegroupExperimentation = require(SquadsCoreParent.SocialExperiments).SquadRegroupExperimentation
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
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v29 = game:DefineFastInt("SquadRegroupPromptDebounceTimeMs", 20000)
local FFlagSquadsPresenceStoreMigration = require(SquadsCore.Flags.FFlagSquadsPresenceStoreMigration)
local v31 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsCoreParent.DataHydration)
local v32 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsCoreParent.Signals)
local v33 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsCoreParent.SignalsReact)
local v34 = if not FFlagSquadsPresenceStoreMigration then nil else v31.Presence.PresenceStore.get()
local v35 = if not FFlagSquadsPresenceStoreMigration then nil else v31.Presence.normalizePresenceRawData
local v36 = if not FFlagSquadsPresenceStoreMigration then nil else v31.Presence.PresenceEnums.PresenceType
local v37 = if not FFlagSquadsPresenceStoreMigration then nil else v33.useSignalState

return function(t1: {[any]: any}) -- line: 58
	-- upvalues: React (copy), SquadExternalContractContext (copy), useLocalization (copy), useDispatch (copy), useLocalUserId (copy), Cryo (copy), FFlagSquadsPresenceStoreMigration (copy), v32 (copy), v34 (copy), v37 (copy), NetworkingPresence (copy), PresenceType (copy), Logger (copy), serializeTable (copy), useSelector (copy), v29 (copy), Dash (copy), v36 (copy), SquadRegroupExperimentation (copy), GuiService (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), SquadExperienceInviteSource (copy), setRegroupPromptShown (copy), RealtimeDelivery (copy), Constants2 (copy), v35 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	local v39 = React.useContext(SquadExternalContractContext)
	local v40 = useLocalization({
		RegroupPromptTitle = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		RegroupPromptBody = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Dismiss = "Notifications.SquadRegroupPrompt.ToastAction.Dismiss",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})
	local v41 = useDispatch()
	local v42 = tonumber(useLocalUserId()) or 0
	local v43 = React.useRef(false)
	local v44 = React.useMemo(function() -- line: 72
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.List.map(t1.currentSquadMembers, function(p1) -- line: 73
			return p1.userId
		end)
	end, { t1.currentSquadMembers })
	local v45 = React.useMemo(function() -- line: 78
		-- upvalues: t1 (copy)
		local t2 = {}

		for _, v in ipairs(t1.currentSquadMembers) do
			t2[tostring(v.userId)] = true
		end

		return t2
	end, { t1.currentSquadMembers })
	local v46 = if not FFlagSquadsPresenceStoreMigration then nil else React.useMemo(function() -- line: 89
		-- upvalues: v32 (copy), v44 (copy), v34 (copy)
		return v32.createComputed(function(p2) -- line: 90
			-- upvalues: v44 (copy), v34 (copy)
			local t3 = {}

			for _, v in ipairs(v44) do
				local str = tostring(v)

				t3[str] = v34.GetPresenceByUserId(str).data(p2)
			end

			return t3
		end)
	end, { v44 })
	local u47 = nil
	local u48

	if FFlagSquadsPresenceStoreMigration then
		u48 = v37(v46)
	else
		local v49, v50 = React.useState({})

		u48 = v49
		u47 = v50
	end

	local v51 = React.useCallback(function() -- line: 110
		-- upvalues: FFlagSquadsPresenceStoreMigration (copy), v44 (copy), v34 (copy), v41 (copy), NetworkingPresence (copy), Cryo (copy), PresenceType (copy), u47 (ref), Logger (copy), serializeTable (copy)
		if FFlagSquadsPresenceStoreMigration then
			for _, v in ipairs(v44) do
				v34.RefreshPresenceByUserId((tostring(v)))
			end

			return
		end

		v41(NetworkingPresence.GetPresencesFromUserIds.API(v44)):andThen(function(p3) -- line: 117
			-- upvalues: Cryo (copy), PresenceType (copy), u47 (ref)
			local v91 = p3 and (not not p3.responseBody and p3.responseBody.userPresences) or {}
			local t4 = {}

			for _, v in pairs(v91) do
				if v.userId and v.userPresenceType then
					t4[tostring(v.userId)] = Cryo.Dictionary.join(v, {
						userPresenceType = PresenceType.fromRawValue(v.userPresenceType)
					})
				end
			end

			u47(function(p4) -- line: 127
				-- upvalues: Cryo (copy), t4 (copy)
				return Cryo.Dictionary.join(p4 or {}, t4)
			end)
		end):catch(function(p5) -- line: 131
			-- upvalues: Logger (copy), serializeTable (copy)
			Logger:warning("SquadRegroupPromptEventReceiver: initial presence fetch failed. err={}", serializeTable(p5))
		end)
	end, {
		v41,
		v44,
		v42
	})
	local v52 = React.useRef(true)

	React.useEffect(function() -- line: 141
		-- upvalues: v52 (copy), v51 (copy)
		v52.current = true
		v51()

		return function() -- line: 145
			-- upvalues: v52 (copy)
			v52.current = false
		end
	end, {})

	local v53 = React.useCallback(function(p6) -- line: 150
		if p6.Squad and p6.Squad.Squad then
			return p6.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v54 = useSelector(v53)
	local v55 = React.useRef(nil)

	v55.current = v54

	local v56 = v29 / 1000
	local v57 = React.useRef(nil)

	if v57.current == nil then
		v57.current = Dash.debounce(function(t5: {[any]: any}, p7, p8, s1: string) -- line: 163
			-- upvalues: v52 (copy), v43 (copy), v55 (copy), FFlagSquadsPresenceStoreMigration (copy), v36 (copy), PresenceType (copy), SquadRegroupExperimentation (copy), GuiService (copy), v40 (copy), v39 (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), Logger (copy), serializeTable (copy), v41 (copy), SquadExperienceInviteSource (copy), setRegroupPromptShown (copy)
			if not v52.current or (v43.current or v55.current ~= nil) then
				return
			end

			local v68 = t5[tostring(p7)]

			if v68 == nil then
				return
			end

			for _, v in pairs(t5) do
				if v and (v.userPresenceType == (if not FFlagSquadsPresenceStoreMigration then PresenceType.Online else v36.Online) or v.userPresenceType == (if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v36.InGame) and (v68.gameId ~= (if not FFlagSquadsPresenceStoreMigration then nil else "") and (v.gameId ~= (if not FFlagSquadsPresenceStoreMigration then nil else "") and v68.gameId ~= v.gameId))) then
					SquadRegroupExperimentation.logExposure()

					if not SquadRegroupExperimentation.getSquadRegroupEnabled() then
						return
					end

					local u71 = nil

					u71 = GuiService:SendNotification({
						Title = v40.RegroupPromptTitle,
						Text = v40.RegroupPromptBody,
						Icon = s1,
						Buttons = {
							{
								Text = v40.Dismiss,
								ButtonType = Enum.NotificationButtonType.Secondary,
								OnActivated = function() -- line: 215
									-- upvalues: v39 (copy), EventNames (copy), p8 (copy), p7 (copy), v68 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), u71 (ref), v43 (copy)
									v39.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
										clientTimestamp = os.time(),
										squadId = p8,
										initiatorId = p7,
										gameInstanceId = v68.gameId,
										rootPlaceId = v68.rootPlaceId,
										placeId = v68.placeId,
										universeId = v68.universeId,
										playSessionId = RbxAnalyticsService:GetPlaySessionId(),
										button = SquadToastActionsAndStates.RegroupDismiss,
										entryPoint = SquadRegroupEntryPoint.ToastPrompt
									})
									RegroupPromptNotificationState.dismissNotification(u71)
									v43.current = false
								end
							},
							{
								Text = v40.Join,
								ButtonType = Enum.NotificationButtonType.Primary,
								OnActivated = function() -- line: 235
									-- upvalues: v68 (copy), v39 (copy), Logger (copy), FFlagSquadsPresenceStoreMigration (copy), serializeTable (copy), v41 (copy), SquadExperienceInviteSource (copy), EventNames (copy), p8 (copy), p7 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), u71 (ref), v43 (copy)
									local rootPlaceId = v68.rootPlaceId

									if v39.createExperienceInvite == nil then
										Logger:warning("SquadRegroupEventReceiver: Join clicked but createExperienceInvite was not supplied in the external contract")
									elseif rootPlaceId == nil or FFlagSquadsPresenceStoreMigration and rootPlaceId == "" then
										Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence. localPresence={}", serializeTable(v68))
									else
										v41(v39.createExperienceInvite(tostring(rootPlaceId), SquadExperienceInviteSource.Regroup)):andThen(function(p9) -- line: 256
											-- upvalues: v39 (copy), EventNames (copy), p8 (copy), p7 (copy), v68 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
											v39.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
												clientTimestamp = os.time(),
												squadId = p8,
												initiatorId = p7,
												gameInstanceId = v68.gameId,
												rootPlaceId = v68.rootPlaceId,
												placeId = v68.placeId,
												universeId = v68.universeId,
												playSessionId = RbxAnalyticsService:GetPlaySessionId(),
												experienceInviteId = p9,
												button = SquadToastActionsAndStates.RegroupJoin,
												entryPoint = SquadRegroupEntryPoint.ToastPrompt
											})
										end):catch(function(p10) -- line: 274
											-- upvalues: Logger (copy), serializeTable (copy)
											Logger:warning("SquadRegroupEventReceiver: createExperienceInvite failed. err={}", serializeTable(p10))
										end)
									end

									RegroupPromptNotificationState.dismissNotification(u71)
									v43.current = false
								end
							}
						}
					})
					v43.current = true
					RegroupPromptNotificationState.setActive(u71, p8)
					v39.fireSquadAnalytics(EventNames.SquadRegroupPromptShown, {
						clientTimestamp = os.time(),
						squadId = p8,
						initiatorId = p7,
						gameInstanceId = v68.gameId,
						rootPlaceId = v68.rootPlaceId,
						placeId = v68.placeId,
						universeId = v68.universeId,
						playSessionId = RbxAnalyticsService:GetPlaySessionId(),
						entryPoint = SquadRegroupEntryPoint.ToastPrompt
					})

					if p8 then
						v41(setRegroupPromptShown(p8))
					end

					return
				end
			end
		end, v56, {
			leading = false,
			trailing = true
		})
	end

	RealtimeDelivery.useRealtimeNamespace(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(p11) -- line: 318
		-- upvalues: v45 (copy), FFlagSquadsPresenceStoreMigration (copy), v34 (copy), v35 (copy), PresenceType (copy), u47 (ref)
		if type(p11) ~= "table" then
			return
		end

		local u73 = nil

		for _, v in ipairs(p11) do
			local v76 = v and v.UserId

			if v76 ~= nil then
				local str = tostring(v76)

				if v45[str] then
					local v78 = v and v.PresenceReport

					if v78 ~= nil then
						if FFlagSquadsPresenceStoreMigration then
							v34.UpdateUserPresence(str, v35(v78), {
								isUpdatedRealtime = true
							})
						else
							v78.userPresenceType = PresenceType.fromRawValue(v78.userPresenceType)
							u73 = u73 or {}
							u73[str] = v78
						end
					end
				end
			end
		end

		if not FFlagSquadsPresenceStoreMigration and u73 ~= nil then
			u47(function(p12) -- line: 350
				-- upvalues: u73 (ref)
				local v98 = table.clone(p12 or {})

				for k, v in pairs(u73) do
					v98[k] = v
				end

				return v98
			end)
		end
	end, {
		v41,
		t1.currentSquadId,
		v45
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(p13, p14) -- line: 363
		-- upvalues: Logger (copy), v51 (copy)
		if p13 == Enum.ConnectionState.Connected and p14 then
			Logger:info("Connection re-established, fetching squad presences.")
			v51()
		end
	end, { v51 })
	React.useEffect(function() -- line: 372
		-- upvalues: v43 (copy), u48 (ref), v42 (copy), FFlagSquadsPresenceStoreMigration (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), v57 (copy), t1 (copy)
		if not v43.current then
			local v81 = u48[tostring(v42)]
			local v82 = if not FFlagSquadsPresenceStoreMigration then v81 and (v81.universeId or v81.gameId) or nil else v81 and (v81.universeId ~= "" and v81.universeId) or (v81 and (v81.gameId ~= "" and v81.gameId) or nil)
			local v83 = if v82 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v82), Constants.RbxthumbTypes.GameIcon, 128, false)

			v57.current(u48, v42, t1.currentSquadId, v83)
		end
	end, {
		u48,
		v42,
		t1.currentSquadId
	})

	return nil
end

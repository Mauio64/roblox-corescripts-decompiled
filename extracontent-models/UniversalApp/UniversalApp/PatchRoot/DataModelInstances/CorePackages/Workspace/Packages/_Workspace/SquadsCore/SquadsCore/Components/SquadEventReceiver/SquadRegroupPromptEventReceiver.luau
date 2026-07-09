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

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), SquadExternalContractContext (copy), useLocalization (copy), useDispatch (copy), useLocalUserId (copy), Cryo (copy), NetworkingPresence (copy), PresenceType (copy), Logger (copy), serializeTable (copy), useSelector (copy), v29 (copy), Dash (copy), SquadRegroupExperimentation (copy), GuiService (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), SquadExperienceInviteSource (copy), setRegroupPromptShown (copy), RealtimeDelivery (copy), Constants2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	local v31 = React.useContext(SquadExternalContractContext)
	local v32 = useLocalization({
		RegroupPromptTitle = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		RegroupPromptBody = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Dismiss = "Notifications.SquadRegroupPrompt.ToastAction.Dismiss",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})
	local v33 = useDispatch()
	local v34 = tonumber(useLocalUserId()) or 0
	local v35 = React.useRef(false)
	local v36 = React.useMemo(function() -- line: 57
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.List.map(t1.currentSquadMembers, function(p1) -- line: 58
			return p1.userId
		end)
	end, { t1.currentSquadMembers })
	local v37, v38 = React.useState({})
	local v39 = React.useMemo(function() -- line: 64
		-- upvalues: t1 (copy)
		local t2 = {}

		for _, v in ipairs(t1.currentSquadMembers) do
			t2[tostring(v.userId)] = true
		end

		return t2
	end, { t1.currentSquadMembers })
	local v40 = React.useCallback(function() -- line: 73
		-- upvalues: v33 (copy), NetworkingPresence (copy), v36 (copy), Cryo (copy), PresenceType (copy), v38 (copy), Logger (copy), serializeTable (copy)
		v33(NetworkingPresence.GetPresencesFromUserIds.API(v36)):andThen(function(p2) -- line: 75
			-- upvalues: Cryo (copy), PresenceType (copy), v38 (copy)
			local v73 = p2 and (not not p2.responseBody and p2.responseBody.userPresences) or {}
			local t3 = {}

			for _, v in pairs(v73) do
				if v.userId and v.userPresenceType then
					t3[tostring(v.userId)] = Cryo.Dictionary.join(v, {
						userPresenceType = PresenceType.fromRawValue(v.userPresenceType)
					})
				end
			end

			v38(function(p3) -- line: 85
				-- upvalues: Cryo (copy), t3 (copy)
				return Cryo.Dictionary.join(p3 or {}, t3)
			end)
		end):catch(function(p4) -- line: 89
			-- upvalues: Logger (copy), serializeTable (copy)
			Logger:warning("SquadRegroupPromptEventReceiver: initial presence fetch failed. err={}", serializeTable(p4))
		end)
	end, {
		v33,
		v36,
		v34
	})
	local v41 = React.useRef(true)

	React.useEffect(function() -- line: 98
		-- upvalues: v41 (copy), v40 (copy)
		v41.current = true
		v40()

		return function() -- line: 102
			-- upvalues: v41 (copy)
			v41.current = false
		end
	end, {})

	local v42 = React.useCallback(function(p5) -- line: 107
		if p5.Squad and p5.Squad.Squad then
			return p5.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v43 = useSelector(v42)
	local v44 = React.useRef(nil)

	v44.current = v43

	local v45 = v29 / 1000
	local v46 = React.useRef(nil)

	if v46.current == nil then
		v46.current = Dash.debounce(function(t4: {[any]: any}, p6, p7, s1: string) -- line: 120
			-- upvalues: v41 (copy), v35 (copy), v44 (copy), PresenceType (copy), SquadRegroupExperimentation (copy), GuiService (copy), v32 (copy), v31 (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), Logger (copy), serializeTable (copy), v33 (copy), SquadExperienceInviteSource (copy), setRegroupPromptShown (copy)
			if not v41.current or (v35.current or v44.current ~= nil) then
				return
			end

			local v55 = t4[tostring(p6)]

			if v55 == nil then
				return
			end

			for _, v in pairs(t4) do
				if v and (v.userPresenceType == PresenceType.Online or v.userPresenceType == PresenceType.InGame and (v55.gameId ~= nil and (v.gameId ~= nil and v55.gameId ~= v.gameId))) then
					SquadRegroupExperimentation.logExposure()

					if not SquadRegroupExperimentation.getSquadRegroupEnabled() then
						return
					end

					local u58 = nil

					u58 = GuiService:SendNotification({
						Title = v32.RegroupPromptTitle,
						Text = v32.RegroupPromptBody,
						Icon = s1,
						Buttons = {
							{
								Text = v32.Dismiss,
								ButtonType = Enum.NotificationButtonType.Secondary,
								OnActivated = function() -- line: 166
									-- upvalues: v31 (copy), EventNames (copy), p7 (copy), p6 (copy), v55 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), u58 (ref), v35 (copy)
									v31.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
										clientTimestamp = os.time(),
										squadId = p7,
										initiatorId = p6,
										gameInstanceId = v55.gameId,
										rootPlaceId = v55.rootPlaceId,
										placeId = v55.placeId,
										universeId = v55.universeId,
										playSessionId = RbxAnalyticsService:GetPlaySessionId(),
										button = SquadToastActionsAndStates.RegroupDismiss,
										entryPoint = SquadRegroupEntryPoint.ToastPrompt
									})
									RegroupPromptNotificationState.dismissNotification(u58)
									v35.current = false
								end
							},
							{
								Text = v32.Join,
								ButtonType = Enum.NotificationButtonType.Primary,
								OnActivated = function() -- line: 186
									-- upvalues: v55 (copy), v31 (copy), Logger (copy), serializeTable (copy), v33 (copy), SquadExperienceInviteSource (copy), EventNames (copy), p7 (copy), p6 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy), RegroupPromptNotificationState (copy), u58 (ref), v35 (copy)
									local rootPlaceId = v55.rootPlaceId

									if v31.createExperienceInvite == nil then
										Logger:warning("SquadRegroupEventReceiver: Join clicked but createExperienceInvite was not supplied in the external contract")
									elseif rootPlaceId == nil then
										Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence. localPresence={}", serializeTable(v55))
									else
										v33(v31.createExperienceInvite(tostring(rootPlaceId), SquadExperienceInviteSource.Regroup)):andThen(function(p8) -- line: 204
											-- upvalues: v31 (copy), EventNames (copy), p7 (copy), p6 (copy), v55 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
											v31.fireSquadAnalytics(EventNames.SquadRegroupPromptClicked, {
												clientTimestamp = os.time(),
												squadId = p7,
												initiatorId = p6,
												gameInstanceId = v55.gameId,
												rootPlaceId = v55.rootPlaceId,
												placeId = v55.placeId,
												universeId = v55.universeId,
												playSessionId = RbxAnalyticsService:GetPlaySessionId(),
												experienceInviteId = p8,
												button = SquadToastActionsAndStates.RegroupJoin,
												entryPoint = SquadRegroupEntryPoint.ToastPrompt
											})
										end):catch(function(p9) -- line: 222
											-- upvalues: Logger (copy), serializeTable (copy)
											Logger:warning("SquadRegroupEventReceiver: createExperienceInvite failed. err={}", serializeTable(p9))
										end)
									end

									RegroupPromptNotificationState.dismissNotification(u58)
									v35.current = false
								end
							}
						}
					})
					v35.current = true
					RegroupPromptNotificationState.setActive(u58, p7)
					v31.fireSquadAnalytics(EventNames.SquadRegroupPromptShown, {
						clientTimestamp = os.time(),
						squadId = p7,
						initiatorId = p6,
						gameInstanceId = v55.gameId,
						rootPlaceId = v55.rootPlaceId,
						placeId = v55.placeId,
						universeId = v55.universeId,
						playSessionId = RbxAnalyticsService:GetPlaySessionId(),
						entryPoint = SquadRegroupEntryPoint.ToastPrompt
					})

					if p7 then
						v33(setRegroupPromptShown(p7))
					end

					return
				end
			end
		end, v45, {
			leading = false,
			trailing = true
		})
	end

	RealtimeDelivery.useRealtimeNamespace(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(p10) -- line: 266
		-- upvalues: v39 (copy), PresenceType (copy), v38 (copy)
		if type(p10) ~= "table" then
			return
		end

		local u60 = nil

		for _, v in ipairs(p10) do
			local v63 = v and v.UserId

			if v63 ~= nil then
				local str = tostring(v63)

				if v39[str] then
					local v65 = v and v.PresenceReport

					if v65 ~= nil then
						v65.userPresenceType = PresenceType.fromRawValue(v65.userPresenceType)
						u60 = u60 or {}
						u60[str] = v65
					end
				end
			end
		end

		if u60 ~= nil then
			v38(function(p11) -- line: 290
				-- upvalues: u60 (ref)
				local v80 = table.clone(p11 or {})

				for k, v in pairs(u60) do
					v80[k] = v
				end

				return v80
			end)
		end
	end, {
		v33,
		t1.currentSquadId,
		v39
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged(Constants2.PRESENCE_BULK_RTN_NAMESPACE, function(p12, p13) -- line: 303
		-- upvalues: Logger (copy), v40 (copy)
		if p12 == Enum.ConnectionState.Connected and p13 then
			Logger:info("Connection re-established, fetching squad presences.")
			v40()
		end
	end, { v40 })
	React.useEffect(function() -- line: 312
		-- upvalues: v35 (copy), v37 (copy), v34 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), v46 (copy), t1 (copy)
		if not v35.current then
			local v68 = v37[tostring(v34)]
			local v69 = v68 and (v68.universeId or v68.gameId) or nil
			local v70 = if v69 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v69), Constants.RbxthumbTypes.GameIcon, 128, false)

			v46.current(v37, v34, t1.currentSquadId, v70)
		end
	end, {
		v37,
		v34,
		t1.currentSquadId
	})

	return nil
end

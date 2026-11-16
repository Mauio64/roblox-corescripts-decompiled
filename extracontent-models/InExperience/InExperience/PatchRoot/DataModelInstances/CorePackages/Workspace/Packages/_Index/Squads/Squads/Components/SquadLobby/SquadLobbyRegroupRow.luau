local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local Logger = require(Squads.Logger)
local dependencies = require(Squads.dependencies)
local react = dependencies.React
local foundation = dependencies.Foundation
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local buttonSize = foundation.Enums.ButtonSize
local buttonVariant = foundation.Enums.ButtonVariant
local image = foundation.Image
local Enums = require(parent.SquadsCore.Enums)

local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(parent.UserLib)
local Constants = UserLib2.Utils.Constants

local CreateExperienceInvite = require(Squads.Thunks.CreateExperienceInvite)
local Hooks2 = require(parent.SquadsCore.Hooks)
local useIsExperienceInviteRetryBlocked = Hooks2.useIsExperienceInviteRetryBlocked

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)
local SquadToastActionsAndStates = Enums.SquadToastActionsAndStates
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local SquadRegroupEntryPoint = Enums.SquadRegroupEntryPoint

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local defineFastFlag = game:DefineFastFlag("RegroupTextTruncationFix", false)
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)
local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local Stores = require(parent.SquadsCore.Stores)
local GetSquadExperienceInviteStore = Stores.GetSquadExperienceInviteStore
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local function SquadLobbyRegroupRow(p)
	local v = useDispatch()
	local v2 = react.useContext(SquadExternalContractContext)
	local v3 = useLocalization({
		Title = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		Body = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})

	local v4 = react.useCallback(function(p2)
		return p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentExperienceInvite
	end, {})
	local v5

	if fFlagUseSignalsForSquadExperienceInvite then
		v5 = useSignalState(GetSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
	else
		v5 = useSelector(v4) ~= nil
	end

	local squadId = useCurrentSquadId()
	local v6 = useIsExperienceInviteRetryBlocked(squadId)

	local v7 = react.useCallback(function(p2)
		return p2
			and p2.Squad
			and p2.Squad.Presence
			and p2.Squad.Presence.byUserId
			and p2.Squad.Presence.byUserId[tostring(p.localUserId)]
	end, { p.localUserId })
	local v8

	if FFlagSquadsPresenceStoreMigration then
		v8 = useGetPresenceByUserId((tostring(p.localUserId)))
	else
		v8 = useSelector(v7)
	end

	local rootPlaceId

	if FFlagSquadsPresenceStoreMigration then
		if v8 and v8.rootPlaceId ~= "" then
			rootPlaceId = v8.rootPlaceId
		else
			rootPlaceId = nil
		end
	elseif v8 then
		rootPlaceId = v8.rootPlaceId or nil
	else
		rootPlaceId = nil
	end

	local v9

	if FFlagSquadsPresenceStoreMigration then
		if v8 and v8.universeId ~= "" then
			v9 = v8.universeId
		elseif v8 and v8.gameId ~= "" then
			v9 = v8.gameId
		end
	elseif v8 then
		v9 = v8.universeId or v8.gameId or nil
	end

	local image2

	if v9 ~= nil then
		image2 = getRbxthumbWithTypeSizeAndOptions(tostring(v9), Constants.RbxthumbTypes.GameIcon, 150, false)
	end

	local createElement = react.createElement
	local view = foundation.View
	local thumbnail

	if image2 then
		thumbnail = react.createElement(image, {
			tag = "radius-small bg-surface-100 size-1000",
			LayoutOrder = 1,
			Image = image2,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--thumbnail" or nil
		})
	end

	return createElement(view, {
		tag = "align-y-center row auto-none size-full radius-medium gap-medium gui-object-defaults padding-x-xlarge padding-y-medium",
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row" or nil
	}, {
		Thumbnail = thumbnail,
		TextContainer = react.createElement(
			foundation.View,
			{ tag = "auto-y fill col gap-xsmall align-x-left gui-object-defaults", LayoutOrder = 2 },
			{
				Title = react.createElement(foundation.Text, {
					tag = {
						["auto-y text-align-x-left text-no-wrap text-title-medium content-emphasis"] = true,
						["size-full-0 text-truncate-end"] = defineFastFlag
					},
					LayoutOrder = 1,
					Text = v3.Title,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--title" or nil
				}),
				Body = react.createElement(foundation.Text, {
					tag = {
						["auto-y content-default text-body-medium text-align-x-left text-no-wrap gui-object-defaults"] = true,
						["size-full-0 text-truncate-end"] = defineFastFlag
					},
					LayoutOrder = 2,
					Text = v3.Body,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--body" or nil
				})
			}
		),
		JoinButton = react.createElement(foundation.Button, {
			LayoutOrder = 3,
			text = v3.Join,
			size = buttonSize.Medium,
			variant = buttonVariant.Standard,
			isDisabled = v5 or v6,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--join-button" or nil,
			onActivated = react.useCallback(function()
				if rootPlaceId == nil then
					Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence")
				else
					v(CreateExperienceInvite(tostring(rootPlaceId), v2, SquadExperienceInviteSource.Regroup)):andThen(function(experienceInviteId)
						local fireSquadAnalytics = v2.fireSquadAnalytics
						local squadRegroupButtonClicked = EventNames.SquadRegroupButtonClicked
						local v10 = {
							clientTimestamp = os.time(),
							squadId = squadId,
							initiatorId = p.localUserId,
							gameInstanceId = 0,
							rootPlaceId = 0,
							placeId = 0,
							universeId = 0,
							playSessionId = 0,
							experienceInviteId = 0,
							button = 0,
							entryPoint = 0
						}
						local gameInstanceId

						if FFlagSquadsPresenceStoreMigration then
							gameInstanceId = v8 and v8.gameId
						else
							gameInstanceId = v8.gameId
						end

						v10.gameInstanceId = gameInstanceId
						local rootPlaceId2

						if FFlagSquadsPresenceStoreMigration then
							rootPlaceId2 = v8 and v8.rootPlaceId
						else
							rootPlaceId2 = v8.rootPlaceId
						end

						v10.rootPlaceId = rootPlaceId2
						local placeId

						if FFlagSquadsPresenceStoreMigration then
							placeId = v8 and v8.placeId
						else
							placeId = v8.placeId
						end

						v10.placeId = placeId
						local universeId

						if FFlagSquadsPresenceStoreMigration then
							universeId = v8 and v8.universeId
						else
							universeId = v8.universeId
						end

						v10.universeId = universeId

						v10.playSessionId = RbxAnalyticsService:GetPlaySessionId()
						v10.experienceInviteId = experienceInviteId
						v10.button = SquadToastActionsAndStates.RegroupJoin
						v10.entryPoint = SquadRegroupEntryPoint.SquadLobbyButton
						fireSquadAnalytics(squadRegroupButtonClicked, v10)
					end)
				end
			end, { v, CreateExperienceInvite, rootPlaceId, v2, squadId, p.localUserId, v8 })
		})
	})
end

return SquadLobbyRegroupRow

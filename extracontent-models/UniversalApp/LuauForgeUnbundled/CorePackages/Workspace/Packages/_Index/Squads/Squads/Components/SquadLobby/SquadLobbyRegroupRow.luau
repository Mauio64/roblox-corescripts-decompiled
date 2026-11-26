local Logger = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Logger")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local react = dependencies.React
local foundation = dependencies.Foundation
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadId
local buttonSize = foundation.Enums.ButtonSize
local buttonVariant = foundation.Enums.ButtonVariant
local image = foundation.Image
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums")

local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.Constants

local CreateExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/CreateExperienceInvite")
local useIsExperienceInviteRetryBlocked = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useIsExperienceInviteRetryBlocked

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadToastActionsAndStates = Enums.SquadToastActionsAndStates
local squadExperienceInviteSource = Enums.SquadExperienceInviteSource
local squadRegroupEntryPoint = Enums.SquadRegroupEntryPoint

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local defineFastFlag = game:DefineFastFlag("RegroupTextTruncationFix", false)
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local getSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetSquadExperienceInviteStore
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SignalsReact").useSignalState
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local function SquadLobbyRegroupRow(p2)
	local v5 = useDispatch()
	local v6 = react.useContext(squadExternalContractContext)
	local v7 = useLocalization({
		Title = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		Body = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})

	local v8 = react.useCallback(function(p3)
		return p3.Squad and p3.Squad.Squad and p3.Squad.Squad.currentExperienceInvite
	end, {})
	local v9

	if fFlagUseSignalsForSquadExperienceInvite then
		v9 = useSignalState(getSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
	else
		v9 = useSelector(v8) ~= nil
	end

	local v10 = useCurrentSquadId()
	local v11 = useIsExperienceInviteRetryBlocked(v10)

	local v12 = react.useCallback(function(p3)
		return p3
			and p3.Squad
			and p3.Squad.Presence
			and p3.Squad.Presence.byUserId
			and p3.Squad.Presence.byUserId[tostring(p2.localUserId)]
	end, { p2.localUserId })
	local v13

	if fFlagSquadsPresenceStoreMigration then
		v13 = useGetPresenceByUserId((tostring(p2.localUserId)))
	else
		v13 = useSelector(v12)
	end

	local rootPlaceId

	if fFlagSquadsPresenceStoreMigration then
		rootPlaceId = if v13 and v13.rootPlaceId ~= "" then v13.rootPlaceId else nil
	else
		rootPlaceId = if v13 then v13.rootPlaceId or nil else nil
	end

	local v14

	if fFlagSquadsPresenceStoreMigration then
		if v13 and v13.universeId ~= "" then
			v14 = v13.universeId
		elseif v13 and v13.gameId ~= "" then
			v14 = v13.gameId
		end
	elseif v13 then
		v14 = v13.universeId or v13.gameId or nil
	end

	local v15

	if v14 ~= nil then
		v15 = getRbxthumbWithTypeSizeAndOptions(tostring(v14), constants.RbxthumbTypes.GameIcon, 150, false)
	end

	local createElement = react.createElement
	local view = foundation.View

	local v17 = if v15 then react.createElement(image, {
		tag = "radius-small bg-surface-100 size-1000",
		LayoutOrder = 1,
		Image = v15,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--thumbnail" or nil
	}) else nil
	return createElement(view, {
		tag = "align-y-center row auto-none size-full radius-medium gap-medium gui-object-defaults padding-x-xlarge padding-y-medium",
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row" or nil
	}, {
		Thumbnail = v17,
		TextContainer = react.createElement(
			foundation.View,
			{
				tag = "auto-y fill col gap-xsmall align-x-left gui-object-defaults",
				LayoutOrder = 2
			},
			{
				Title = react.createElement(foundation.Text, {
					tag = {
						["auto-y text-align-x-left text-no-wrap text-title-medium content-emphasis"] = true,
						["size-full-0 text-truncate-end"] = defineFastFlag
					},
					LayoutOrder = 1,
					Text = v7.Title,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--title" or nil
				}),
				Body = react.createElement(foundation.Text, {
					tag = {
						["auto-y content-default text-body-medium text-align-x-left text-no-wrap gui-object-defaults"] = true,
						["size-full-0 text-truncate-end"] = defineFastFlag
					},
					LayoutOrder = 2,
					Text = v7.Body,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--body" or nil
				})
			}
		),
		JoinButton = react.createElement(foundation.Button, {
			LayoutOrder = 3,
			text = v7.Join,
			size = buttonSize.Medium,
			variant = buttonVariant.Standard,
			isDisabled = v9 or v11,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-regroup-row--join-button" or nil,
			onActivated = react.useCallback(function()
				if rootPlaceId == nil then
					Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence")
				else
					v5(CreateExperienceInvite(tostring(rootPlaceId), v6, squadExperienceInviteSource.Regroup)):andThen(function(experienceInviteId)
						local fireSquadAnalytics = v6.fireSquadAnalytics
						local squadRegroupButtonClicked = EventNames.SquadRegroupButtonClicked
						local v18 = {
							clientTimestamp = os.time(),
							squadId = v10,
							initiatorId = p2.localUserId,
							gameInstanceId = 0,
							rootPlaceId = 0,
							placeId = 0,
							universeId = 0,
							playSessionId = 0,
							experienceInviteId = 0,
							button = 0,
							entryPoint = 0
						}

						local v19 = if fFlagSquadsPresenceStoreMigration then v13 and v13.gameId else v13.gameId
						v18.gameInstanceId = v19

						local v20 = if fFlagSquadsPresenceStoreMigration then v13 and v13.rootPlaceId else v13.rootPlaceId
						v18.rootPlaceId = v20

						local v21 = if fFlagSquadsPresenceStoreMigration then v13 and v13.placeId else v13.placeId
						v18.placeId = v21

						local v22 = if fFlagSquadsPresenceStoreMigration then v13 and v13.universeId else v13.universeId
						v18.universeId = v22

						v18.playSessionId = RbxAnalyticsService:GetPlaySessionId()
						v18.experienceInviteId = experienceInviteId
						v18.button = squadToastActionsAndStates.RegroupJoin
						v18.entryPoint = squadRegroupEntryPoint.SquadLobbyButton
						fireSquadAnalytics(squadRegroupButtonClicked, v18)
					end)
				end
			end, { v5, CreateExperienceInvite, rootPlaceId, v6, v10, p2.localUserId, v13 })
		})
	})
end

return SquadLobbyRegroupRow

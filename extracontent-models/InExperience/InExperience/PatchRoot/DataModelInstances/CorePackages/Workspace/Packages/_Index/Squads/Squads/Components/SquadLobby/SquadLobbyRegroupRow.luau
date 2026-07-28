local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Logger = require(Squads.Logger)
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useCurrentSquadId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadId
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FoundationImage = Foundation.Image
local Enums = require(SquadsParent.SquadsCore.Enums)
local getRbxthumbWithTypeSizeAndOptions = require(SquadsParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(SquadsParent.UserLib).Utils.Constants
local CreateExperienceInvite = require(Squads.Thunks.CreateExperienceInvite)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadToastActionsAndStates = Enums.SquadToastActionsAndStates
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local SquadRegroupEntryPoint = Enums.SquadRegroupEntryPoint
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v24 = game:DefineFastFlag("RegroupTextTruncationFix", false)
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local v26 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.FriendsCommon).Hooks.useGetPresenceByUserId

local function SquadLobbyRegroupRow(t1: {[any]: any}) -- line: 39
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), useLocalization (copy), useSelector (copy), useCurrentSquadId (copy), FFlagSquadsPresenceStoreMigration (copy), v26 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Foundation (copy), FoundationImage (copy), v24 (copy), ButtonSize (copy), ButtonVariant (copy), Logger (copy), CreateExperienceInvite (copy), SquadExperienceInviteSource (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
	local v29 = useDispatch()
	local v30 = React.useContext(SquadExternalContractContext)
	local v31 = useLocalization({
		Title = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		Body = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})
	local v32 = React.useCallback(function(p1) -- line: 48
		return p1.Squad and (p1.Squad.Squad and p1.Squad.Squad.currentExperienceInvite)
	end, {})
	local v33 = useSelector(v32)
	local v34 = useCurrentSquadId()
	local v35 = React.useCallback(function(p2) -- line: 54
		-- upvalues: t1 (copy)
		return p2 and (p2.Squad and (p2.Squad.Presence and (p2.Squad.Presence.byUserId and p2.Squad.Presence.byUserId[tostring(t1.localUserId)])))
	end, { t1.localUserId })
	local v36 = if not FFlagSquadsPresenceStoreMigration then useSelector(v35) else v26((tostring(t1.localUserId)))
	local v37 = if not FFlagSquadsPresenceStoreMigration then v36 and v36.rootPlaceId or nil else if not v36 or v36.rootPlaceId == "" then nil else v36.rootPlaceId
	local v38 = if not FFlagSquadsPresenceStoreMigration then v36 and (v36.universeId or v36.gameId) or nil else if not v36 or v36.universeId == "" then if not v36 or v36.gameId == "" then nil else v36.gameId else v36.universeId
	local v39 = if v38 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v38), Constants.RbxthumbTypes.GameIcon, 150, false)

	return React.createElement(Foundation.View, {
		tag = "align-y-center row auto-none size-full radius-medium gap-medium gui-object-defaults padding-x-xlarge padding-y-medium"
	}, {
		Thumbnail = if not v39 then nil else React.createElement(FoundationImage, {
			tag = "radius-small bg-surface-100 size-1000",
			LayoutOrder = 1,
			Image = v39
		}),
		TextContainer = React.createElement(Foundation.View, {
			tag = "auto-y fill col gap-xsmall align-x-left gui-object-defaults",
			LayoutOrder = 2
		}, {
			Title = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = {
					["auto-y text-align-x-left text-no-wrap text-title-medium content-emphasis"] = true,
					["size-full-0 text-truncate-end"] = v24
				},
				Text = v31.Title
			}),
			Body = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = {
					["auto-y content-default text-body-medium text-align-x-left text-no-wrap gui-object-defaults"] = true,
					["size-full-0 text-truncate-end"] = v24
				},
				Text = v31.Body
			})
		}),
		JoinButton = React.createElement(Foundation.Button, {
			LayoutOrder = 3,
			text = v31.Join,
			size = ButtonSize.Medium,
			variant = ButtonVariant.Standard,
			isDisabled = v33 ~= nil,
			onActivated = React.useCallback(function() -- line: 124
				-- upvalues: v37 (copy), Logger (copy), v29 (copy), CreateExperienceInvite (copy), v30 (copy), SquadExperienceInviteSource (copy), EventNames (copy), v34 (copy), t1 (copy), FFlagSquadsPresenceStoreMigration (copy), v36 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
				if v37 == nil then
					Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence")

					return
				end

				v29(CreateExperienceInvite(tostring(v37), v30, SquadExperienceInviteSource.Regroup)):andThen(function(p3) -- line: 136
					-- upvalues: v30 (copy), EventNames (copy), v34 (copy), t1 (copy), FFlagSquadsPresenceStoreMigration (copy), v36 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
					v30.fireSquadAnalytics(EventNames.SquadRegroupButtonClicked, {
						clientTimestamp = os.time(),
						squadId = v34,
						initiatorId = t1.localUserId,
						gameInstanceId = if not FFlagSquadsPresenceStoreMigration then v36.gameId else v36 and v36.gameId,
						rootPlaceId = if not FFlagSquadsPresenceStoreMigration then v36.rootPlaceId else v36 and v36.rootPlaceId,
						placeId = if not FFlagSquadsPresenceStoreMigration then v36.placeId else v36 and v36.placeId,
						universeId = if not FFlagSquadsPresenceStoreMigration then v36.universeId else v36 and v36.universeId,
						playSessionId = RbxAnalyticsService:GetPlaySessionId(),
						experienceInviteId = p3,
						button = SquadToastActionsAndStates.RegroupJoin,
						entryPoint = SquadRegroupEntryPoint.SquadLobbyButton
					})
				end)
			end, {
				v29,
				CreateExperienceInvite,
				v37,
				v30,
				v34,
				t1.localUserId,
				v36
			})
		})
	})
end

return SquadLobbyRegroupRow

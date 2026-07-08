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

local function SquadLobbyRegroupRow(t1: {[any]: any}) -- line: 35
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), useLocalization (copy), useSelector (copy), useCurrentSquadId (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Foundation (copy), FoundationImage (copy), v24 (copy), ButtonSize (copy), ButtonVariant (copy), Logger (copy), CreateExperienceInvite (copy), SquadExperienceInviteSource (copy), EventNames (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
	local v27 = useDispatch()
	local v28 = React.useContext(SquadExternalContractContext)
	local v29 = useLocalization({
		Title = "Notifications.SquadRegroupPrompt.ToastLabel.ContinuePlayingTogether",
		Body = "Notifications.SquadRegroupPrompt.ToastLabel.JoinANewServer",
		Join = "Notifications.SquadRegroupPrompt.ToastAction.Join"
	})
	local v30 = React.useCallback(function(p1) -- line: 44
		return p1.Squad and (p1.Squad.Squad and p1.Squad.Squad.currentExperienceInvite)
	end, {})
	local v31 = useSelector(v30)
	local v32 = useCurrentSquadId()
	local v33 = React.useCallback(function(p2) -- line: 50
		-- upvalues: t1 (copy)
		return p2 and (p2.Squad and (p2.Squad.Presence and (p2.Squad.Presence.byUserId and p2.Squad.Presence.byUserId[tostring(t1.localUserId)])))
	end, { t1.localUserId })
	local v34 = useSelector(v33)
	local v35 = v34 and v34.rootPlaceId or nil
	local v36 = v34 and (v34.universeId or v34.gameId) or nil
	local v37 = if v36 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v36), Constants.RbxthumbTypes.GameIcon, 150, false)

	return React.createElement(Foundation.View, {
		tag = "align-y-center row auto-none size-full radius-medium gap-medium gui-object-defaults padding-x-xlarge padding-y-medium"
	}, {
		Thumbnail = if not v37 then nil else React.createElement(FoundationImage, {
			tag = "radius-small bg-surface-100 size-1000",
			LayoutOrder = 1,
			Image = v37
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
				Text = v29.Title
			}),
			Body = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = {
					["auto-y content-default text-body-medium text-align-x-left text-no-wrap gui-object-defaults"] = true,
					["size-full-0 text-truncate-end"] = v24
				},
				Text = v29.Body
			})
		}),
		JoinButton = React.createElement(Foundation.Button, {
			LayoutOrder = 3,
			text = v29.Join,
			size = ButtonSize.Medium,
			variant = ButtonVariant.Standard,
			isDisabled = v31 ~= nil,
			onActivated = React.useCallback(function() -- line: 111
				-- upvalues: v35 (copy), Logger (copy), v27 (copy), CreateExperienceInvite (copy), v28 (copy), SquadExperienceInviteSource (copy), EventNames (copy), v32 (copy), t1 (copy), v34 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
				if v35 == nil then
					Logger:warning("SquadRegroupEventReceiver: Join clicked but rootPlaceId is missing from local presence")

					return
				end

				v27(CreateExperienceInvite(tostring(v35), v28, SquadExperienceInviteSource.Regroup)):andThen(function(p3) -- line: 123
					-- upvalues: v28 (copy), EventNames (copy), v32 (copy), t1 (copy), v34 (copy), RbxAnalyticsService (copy), SquadToastActionsAndStates (copy), SquadRegroupEntryPoint (copy)
					v28.fireSquadAnalytics(EventNames.SquadRegroupButtonClicked, {
						clientTimestamp = os.time(),
						squadId = v32,
						initiatorId = t1.localUserId,
						gameInstanceId = v34.gameId,
						rootPlaceId = v34.rootPlaceId,
						placeId = v34.placeId,
						universeId = v34.universeId,
						playSessionId = RbxAnalyticsService:GetPlaySessionId(),
						experienceInviteId = p3,
						button = SquadToastActionsAndStates.RegroupJoin,
						entryPoint = SquadRegroupEntryPoint.SquadLobbyButton
					})
				end)
			end, {
				v27,
				CreateExperienceInvite,
				v35,
				v28,
				v32,
				t1.localUserId,
				v34
			})
		})
	})
end

return SquadLobbyRegroupRow

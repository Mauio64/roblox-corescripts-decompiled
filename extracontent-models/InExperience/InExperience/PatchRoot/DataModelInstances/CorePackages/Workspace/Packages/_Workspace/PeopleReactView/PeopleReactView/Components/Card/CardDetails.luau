local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GuiService = game:GetService("GuiService")
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local formatUsername = require(PeopleReactViewParent.UserProfiles).Formatters.formatUsername
local Foundation = require(PeopleReactViewParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ControlState = Foundation.Enums.ControlState
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local useInExperienceCombinedName = require(PeopleReactView.Hooks.useInExperienceCombinedName)
local useIsComponentInputEnded = require(PeopleReactView.Hooks.useIsComponentInputEnded)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local FFlagAddIEMProfilePage = require(PeopleReactViewParent.SharedFlags).FFlagAddIEMProfilePage

local function CardDetails(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), useGetPeopleService (copy), FFlagAddIEMProfilePage (copy), PersonButtonConfigs (copy), useInExperienceCombinedName (copy), SignalsReact (copy), IconName (copy), IconVariant (copy), useIsComponentInputEnded (copy), ControlState (copy), EngineFeature (copy), RbxAnalyticsService (copy), GuiService (copy), View (copy), StateLayerAffordance (copy), FoundationText (copy), formatUsername (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy)
	local v26 = React.useRef(nil)
	local v27 = useGetPeopleService("FriendStatusStore")
	local v28 = useGetPeopleService("Constants")
	local v29 = if not FFlagAddIEMProfilePage then nil else useGetPeopleService("PeopleAnalyticsManager")
	local v30 = if not FFlagAddIEMProfilePage then nil else useGetPeopleService("SettingsHubService")
	local v31 = PersonButtonConfigs(t1.person.UserId)
	local v32 = React.useMemo(function() -- line: 56
		-- upvalues: v31 (copy), v28 (copy)
		return v31[v28.PERSON_BUTTONS.ADD_FRIEND]
	end, { v31 })
	local v33 = useInExperienceCombinedName(t1.person.UserId, t1.person.DisplayName)
	local v34 = SignalsReact.useSignalState(v27.getFriendStatus(t1.person.UserId))
	local v35 = SignalsReact.useSignalState(v27.getIsFriendButtonGrayedOut(t1.person.UserId))
	local v36 = React.useMemo(function() -- line: 66
		-- upvalues: v34 (copy), IconName (copy), IconVariant (copy), v35 (copy)
		if v34 then
			return {
				name = IconName.PersonCheck,
				variant = IconVariant.Filled
			}
		end

		if v35 then
			return {
				name = IconName.Clock,
				variant = IconVariant.Filled
			}
		end

		return {
			name = IconName.PersonPlus,
			variant = IconVariant.Regular
		}
	end, {
		v34,
		v35
	})
	local v37 = useIsComponentInputEnded(v26)
	local v38 = SignalsReact.useSignalState(v27.getIsFriendButtonDisabled(t1.person.UserId))
	local v39, v40 = React.useState(false)
	local v41 = React.useCallback(function(p1) -- line: 91
		-- upvalues: v40 (copy), ControlState (copy)
		v40(p1 == ControlState.Hover or p1 == ControlState.Pressed)
	end, {})
	local v42 = if not FFlagAddIEMProfilePage then nil else React.useCallback(function() -- line: 96
		-- upvalues: v30 (copy), t1 (copy), EngineFeature (copy), RbxAnalyticsService (copy), v29 (copy), GuiService (copy)
		local v45 = v30.hubRef()

		if v45 then
			v45:SwitchToReactPage(v45.PlayerProfilePage, {
				userId = t1.person.UserId,
				inspectAvatar = function() -- line: 101
					-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), v29 (copy), GuiService (copy), t1 (copy), v45 (copy)
					local v46 = if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId()

					v29:trackInspectButton(game.GameId, v46, "player_profile")
					GuiService:InspectPlayerFromUserIdWithCtx(t1.person.UserId, "playerProfile")
					v45:SetVisibility(false)
				end,
				closePage = function() -- line: 110
					-- upvalues: v45 (copy)
					v45:CloseReactPage()
				end
			})
		end
	end, {})
	local v43 = React.useCallback(function() -- line: 118
		-- upvalues: v32 (copy), v28 (copy)
		v32.onActivated(v28.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
	end, { v32.onActivated })

	return React.createElement(View, {
		tag = "row size-full-1400 align-y-center padding-x-small radius-medium",
		LayoutOrder = t1.layoutOrder,
		stateLayer = {
			affordance = if not v39 and not v37 then StateLayerAffordance.Background else StateLayerAffordance.None
		},
		onActivated = if not FFlagAddIEMProfilePage then nil else v42,
		ref = v26
	}, {
		NameContainer = React.createElement(View, {
			tag = "col fill auto-y",
			LayoutOrder = 1
		}, {
			Name = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y content-emphasis text-title-medium text-align-x-left text-truncate-end padding-right-small",
				LayoutOrder = 1,
				Text = v33
			}),
			Handle = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y content-default text-body-medium text-align-x-left text-truncate-end padding-right-small",
				LayoutOrder = 2,
				Text = formatUsername(t1.person.Name)
			})
		}),
		ConnectButtonBackground = React.createElement(View, {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onStateChanged = v41
		}, {
			ConnectButton = React.createElement(IconButton, {
				icon = v36,
				variant = if not v38 then ButtonVariant.Standard else ButtonVariant.Utility,
				size = InputSize.Medium,
				isDisabled = v38,
				Visible = v32.shouldShow(),
				onActivated = v43
			})
		})
	})
end

return React.memo(CardDetails)

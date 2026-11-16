local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/SquadExternalContractProvider")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/SharedFlags")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Hooks").useCurrentSquadId
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Hooks").useCurrentSquadParentChannelId
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Navigation").useNavigation

local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Thunks").leaveSquad
local squadButtonClickIntentionEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").SquadButtonClickIntentionEnum
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").SquadButtonSourceEnum

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/EventNames")
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Enums").SquadPromptType

local useTokens = Foundation.Hooks.useTokens

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/useCanAccessParty")

local function SquadEndedCard(p2)
	local v5 = useDispatch()
	local v6 = useLocalization({
		partyEnded = "Feature.Squads.Label.PartyEndedText",
		tapToStartNewParty = "Feature.Squads.Action.TapToStartNewParty"
	})

	local v7 = useNavigation()
	local v8 = useTokens()

	local v9 = useCurrentSquadId()
	local v10 = useCurrentSquadParentChannelId()

	local v11 = React.useContext(squadExternalContractContext)
	local v12 = v11.useParentChannelHasGroupUp(p2.conversationId)

	local v13 = useCanAccessParty()
	local v14 = v11.useParentChannelHasSquadAccess(p2.conversationId)

	local v15 = v13 and v14

	local v16 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v11.useIsChatEnabled()

	local v17 = React.useMemo(function(): boolean
		return v10 == p2.conversationId
	end, { v10, p2.conversationId })

	local v18 = React.useMemo(function()
		if v17 then
			return squadButtonClickIntentionEnum.View
		end

		if v12 then
			return squadButtonClickIntentionEnum.Join
		end

		return squadButtonClickIntentionEnum.Create
	end, { v17, v12 })

	local v19 = React.useCallback(function()
		v11.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = p2.conversationId,
			squadButtonSource = squadButtonSourceEnum.PartyEndedCard,
			squadId = v9,
			squadLocation = p2.squadLocation,
			userIntention = v18
		})
	end, { v18, v9, p2.conversationId, p2.squadLocation, v11.fireSquadAnalytics })

	local createElement = React.createElement
	local view = Foundation.View
	local v20 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		backgroundStyle = v8.Color.Shift.Shift_200,
		cornerRadius = UDim.new(0, v8.Radius.Large),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v8.Gap.XSmall),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		selection = { Selectable = true },
		onActivated = v15 and function()
			v19()

			if v9 and p2.conversationId ~= v10 then
				v5(leaveSquad(squadPromptType.JoinAnotherSquad, v11.setSquadPrompt, function()
					v7.navigate("SquadLobby", { conversationId = p2.conversationId })
				end, v11.squadLocation, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v16))
			else
				v7.navigate("SquadLobby", { conversationId = p2.conversationId })
			end
		end or nil,
		padding = {
			bottom = UDim.new(0, v8.Padding.Medium),
			left = UDim.new(0, v8.Padding.Large),
			right = UDim.new(0, v8.Padding.Large),
			top = UDim.new(0, v8.Padding.Medium)
		}
	}

	local v21 = {
		Title = React.createElement(Foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v8.Color.None,
			fontStyle = v8.Typography.TitleMedium,
			LayoutOrder = 1,
			Text = v6.partyEnded,
			textStyle = v8.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Status = 0
	}

	local v22 = if v15 then React.createElement(Foundation.Text, {
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v8.Color.None,
		fontStyle = v8.Typography.LabelSmall,
		LayoutOrder = 2,
		Text = v6.tapToStartNewParty,
		textStyle = v8.Color.Content.Muted,
		TextTruncate = Enum.TextTruncate.AtEnd
	}) else nil
	v21.Status = v22
	return createElement(view, v20, v21)
end

return SquadEndedCard

local parent = script:FindFirstAncestor("SocialCards").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SharedFlags = require(parent.SharedFlags)
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local Hooks2 = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks2.useCurrentSquadParentChannelId
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local Thunks = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks.leaveSquad
local Enums = require(parent.Squads.Enums)
local SquadButtonClickIntentionEnum = Enums.SquadButtonClickIntentionEnum
local Enums2 = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums2.SquadButtonSourceEnum

local EventNames = require(parent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums3 = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums3.SquadPromptType

local useTokens = Foundation.Hooks.useTokens

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local useCanAccessParty = require(parent.Squads.useCanAccessParty)

local function SquadEndedCard(p)
	local v = useDispatch()
	local v2 = useLocalization({
		partyEnded = "Feature.Squads.Label.PartyEndedText",
		tapToStartNewParty = "Feature.Squads.Action.TapToStartNewParty"
	})

	local v3 = useNavigation()
	local v4 = useTokens()

	local squadId = useCurrentSquadId()
	local v5 = useCurrentSquadParentChannelId()

	local v6 = React.useContext(SquadExternalContractContext)
	local v7 = v6.useParentChannelHasGroupUp(p.conversationId)

	local v8 = useCanAccessParty()
	local v9 = v6.useParentChannelHasSquadAccess(p.conversationId)

	local v10 = v8 and v9

	local v11 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v6.useIsChatEnabled()

	local v12 = React.useMemo(function(): boolean
		return v5 == p.conversationId
	end, { v5, p.conversationId })

	local userIntention = React.useMemo(function()
		if v12 then
			return SquadButtonClickIntentionEnum.View
		end

		if v7 then
			return SquadButtonClickIntentionEnum.Join
		end

		return SquadButtonClickIntentionEnum.Create
	end, { v12, v7 })

	local v13 = React.useCallback(function()
		v6.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = p.conversationId,
			squadButtonSource = SquadButtonSourceEnum.PartyEndedCard,
			squadId = squadId,
			squadLocation = p.squadLocation,
			userIntention = userIntention
		})
	end, { userIntention, squadId, p.conversationId, p.squadLocation, v6.fireSquadAnalytics })

	local createElement = React.createElement
	local view = Foundation.View
	local v14 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		backgroundStyle = v4.Color.Shift.Shift_200,
		cornerRadius = UDim.new(0, v4.Radius.Large),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v4.Gap.XSmall),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		selection = { Selectable = true },
		onActivated = v10 and function()
			v13()

			if squadId and p.conversationId ~= v5 then
				v(leaveSquad(SquadPromptType.JoinAnotherSquad, v6.setSquadPrompt, function()
					v3.navigate("SquadLobby", { conversationId = p.conversationId })
				end, v6.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v11))
			else
				v3.navigate("SquadLobby", { conversationId = p.conversationId })
			end
		end or nil,
		padding = {
			bottom = UDim.new(0, v4.Padding.Medium),
			left = UDim.new(0, v4.Padding.Large),
			right = UDim.new(0, v4.Padding.Large),
			top = UDim.new(0, v4.Padding.Medium)
		}
	}

	local v15 = {
		Title = React.createElement(Foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v4.Color.None,
			fontStyle = v4.Typography.TitleMedium,
			LayoutOrder = 1,
			Text = v2.partyEnded,
			textStyle = v4.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Status = 0
	}
	local status

	if v10 then
		status = React.createElement(Foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v4.Color.None,
			fontStyle = v4.Typography.LabelSmall,
			LayoutOrder = 2,
			Text = v2.tapToStartNewParty,
			textStyle = v4.Color.Content.Muted,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	end

	v15.Status = status
	return createElement(view, v14, v15)
end

return SquadEndedCard

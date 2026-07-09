local Parent = script:FindFirstAncestor("SocialCards").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SquadExternalContractProvider = require(Parent.SquadsCore.SquadExternalContractProvider)
local SharedFlags = require(Parent.SharedFlags)
local useCurrentSquadId = require(Parent.SquadsCore.Hooks).useCurrentSquadId
local useCurrentSquadParentChannelId = require(Parent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useNavigation = require(Parent.Navigation).useNavigation
local leaveSquad = require(Parent.SquadsCore.Thunks).leaveSquad
local SquadButtonClickIntentionEnum = require(Parent.Squads.Enums).SquadButtonClickIntentionEnum
local SquadButtonSourceEnum = require(Parent.Squads.Enums).SquadButtonSourceEnum
local EventNames = require(Parent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadPromptType = require(Parent.SquadsCore.Enums).SquadPromptType
local useTokens = Foundation.Hooks.useTokens
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local useCanAccessParty = require(Parent.Squads.useCanAccessParty)

local function SquadEndedCard(t1: {[any]: any}) -- line: 33
	-- upvalues: useDispatch (copy), useLocalization (copy), useNavigation (copy), useTokens (copy), useCurrentSquadId (copy), useCurrentSquadParentChannelId (copy), React (copy), SquadExternalContractContext (copy), useCanAccessParty (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), SquadButtonClickIntentionEnum (copy), EventNames (copy), SquadButtonSourceEnum (copy), Foundation (copy), leaveSquad (copy), SquadPromptType (copy)
	local v22 = useDispatch()
	local v23 = useLocalization({
		partyEnded = "Feature.Squads.Label.PartyEndedText",
		tapToStartNewParty = "Feature.Squads.Action.TapToStartNewParty"
	})
	local v24 = useNavigation()
	local v25 = useTokens()
	local v26 = useCurrentSquadId()
	local v27 = useCurrentSquadParentChannelId()
	local v28 = React.useContext(SquadExternalContractContext)
	local v29 = v28.useParentChannelHasGroupUp(t1.conversationId)
	local v30 = useCanAccessParty()
	local v31 = v28.useParentChannelHasSquadAccess(t1.conversationId)
	local v32 = v30 and v31
	local v33 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v28.useIsChatEnabled()
	local v34 = React.useMemo(function() -- line: 56
		-- upvalues: v27 (copy), t1 (copy)
		return v27 == t1.conversationId
	end, {
		v27,
		t1.conversationId
	})
	local v35 = React.useMemo(function() -- line: 60
		-- upvalues: v34 (copy), SquadButtonClickIntentionEnum (copy), v29 (copy)
		if v34 then
			return SquadButtonClickIntentionEnum.View
		end

		if v29 then
			return SquadButtonClickIntentionEnum.Join
		end

		return SquadButtonClickIntentionEnum.Create
	end, {
		v34,
		v29
	})
	local v36 = React.useCallback(function() -- line: 72
		-- upvalues: v28 (copy), EventNames (copy), t1 (copy), SquadButtonSourceEnum (copy), v26 (copy), v35 (copy)
		v28.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = t1.conversationId,
			squadButtonSource = SquadButtonSourceEnum.PartyEndedCard,
			squadId = v26,
			squadLocation = t1.squadLocation,
			userIntention = v35
		})
	end, {
		v35,
		v26,
		t1.conversationId,
		t1.squadLocation,
		v28.fireSquadAnalytics
	})

	return React.createElement(Foundation.View, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		backgroundStyle = v25.Color.Shift.Shift_200,
		cornerRadius = UDim.new(0, v25.Radius.Large),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v25.Gap.XSmall),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		selection = {
			Selectable = true
		},
		onActivated = if not v32 then nil else function() -- line: 104
			-- upvalues: v36 (copy), v26 (copy), t1 (copy), v27 (copy), v22 (copy), leaveSquad (copy), SquadPromptType (copy), v28 (copy), v24 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v33 (copy)
			v36()

			if v26 and t1.conversationId ~= v27 then
				v22(leaveSquad(SquadPromptType.JoinAnotherSquad, v28.setSquadPrompt, function() -- line: 112
					-- upvalues: v24 (copy), t1 (copy)
					v24.navigate("SquadLobby", {
						conversationId = t1.conversationId
					})
				end, v28.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v33))

				return
			end

			v24.navigate("SquadLobby", {
				conversationId = t1.conversationId
			})
		end,
		padding = {
			bottom = UDim.new(0, v25.Padding.Medium),
			left = UDim.new(0, v25.Padding.Large),
			right = UDim.new(0, v25.Padding.Large),
			top = UDim.new(0, v25.Padding.Medium)
		}
	}, {
		Title = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v25.Color.None,
			fontStyle = v25.Typography.TitleMedium,
			Text = v23.partyEnded,
			textStyle = v25.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Status = if not v32 then nil else React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v25.Color.None,
			fontStyle = v25.Typography.LabelSmall,
			Text = v23.tapToStartNewParty,
			textStyle = v25.Color.Content.Muted,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return SquadEndedCard

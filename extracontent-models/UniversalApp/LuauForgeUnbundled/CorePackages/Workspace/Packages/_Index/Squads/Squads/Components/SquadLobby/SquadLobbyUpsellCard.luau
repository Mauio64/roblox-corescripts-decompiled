local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Responsive")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local foundation = dependencies.Foundation
local react = dependencies.React
local networkingSquads = dependencies.NetworkingSquads
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector

local useTokens = foundation.Hooks.useTokens
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useLocalization = dependencies.Hooks.useLocalization

local reinviteToSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").reinviteToSquad
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadId

local avatarGroup = foundation.AvatarGroup
local avatarGroupType = foundation.Enums.AvatarGroupType
local inputSize = foundation.Enums.InputSize

local NoResponseInviteAgainOrAddOthersEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/NoResponseInviteAgainOrAddOthersEnum")
local SquadInvitePageNavSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadInvitePageNavSourceEnum")

return function(props)
	local v5 = useDispatch()
	local v6 = useTokens()
	local v7 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v8 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)
	local v9 = useLocalUserId()

	local v10 = useLocalization({
		addOthers = "Feature.Squads.Action.AddOthers",
		upsellText = "Feature.Squads.Description.upsellInviteText",
		inviteText = "Feature.Squads.Action.Invite",
		inviteAgain = "Feature.Squads.Action.InviteAgain"
	})

	local v11 = useCurrentSquadSelector()
	local parentChannelId = if v11 and v11.parentChannelId then v11.parentChannelId else nil

	local v12 = useCurrentSquadId()

	local v14 = useSelector((react.useCallback(function(p2)
		return networkingSquads.ReinviteToSquad.getStatus(p2, { squadId = v12 })
	end, { v12 })))

	local v15 = react.useContext(squadExternalContractContext)
	local v16 = v15.useGetConversationFromId(parentChannelId or "")

	local v17 = react.useMemo(function()
		return react.createElement(foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			fontStyle = v6.Typography.BodyLarge,
			LayoutOrder = 1,
			Text = v10.upsellText,
			textStyle = v6.Color.Content.Default,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--label" or nil
		})
	end, { v6, v10.upsellText })

	local v18 = react.useMemo(function()
		local participants = {}

		if v16 and v16.participants then
			for i, participant in ipairs(v16.participants) do
				if participant ~= v9 then
					table.insert(participants, participant)
				end
			end
		end

		if v8 or v7 then
			return nil
		end

		return (react.createElement(avatarGroup, {
			avatars = participants,
			size = inputSize.Medium,
			type = avatarGroupType.Stacked,
			max = 4,
			imageBackgroundStyle = {
				Color3 = v6.Color.OverMedia.OverMedia_300.Color3,
				Transparency = v6.Color.OverMedia.OverMedia_300.Transparency
			},
			imageBorderStyle = {
				Color = v6.Color.Surface.Surface_0.Color3,
				Transparency = v6.Color.Surface.Surface_0.Transparency
			},
			layoutOrder = 0,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--facepile" or nil
		}))
	end, {
		v16 and v16.participants,
		v9,
		v8,
		v7
	})

	useEffectOnce(function()
		v15.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = parentChannelId
		})

		v15.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = parentChannelId
		})
	end, parentChannelId)

	local v19 = react.useCallback(function()
		v5(reinviteToSquad(v12, v15.setSquadPrompt))

		v15.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = parentChannelId
		})
	end, { v15.fireSquadAnalytics, parentChannelId })

	local v20 = react.useCallback(function()
		v15.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = parentChannelId
		})

		v15.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = SquadInvitePageNavSourceEnum.SquadLobbyUpsellCardClicked,
			parentChannelId = parentChannelId
		})

		props.navigateToSquadInviteFriends()
	end, { parentChannelId, v15.fireSquadAnalytics, props.navigateToSquadInviteFriends })

	local v21 = react.useMemo(function()
		return react.createElement(foundation.Button, {
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			isDisabled = v14 == networkStatus.Fetching,
			LayoutOrder = 1,
			onActivated = v19,
			text = v10.inviteAgain,
			size = foundation.Enums.InputSize.Medium,
			variant = foundation.Enums.ButtonVariant.Standard,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--invite-again-button" or nil
		})
	end, { v19, v10.inviteAgain, v14 })

	local v22 = react.useMemo(function()
		return react.createElement(foundation.Button, {
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			onActivated = v20,
			text = v10.addOthers,
			size = foundation.Enums.ButtonSize.Medium,
			variant = foundation.Enums.ButtonVariant.Standard,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--add-others-button" or nil
		})
	end, { v20, v10.addOthers })

	local createElement = react.createElement
	local v24 = {
		Size = props.size,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = react.createElement
	local view = foundation.View
	local v26 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -2 * v6.Stroke.Standard, 1, -2 * v6.Stroke.Standard),
		cornerRadius = UDim.new(0, v6.Radius.Medium),
		padding = v6.Padding.XXLarge,
		layout = 0,
		stroke = 0,
		testId = 0
	}
	local v27 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = 0,
		SortOrder = 0,
		VerticalAlignment = 0
	}
	local newUDim = UDim.new

	local v29 = if v8 or v7 then v6.Padding.Medium else v6.Padding.XXLarge
	v27.Padding = newUDim(0, v29)

	v27.SortOrder = Enum.SortOrder.LayoutOrder
	v27.VerticalAlignment = Enum.VerticalAlignment.Center
	v26.layout = v27

	v26.stroke = {
		Color = v6.Color.Stroke.Default.Color3,
		Transparency = v6.Color.Stroke.Default.Transparency,
		Thickness = v6.Stroke.Standard
	}

	v26.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card" or nil
	return createElement("Frame", v24, { createElement2(view, v26, {
			UpsellInformation = react.createElement(
				foundation.View,
				{
					LayoutOrder = 1,
					tag = "size-full-0 gap-medium align-x-center auto-y col"
				},
				{ UpsellFacepile = v18, UpsellLabel = v17 }
			),
			Buttons = react.createElement(foundation.View, {
				LayoutOrder = 2,
				tag = {
					["size-full-0 gap-small align-x-center flex-fill align-y-center auto-y"] = true,
					col = v7,
					row = not v7
				}
			}, { InviteAgainButton = v21, AddOthersButton = v22 })
		}) })
end

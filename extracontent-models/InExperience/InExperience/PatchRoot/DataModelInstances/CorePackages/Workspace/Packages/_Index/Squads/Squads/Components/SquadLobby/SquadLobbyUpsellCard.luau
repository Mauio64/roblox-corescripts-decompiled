local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Responsive = require(parent.Responsive)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local dependencies = require(Squads.dependencies)

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

local Thunks = require(parent.SquadsCore.Thunks)
local reinviteToSquad = Thunks.reinviteToSquad
local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId

local avatarGroup = foundation.AvatarGroup
local avatarGroupType = foundation.Enums.AvatarGroupType
local inputSize = foundation.Enums.InputSize

local NoResponseInviteAgainOrAddOthersEnum = require(Squads.Enums.NoResponseInviteAgainOrAddOthersEnum)
local SquadInvitePageNavSourceEnum = require(Squads.Enums.SquadInvitePageNavSourceEnum)

return function(props)
	local v = useDispatch()
	local v2 = useTokens()
	local col = Responsive.useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v3 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)
	local v4 = useLocalUserId()

	local v5 = useLocalization({
		addOthers = "Feature.Squads.Action.AddOthers",
		upsellText = "Feature.Squads.Description.upsellInviteText",
		inviteText = "Feature.Squads.Action.Invite",
		inviteAgain = "Feature.Squads.Action.InviteAgain"
	})

	local v6 = useCurrentSquadSelector()
	local parentChannelId

	if v6 and v6.parentChannelId then
		parentChannelId = v6.parentChannelId
	else
		parentChannelId = nil
	end

	local squadId = useCurrentSquadId()

	local v7 = useSelector((react.useCallback(function(p)
		return networkingSquads.ReinviteToSquad.getStatus(p, { squadId = squadId })
	end, { squadId })))

	local v8 = react.useContext(SquadExternalContractContext)
	local v9 = v8.useGetConversationFromId(parentChannelId or "")

	local upsellLabel = react.useMemo(function()
		return react.createElement(foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			fontStyle = v2.Typography.BodyLarge,
			LayoutOrder = 1,
			Text = v5.upsellText,
			textStyle = v2.Color.Content.Default,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--label" or nil
		})
	end, { v2, v5.upsellText })

	local upsellFacepile = react.useMemo(function()
		local participants = {}

		if v9 and v9.participants then
			for _, participant in ipairs(v9.participants) do
				if participant ~= v4 then
					table.insert(participants, participant)
				end
			end
		end

		if v3 or col then
			return nil
		end

		return (react.createElement(avatarGroup, {
			avatars = participants,
			size = inputSize.Medium,
			type = avatarGroupType.Stacked,
			max = 4,
			imageBackgroundStyle = {
				Color3 = v2.Color.OverMedia.OverMedia_300.Color3,
				Transparency = v2.Color.OverMedia.OverMedia_300.Transparency
			},
			imageBorderStyle = {
				Color = v2.Color.Surface.Surface_0.Color3,
				Transparency = v2.Color.Surface.Surface_0.Transparency
			},
			layoutOrder = 0,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--facepile" or nil
		}))
	end, {
		v9 and v9.participants,
		v4,
		v3,
		col
	})

	useEffectOnce(function()
		v8.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = parentChannelId
		})

		v8.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = parentChannelId
		})
	end, parentChannelId)

	local onActivated = react.useCallback(function()
		v(reinviteToSquad(squadId, v8.setSquadPrompt))

		v8.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = parentChannelId
		})
	end, { v8.fireSquadAnalytics, parentChannelId })

	local onActivated2 = react.useCallback(function()
		v8.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = parentChannelId
		})

		v8.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = SquadInvitePageNavSourceEnum.SquadLobbyUpsellCardClicked,
			parentChannelId = parentChannelId
		})

		props.navigateToSquadInviteFriends()
	end, { parentChannelId, v8.fireSquadAnalytics, props.navigateToSquadInviteFriends })

	local inviteAgainButton = react.useMemo(function()
		return react.createElement(foundation.Button, {
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			isDisabled = v7 == networkStatus.Fetching,
			LayoutOrder = 1,
			onActivated = onActivated,
			text = v5.inviteAgain,
			size = foundation.Enums.InputSize.Medium,
			variant = foundation.Enums.ButtonVariant.Standard,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--invite-again-button" or nil
		})
	end, { onActivated, v5.inviteAgain, v7 })

	local addOthersButton = react.useMemo(function()
		return react.createElement(foundation.Button, {
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			onActivated = onActivated2,
			text = v5.addOthers,
			size = foundation.Enums.ButtonSize.Medium,
			variant = foundation.Enums.ButtonVariant.Standard,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card--add-others-button" or nil
		})
	end, { onActivated2, v5.addOthers })

	local createElement = react.createElement
	local v10 = { Size = props.size, BackgroundTransparency = 1, LayoutOrder = props.layoutOrder }

	local createElement2 = react.createElement
	local view = foundation.View
	local v11 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -2 * v2.Stroke.Standard, 1, -2 * v2.Stroke.Standard),
		cornerRadius = UDim.new(0, v2.Radius.Medium),
		padding = v2.Padding.XXLarge,
		layout = 0,
		stroke = 0,
		testId = 0
	}
	local layout = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = 0,
		SortOrder = 0,
		VerticalAlignment = 0
	}
	local v12

	if v3 or col then
		v12 = v2.Padding.Medium
	else
		v12 = v2.Padding.XXLarge
	end

	layout.Padding = UDim.new(0, v12)

	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	v11.layout = layout

	v11.stroke = {
		Color = v2.Color.Stroke.Default.Color3,
		Transparency = v2.Color.Stroke.Default.Transparency,
		Thickness = v2.Stroke.Standard
	}

	v11.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-upsell-card" or nil
	return createElement("Frame", v10, { createElement2(view, v11, {
			UpsellInformation = react.createElement(
				foundation.View,
				{ LayoutOrder = 1, tag = "size-full-0 gap-medium align-x-center auto-y col" },
				{ UpsellFacepile = upsellFacepile, UpsellLabel = upsellLabel }
			),
			Buttons = react.createElement(foundation.View, {
				LayoutOrder = 2,
				tag = {
					["size-full-0 gap-small align-x-center flex-fill align-y-center auto-y"] = true,
					col = col,
					row = not col
				}
			}, { InviteAgainButton = inviteAgainButton, AddOthersButton = addOthersButton })
		}) })
end

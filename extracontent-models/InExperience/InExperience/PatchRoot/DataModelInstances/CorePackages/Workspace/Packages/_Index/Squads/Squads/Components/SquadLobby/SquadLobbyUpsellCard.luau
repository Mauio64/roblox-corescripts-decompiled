local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Responsive = require(SquadsParent.Responsive)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local dependencies = require(Squads.dependencies)
local Foundation = dependencies.Foundation
local React = dependencies.React
local NetworkingSquads = dependencies.NetworkingSquads
local NetworkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local useTokens = Foundation.Hooks.useTokens
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useLocalization = dependencies.Hooks.useLocalization
local reinviteToSquad = require(SquadsParent.SquadsCore.Thunks).reinviteToSquad
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local useCurrentSquadId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadId
local AvatarGroup = Foundation.AvatarGroup
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local InputSize = Foundation.Enums.InputSize
local NoResponseInviteAgainOrAddOthersEnum = require(Squads.Enums.NoResponseInviteAgainOrAddOthersEnum)
local SquadInvitePageNavSourceEnum = require(Squads.Enums.SquadInvitePageNavSourceEnum)

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: useDispatch (copy), useTokens (copy), Responsive (copy), useLocalUserId (copy), useLocalization (copy), useCurrentSquadSelector (copy), useCurrentSquadId (copy), React (copy), NetworkingSquads (copy), useSelector (copy), SquadExternalContractContext (copy), Foundation (copy), AvatarGroup (copy), InputSize (copy), AvatarGroupType (copy), useEffectOnce (copy), EventNames (copy), NoResponseInviteAgainOrAddOthersEnum (copy), reinviteToSquad (copy), SquadInvitePageNavSourceEnum (copy), NetworkStatus (copy)
	local v26 = useDispatch()
	local v27 = useTokens()
	local v28 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v29 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)
	local v30 = useLocalUserId()
	local v31 = useLocalization({
		addOthers = "Feature.Squads.Action.AddOthers",
		upsellText = "Feature.Squads.Description.upsellInviteText",
		inviteText = "Feature.Squads.Action.Invite",
		inviteAgain = "Feature.Squads.Action.InviteAgain"
	})
	local v32 = useCurrentSquadSelector()
	local v33 = if not v32 or not v32.parentChannelId then nil else v32.parentChannelId
	local v34 = useCurrentSquadId()
	local v35 = React.useCallback(function(p1) -- line: 62
		-- upvalues: NetworkingSquads (copy), v34 (copy)
		return NetworkingSquads.ReinviteToSquad.getStatus(p1, {
			squadId = v34
		})
	end, { v34 })
	local v36 = useSelector(v35)
	local v37 = React.useContext(SquadExternalContractContext)
	local v38 = v37.useGetConversationFromId(v33 or "")
	local v39 = React.useMemo(function() -- line: 70
		-- upvalues: React (copy), Foundation (copy), v27 (copy), v31 (copy)
		return React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			fontStyle = v27.Typography.BodyLarge,
			Text = v31.upsellText,
			textStyle = v27.Color.Content.Default,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	end, {
		v27,
		v31.upsellText
	})
	local v40 = React.useMemo(function() -- line: 83
		-- upvalues: v38 (copy), v30 (copy), v29 (copy), v28 (copy), React (copy), AvatarGroup (copy), InputSize (copy), AvatarGroupType (copy), v27 (copy)
		local t2 = {}

		if v38 and v38.participants then
			for _, v in ipairs(v38.participants) do
				if v ~= v30 then
					table.insert(t2, v)
				end
			end
		end

		if v29 or v28 then
			return nil
		end

		return (React.createElement(AvatarGroup, {
			max = 4,
			layoutOrder = 0,
			avatars = t2,
			size = InputSize.Medium,
			type = AvatarGroupType.Stacked,
			imageBackgroundStyle = {
				Color3 = v27.Color.OverMedia.OverMedia_300.Color3,
				Transparency = v27.Color.OverMedia.OverMedia_300.Transparency
			},
			imageBorderStyle = {
				Color = v27.Color.Surface.Surface_0.Color3,
				Transparency = v27.Color.Surface.Surface_0.Transparency
			}
		}))
	end, {
		v38 and v38.participants,
		v30,
		v29,
		v28
	})

	useEffectOnce(function() -- line: 112
		-- upvalues: v37 (copy), EventNames (copy), NoResponseInviteAgainOrAddOthersEnum (copy), v33 (copy)
		v37.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = v33
		})
		v37.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Impression,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = v33
		})
	end, v33)

	local v41 = React.useCallback(function() -- line: 125
		-- upvalues: v26 (copy), reinviteToSquad (copy), v34 (copy), v37 (copy), EventNames (copy), NoResponseInviteAgainOrAddOthersEnum (copy), v33 (copy)
		v26(reinviteToSquad(v34, v37.setSquadPrompt))
		v37.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.InviteAgain,
			conversationId = v33
		})
	end, {
		v37.fireSquadAnalytics,
		v33
	})
	local v42 = React.useCallback(function() -- line: 136
		-- upvalues: v37 (copy), EventNames (copy), NoResponseInviteAgainOrAddOthersEnum (copy), v33 (copy), SquadInvitePageNavSourceEnum (copy), t1 (copy)
		v37.fireSquadAnalytics(EventNames.NoResponseInviteAgainOrAddOthers, {
			actionType = NoResponseInviteAgainOrAddOthersEnum.Click,
			button = NoResponseInviteAgainOrAddOthersEnum.AddOthers,
			conversationId = v33
		})
		v37.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = SquadInvitePageNavSourceEnum.SquadLobbyUpsellCardClicked,
			parentChannelId = v33
		})
		t1.navigateToSquadInviteFriends()
	end, {
		v33,
		v37.fireSquadAnalytics,
		t1.navigateToSquadInviteFriends
	})
	local v43 = React.useMemo(function() -- line: 155
		-- upvalues: React (copy), Foundation (copy), v36 (copy), NetworkStatus (copy), v41 (copy), v31 (copy)
		return React.createElement(Foundation.Button, {
			LayoutOrder = 1,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isDisabled = v36 == NetworkStatus.Fetching,
			onActivated = v41,
			text = v31.inviteAgain,
			size = Foundation.Enums.InputSize.Medium,
			variant = Foundation.Enums.ButtonVariant.Standard
		})
	end, {
		v41,
		v31.inviteAgain,
		v36
	})
	local v44 = React.useMemo(function() -- line: 171
		-- upvalues: React (copy), Foundation (copy), v42 (copy), v31 (copy)
		return React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			onActivated = v42,
			text = v31.addOthers,
			size = Foundation.Enums.ButtonSize.Medium,
			variant = Foundation.Enums.ButtonVariant.Standard
		})
	end, {
		v42,
		v31.addOthers
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.size,
		LayoutOrder = t1.layoutOrder
	}, { React.createElement(Foundation.View, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -2 * v27.Stroke.Standard, 1, -2 * v27.Stroke.Standard),
		cornerRadius = UDim.new(0, v27.Radius.Medium),
		padding = v27.Padding.XXLarge,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, if not v29 and not v28 then v27.Padding.XXLarge else v27.Padding.Medium),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		},
		stroke = {
			Color = v27.Color.Stroke.Default.Color3,
			Transparency = v27.Color.Stroke.Default.Transparency,
			Thickness = v27.Stroke.Standard
		}
	}, {
		UpsellInformation = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			tag = "size-full-0 gap-medium align-x-center auto-y col"
		}, {
			UpsellFacepile = v40,
			UpsellLabel = v39
		}),
		Buttons = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = {
				["size-full-0 gap-small align-x-center flex-fill align-y-center auto-y"] = true,
				col = v28,
				row = not v28
			}
		}, {
			InviteAgainButton = v43,
			AddOthersButton = v44
		})
	}) })
end

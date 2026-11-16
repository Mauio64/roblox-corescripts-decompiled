local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local imagePile = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/AppBlox").ImagePile
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Localization").Hooks.useLocalization

local useTokens = Foundation.Hooks.useTokens

local SquadJoinButton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/SquadJoinButton")
local SquadComponentAccessWrapper = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/SquadComponentAccessWrapper")
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").SquadButtonSourceEnum

local function SquadStartedCard(props)
	local v5 = useNavigation()
	local v6 = useTokens()
	local v7 = useLocalization({
		manyPeopleActive = {
			"Feature.Squads.Description.ManyPeopleActive",
			userCount = #props.participantUserIds
		},
		onePersonActive = "Feature.Squads.Description.OnePersonActive",
		partyStarted = "Feature.Squads.Label.PartyStartedText"
	})

	local v8 = React.useCallback(function(list)
		local v9 = {}

		for i, item in ipairs(list) do
			table.insert(v9, {
				Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(item))),
				BackgroundColor3 = v6.Color.Surface.Surface_200.Color3:lerp(
					v6.Color.ActionStandard.Background.Color3,
					1 - v6.Color.ActionStandard.Background.Transparency
				)
			})
		end

		local createElement = React.createElement

		local v12 = if v6.Config.Theme.IsUIBlox == "true" then v6.Color.Shift.Shift_200.Color3 else v6.Color.Surface.Surface_200.Color3
		return createElement(imagePile, { images = v9, imageBorderColor = v12 })
	end, {})

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v6.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = {
			bottom = UDim.new(0, v6.Padding.Medium),
			left = UDim.new(0, v6.Padding.Large),
			right = UDim.new(0, v6.Padding.Large),
			top = UDim.new(0, v6.Padding.Medium)
		},
		selection = { Selectable = true },
		tag = "bg-shift-200 radius-large"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v10 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v6.Gap.Large),
			VerticalAlignment = Enum.VerticalAlignment.Center
		},
		LayoutOrder = 1
	}

	local v12 = if #props.participantUserIds > 0 then React.createElement(
		Foundation.View,
		{
			Size = UDim2.fromOffset(v6.Size.Size_1000, v6.Size.Size_1000),
			LayoutOrder = 1
		},
		{ v8(props.participantUserIds) }
	) else nil

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0,
		layout = 0,
		LayoutOrder = 2
	}
	local v14 = if #props.participantUserIds > 0 then UDim2.new(1, -v6.Size.Size_1000 - v6.Padding.Large, 0, 0) else UDim2.fromScale(1, 0)
	v13.Size = v14

	v13.layout = {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v6.Gap.XSmall),
		SortOrder = Enum.SortOrder.LayoutOrder
	}

	local v15 = {
		Title = React.createElement(Foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v6.Color.None,
			fontStyle = v6.Typography.TitleMedium,
			LayoutOrder = 1,
			Text = v7.partyStarted,
			textStyle = v6.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Status = 0
	}

	local createElement4 = React.createElement
	local text = Foundation.Text
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v6.Color.None,
		fontStyle = v6.Typography.LabelSmall,
		LayoutOrder = 2,
		Text = 0,
		textStyle = 0,
		TextTruncate = 0
	}

	local v17 = if #props.participantUserIds == 1 then v7.onePersonActive else v7.manyPeopleActive
	v16.Text = v17

	v16.textStyle = v6.Color.Content.Muted
	v16.TextTruncate = Enum.TextTruncate.AtEnd
	v15.Status = createElement4(text, v16)
	return createElement(view, v9, {
		InfoContainer = createElement2(view2, v10, {
			Thumbnail = v12,
			TextContainer = createElement3(view3, v13, v15)
		}),
		ActionButton = React.createElement(SquadComponentAccessWrapper, {
			parentChannelId = props.conversationId
		}, {
			React.createElement(SquadJoinButton, {
				conversationId = props.conversationId,
				isFullWidth = true,
				isInCard = true,
				layoutOrder = 3,
				onActivated = function()
					v5.navigate("SquadLobby", { conversationId = props.conversationId })
				end,
				shouldAnimate = false,
				squadButtonSource = squadButtonSourceEnum.PartyStartedCard,
				squadLocation = props.squadLocation
			})
		})
	})
end

return SquadStartedCard

local parent = script:FindFirstAncestor("SocialCards").Parent

local Foundation = require(parent.Foundation)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local AppBlox = require(parent.AppBlox)
local ImagePile = AppBlox.ImagePile
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTokens = Foundation.Hooks.useTokens

local SquadJoinButton = require(parent.Squads.SquadJoinButton)
local SquadComponentAccessWrapper = require(parent.Squads.SquadComponentAccessWrapper)
local Enums = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums.SquadButtonSourceEnum

local function SquadStartedCard(props)
	local v = useNavigation()
	local v2 = useTokens()
	local v3 = useLocalization({
		manyPeopleActive = {
			"Feature.Squads.Description.ManyPeopleActive",
			userCount = #props.participantUserIds
		},
		onePersonActive = "Feature.Squads.Description.OnePersonActive",
		partyStarted = "Feature.Squads.Label.PartyStartedText"
	})

	local v4 = React.useCallback(function(list)
		local images = {}

		for _, item in ipairs(list) do
			table.insert(images, {
				Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(item))),
				BackgroundColor3 = v2.Color.Surface.Surface_200.Color3:lerp(
					v2.Color.ActionStandard.Background.Color3,
					1 - v2.Color.ActionStandard.Background.Transparency
				)
			})
		end

		local createElement = React.createElement
		local imageBorderColor

		if v2.Config.Theme.IsUIBlox == "true" then
			imageBorderColor = v2.Color.Shift.Shift_200.Color3
		else
			imageBorderColor = v2.Color.Surface.Surface_200.Color3
		end

		return createElement(ImagePile, { images = images, imageBorderColor = imageBorderColor })
	end, {})

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v2.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = {
			bottom = UDim.new(0, v2.Padding.Medium),
			left = UDim.new(0, v2.Padding.Large),
			right = UDim.new(0, v2.Padding.Large),
			top = UDim.new(0, v2.Padding.Medium)
		},
		selection = { Selectable = true },
		tag = "bg-shift-200 radius-large"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v2.Gap.Large),
			VerticalAlignment = Enum.VerticalAlignment.Center
		},
		LayoutOrder = 1
	}
	local thumbnail

	if #props.participantUserIds > 0 then
		thumbnail = React.createElement(
			Foundation.View,
			{
				Size = UDim2.fromOffset(v2.Size.Size_1000, v2.Size.Size_1000),
				LayoutOrder = 1
			},
			{ v4(props.participantUserIds) }
		)
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v7 = { AutomaticSize = Enum.AutomaticSize.Y, Size = 0, layout = 0, LayoutOrder = 2 }
	local size

	if #props.participantUserIds > 0 then
		size = UDim2.new(1, -v2.Size.Size_1000 - v2.Padding.Large, 0, 0)
	else
		size = UDim2.fromScale(1, 0)
	end

	v7.Size = size

	v7.layout = {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v2.Gap.XSmall),
		SortOrder = Enum.SortOrder.LayoutOrder
	}

	local v8 = {
		Title = React.createElement(Foundation.Text, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v2.Color.None,
			fontStyle = v2.Typography.TitleMedium,
			LayoutOrder = 1,
			Text = v3.partyStarted,
			textStyle = v2.Color.Content.Emphasis,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Status = 0
	}

	local createElement4 = React.createElement
	local text = Foundation.Text
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v2.Color.None,
		fontStyle = v2.Typography.LabelSmall,
		LayoutOrder = 2,
		Text = 0,
		textStyle = 0,
		TextTruncate = 0
	}
	local text2

	if #props.participantUserIds == 1 then
		text2 = v3.onePersonActive
	else
		text2 = v3.manyPeopleActive
	end

	v9.Text = text2

	v9.textStyle = v2.Color.Content.Muted
	v9.TextTruncate = Enum.TextTruncate.AtEnd
	v8.Status = createElement4(text, v9)
	return createElement(view, v5, {
		InfoContainer = createElement2(view2, v6, {
			Thumbnail = thumbnail,
			TextContainer = createElement3(view3, v7, v8)
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
					v.navigate("SquadLobby", { conversationId = props.conversationId })
				end,
				shouldAnimate = false,
				squadButtonSource = SquadButtonSourceEnum.PartyStartedCard,
				squadLocation = props.squadLocation
			})
		})
	})
end

return SquadStartedCard

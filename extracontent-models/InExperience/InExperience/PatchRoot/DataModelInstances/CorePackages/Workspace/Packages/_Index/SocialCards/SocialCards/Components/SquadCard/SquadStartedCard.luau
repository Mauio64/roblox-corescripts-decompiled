local Parent = script:FindFirstAncestor("SocialCards").Parent
local Foundation = require(Parent.Foundation)
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local ImagePile = require(Parent.AppBlox).ImagePile
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local SquadJoinButton = require(Parent.Squads.SquadJoinButton)
local SquadComponentAccessWrapper = require(Parent.Squads.SquadComponentAccessWrapper)
local SquadButtonSourceEnum = require(Parent.Squads.Enums).SquadButtonSourceEnum

local function SquadStartedCard(t1: {[any]: any}) -- line: 23
	-- upvalues: useNavigation (copy), useTokens (copy), useLocalization (copy), React (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), ImagePile (copy), Foundation (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy)
	local v14 = useNavigation()
	local v15 = useTokens()
	local v16 = useLocalization({
		onePersonActive = "Feature.Squads.Description.OnePersonActive",
		partyStarted = "Feature.Squads.Label.PartyStartedText",
		manyPeopleActive = {
			"Feature.Squads.Description.ManyPeopleActive",
			userCount = #t1.participantUserIds
		}
	})
	local v17 = React.useCallback(function(p1) -- line: 32
		-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy), v15 (copy), React (copy), ImagePile (copy)
		local t2 = {}

		for _, v in ipairs(p1) do
			table.insert(t2, {
				Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(v))),
				BackgroundColor3 = v15.Color.Surface.Surface_200.Color3:lerp(v15.Color.ActionStandard.Background.Color3, 1 - v15.Color.ActionStandard.Background.Transparency)
			})
		end

		return React.createElement(ImagePile, {
			images = t2,
			imageBorderColor = if v15.Config.Theme.IsUIBlox ~= "true" then v15.Color.Surface.Surface_200.Color3 else v15.Color.Shift.Shift_200.Color3
		})
	end, {})

	return React.createElement(Foundation.View, {
		tag = "bg-shift-200 radius-large",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v15.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = {
			bottom = UDim.new(0, v15.Padding.Medium),
			left = UDim.new(0, v15.Padding.Large),
			right = UDim.new(0, v15.Padding.Large),
			top = UDim.new(0, v15.Padding.Medium)
		},
		selection = {
			Selectable = true
		}
	}, {
		InfoContainer = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v15.Gap.Large),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}
		}, {
			Thumbnail = if not (#t1.participantUserIds > 0) then nil else React.createElement(Foundation.View, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v15.Size.Size_1000, v15.Size.Size_1000)
			}, { v17(t1.participantUserIds) }),
			TextContainer = React.createElement(Foundation.View, {
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = if not (#t1.participantUserIds > 0) then UDim2.fromScale(1, 0) else UDim2.new(1, -v15.Size.Size_1000 - v15.Padding.Large, 0, 0),
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v15.Gap.XSmall),
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Title = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					backgroundStyle = v15.Color.None,
					fontStyle = v15.Typography.TitleMedium,
					Text = v16.partyStarted,
					textStyle = v15.Color.Content.Emphasis,
					TextTruncate = Enum.TextTruncate.AtEnd
				}),
				Status = React.createElement(Foundation.Text, {
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY,
					backgroundStyle = v15.Color.None,
					fontStyle = v15.Typography.LabelSmall,
					Text = if #t1.participantUserIds ~= 1 then v16.manyPeopleActive else v16.onePersonActive,
					textStyle = v15.Color.Content.Muted,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			})
		}),
		ActionButton = React.createElement(SquadComponentAccessWrapper, {
			parentChannelId = t1.conversationId
		}, { React.createElement(SquadJoinButton, {
			isFullWidth = true,
			isInCard = true,
			layoutOrder = 3,
			shouldAnimate = false,
			conversationId = t1.conversationId,
			onActivated = function() -- line: 133
				-- upvalues: v14 (copy), t1 (copy)
				v14.navigate("SquadLobby", {
					conversationId = t1.conversationId
				})
			end,
			squadButtonSource = SquadButtonSourceEnum.PartyStartedCard,
			squadLocation = t1.squadLocation
		}) })
	})
end

return SquadStartedCard

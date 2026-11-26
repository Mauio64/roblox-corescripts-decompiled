local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function fn(p2)
	return React.createElement(React.Fragment, nil, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = p2.Theme.BackgroundUIDefault.Color,
			Transparency = p2.Theme.BackgroundUIDefault.Transparency,
			Thickness = 2
		})
	})
end

local function fn2(friends, p2)
	local children = {}

	if not friends then
		return nil, nil
	end

	local count = 0

	for k, item in pairs(friends) do
		count += 1
		local v5 = tostring(item)

		if not (count <= 3) then
			continue
		end

		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			v5,
			constants.RbxthumbTypes.AvatarHeadShot,
			100
		)

		children["mini_avatar_" .. v5] = React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, count * 16 / 2, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 0,
			Image = rbxthumbWithTypeSizeAndOptions,
			BackgroundColor3 = Color3.fromRGB(209, 209, 209),
			ZIndex = 4 - count
		}, { fn(p2) })
	end

	children.online_indicator = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 180, 109),
		ZIndex = 4
	}, {
		fn(p2),
		InExperienceCounter = React.createElement(styledTextLabel, {
			colorStyle = p2.Theme.TextEmphasis,
			fontStyle = p2.Font.Footer,
			textXAlignment = Enum.TextXAlignment.Center,
			size = UDim2.fromScale(1, 1),
			lineHeight = 1,
			text = tostring(count),
			textTruncate = Enum.TextTruncate.None,
			richText = false
		})
	})

	return
		React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1
			},
			children
		),
		count
end

return function(p2)
	local v5 = useStyle()
	local font = v5.Font
	local v6, v7 = fn2(p2.friends, v5)
	local v8 = useLocalization({ friendsText = "CommonUI.Features.Label.Friends" })

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6)
		}),
		PresenceList = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, math.min(3, v7 or 0) * 16 / 2 + 16, 0, 22),
			LayoutOrder = 1
		}, { ActiveFriends = v6 }),
		FriendsLabel = React.createElement(styledTextLabel, {
			colorStyle = v5.Theme.TextMuted,
			fontStyle = font.CaptionHeader,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, -40, 0, font.BaseSize * font.CaptionHeader.RelativeSize),
			lineHeight = 1,
			text = v8.friendsText,
			textTruncate = Enum.TextTruncate.AtEnd,
			richText = false,
			layoutOrder = 2
		})
	})
end

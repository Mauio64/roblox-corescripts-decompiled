local parent = script:FindFirstAncestor("GameTile").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function fn(p)
	return React.createElement(React.Fragment, nil, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = p.Theme.BackgroundUIDefault.Color,
			Transparency = p.Theme.BackgroundUIDefault.Transparency,
			Thickness = 2
		})
	})
end

local function fn2(friends, p)
	local children = {}

	if not friends then
		return nil, nil
	end

	local count = 0

	for _, item in pairs(friends) do
		count += 1
		local v = tostring(item)

		if not (count <= 3) then
			continue
		end

		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			v,
			Constants.RbxthumbTypes.AvatarHeadShot,
			100
		)

		children["mini_avatar_" .. v] = React.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, count * 16 / 2, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 0,
			Image = rbxthumbWithTypeSizeAndOptions,
			BackgroundColor3 = Color3.fromRGB(209, 209, 209),
			ZIndex = 4 - count
		}, { fn(p) })
	end

	children.online_indicator = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 180, 109),
		ZIndex = 4
	}, {
		fn(p),
		InExperienceCounter = React.createElement(StyledTextLabel, {
			colorStyle = p.Theme.TextEmphasis,
			fontStyle = p.Font.Footer,
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

return function(p)
	local v = useStyle()
	local font = v.Font
	local activeFriends, v2 = fn2(p.friends, v)
	local v3 = useLocalization({ friendsText = "CommonUI.Features.Label.Friends" })

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
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
			Size = UDim2.new(0, math.min(3, v2 or 0) * 16 / 2 + 16, 0, 22),
			LayoutOrder = 1
		}, { ActiveFriends = activeFriends }),
		FriendsLabel = React.createElement(StyledTextLabel, {
			colorStyle = v.Theme.TextMuted,
			fontStyle = font.CaptionHeader,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, -40, 0, font.BaseSize * font.CaptionHeader.RelativeSize),
			lineHeight = 1,
			text = v3.friendsText,
			textTruncate = Enum.TextTruncate.AtEnd,
			richText = false,
			layoutOrder = 2
		})
	})
end

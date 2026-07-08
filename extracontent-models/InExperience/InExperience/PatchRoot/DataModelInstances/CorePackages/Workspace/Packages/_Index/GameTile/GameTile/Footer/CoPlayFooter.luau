local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UserLib = require(Parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function v11(p1) -- line: 24
	-- upvalues: React (copy)
	return React.createElement(React.Fragment, nil, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Border = React.createElement("UIStroke", {
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = p1.Theme.BackgroundUIDefault.Color,
			Transparency = p1.Theme.BackgroundUIDefault.Transparency
		})
	})
end
local function v12(p2, p3) -- line: 38
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), React (copy), ImageSetLabel (copy), v11 (copy), StyledTextLabel (copy)
	local t1 = {}

	if p2 then
		local n1 = 0

		for _, v in pairs(p2) do
			n1 += 1

			local str = tostring(v)

			if n1 <= 3 then
				local v21 = getRbxthumbWithTypeSizeAndOptions(str, Constants.RbxthumbTypes.AvatarHeadShot, 100)

				t1["mini_avatar_" .. str] = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 0,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, n1 * 16 / 2, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					Image = v21,
					BackgroundColor3 = Color3.fromRGB(209, 209, 209),
					ZIndex = 4 - n1
				}, { v11(p3) })
			end
		end

		t1.online_indicator = React.createElement("Frame", {
			BackgroundTransparency = 0,
			ZIndex = 4,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = Color3.fromRGB(0, 180, 109)
		}, {
			v11(p3),
			InExperienceCounter = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				richText = false,
				colorStyle = p3.Theme.TextEmphasis,
				fontStyle = p3.Font.Footer,
				textXAlignment = Enum.TextXAlignment.Center,
				size = UDim2.fromScale(1, 1),
				text = tostring(n1),
				textTruncate = Enum.TextTruncate.None
			})
		})

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, t1), n1
	end

	return nil, nil
end

return function(t2: {[any]: any}) -- line: 99
	-- upvalues: useStyle (copy), v12 (copy), useLocalization (copy), React (copy), StyledTextLabel (copy)
	local v23 = useStyle()
	local Font = v23.Font
	local v25, v26 = v12(t2.friends, v23)
	local v27 = useLocalization({
		friendsText = "CommonUI.Features.Label.Friends"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
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
			LayoutOrder = 1,
			Size = UDim2.new(0, math.min(3, v26 or 0) * 16 / 2 + 16, 0, 22)
		}, {
			ActiveFriends = v25
		}),
		FriendsLabel = React.createElement(StyledTextLabel, {
			lineHeight = 1,
			richText = false,
			layoutOrder = 2,
			colorStyle = v23.Theme.TextMuted,
			fontStyle = Font.CaptionHeader,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, -40, 0, Font.BaseSize * Font.CaptionHeader.RelativeSize),
			text = v27.friendsText,
			textTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

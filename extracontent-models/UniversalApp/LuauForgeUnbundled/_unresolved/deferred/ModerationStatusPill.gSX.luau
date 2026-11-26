local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dPN")

local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function getIconForModerationStatus(p2): nil | string
	if p2 == module.ModerationStatus.PendingModeration then
		return "icons/status/pending_small"
	end

	if p2 == module.ModerationStatus.Moderated then
		return "icons/actions/info_small"
	end

	return nil
end

local function getDangerStyleForModerationStatus(p2): boolean
	return p2 == module.ModerationStatus.Moderated
end

local function ModerationStatusPill(props)
	local v5 = useStyle()
	local theme = v5.Theme

	local size_300 = v5.Tokens.Size.Size_300
	local size_150 = v5.Tokens.Size.Size_150
	local size_150_2 = v5.Tokens.Size.Size_150
	local size_250 = v5.Tokens.Size.Size_250
	local v6 = useLocalization({
		moderated = "Feature.Catalog.Message.AvatarModerationModerated",
		underReview = "Feature.Catalog.Message.AvatarModerationPending"
	})

	local moderationStatus = props.moderationStatus
	local v7 = moderationStatus == module.ModerationStatus.PendingModeration
		and "icons/status/pending_small"
		or moderationStatus == module.ModerationStatus.Moderated and "icons/actions/info_small"
		or nil

	local v8 = moderationStatus == module.ModerationStatus.Moderated
	local v9

	if moderationStatus == module.ModerationStatus.Moderated then
		v9 = v6.moderated
	else
		v9 = v6.underReview
	end

	if v7 == nil then
		return nil
	end

	local font = v5.Font
	local iconSize2 = getIconSize(iconSize.Small)
	local baseSize = font.BaseSize
	local v10 = font.CaptionHeader.RelativeSize * baseSize

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = theme.BackgroundUIDefault.Color,
		BackgroundTransparency = props.hideBackground and 1 or 0.5,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Position = UDim2.new(0, 0, 0, size_250)
	}
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_300),
			PaddingRight = UDim.new(0, size_300),
			PaddingTop = UDim.new(0, size_150),
			PaddingBottom = UDim.new(0, size_150)
		}),
		Content = 0,
		UICorner = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}

	local v15 = {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, size_150_2),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Icon = 0,
		PillText = 0
	}

	local createElement3 = React.createElement
	local v17 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(iconSize2, iconSize2),
		BackgroundTransparency = 1,
		Image = images[v7],
		ImageColor3 = 0,
		ImageTransparency = 0
	}
	local v18 = if v8 then theme.Alert.Color else theme.IconEmphasis.Color
	v17.ImageColor3 = v18
	v17.ImageTransparency = theme.IconEmphasis.Transparency
	v15.Icon = createElement3(imageSetLabel, v17)
	local v19

	if not props.iconOnly then
		local createElement4 = React.createElement
		local v21 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = v10,
			Text = v9,
			FontFace = normalizeFontFace(v5.Tokens.Typography.CaptionLarge.Font),
			BackgroundTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v22 = if v8 then theme.Alert.Color else theme.IconEmphasis.Color
		v21.TextColor3 = v22
		v21.TextXAlignment = Enum.TextXAlignment.Left
		v21.TextYAlignment = Enum.TextYAlignment.Center
		v19 = createElement4("TextLabel", v21)
	end

	v15.PillText = v19
	children.Content = createElement2("Frame", v14, v15)

	children.UICorner = React.createElement("UICorner", {
		CornerRadius = UDim.new(1, 0)
	})
	return createElement("Frame", v12, children)
end

return ModerationStatusPill

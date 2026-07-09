local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Common = Modules.AvatarExperience.Common

require(Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function getIconForModerationStatus(p1) -- line: 33
	-- upvalues: Constants (copy)
	if p1 == Constants.ModerationStatus.PendingModeration then
		return "icons/status/pending_small"
	end

	if p1 == Constants.ModerationStatus.Moderated then
		return "icons/actions/info_small"
	end

	return nil
end
local function getDangerStyleForModerationStatus(p2) -- line: 43
	-- upvalues: Constants (copy)
	if p2 == Constants.ModerationStatus.Moderated then
		return true
	end

	return false
end
local function ModerationStatusPill(t1: {[any]: any}) -- line: 51
	-- upvalues: useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useLocalization (copy), Constants (copy), getIconSize (copy), IconSize (copy), React (copy), ImageSetLabel (copy), Images (copy)
	local v20 = useStyle()
	local Theme = v20.Theme
	local v22 = if not FFlagRenameDeprecatedUIBloxTokens then v20.Tokens.Global.Space_150 else v20.Tokens.Size.Size_300
	local v23 = if not FFlagRenameDeprecatedUIBloxTokens then v20.Tokens.Global.Space_75 else v20.Tokens.Size.Size_150
	local v24 = if not FFlagRenameDeprecatedUIBloxTokens then v20.Tokens.Global.Space_75 else v20.Tokens.Size.Size_150
	local v25 = if not FFlagRenameDeprecatedUIBloxTokens then v20.Tokens.Global.Space_125 else v20.Tokens.Size.Size_250
	local v26 = useLocalization({
		moderated = "Feature.Catalog.Message.AvatarModerationModerated",
		underReview = "Feature.Catalog.Message.AvatarModerationPending"
	})
	local moderationStatus = t1.moderationStatus
	local v28 = if moderationStatus ~= Constants.ModerationStatus.PendingModeration then if moderationStatus ~= Constants.ModerationStatus.Moderated then nil else "icons/actions/info_small" else "icons/status/pending_small"
	local v29 = moderationStatus == Constants.ModerationStatus.Moderated
	local v30 = if moderationStatus ~= Constants.ModerationStatus.Moderated then v26.underReview else v26.moderated

	if v28 == nil then
		return nil
	end

	local Font = v20.Font
	local v32 = getIconSize(IconSize.Small)
	local BaseSize = Font.BaseSize
	local v34 = Font.CaptionHeader.RelativeSize * BaseSize

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = not t1.hideBackground and 0.5 or 1,
		Position = UDim2.new(0, 0, 0, v25)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v22),
			PaddingRight = UDim.new(0, v22),
			PaddingTop = UDim.new(0, v23),
			PaddingBottom = UDim.new(0, v23)
		}),
		Content = React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v24),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Icon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(v32, v32),
				Image = Images[v28],
				ImageColor3 = if not v29 then Theme.IconEmphasis.Color else Theme.Alert.Color,
				ImageTransparency = Theme.IconEmphasis.Transparency
			}),
			PillText = if not t1.iconOnly then React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = v34,
				Text = v30,
				Font = Font.CaptionHeader.Font,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextColor3 = if not v29 then Theme.IconEmphasis.Color else Theme.Alert.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}) else nil
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end

return ModerationStatusPill

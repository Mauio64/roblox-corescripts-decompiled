local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent
local connection = parent.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local FFlagPlayerListFixDropDownVerifiedBadgeSize = require(parent.Parent.Flags.FFlagPlayerListFixDropDownVerifiedBadgeSize)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local useVerifiedBadge = UserProfiles.Hooks.useVerifiedBadge

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji

local extended = Roact.PureComponent:extend("DropDownPlayerHeader")

extended.validateProps = t.strictInterface({
	player = t.instanceIsA("Player"),
	showVerifiedBadge = t.optional(t.boolean)
})

function extended.render(p)
	return WithLayoutValues(function(data)
		return withFoundationOrUIBloxStyle(function(tokens)
			return {
				Tokens = tokens,
				Theme = {
					Divider = {
						Color = tokens.Color.Stroke.Emphasis.Color3,
						Transparency = tokens.Color.Stroke.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = tokens.Color.Content.Emphasis.Color3,
						Transparency = tokens.Color.Content.Emphasis.Transparency
					},
					TextMuted = {
						Color = tokens.Color.Content.Muted.Color3,
						Transparency = tokens.Color.Content.Muted.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					CaptionHeader = {
						Font = tokens.Typography.CaptionLarge.Font,
						RelativeSize = tokens.Typography.CaptionLarge.FontSize
					},
					Footer = {
						Font = tokens.Typography.CaptionSmall.Font,
						RelativeSize = tokens.Typography.CaptionSmall.FontSize
					},
					Header2 = {
						Font = tokens.Typography.TitleLarge.Font,
						RelativeSize = tokens.Typography.TitleLarge.FontSize,
						FontSize = tokens.Typography.TitleLarge.FontSize,
						LineHeight = tokens.Typography.TitleLarge.LineHeight,
						LetterSpacing = tokens.Typography.TitleLarge.LetterSpacing
					}
				}
			}
		end, function(props)
			local player = p.props.player
			local v

			if FFlagEnableVerifiedBadgeStore then
				v = p.props.showVerifiedBadge
			else
				v = UserLib.Utils.isPlayerVerified(player)
			end

			local join = Cryo.Dictionary.join
			local header2 = props.Font.Header2
			local v2 = { Font = props.Tokens.Typography.TitleLarge.Font, RelativeSize = 0 }
			local relativeSize

			if FFlagPlayerListFixDropDownVerifiedBadgeSize and FFlagCoreUiMigrateUIBloxToFoundation then
				relativeSize = Cryo.None
			end

			v2.RelativeSize = relativeSize
			local fontStyle = join(header2, v2)

			return Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				Text = "",
				Size = UDim2.new(1, 0, 0, data.DropDownHeaderSizeY),
				LayoutOrder = 0,
				Selectable = false
			}, {
				Background = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/PlayerList/NewAvatarBackground.png",
					ImageTransparency = 0,
					Size = UDim2.new(1, 0, 0, data.DropDownHeaderBackgroundSize),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				}, {
					TextContainerFrame = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -124, 1, 0),
							Position = UDim2.new(0, 107, 0, 0)
						},
						{
							Layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								Padding = UDim.new(0, 0),
								VerticalAlignment = Enum.VerticalAlignment.Center
							}),
							DisplayName = v and Roact.createElement(EmojiTextLabel, {
								fontStyle = fontStyle,
								colorStyle = props.Theme.TextEmphasis,
								fluidSizing = false,
								emoji = Emoji.Verified,
								maxSize = Vector2.new(data.PlayerDropDownSizeX - 124, 22),
								LayoutOrder = 1,
								Text = player.DisplayName,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								BackgroundTransparency = 1,
								TextScaled = true
							}) or Roact.createElement("TextLabel", {
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, 22),
								Text = player.DisplayName,
								FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
								TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
								TextColor3 = props.Theme.TextEmphasis.Color,
								TextTransparency = props.Theme.TextEmphasis.Transparency,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								BackgroundTransparency = 1,
								TextScaled = true
							}, {
								SizeConstraint = Roact.createElement("UITextSizeConstraint", {
									MaxTextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
									MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
								})
							}),
							PlayerName = Roact.createElement("TextLabel", {
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, 22),
								Text = "@" .. player.Name,
								FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
								TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
								TextColor3 = props.Theme.TextMuted.Color,
								TextTransparency = props.Theme.TextMuted.Transparency,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								BackgroundTransparency = 1,
								TextScaled = true
							}, {
								SizeConstraint = Roact.createElement("UITextSizeConstraint", {
									MaxTextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
									MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
								})
							})
						}
					)
				}),
				AvatarImage = Roact.createElement("ImageLabel", {
					Position = UDim2.new(0, 56, 0, 0),
					Size = UDim2.new(0, data.DropDownHeaderSizeY, 0, data.DropDownHeaderSizeY),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150",
					ZIndex = 2
				}),
				Divider = not p.props.lastButton and Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = props.Theme.Divider.Transparency,
					BackgroundColor3 = props.Theme.Divider.Color,
					BorderSizePixel = 0,
					ZIndex = 3
				})
			})
		end)
	end)
end

local function fn(p)
	local showVerifiedBadge = useVerifiedBadge(p.player)

	return Roact.createElement(extended, Cryo.Dictionary.join(p, {
		showVerifiedBadge = showVerifiedBadge
	}))
end

return if FFlagEnableVerifiedBadgeStore then fn else extended

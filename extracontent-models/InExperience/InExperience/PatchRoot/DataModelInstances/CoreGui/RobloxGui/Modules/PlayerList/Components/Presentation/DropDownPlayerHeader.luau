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
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji

local extended = Roact.PureComponent:extend("DropDownPlayerHeader")

extended.validateProps = t.strictInterface({
	player = t.instanceIsA("Player"),
	showVerifiedBadge = t.optional(t.boolean)
})

function extended.render(p)
	return WithLayoutValues(function(data)
		return withFoundationOrUIBloxStyle(function(p2)
			local tokens

			if FoundationFontFaceMigration then
				tokens = p2
			end

			return {
				Tokens = tokens,
				Theme = {
					Divider = {
						Color = p2.Color.Stroke.Emphasis.Color3,
						Transparency = p2.Color.Stroke.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p2.Color.Content.Emphasis.Color3,
						Transparency = p2.Color.Content.Emphasis.Transparency
					},
					TextMuted = {
						Color = p2.Color.Content.Muted.Color3,
						Transparency = p2.Color.Content.Muted.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					CaptionHeader = {
						Font = p2.Typography.CaptionLarge.Font,
						RelativeSize = p2.Typography.CaptionLarge.FontSize
					},
					Footer = {
						Font = p2.Typography.CaptionSmall.Font,
						RelativeSize = p2.Typography.CaptionSmall.FontSize
					},
					Header2 = {
						Font = p2.Typography.TitleLarge.Font,
						RelativeSize = p2.Typography.TitleLarge.FontSize,
						FontSize = p2.Typography.TitleLarge.FontSize,
						LineHeight = p2.Typography.TitleLarge.LineHeight,
						LetterSpacing = p2.Typography.TitleLarge.LetterSpacing
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

			local fontStyle

			if FoundationFontFaceMigration then
				local join = Cryo.Dictionary.join
				local header2 = props.Font.Header2
				local v2 = { Font = props.Tokens.Typography.TitleLarge.Font, RelativeSize = 0 }
				local relativeSize

				if FFlagPlayerListFixDropDownVerifiedBadgeSize and FFlagCoreUiMigrateUIBloxToFoundation then
					relativeSize = Cryo.None
				end

				v2.RelativeSize = relativeSize
				fontStyle = join(header2, v2)
			elseif FFlagCoreUiMigrateUIBloxToFoundation and props.Font.Header2.FontSize then
				fontStyle = {
					Font = props.Font.Header2.Font,
					FontSize = props.Font.Header2.FontSize,
					LineHeight = props.Font.Header2.LineHeight,
					LetterSpacing = props.Font.Header2.LetterSpacing
				}
			else
				fontStyle = props.Font.Header2
			end

			local createElement = Roact.createElement
			local v2 = {
				BackgroundTransparency = 1,
				Text = "",
				Size = UDim2.new(1, 0, 0, data.DropDownHeaderSizeY),
				LayoutOrder = 0,
				Selectable = false
			}

			local createElement2 = Roact.createElement
			local v3 = {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/PlayerList/NewAvatarBackground.png",
				ImageTransparency = 0,
				Size = UDim2.new(1, 0, 0, data.DropDownHeaderBackgroundSize),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}

			local createElement3 = Roact.createElement
			local v4 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -124, 1, 0),
				Position = UDim2.new(0, 107, 0, 0)
			}
			local v5 = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 0),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				DisplayName = 0,
				PlayerName = 0
			}

			local displayName = v and Roact.createElement(EmojiTextLabel, {
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
			})

			if not displayName then
				local createElement4 = Roact.createElement
				local v6 = {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 22),
					Text = player.DisplayName,
					Font = 0,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextTruncate = 0,
					BackgroundTransparency = 1,
					TextScaled = true
				}
				local font

				if not FoundationFontFaceMigration then
					font = props.Font.Header2.Font
				end

				v6.Font = font
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
				end

				v6.FontFace = fontFace

				v6.TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
				v6.TextColor3 = props.Theme.TextEmphasis.Color
				v6.TextTransparency = props.Theme.TextEmphasis.Transparency
				v6.TextXAlignment = Enum.TextXAlignment.Left
				v6.TextTruncate = Enum.TextTruncate.AtEnd
				displayName = createElement4("TextLabel", v6, {
					SizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
						MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
					})
				})
			end

			v5.DisplayName = displayName

			local createElement4 = Roact.createElement
			local v6 = {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 22),
				Text = "@" .. player.Name,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextXAlignment = 0,
				TextTruncate = 0,
				BackgroundTransparency = 1,
				TextScaled = true
			}
			local font

			if not FoundationFontFaceMigration then
				font = props.Font.CaptionHeader.Font
			end

			v6.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font)
			end

			v6.FontFace = fontFace

			v6.TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
			v6.TextColor3 = props.Theme.TextMuted.Color
			v6.TextTransparency = props.Theme.TextMuted.Transparency
			v6.TextXAlignment = Enum.TextXAlignment.Left
			v6.TextTruncate = Enum.TextTruncate.AtEnd
			v5.PlayerName = createElement4("TextLabel", v6, {
				SizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MaxTextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
					MinTextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
				})
			})
			return createElement("TextButton", v2, {
				Background = createElement2("ImageLabel", v3, {
					TextContainerFrame = createElement3("Frame", v4, v5)
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

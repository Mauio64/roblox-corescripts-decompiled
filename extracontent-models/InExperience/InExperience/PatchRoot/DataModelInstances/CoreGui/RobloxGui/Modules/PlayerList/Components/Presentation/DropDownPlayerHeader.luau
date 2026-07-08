local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Cryo = require(CorePackages.Packages.Cryo)
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Connection = script.Parent.Parent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local useVerifiedBadge = require(CorePackages.Workspace.Packages.UserProfiles).Hooks.useVerifiedBadge
local FFlagEnableVerifiedBadgeStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableVerifiedBadgeStore
local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji
local v14 = Roact.PureComponent:extend("DropDownPlayerHeader")

v14.validateProps = t.strictInterface({
	player = t.instanceIsA("Player"),
	showVerifiedBadge = t.optional(t.boolean)
})

function v14.render(p1) -- line: 37
	-- upvalues: WithLayoutValues (copy), withFoundationOrUIBloxStyle (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy)
	return WithLayoutValues(function(p2) -- line: 38
		-- upvalues: withFoundationOrUIBloxStyle (copy), p1 (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy)
		return withFoundationOrUIBloxStyle(function(p3) -- line: 39
			return {
				Theme = {
					Divider = {
						Color = p3.Color.Stroke.Emphasis.Color3,
						Transparency = p3.Color.Stroke.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p3.Color.Content.Emphasis.Color3,
						Transparency = p3.Color.Content.Emphasis.Transparency
					},
					TextMuted = {
						Color = p3.Color.Content.Muted.Color3,
						Transparency = p3.Color.Content.Muted.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					CaptionHeader = {
						Font = p3.Typography.CaptionLarge.Font,
						RelativeSize = p3.Typography.CaptionLarge.FontSize
					},
					Footer = {
						Font = p3.Typography.CaptionSmall.Font,
						RelativeSize = p3.Typography.CaptionSmall.FontSize
					},
					Header2 = {
						Font = p3.Typography.TitleLarge.Font,
						RelativeSize = p3.Typography.TitleLarge.FontSize
					}
				}
			}
		end, function(p4) -- line: 71
			-- upvalues: p1 (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), Roact (copy), p2 (copy), EmojiTextLabel (copy), Emoji (copy)
			local player = p1.props.player
			local v22 = if not FFlagEnableVerifiedBadgeStore then UserLib.Utils.isPlayerVerified(player) else p1.props.showVerifiedBadge

			return Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				Text = "",
				LayoutOrder = 0,
				Selectable = false,
				Size = UDim2.new(1, 0, 0, p2.DropDownHeaderSizeY)
			}, {
				Background = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/PlayerList/NewAvatarBackground.png",
					ImageTransparency = 0,
					Size = UDim2.new(1, 0, 0, p2.DropDownHeaderBackgroundSize),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				}, {
					TextContainerFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -124, 1, 0),
						Position = UDim2.new(0, 107, 0, 0)
					}, {
						Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 0),
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						DisplayName = v22 and Roact.createElement(EmojiTextLabel, {
							fluidSizing = false,
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextScaled = true,
							fontStyle = p4.Font.Header2,
							colorStyle = p4.Theme.TextEmphasis,
							emoji = Emoji.Verified,
							maxSize = Vector2.new(p2.PlayerDropDownSizeX - 124, 22),
							Text = player.DisplayName,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd
						}) or Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextScaled = true,
							Size = UDim2.new(1, 0, 0, 22),
							Text = player.DisplayName,
							Font = p4.Font.Header2.Font,
							TextSize = p4.Font.BaseSize * p4.Font.Header2.RelativeSize,
							TextColor3 = p4.Theme.TextEmphasis.Color,
							TextTransparency = p4.Theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd
						}, {
							SizeConstraint = Roact.createElement("UITextSizeConstraint", {
								MaxTextSize = p4.Font.BaseSize * p4.Font.Header2.RelativeSize,
								MinTextSize = p4.Font.BaseSize * p4.Font.Footer.RelativeSize
							})
						}),
						PlayerName = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							TextScaled = true,
							Size = UDim2.new(1, 0, 0, 22),
							Text = "@" .. player.Name,
							Font = p4.Font.CaptionHeader.Font,
							TextSize = p4.Font.BaseSize * p4.Font.CaptionHeader.RelativeSize,
							TextColor3 = p4.Theme.TextMuted.Color,
							TextTransparency = p4.Theme.TextMuted.Transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd
						}, {
							SizeConstraint = Roact.createElement("UITextSizeConstraint", {
								MaxTextSize = p4.Font.BaseSize * p4.Font.CaptionHeader.RelativeSize,
								MinTextSize = p4.Font.BaseSize * p4.Font.Footer.RelativeSize
							})
						})
					})
				}),
				AvatarImage = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Position = UDim2.new(0, 56, 0, 0),
					Size = UDim2.new(0, p2.DropDownHeaderSizeY, 0, p2.DropDownHeaderSizeY),
					AnchorPoint = Vector2.new(0.5, 0),
					Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
				}),
				Divider = not p1.props.lastButton and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 3,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = p4.Theme.Divider.Transparency,
					BackgroundColor3 = p4.Theme.Divider.Color
				})
			})
		end)
	end)
end

if FFlagEnableVerifiedBadgeStore then
	return function(p5) -- line: 181
		-- upvalues: useVerifiedBadge (copy), Roact (copy), v14 (copy), Cryo (copy)
		local v17 = useVerifiedBadge(p5.player)

		return Roact.createElement(v14, Cryo.Dictionary.join(p5, {
			showVerifiedBadge = v17
		}))
	end
end

return v14

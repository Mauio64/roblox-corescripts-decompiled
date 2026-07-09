local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Parent.Localization).withLocalization
local Text = require(Parent.AppCommonLib).Text
local VerifiedBadges = require(Parent.VerifiedBadges)
local v9 = Roact.PureComponent:extend("ItemTileCreatorName")

v9.defaultProps = {
	textYAlignment = Enum.TextYAlignment.Top
}

function v9.render(p1) -- line: 20
	-- upvalues: withStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), withLocalization (copy), Text (copy), Roact (copy), VerifiedBadges (copy)
	local name = p1.props.name
	local hasVerifiedBadge = p1.props.hasVerifiedBadge
	local textYAlignment = p1.props.textYAlignment

	return withStyle(function(p2) -- line: 25
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), withLocalization (copy), Text (copy), Roact (copy), hasVerifiedBadge (copy), name (copy), textYAlignment (copy), VerifiedBadges (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local v17 = p2Font.BaseSize * p2Font.Header2.RelativeSize
		local v18 = v17 + if not FFlagRenameDeprecatedUIBloxTokens then p2.Tokens.Global.Size_100 else p2.Tokens.Size.Size_200

		return withLocalization({
			creatorByLabel = "Feature.GameDetails.Label.By"
		})(function(p3) -- line: 38
			-- upvalues: Text (copy), p2Font (copy), v17 (copy), Roact (copy), hasVerifiedBadge (copy), Theme (copy), name (copy), textYAlignment (copy), v18 (copy), VerifiedBadges (copy)
			local creatorByLabel = p3.creatorByLabel
			local v21 = Text.GetTextWidth(creatorByLabel, p2Font.Body.Font, v17)
			local v22 = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = if not hasVerifiedBadge then UDim2.new(1, -v21, 1, 0) else UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = v17,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = p2Font.Header2.Font,
				Text = name,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = textYAlignment
			}, {
				UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MaxTextSize = v18
				})
			})

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 6)
				}),
				Label = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 0, 0),
					TextSize = v17,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					Font = p2Font.Header2.Font,
					Text = creatorByLabel,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = textYAlignment,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = v18
					})
				}),
				CreatorName = not hasVerifiedBadge and v22,
				VerifiedCreatorName = hasVerifiedBadge and Roact.createElement(VerifiedBadges.EmojiWrapper, {
					layoutOrder = 2,
					emoji = VerifiedBadges.emoji.verified,
					font = p2Font.Body.Font,
					size = UDim2.new(1, -v21, 0, 0),
					automaticSize = Enum.AutomaticSize.XY,
					horizontalAlignment = Enum.HorizontalAlignment.Left,
					verticalAlignment = Enum.VerticalAlignment.Center
				}, {
					CreatorName = v22
				})
			})
		end)
	end)
end

return v9

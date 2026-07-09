local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local UIBlox = require(DiscoveryMonolithParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(DiscoveryMonolithParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Dash = require(DiscoveryMonolithParent.Dash)
local GameTile = require(DiscoveryMonolithParent.GameTile)
local GridTileTextFooter = GameTile.GridTileTextFooter
local ExperienceFooter = GameTile.ExperienceFooter
local Modules = DiscoveryMonolith.Modules
local ItemTileCreatorName = require(Modules.LuaApp.Components.Common.ItemTileCreatorName)

return function(t1: {[any]: any}) -- line: 41
	-- upvalues: useStyle (copy), useTextSizeOffset (copy), React (copy), Dash (copy), GridTileTextFooter (copy), ExperienceFooter (copy), ItemTileCreatorName (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v15 = useStyle()
	local Font = v15.Font
	local Theme = v15.Theme
	local v18 = useTextSizeOffset()
	local v19 = t1.padding or 0
	local v20 = math.ceil(Font.BaseSize * Font.Header2.RelativeSize)
	local v21, v22 = React.useState(v20)

	React.useEffect(function() -- line: 51
		-- upvalues: v22 (copy), v20 (copy), v18 (copy)
		v22(v20 + v18)
	end, {
		v20,
		v18
	})

	local v23 = Dash.join(t1.footerData, {
		layoutOrder = 2,
		isStatsOnly = true,
		size = UDim2.new(0, 132, 0, v20)
	})
	local v24 = nil

	if t1.licenseDescription then
		v24 = React.createElement(GridTileTextFooter, {
			useLargerFont = true,
			LayoutOrder = 2,
			text = t1.licenseDescription
		})
	elseif t1.paidAccessDescription then
		v24 = React.createElement(GridTileTextFooter, {
			useLargerFont = true,
			LayoutOrder = 2,
			text = t1.paidAccessDescription
		})
	else
		React.createElement(ExperienceFooter, v23)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v19),
			PaddingLeft = if not t1.hasBackground then nil else UDim.new(0, v19),
			PaddingRight = if not t1.hasBackground then nil else UDim.new(0, v19),
			PaddingBottom = if not t1.hasBackground then nil else UDim.new(0, v19)
		}),
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v19)
		}),
		Title = if not t1.title or not (string.len(t1.title) > 0) then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v21),
			Text = t1.title,
			Font = Font.Header2.Font,
			TextSize = v20,
			TextTransparency = Theme.TextEmphasis.Transparency,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		Footer = v24,
		CreatorName = if not t1.creatorName then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v21)
		}, {
			Text = React.createElement(ItemTileCreatorName, {
				name = t1.creatorName,
				hasVerifiedBadge = t1.creatorVerified,
				creatorId = t1.creatorId
			})
		}),
		Description = if not t1.description or not (string.len(t1.description) > 0) then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, v21 * 3),
			Text = t1.description,
			Font = Font.Body.Font,
			TextSize = Font.BaseSize * Font.Body.RelativeSize,
			TextTransparency = Theme.TextDefault.Transparency,
			TextColor3 = Theme.TextDefault.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}, {
			UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = if not FFlagRenameDeprecatedUIBloxTokens then v15.Tokens.Global.FontSize_300 else v15.Tokens.FontSize.FontSize_600
			})
		})
	})
end

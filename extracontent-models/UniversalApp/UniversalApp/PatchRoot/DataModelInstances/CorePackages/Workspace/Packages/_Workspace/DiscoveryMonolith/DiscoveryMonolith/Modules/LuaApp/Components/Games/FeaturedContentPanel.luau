local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)
local UIBlox = require(DiscoveryMonolithParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(DiscoveryMonolithParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Dash = require(DiscoveryMonolithParent.Dash)
local ExperienceFooter = require(DiscoveryMonolithParent.GameTile).ExperienceFooter
local Modules = DiscoveryMonolith.Modules
local ItemTileCreatorName = require(Modules.LuaApp.Components.Common.ItemTileCreatorName)

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: useStyle (copy), useTextSizeOffset (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ArgCheck (copy), Dash (copy), ExperienceFooter (copy), ItemTileCreatorName (copy)
	local v14 = useStyle()
	local Font = v14.Font
	local Theme = v14.Theme
	local v17 = useTextSizeOffset()
	local v18, v19 = React.useState(2)
	local v20 = math.max(0, v18 - 2)
	local v21 = v18 > 3
	local v22 = v18 == 2
	local v23 = t1.padding or 0
	local v24 = math.ceil(Font.BaseSize * Font.Header2.RelativeSize)
	local v25, v26 = React.useState(v24)
	local v27 = if not FFlagRenameDeprecatedUIBloxTokens then v14.Tokens.Global.FontSize_300 else v14.Tokens.FontSize.FontSize_600

	React.useEffect(function() -- line: 76
		-- upvalues: v26 (copy), v24 (copy), v17 (copy)
		v26(v24 + v17)
	end, {
		v24,
		v17
	})

	local v28 = React.useCallback(function(p1) -- line: 81
		-- upvalues: v25 (copy), v23 (copy), v27 (copy), ArgCheck (copy), v19 (copy)
		if p1 and v25 > 0 then
			local AbsoluteSize = p1.AbsoluteSize
			local AbsoluteSizeX = AbsoluteSize.X
			local v34 = AbsoluteSize.Y - v23 - math.max(v23, 8) - AbsoluteSizeX - 48
			local v35 = math.floor(v34 / (v25 + 8))

			if v35 > 3 then
				local v36 = math.floor((v34 - math.floor(v34 - (v25 + 8) * 2)) / v27)

				ArgCheck.assert(v36 >= 0, "bodyRows should always be at least 0. Otherwise, it will subtract from newContentRows, breaking component behavior.")
				v35 = v36 + 2
			end

			v19(v35)
		end
	end, {
		v23,
		v25
	})
	local v29 = Dash.join(t1.footerData, {
		isStatsOnly = true,
		size = UDim2.new(0, 132, 0, v25),
		position = if not v21 and not v22 then nil else UDim2.new(1, 0, 0, 0),
		anchorPoint = if not v21 and not v22 then nil else Vector2.new(1, 0),
		automaticSize = Enum.AutomaticSize.X
	})
	local v30 = React.createElement(ExperienceFooter, v29)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ref = v28,
		[React.Change.AbsoluteSize] = v28
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = if not t1.hasBackground then nil else UDim.new(0, v23),
			PaddingRight = UDim.new(0, v23),
			PaddingTop = UDim.new(0, (math.max(v23, 8))),
			PaddingBottom = UDim.new(0, v23)
		}),
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		TitleFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v25)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = if not t1.title or not (string.len(t1.title) > 0) then nil else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = -1,
				Size = UDim2.new(1, not v21 and 0 or -132, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = t1.title,
				Font = Font.Header2.Font,
				TextSize = v24,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}, {
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Shrink
				})
			}),
			InlineFooter = if not v21 then nil else v30
		}),
		LicenseDescription = if not t1.licenseDescription then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v25)
		}, {
			LicenseDescription = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = t1.licenseDescription,
				Font = Font.Body.Font,
				TextSize = v24,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		}),
		PaidAccessDescription = if not t1.paidAccessDescription or t1.licenseDescription then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v25)
		}, {
			PaidAccessDescription = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = t1.paidAccessDescription,
				Font = Font.Body.Font,
				TextSize = v24,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		}),
		SubtitleFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v25)
		}, {
			CreatorName = if not t1.creatorName then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, not v22 and 0 or -132, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Text = React.createElement(ItemTileCreatorName, {
					name = t1.creatorName,
					hasVerifiedBadge = t1.creatorVerified,
					creatorId = t1.creatorId
				})
			}),
			InlineFooter = if not v22 then nil else v30
		}),
		BodyFrame = if not (v20 > 0) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, if not (v20 > 1) then v25 * v20 else v27 * v20)
		}, {
			ExperienceInfo = if not (v20 > 1) then v30 else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 1, 0),
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
					MaxTextSize = v27
				})
			})
		})
	})
end

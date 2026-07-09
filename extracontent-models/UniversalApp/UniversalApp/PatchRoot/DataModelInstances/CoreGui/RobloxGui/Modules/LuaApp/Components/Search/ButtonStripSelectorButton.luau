local CorePackages = game:GetService("CorePackages")
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Roact = require(CorePackages.Packages.Roact)
local SearchSourceEvent = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchSourceEvent
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local FFlagSearchTopResultsTabEnabledForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchTopResultsTabEnabledForAll
local v8 = Roact.PureComponent:extend("ButtonStripSelectorButton")

function v8.render(p1) -- line: 23
	-- upvalues: withStyle (copy), Roact (copy), SearchSourceEvent (copy), FFlagSearchTopResultsTabEnabledForAll (copy), DEPRECATED_ImageSetLabel (copy)
	local text = p1.props.text
	local layoutOrder = p1.props.layoutOrder
	local selected = p1.props.selected

	return withStyle(function(p2) -- line: 27
		-- upvalues: selected (copy), Roact (copy), layoutOrder (copy), p1 (copy), SearchSourceEvent (copy), FFlagSearchTopResultsTabEnabledForAll (copy), DEPRECATED_ImageSetLabel (copy), text (copy)
		local v14 = selected and p2.Theme.TextEmphasis.Color or p2.Theme.TextDefault.Color
		local v15 = selected and p2.Theme.SystemPrimaryContent.Transparency or p2.Theme.TextDefault.Transparency
		local BackgroundOnHoverColor = p2.Theme.BackgroundOnHover.Color
		local v17 = selected and p2.Theme.BackgroundOnHover.Transparency or 1
		local v18 = p2.Font.BaseSize * p2.Font.Header2.RelativeSize

		return Roact.createElement("ImageButton", {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = v17,
			BackgroundColor3 = BackgroundOnHoverColor,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = function() -- line: 42
				-- upvalues: p1 (copy), SearchSourceEvent (copy)
				if p1.props.handleClick then
					p1.props.handleClick(SearchSourceEvent.TabSwitch)
				end
			end
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 1000)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, not FFlagSearchTopResultsTabEnabledForAll and not p1.props.newDesignEnabled and 6 or 12),
				PaddingRight = UDim.new(0, not FFlagSearchTopResultsTabEnabledForAll and not p1.props.newDesignEnabled and 6 or 12),
				PaddingTop = UDim.new(0, not FFlagSearchTopResultsTabEnabledForAll and not p1.props.newDesignEnabled and 6 or 6),
				PaddingBottom = UDim.new(0, not FFlagSearchTopResultsTabEnabledForAll and not p1.props.newDesignEnabled and 6 or 6)
			}),
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			Image = p1.props.image and Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				BorderSizePixel = 0,
				Size = UDim2.new(0, v18, 0, v18),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = p1.props.image,
				ImageColor3 = v14,
				ImageTransparency = v15
			}) or nil,
			Label = Roact.createElement("TextLabel", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = text,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = v18,
				Font = if not FFlagSearchTopResultsTabEnabledForAll and not p1.props.newDesignEnabled then p2.Font.Header2.Font else p2.Font.Body.Font,
				TextColor3 = v14,
				TextTransparency = v15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return v8

local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local searchSourceEvent = require("@luauforge/bundled/cBc").SearchSourceEvent

local module = require("@luauforge/bundled/egF")

local fFlagSearchTopResultsTabEnabledForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSearchTopResultsTabEnabledForAll
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId

local extended = Roact.PureComponent:extend("ButtonStripSelectorButton")

function extended.render(p2)
	local text = p2.props.text
	local layoutOrder = p2.props.layoutOrder
	local selected = p2.props.selected
	return withStyle(function(props)
		local color = selected and props.Theme.TextEmphasis.Color or props.Theme.TextDefault.Color
		local transparency = selected and props.Theme.SystemPrimaryContent.Transparency
			or props.Theme.TextDefault.Transparency
		local color2 = props.Theme.BackgroundOnHover.Color
		local transparency2 = selected and props.Theme.BackgroundOnHover.Transparency or 1
		local v5 = props.Font.BaseSize * props.Font.Header2.RelativeSize

		local createElement = Roact.createElement
		local v7 = {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = transparency2,
			BackgroundColor3 = color2,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = function()
				if p2.props.handleClick then
					p2.props.handleClick(searchSourceEvent.TabSwitch)
				end
			end
		}
		local tag = React.Tag
		local v8 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-search-type", p2.props.name) else nil
		v7[tag] = v8

		local children = {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 1000)
			}),
			Padding = 0,
			Layout = 0,
			Image = 0,
			Label = 0
		}

		local createElement2 = Roact.createElement
		local v10 = {
			PaddingLeft = UDim.new(
				0,
				(fFlagSearchTopResultsTabEnabledForAll or p2.props.newDesignEnabled) and 12 or 6
			),
			PaddingRight = UDim.new(
				0,
				(fFlagSearchTopResultsTabEnabledForAll or p2.props.newDesignEnabled) and 12 or 6
			),
			PaddingTop = 0,
			PaddingBottom = 0
		}

		local newUDim = UDim.new

		local v12 = fFlagSearchTopResultsTabEnabledForAll or p2.props.newDesignEnabled
		v10.PaddingTop = newUDim(0, 6)

		local newUDim2 = UDim.new

		local v15 = fFlagSearchTopResultsTabEnabledForAll or p2.props.newDesignEnabled
		v10.PaddingBottom = newUDim2(0, 6)
		children.Padding = createElement2("UIPadding", v10)

		children.Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		})

		local v17 = if p2.props.image then Roact.createElement(module, {
			Size = UDim2.new(0, v5, 0, v5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = p2.props.image,
			ImageColor3 = color,
			ImageTransparency = transparency,
			LayoutOrder = 2,
			BorderSizePixel = 0
		}) or nil else nil
		children.Image = v17

		local createElement3 = Roact.createElement
		local v19 = {
			Text = text,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			TextSize = v5,
			FontFace = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextWrapped = true,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v21

		if fFlagSearchTopResultsTabEnabledForAll or p2.props.newDesignEnabled then
			v21 = props.Tokens.Typography.BodyLarge.Font
		else
			v21 = props.Tokens.Typography.TitleLarge.Font
		end

		v19.FontFace = normalizeFontFace(v21)

		v19.TextColor3 = color
		v19.TextTransparency = transparency

		v19.TextXAlignment = Enum.TextXAlignment.Left
		v19.TextYAlignment = Enum.TextYAlignment.Top
		children.Label = createElement3("TextLabel", v19)
		return createElement("ImageButton", v7, children)
	end)
end

return extended

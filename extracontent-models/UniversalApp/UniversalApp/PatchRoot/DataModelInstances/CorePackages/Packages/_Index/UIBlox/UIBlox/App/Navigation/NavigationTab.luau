local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local StateLayer = require(ParentParent.Core.Control.StateLayer)
local useStyle = require(ParentParent.Core.Style.useStyle)
local Label = require(ParentParent.Core.ImageSet.ImageSetComponent).Label
local NavigationTabLayout = require(ParentParent.App.Navigation.Enum.NavigationTabLayout)

require(ParentParent.App.ImageSet.ImagesTypes)
require(ParentParent.App.Style.StyleTypes)

local StatusIndicator = Foundation.StatusIndicator
local migrateBadgeVariant = require(ParentParent.Utility.migrateBadgeVariant)
local vector2 = Vector2.new(1e999, 1e999)
local t1 = {
	hasLabel = false,
	isChecked = false,
	badgeValue = nil,
	layout = NavigationTabLayout.Stacked
}

return (React.forwardRef(function(t2: {[any]: any}, p1) -- line: 69
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), TextService (copy), vector2 (copy), Label (copy), NavigationTabLayout (copy), StatusIndicator (copy), migrateBadgeVariant (copy), UIBloxConfig (copy), StateLayer (copy)
	local v18 = Cryo.Dictionary.join(t1, t2)
	local Tokens = useStyle().Tokens
	local v20, v21 = React.useBinding(UDim2.new())
	local v22 = React.useCallback(function(p2) -- line: 73
		-- upvalues: v21 (copy)
		v21(UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y))
	end, {})
	local FontSize = nil

	if v18.labelTypography then
		FontSize = v18.labelTypography.FontSize

		if FontSize ~= nil and typeof(FontSize) ~= "number" then
			FontSize = FontSize:getValue()
		end
	end

	local v24 = React.useMemo(function() -- line: 86
		-- upvalues: v18 (copy), TextService (copy), FontSize (ref), vector2 (copy)
		if v18.hasLabel and (v18.labelText and v18.labelTypography) then
			local TextSize = TextService:GetTextSize(v18.labelText, FontSize, v18.labelTypography.Font, vector2)

			return UDim2.new(0, TextSize.X + 2, 0, TextSize.Y + 2)
		end

		return nil
	end, {
		v18.hasLabel,
		v18.labelText,
		v18.labelTypography,
		FontSize
	})
	local uDim2 = UDim2.fromOffset(Tokens.Global.Size_350, Tokens.Global.Size_350)
	local v26

	if v18.renderIcon then
		v26 = v18.renderIcon(v18.isChecked)
	else
		local v27 = if not v18.isChecked or not v18.iconCheckedImage then v18.iconImage else v18.iconCheckedImage
		local v28 = if not v18.isChecked then Tokens.Semantic.Color.Icon.Default else Tokens.Semantic.Color.Icon.Emphasis

		v26 = React.createElement(Label, {
			BackgroundTransparency = 1,
			Size = uDim2,
			Image = v27,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = v28.Color3,
			ImageTransparency = v28.Transparency
		})
	end

	if v18.layout == NavigationTabLayout.Stacked and v18.badgeValue ~= nil then
		v26 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = uDim2
		}, {
			Icon = v26,
			Badge = React.createElement(StatusIndicator, {
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(0.6, 0.35),
				value = tonumber(v18.badgeValue),
				variant = migrateBadgeVariant(v18.badgeVariant),
				max = if not tonumber(v18.badgeValue) then nil else 99
			})
		})
	end

	local v29 = nil

	if v18.hasLabel and v18.labelText then
		local v30 = if not v18.isChecked then Tokens.Semantic.Color.Text.Default else Tokens.Semantic.Color.Text.Emphasis

		v29 = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = false,
			AutomaticSize = if not v24 then Enum.AutomaticSize.XY else nil,
			Size = v24,
			TextXAlignment = Enum.TextXAlignment.Center,
			Text = v18.labelText,
			Font = if not v18.labelTypography then nil else v18.labelTypography.Font,
			TextSize = if not v18.labelTypography then nil else v18.labelTypography.FontSize,
			LineHeight = if not v18.labelTypography then nil else v18.labelTypography.LineHeight,
			TextColor3 = v30.Color3,
			TextTransparency = v30.Transparency
		})
	end

	local v31 = nil
	local uDim = nil

	if v18.layout == NavigationTabLayout.Stacked then
		uDim = UDim.new(0, Tokens.Semantic.Radius.Medium)
		v31 = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(Tokens.Global.Space_600, Tokens.Global.Space_600),
			[React.Change.AbsoluteSize] = v22
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Tokens.Global.Space_100),
				PaddingBottom = UDim.new(0, Tokens.Global.Space_100)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = if not UIBloxConfig.removeStackedNavigationTabIconLabelSpacing then UDim.new(0, Tokens.Global.Space_50) else nil
			}),
			Icon = v26,
			Label = v29
		})
	elseif v18.layout == NavigationTabLayout.Inline then
		uDim = UDim.new(0, Tokens.Semantic.Radius.Large)

		local v33 = if not v18.isChecked then {
			Transparency = 1,
			Color3 = nil
		} else Tokens.Semantic.Color.State.Standard.Pressed

		v31 = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = v33.Transparency,
			BackgroundColor3 = v33.Color3,
			Size = UDim2.fromOffset(Tokens.Global.Space_600, Tokens.Global.Space_500),
			[React.Change.AbsoluteSize] = v22
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Tokens.Global.Space_50),
				PaddingBottom = UDim.new(0, Tokens.Global.Space_50),
				PaddingLeft = UDim.new(0, Tokens.Global.Space_150),
				PaddingRight = UDim.new(0, Tokens.Global.Space_150)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, Tokens.Global.Space_150)
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = uDim
			}),
			Icon = v26,
			Label = v29,
			Badge = if v18.badgeValue == nil then nil else React.createElement(StatusIndicator, {
				LayoutOrder = 3,
				value = tonumber(v18.badgeValue),
				variant = migrateBadgeVariant(v18.badgeVariant),
				max = if not tonumber(v18.badgeValue) then nil else 99
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = p1,
		Size = v20,
		AnchorPoint = v18.anchorPoint,
		Position = v18.position,
		LayoutOrder = v18.layoutOrder
	}, {
		Contents = v31,
		StateLayer = React.createElement(StateLayer, {
			affordance = "Background",
			zIndex = 10,
			cornerRadius = uDim,
			onActivated = v18.onActivated,
			onStateChanged = v18.onStateChanged
		})
	})
end))

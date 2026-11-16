local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local Style = require(parent2.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent2.UIBlox)
local BaseMenu = UIBlox.App.Menu.BaseMenu
local useCursor = UIBlox.App.SelectionCursor.useCursor

local PlayerContextualMenuHeader = require(script.Parent.PlayerContextualMenuHeader)

local FFlagPlayerContextualMenuFitToViewport = require(parent.Flags.FFlagPlayerContextualMenuFitToViewport)

local function noop() end

local v = { width = UDim.new(1, 0) }

local function getCardLayout(data, data2)
	local v2 = not (data.scaleReference > 0) and 1 or data.scaleReference / 100
	local v3 = data.container / v2
	local height = data.content / v2

	local v4 = data2.minScrollHeight + data2.cornerRadius * 2

	local v5 = not (v3 > 0) and 1e999 or math.max(v3 - data2.viewportMargin * 2, v4)

	local isOverflowing = v5 < height
	local cardLayout = {
		isContentMeasured = height > 0,
		isOverflowing = isOverflowing,
		height = 0,
		inset = 0
	}

	if isOverflowing then
		height = v5
	end

	cardLayout.height = height

	cardLayout.inset = not isOverflowing and 0 or data2.cornerRadius
	return cardLayout
end

local function useFitToViewport(viewportMargin: number, menuCornerRadius: number, minScrollHeight: number)
	local v2 = React.useMemo(function()
		return {
			viewportMargin = viewportMargin,
			cornerRadius = menuCornerRadius,
			minScrollHeight = minScrollHeight
		}
	end, { viewportMargin, menuCornerRadius, minScrollHeight })

	local v3, v4 = React.useBinding({ container = 0, content = 0, scaleReference = 0 })

	local state, setState = React.useState(false)

	local v5 = React.useCallback(function(p)
		local joined = Dash.join(v3:getValue(), p)
		v4(joined)
		setState(getCardLayout(joined, v2).isOverflowing)
	end, { v3, v2 })

	local onContainerAbsoluteSizeChanged = React.useCallback(function(p)
		v5({ container = p.AbsoluteSize.Y })
	end, { v5 })

	local onContentAbsoluteSizeChanged = React.useCallback(function(p)
		v5({ content = p.AbsoluteSize.Y })
	end, { v5 })

	local onScaleReferenceAbsoluteSizeChanged = React.useCallback(function(p)
		v5({ scaleReference = p.AbsoluteSize.Y })
	end, { v5 })

	local v6 = React.useMemo(function()
		return v3:map(function(p)
			return getCardLayout(p, v2)
		end)
	end, { v3, v2 })

	return {
		isOverflowing = state,
		automaticSize = React.useMemo(function()
			return v6:map(function(p)
				if p.isContentMeasured then
					return Enum.AutomaticSize.None
				end

				return Enum.AutomaticSize.Y
			end)
		end, { v6 }),
		scrollViewSize = React.useMemo(function()
			return v6:map(function(data)
				return UDim2.new(1, 0, 0, not data.isContentMeasured and 0 or data.height - data.inset * 2)
			end)
		end, { v6 }),
		inset = React.useMemo(function()
			return v6:map(function(p)
				return UDim.new(0, p.inset)
			end)
		end, { v6 }),
		onContainerAbsoluteSizeChanged = onContainerAbsoluteSizeChanged,
		onContentAbsoluteSizeChanged = onContentAbsoluteSizeChanged,
		onScaleReferenceAbsoluteSizeChanged = onScaleReferenceAbsoluteSizeChanged
	}
end

return function(p)
	local joined = Dash.join(v, p)
	local selectionImageObject = useCursor()
	local v2 = useDesignTokens(function(data)
		return {
			overlayBackgroundColor3 = data.Color.Common.Scrim.Color3,
			overlayBackgroundTransparency = data.Color.Common.Scrim.Transparency,
			backgroundColor = data.Color.Surface.Surface_0.Color3,
			backgroundTransparency = data.Color.Surface.Surface_0.Transparency,
			menuCornerRadius = data.Radius.Medium,
			viewportMargin = data.Size.Size_400,
			minScrollHeight = data.Size.Size_1400
		}
	end)

	local state, setState = React.useState(0)
	local v3

	if FFlagPlayerContextualMenuFitToViewport then
		v3 = useFitToViewport(v2.viewportMargin, v2.menuCornerRadius, v2.minScrollHeight)
	end

	local renderHeader = React.useCallback(function()
		return React.createElement(
			PlayerContextualMenuHeader,
			Dash.join(joined.headerProps, { onHeaderHeightChanged = setState })
		)
	end, { joined.headerProps })

	local createElement = React.createElement
	local v4 = {
		["Size"] = nil,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v2.overlayBackgroundColor3,
		BackgroundTransparency = v2.overlayBackgroundTransparency,
		ZIndex = -1
	}

	local absoluteSize = React.Change.AbsoluteSize
	local v5

	if v3 then
		v5 = v3.onContainerAbsoluteSizeChanged
	end

	v4[absoluteSize] = v5
	local scaleReference

	if v3 then
		scaleReference = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 100),
			[React.Change.AbsoluteSize] = v3.onScaleReferenceAbsoluteSizeChanged
		})
	end

	local createElement2 = React.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = v2.backgroundColor,
		BackgroundTransparency = v2.backgroundTransparency,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Selectable = #joined.buttonProps == 0,
		SelectionImageObject = selectionImageObject,
		Size = UDim2.new(joined.width, UDim.new(0, 0)),
		Text = "",
		ZIndex = 0
	}

	local v7 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v2.menuCornerRadius)
		}),
		CardPadding = 0,
		BaseMenu = 0,
		CardScrollView = 0
	}
	local cardPadding

	if v3 then
		cardPadding = React.createElement("UIPadding", {
			PaddingTop = v3.inset,
			PaddingBottom = v3.inset
		})
	end

	v7.CardPadding = cardPadding
	local baseMenu

	if not v3 then
		baseMenu = React.createElement(BaseMenu, {
			topElementRounded = false,
			buttonProps = joined.buttonProps,
			width = joined.width,
			enableTokenOverride = true,
			renderHeader = renderHeader,
			headerHeight = state
		})
	end

	v7.BaseMenu = baseMenu
	local cardScrollView

	if v3 then
		cardScrollView = React.createElement(ScrollView, {
			AutomaticSize = v3.automaticSize,
			Size = v3.scrollViewSize,
			scroll = {
				AutomaticSize = v3.automaticSize,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			selection = { Selectable = false }
		}, {
			Content = React.createElement(
				View,
				{
					tag = "col size-full-0 auto-y",
					onAbsoluteSizeChanged = v3.onContentAbsoluteSizeChanged
				},
				{
					HeaderFrame = React.createElement(View, {
						LayoutOrder = 1,
						tag = "size-full-0 auto-y"
					}, {
						Header = React.createElement(
							PlayerContextualMenuHeader,
							Dash.join(joined.headerProps, { onHeaderHeightChanged = noop })
						)
					}),
					BaseMenu = React.createElement(BaseMenu, {
						topElementRounded = false,
						bottomElementRounded = not v3.isOverflowing,
						buttonProps = joined.buttonProps,
						width = joined.width,
						enableTokenOverride = true,
						layoutOrder = 2
					})
				}
			)
		})
	end

	v7.CardScrollView = cardScrollView
	return createElement("Frame", v4, {
		ScaleReference = scaleReference,
		PositionFrame = createElement2("TextButton", v6, v7)
	})
end

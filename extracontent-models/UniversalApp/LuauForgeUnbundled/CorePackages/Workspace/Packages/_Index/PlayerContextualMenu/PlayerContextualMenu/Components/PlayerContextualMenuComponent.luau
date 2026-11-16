local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Foundation")
local scrollView = Foundation.ScrollView
local view = Foundation.View
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Style").useDesignTokens
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/UIBlox")
local baseMenu = UIBlox.App.Menu.BaseMenu
local useCursor = UIBlox.App.SelectionCursor.useCursor

local PlayerContextualMenuHeader = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/PlayerContextualMenuHeader")

local FFlagPlayerContextualMenuFitToViewport = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Flags/FFlagPlayerContextualMenuFitToViewport")

local function noop() end

local v5 = { width = UDim.new(1, 0) }

local function getCardLayout(data, data2)
	local v6 = not (data.scaleReference > 0) and 1 or data.scaleReference / 100
	local v7 = data.container / v6
	local v8 = data.content / v6

	local v9 = data2.minScrollHeight + 2 * data2.cornerRadius

	local v10 = not (v7 > 0) and 1e999 or math.max(v7 - 2 * data2.viewportMargin, v9)

	local v11 = v10 < v8
	local cardLayout = {
		isContentMeasured = v8 > 0,
		isOverflowing = v11,
		height = 0,
		inset = 0
	}

	if v11 then
		v8 = v10
	end

	cardLayout.height = v8

	cardLayout.inset = not v11 and 0 or data2.cornerRadius
	return cardLayout
end

local function useFitToViewport(viewportMargin, menuCornerRadius, minScrollHeight)
	local v6 = React.useMemo(function()
		return {
			viewportMargin = viewportMargin,
			cornerRadius = menuCornerRadius,
			minScrollHeight = minScrollHeight
		}
	end, { viewportMargin, menuCornerRadius, minScrollHeight })

	local v7, v8 = React.useBinding({ container = 0, content = 0, scaleReference = 0 })

	local state, setState = React.useState(false)

	local v9 = React.useCallback(function(p2)
		local joined = Dash.join(v7:getValue(), p2)
		v8(joined)
		setState(getCardLayout(joined, v6).isOverflowing)
	end, { v7, v6 })

	local v10 = React.useCallback(function(p2)
		v9({ container = p2.AbsoluteSize.Y })
	end, { v9 })

	local v11 = React.useCallback(function(p2)
		v9({ content = p2.AbsoluteSize.Y })
	end, { v9 })

	local v12 = React.useCallback(function(p2)
		v9({ scaleReference = p2.AbsoluteSize.Y })
	end, { v9 })

	local v13 = React.useMemo(function()
		return v7:map(function(p2)
			return getCardLayout(p2, v6)
		end)
	end, { v7, v6 })

	return {
		isOverflowing = state,
		automaticSize = React.useMemo(function()
			return v13:map(function(p2)
				if p2.isContentMeasured then
					return Enum.AutomaticSize.None
				end

				return Enum.AutomaticSize.Y
			end)
		end, { v13 }),
		scrollViewSize = React.useMemo(function()
			return v13:map(function(data)
				return UDim2.new(1, 0, 0, not data.isContentMeasured and 0 or data.height - 2 * data.inset)
			end)
		end, { v13 }),
		inset = React.useMemo(function()
			return v13:map(function(p2)
				return UDim.new(0, p2.inset)
			end)
		end, { v13 }),
		onContainerAbsoluteSizeChanged = v10,
		onContentAbsoluteSizeChanged = v11,
		onScaleReferenceAbsoluteSizeChanged = v12
	}
end

return function(p2)
	local joined = Dash.join(v5, p2)
	local v6 = useCursor()
	local v7 = useDesignTokens(function(data)
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
	local v8

	if FFlagPlayerContextualMenuFitToViewport then
		v8 = useFitToViewport(v7.viewportMargin, v7.menuCornerRadius, v7.minScrollHeight)
	end

	local v9 = React.useCallback(function()
		return React.createElement(
			PlayerContextualMenuHeader,
			Dash.join(joined.headerProps, { onHeaderHeightChanged = setState })
		)
	end, { joined.headerProps })

	local createElement = React.createElement
	local v11 = {
		["Size"] = nil,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v7.overlayBackgroundColor3,
		BackgroundTransparency = v7.overlayBackgroundTransparency,
		ZIndex = -1
	}

	local absoluteSize = React.Change.AbsoluteSize
	local v12 = if v8 then v8.onContainerAbsoluteSizeChanged else nil
	v11[absoluteSize] = v12
	local v14

	if v8 then
		v14 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 100),
			[React.Change.AbsoluteSize] = v8.onScaleReferenceAbsoluteSizeChanged
		})
	end

	local createElement2 = React.createElement
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = v7.backgroundColor,
		BackgroundTransparency = v7.backgroundTransparency,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Selectable = #joined.buttonProps == 0,
		SelectionImageObject = v6,
		Size = UDim2.new(joined.width, UDim.new(0, 0)),
		Text = "",
		ZIndex = 0
	}

	local v17 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v7.menuCornerRadius)
		}),
		CardPadding = 0,
		BaseMenu = 0,
		CardScrollView = 0
	}

	local v18 = if v8 then React.createElement("UIPadding", {
		PaddingTop = v8.inset,
		PaddingBottom = v8.inset
	}) else nil
	v17.CardPadding = v18

	local v19 = if not v8 then React.createElement(baseMenu, {
		topElementRounded = false,
		buttonProps = joined.buttonProps,
		width = joined.width,
		enableTokenOverride = true,
		renderHeader = v9,
		headerHeight = state
	}) else nil
	v17.BaseMenu = v19

	local v20 = if v8 then React.createElement(scrollView, {
		AutomaticSize = v8.automaticSize,
		Size = v8.scrollViewSize,
		scroll = {
			AutomaticSize = v8.automaticSize,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		selection = { Selectable = false }
	}, {
		Content = React.createElement(
			view,
			{
				tag = "col size-full-0 auto-y",
				onAbsoluteSizeChanged = v8.onContentAbsoluteSizeChanged
			},
			{
				HeaderFrame = React.createElement(view, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y"
				}, {
					Header = React.createElement(
						PlayerContextualMenuHeader,
						Dash.join(joined.headerProps, {
							onHeaderHeightChanged = noop
						})
					)
				}),
				BaseMenu = React.createElement(baseMenu, {
					topElementRounded = false,
					bottomElementRounded = not v8.isOverflowing,
					buttonProps = joined.buttonProps,
					width = joined.width,
					enableTokenOverride = true,
					layoutOrder = 2
				})
			}
		)
	}) else nil
	v17.CardScrollView = v20
	return createElement("Frame", v11, {
		ScaleReference = v14,
		PositionFrame = createElement2("TextButton", v16, v17)
	})
end

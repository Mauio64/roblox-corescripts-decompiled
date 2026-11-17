local GamepadService = game:GetService("GamepadService")

local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local ScrollingFrameWithIndicators = require(AvatarExperienceUIKit.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators)
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local getCenterScrollOffset = require(AvatarExperienceUIKit.Utils.getCenterScrollOffset)
local getRevealScrollOffset = require(AvatarExperienceUIKit.Utils.getRevealScrollOffset)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local FFlagAXScrollHighlightedTabIntoView = AvatarExperienceFlags.FFlagAXScrollHighlightedTabIntoView
local FFlagAXTabGroupScrollOnlyWhenClipped = AvatarExperienceFlags.FFlagAXTabGroupScrollOnlyWhenClipped

local backgroundStyle = { Transparency = 1 }

local TabGroupTab = require(script.Parent.TabGroupTab)

local layout = {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.None
}

local backgroundStyle2 = { Transparency = 1 }

local v = { dampingRatio = 1, frequency = 5 }

local function getActiveTabPosition(p: number)
	return UDim2.new(0, p, 1, 0)
end

local function getActiveTabSize(p: number)
	return UDim2.new(0, p, 0, 3)
end

local function TabGroup(props, ref5)
	local v2 = useTokens()
	local v3, v4 = useAnimatedBinding(0)
	local v5, v6 = useAnimatedBinding(0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4

	if FFlagAXTabGroupScrollOnlyWhenClipped then
		ref4 = React.useRef(nil)
	else
		ref4 = nil
	end

	local v7 = React.useCallback(function(p: number, p2: number, flag: boolean?)
		if not flag and (not FFlagAXCategoryMenuVisualFixes or v5:getValue() > 0) then
			v4(makeOtterSpringValue(p, v))
			v6(makeOtterSpringValue(p2, v))
		else
			v4(ReactOtter.instant(p))
			v6(ReactOtter.instant(p2))
		end
	end, {})

	local v8 = React.useCallback(function()
		local current = ref3.current
		local current2 = ref.current
		local current3 = ref2.current

		if not (current and current2 and current3) then
			return
		end

		local scrollingFrame = current.getScrollingFrame()

		if not scrollingFrame then
			return
		end

		local x

		if FFlagAXTabGroupScrollOnlyWhenClipped then
			x = scrollingFrame.AbsoluteWindowSize.X
		else
			x = scrollingFrame.AbsoluteSize.X
		end

		if x <= 0 then
			return
		end

		local x2 = scrollingFrame.CanvasPosition.X
		local v8

		if FFlagAXTabGroupScrollOnlyWhenClipped then
			v8 = current3.AbsolutePosition.X - scrollingFrame.AbsolutePosition.X + x2
		else
			v8 = current3.AbsolutePosition.X - current2.AbsolutePosition.X
		end

		if FFlagAXTabGroupScrollOnlyWhenClipped and ref4 then
			local x3 = current3.AbsoluteSize.X
			local x4 = scrollingFrame.AbsoluteCanvasSize.X
			local obscuredEdgeInset = current.getObscuredEdgeInset()

			local revealScrollOffset = getRevealScrollOffset(v8, x3, x2, x, x4, obscuredEdgeInset)

			if revealScrollOffset == nil then
				local scrollTarget = current.getScrollTarget()

				if
					scrollTarget ~= nil
					and scrollTarget == ref4.current
					and getRevealScrollOffset(v8, x3, scrollTarget, x, x4, obscuredEdgeInset) ~= nil
				then
					current.setOffset(x2)
				end
			else
				ref4.current = revealScrollOffset
				current.scrollToOffset(revealScrollOffset)
			end
		else
			local v9 = v8 + current3.AbsoluteSize.X

			if v8 < x2 then
				current.scrollToOffset(v8)
			elseif x2 + x < v9 then
				current.scrollToOffset(v9 - x)
			end
		end
	end, {})
	local v9

	if FFlagAXScrollHighlightedTabIntoView then
		v9 = React.useCallback(function(instance)
			local current = ref3.current

			if not current then
				return
			end

			local scrollingFrame = current.getScrollingFrame()

			if not (scrollingFrame and (instance and instance:IsDescendantOf(game) and instance:IsDescendantOf(scrollingFrame))) then
				return
			end

			local x = scrollingFrame.AbsoluteWindowSize.X
			local x2 = scrollingFrame.CanvasPosition.X
			local centerScrollOffset = getCenterScrollOffset(
				instance.AbsolutePosition.X - scrollingFrame.AbsolutePosition.X + x2,
				instance.AbsoluteSize.X,
				x2,
				x
			)

			if centerScrollOffset == nil then
				return
			end

			current.scrollToOffset(centerScrollOffset)
		end, {})
	else
		v9 = nil
	end

	local v10 = React.useCallback(function(current)
		local current2 = ref.current
		ref2.current = current

		for _, item in props.items do
			if item.id == props.activeTabId and item.ref then
				item.ref.current = current
			end
		end

		if current and current2 then
			v7(current.AbsolutePosition.X - current2.AbsolutePosition.X, current.AbsoluteSize.X)

			if FFlagAXScrollHighlightedTabIntoView and not FFlagAXTabGroupScrollOnlyWhenClipped and v9 then
				v9(current)
			else
				v8()
			end
		end
	end, { props.activeTabId, props.items, v8, v9, v7 })

	React.useEffect(function()
		local current = ref.current
		local current2 = ref2.current

		if current2 and current then
			v7(
				current2.AbsolutePosition.X - current.AbsolutePosition.X,
				current2.AbsoluteSize.X,
				FFlagAXCategoryMenuVisualFixes
			)

			if FFlagAXScrollHighlightedTabIntoView and not FFlagAXTabGroupScrollOnlyWhenClipped and v9 then
				v9(current2)
			else
				v8()
			end
		end
	end, { v8, v9, v7 })

	if FFlagAXScrollHighlightedTabIntoView then
		React.useEffect(function()
			local current = ref3.current

			if not current then
				return
			end

			local scrollingFrame = current.getScrollingFrame()

			if not scrollingFrame then
				return
			end

			local selectionChangedConnection = scrollingFrame.SelectionChanged:Connect(function(_: boolean, _, p)
				if GamepadService.GamepadCursorEnabled then
					return
				end

				if v9 then
					v9(p)
				end
			end)

			return function()
				selectionChangedConnection:Disconnect()
			end
		end, {})
	end

	if FFlagAXCategoryMenuVisualFixes then
		React.useEffect(function()
			local v11 = false

			if props.activeTabId ~= nil then
				for _, item in props.items do
					if item.id == props.activeTabId then
						v11 = true
						break
					end
				end
			end

			if not v11 then
				ref2.current = nil
				v4(ReactOtter.instant(0))
				v6(ReactOtter.instant(0))
			end
		end, { props.activeTabId, props.items })

		React.useImperativeHandle(props.controllerRef, function()
			return {
				scrollToOffset = function(p: number)
					local current = ref3.current

					if current then
						current.scrollToOffset(p)
					end
				end,
				setOffset = function(p: number)
					local current = ref3.current

					if current then
						current.setOffset(p)
					end
				end,
				getScrollingFrame = function()
					local current = ref3.current

					if current then
						return (current.getScrollingFrame())
					end

					return nil
				end,
				getScrollTarget = function()
					local current = ref3.current

					if current then
						return (current.getScrollTarget())
					end

					return nil
				end,
				getObscuredEdgeInset = function()
					local current = ref3.current

					if current then
						return (current.getObscuredEdgeInset())
					end

					return 0
				end
			}
		end, {})
	end

	local children = {}

	for k, item in props.items do
		local isActive = props.activeTabId == item.id
		local id = item.id
		local createElement = React.createElement
		local ref6 = if isActive then v10 else item.ref
		children[id] = createElement(TabGroupTab, {
			ref = ref6,
			text = item.text,
			onActivated = props.onTabActivated and function()
				props.onTabActivated(item.id)
			end or nil,
			isActive = isActive,
			fontStyle = props.tabFontStyle,
			padding = props.tabPadding,
			textStyle = props.tabTextStyle,
			activeTextStyle = props.tabActiveTextStyle,
			LayoutOrder = k
		})
	end

	local position = React.useMemo(function()
		return v3:map(getActiveTabPosition)
	end, {})

	local size = React.useMemo(function()
		return v5:map(getActiveTabSize)
	end, {})

	local element = React.createElement(View, {
		ref = ref,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = backgroundStyle2,
		layout = layout,
		ZIndex = -1
	}, children)

	local element2 = React.createElement("Frame", {
		Position = position,
		Size = size,
		BackgroundColor3 = v2.Color.Content.Emphasis.Color3,
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0
	})

	return React.createElement(ScrollingFrameWithIndicators, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = props.BackgroundTransparency,
		BackgroundColor3 = props.BackgroundColor3,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		ZIndex = props.ZIndex,
		ref = ref5,
		controllerRef = ref3
	}, FFlagAXCategoryMenuVisualFixes and {
		Content = React.createElement(
			View,
			{
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = backgroundStyle
			},
			{ InnerNavigation = element, ActiveTabIndicator = element2 }
		)
	} or { InnerNavigation = element, ActiveTabIndicator = element2 })
end

return React.forwardRef(TabGroup)

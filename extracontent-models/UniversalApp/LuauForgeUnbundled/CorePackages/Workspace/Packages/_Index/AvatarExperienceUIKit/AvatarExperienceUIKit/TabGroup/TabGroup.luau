local GamepadService = game:GetService("GamepadService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/ReactOtter")
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local ScrollingFrameWithIndicators = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ScrollingFrameWithIndicators/ScrollingFrameWithIndicators")
local makeOtterSpringValue = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/makeOtterSpringValue")
local getCenterScrollOffset = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/getCenterScrollOffset")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local fFlagAXScrollHighlightedTabIntoView = AvatarExperienceFlags.FFlagAXScrollHighlightedTabIntoView

local v5 = { Transparency = 1 }

local TabGroupTab = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/TabGroup/TabGroupTab")

local v6 = {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.None
}

local v7 = { Transparency = 1 }

local v8 = { dampingRatio = 1, frequency = 5 }

local function getActiveTabPosition(p2)
	return UDim2.new(0, p2, 1, 0)
end

local function getActiveTabSize(p2)
	return UDim2.new(0, p2, 0, 3)
end

local function TabGroup(props, p2)
	local v9 = useTokens()
	local v10, v11 = useAnimatedBinding(0)
	local v12, v13 = useAnimatedBinding(0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v14 = React.useCallback(function(p3, p4, p5)
		if not p5 and (not fFlagAXCategoryMenuVisualFixes or v12:getValue() > 0) then
			v11(makeOtterSpringValue(p3, v8))
			v13(makeOtterSpringValue(p4, v8))
		else
			v11(ReactOtter.instant(p3))
			v13(ReactOtter.instant(p4))
		end
	end, {})

	local v15 = React.useCallback(function()
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

		local x = scrollingFrame.AbsoluteSize.X

		if x <= 0 then
			return
		end

		local x2 = scrollingFrame.CanvasPosition.X
		local v16 = current3.AbsolutePosition.X - current2.AbsolutePosition.X
		local v17 = v16 + current3.AbsoluteSize.X

		if v16 < x2 then
			current.scrollToOffset(v16)
		elseif x2 + x < v17 then
			current.scrollToOffset(v17 - x)
		end
	end, {})
	local v16

	if fFlagAXScrollHighlightedTabIntoView then
		v16 = React.useCallback(function(instance)
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
			local v18 = getCenterScrollOffset(
				instance.AbsolutePosition.X - scrollingFrame.AbsolutePosition.X + x2,
				instance.AbsoluteSize.X,
				x2,
				x
			)

			if v18 == nil then
				return
			end

			current.scrollToOffset(v18)
		end, {})
	else
		v16 = nil
	end

	local v17 = React.useCallback(function(current)
		local current2 = ref.current
		ref2.current = current

		for k, item in props.items do
			if item.id == props.activeTabId and item.ref then
				item.ref.current = current
			end
		end

		if current and current2 then
			v14(current.AbsolutePosition.X - current2.AbsolutePosition.X, current.AbsoluteSize.X)

			if fFlagAXScrollHighlightedTabIntoView and v16 then
				v16(current)
			else
				v15()
			end
		end
	end, { props.activeTabId, props.items, v15, v16, v14 })

	React.useEffect(function()
		local current = ref.current
		local current2 = ref2.current

		if current2 and current then
			v14(
				current2.AbsolutePosition.X - current.AbsolutePosition.X,
				current2.AbsoluteSize.X,
				fFlagAXCategoryMenuVisualFixes
			)

			if fFlagAXScrollHighlightedTabIntoView and v16 then
				v16(current2)
			else
				v15()
			end
		end
	end, { v15, v16, v14 })

	if fFlagAXScrollHighlightedTabIntoView then
		React.useEffect(function()
			local current = ref3.current

			if not current then
				return
			end

			local scrollingFrame = current.getScrollingFrame()

			if not scrollingFrame then
				return
			end

			local selectionChangedConnection = scrollingFrame.SelectionChanged:Connect(function(p3, p4, p5)
				if GamepadService.GamepadCursorEnabled then
					return
				end

				if v16 then
					v16(p5)
				end
			end)

			return function()
				selectionChangedConnection:Disconnect()
			end
		end, {})
	end

	if fFlagAXCategoryMenuVisualFixes then
		React.useEffect(function()
			local v18 = false

			if props.activeTabId ~= nil then
				for k, item in props.items do
					if item.id == props.activeTabId then
						v18 = true
						break
					end
				end
			end

			if not v18 then
				ref2.current = nil
				v11(ReactOtter.instant(0))
				v13(ReactOtter.instant(0))
			end
		end, { props.activeTabId, props.items })

		React.useImperativeHandle(props.controllerRef, function()
			return {
				scrollToOffset = function(p3)
					local current = ref3.current

					if current then
						current.scrollToOffset(p3)
					end
				end,
				setOffset = function(p3)
					local current = ref3.current

					if current then
						current.setOffset(p3)
					end
				end,
				getScrollingFrame = function()
					local current = ref3.current

					if current then
						return (current.getScrollingFrame())
					end

					return nil
				end
			}
		end, {})
	end

	local children = {}

	for k, item in props.items do
		local v18 = props.activeTabId == item.id
		local id = item.id
		local createElement = React.createElement
		local v21 = if v18 then v17 else item.ref
		children[id] = createElement(TabGroupTab, {
			ref = v21,
			text = item.text,
			onActivated = props.onTabActivated and function()
				props.onTabActivated(item.id)
			end or nil,
			isActive = v18,
			fontStyle = props.tabFontStyle,
			padding = props.tabPadding,
			textStyle = props.tabTextStyle,
			activeTextStyle = props.tabActiveTextStyle,
			LayoutOrder = k
		})
	end

	local v18 = React.useMemo(function()
		return v10:map(getActiveTabPosition)
	end, {})

	local v19 = React.useMemo(function()
		return v12:map(getActiveTabSize)
	end, {})

	local element = React.createElement(view, {
		ref = ref,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v7,
		layout = v6,
		ZIndex = -1
	}, children)

	local element2 = React.createElement("Frame", {
		Position = v18,
		Size = v19,
		BackgroundColor3 = v9.Color.Content.Emphasis.Color3,
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
		ref = p2,
		controllerRef = ref3
	}, fFlagAXCategoryMenuVisualFixes and {
		Content = React.createElement(
			view,
			{
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v5
			},
			{ InnerNavigation = element, ActiveTabIndicator = element2 }
		)
	} or { InnerNavigation = element, ActiveTabIndicator = element2 })
end

return React.forwardRef(TabGroup)

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FFlagAXVirtualizedFeedVerticalPadding = require(Parent.SharedFlags).FFlagAXVirtualizedFeedVerticalPadding
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local FlatList = require(Parent.VirtualizedList).FlatList
local t1 = {
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}
local t2 = {
	Selectable = false,
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = 0,
	ClipsDescendants = false,
	ElasticBehavior = Enum.ElasticBehavior.Always,
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}
local t3 = {
	backToTop = "Feature.GamePage.Action.BackToTop"
}

local function getNativeScrollingFrameRef(t4: {[any]: any}) -- line: 47
	if t4.current ~= nil then
		local v21 = t4.current:getNativeScrollRef()

		if v21 ~= nil then
			return v21._nativeRef
		end
	end

	return nil
end
local function VirtualizedFeedBackToTopButton(t5: {[any]: any}) -- line: 62
	-- upvalues: useLocalization (copy), t3 (copy), React (copy), Button (copy), ButtonVariant (copy)
	local v23 = useLocalization(t3)

	return React.createElement(Button, {
		text = t5.text or v23.backToTop,
		variant = ButtonVariant.Link,
		onActivated = t5.onActivated
	})
end
local function VirtualizedFeedFooterLayout(t6: {[any]: any}) -- line: 76
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "row align-y-center align-x-center padding-xlarge"
	}, t6.children)
end
local function VirtualizedFeed(t7: {[any]: any}, p1) -- line: 124
	-- upvalues: FFlagAXVirtualizedFeedVerticalPadding (copy), React (copy), UserGameSettings (copy), VirtualizedFeedBackToTopButton (copy), Loading (copy), IconSize (copy), FlatList (copy), t1 (copy), t2 (copy), VirtualizedFeedFooterLayout (copy)
	local v27 = t7.horizontalPadding or 0
	local v28 = not FFlagAXVirtualizedFeedVerticalPadding and 0 or (t7.verticalPadding or 0)
	local v29 = React.useRef(nil)
	local v30 = React.useCallback(function(p2) -- line: 129
		-- upvalues: v29 (copy), t7 (copy)
		v29.current = p2

		local flatListRef = t7.flatListRef

		if flatListRef then
			if typeof(flatListRef) == "function" then
				flatListRef(p2)

				return
			end

			if typeof(flatListRef) == "table" then
				flatListRef.current = p2
			end
		end
	end, { t7.flatListRef })
	local v31, v32 = React.useState(false)
	local v33 = React.useCallback(function() -- line: 144
		-- upvalues: v29 (copy), UserGameSettings (copy)
		if v29.current then
			v29.current:scrollToOffset({
				offset = 0,
				animated = not UserGameSettings.ReducedMotion
			})
		end
	end, {})
	local g34 = nil
	local v35 = nil
	local _nativeRef = nil

	repeat
		if g34 or v29.current ~= nil then
			if not g34 then
				v35 = v29.current:getNativeScrollRef()
			end

			if g34 or v35 ~= nil then
				if not g34 then
					_nativeRef = v35._nativeRef
				end

				g34 = false

				local v37 = _nativeRef

				React.useEffect(function() -- line: 155
					-- upvalues: v37 (copy), v32 (copy)
					local t8 = {}

					local function sizeChangeHandler() -- line: 158
						-- upvalues: v37 (copy), v32 (copy)
						if v37 == nil or v37.current == nil then
							return
						end

						local current = v37.current

						v32(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
					end

					if v37 and v37.current then
						table.insert(t8, v37.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(sizeChangeHandler))
						table.insert(t8, v37.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(sizeChangeHandler))

						if v37 ~= nil and v37.current ~= nil then
							local current = v37.current

							v32(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
						end
					end

					return function() -- line: 176
						-- upvalues: t8 (copy)
						for _, v50 in t8 do
							v50:Disconnect()
						end
					end
				end, { v37 })

				local v38 = if not t7.ListFooterComponent then if not t7.isEndOfList or not v31 then if not t7.isLoading then nil else React.createElement(Loading, {
					size = IconSize.Medium
				}) else React.createElement(VirtualizedFeedBackToTopButton, {
					text = t7.scrollToTopLabel,
					onActivated = v33
				}) else t7.ListFooterComponent
				local v39 = React.useCallback(function(p3) -- line: 197
					-- upvalues: t7 (copy)
					if t7.onScroll then
						t7.onScroll(p3.CanvasPosition.Y)
					end
				end, { t7.onScroll })
				local v40 = React.useCallback(function(p4) -- line: 203
					-- upvalues: t7 (copy)
					if t7.onContainerWidthChanged then
						t7.onContainerWidthChanged(p4.AbsoluteSize.X)
					end
				end, { t7.onContainerWidthChanged })

				return React.createElement("Frame", {
					BackgroundColor3 = t7.backgroundColor,
					BackgroundTransparency = if t7.backgroundTransparency == nil then not t7.backgroundColor and 1 or 0 else t7.backgroundTransparency,
					BorderSizePixel = 0,
					Size = t7.Size or UDim2.new(1, 0, 1, 0),
					ClipsDescendants = t7.clipsDescendants == nil or t7.clipsDescendants,
					LayoutOrder = t7.LayoutOrder,
					[React.Change.AbsoluteSize] = v40,
					ref = p1
				}, {
					UIPadding = if not (v27 > 0) and not (v28 > 0) then nil else React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v27),
						PaddingRight = UDim.new(0, v27),
						PaddingTop = UDim.new(0, v28),
						PaddingBottom = UDim.new(0, v28)
					}),
					FeedFlatList = React.createElement(FlatList, {
						UNSTABLE_forceSiblingLayoutUpdate = true,
						showDefaultLoadingIndicators = true,
						data = t7.data,
						renderItem = t7.renderItem,
						windowSize = t7.windowSize or 21,
						initialNumToRender = t7.initialNumToRender or 8,
						maxToRenderPerBatch = t7.maxToRenderPerBatch or 1,
						updateCellsBatchingPeriod = t7.updateCellsBatchingPeriod or 30,
						scrollEventThrottle = t7.scrollEventThrottle or 0,
						ref = v30,
						contentContainerStyle = t1,
						style = t2,
						onScroll = v39,
						onEndReachedThreshold = t7.onEndReachedThreshold,
						onEndReached = t7.onEndReached,
						ListHeaderComponent = t7.ListHeaderComponent,
						ListFooterComponent = if not v38 then nil else React.createElement(VirtualizedFeedFooterLayout, {}, v38),
						scrollEnabled = t7.scrollEnabled
					})
				})
			end
		end

		_nativeRef = nil
		g34 = true
	until not g34
end

return React.forwardRef(VirtualizedFeed)

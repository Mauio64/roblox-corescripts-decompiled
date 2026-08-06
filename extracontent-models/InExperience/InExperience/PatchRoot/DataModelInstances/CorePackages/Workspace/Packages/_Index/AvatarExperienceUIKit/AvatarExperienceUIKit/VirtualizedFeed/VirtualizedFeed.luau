local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FFlagAXVirtualizedFeedVerticalPadding = require(Parent.SharedFlags).FFlagAXVirtualizedFeedVerticalPadding
local FFlagAXSduiFeedBackToTopAndNavClearance = require(Parent.AvatarExperienceFlags).FFlagAXSduiFeedBackToTopAndNavClearance
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local FlatList = require(Parent.VirtualizedList).FlatList
local isFeedContentScrollable = require(script.Parent.isFeedContentScrollable)
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

local function getNativeScrollingFrameRef(t4: {[any]: any}) -- line: 50
	if t4.current ~= nil then
		local v24 = t4.current:getNativeScrollRef()

		if v24 ~= nil then
			return v24._nativeRef
		end
	end

	return nil
end
local function VirtualizedFeedBackToTopButton(t5: {[any]: any}) -- line: 65
	-- upvalues: useLocalization (copy), t3 (copy), React (copy), Button (copy), ButtonVariant (copy)
	local v26 = useLocalization(t3)

	return React.createElement(Button, {
		text = t5.text or v26.backToTop,
		variant = ButtonVariant.Link,
		onActivated = t5.onActivated
	})
end

local v20 = not FFlagAXSduiFeedBackToTopAndNavClearance and "row align-y-center align-x-center padding-xlarge" or "row align-x-center align-y-center size-full-0 auto-y padding-xlarge"

local function VirtualizedFeedFooterLayout(t6: {[any]: any}) -- line: 83
	-- upvalues: React (copy), View (copy), v20 (copy)
	return React.createElement(View, {
		tag = v20
	}, t6.children)
end
local function VirtualizedFeed(t7: {[any]: any}, p1) -- line: 135
	-- upvalues: FFlagAXVirtualizedFeedVerticalPadding (copy), React (copy), FFlagAXSduiFeedBackToTopAndNavClearance (copy), UserGameSettings (copy), isFeedContentScrollable (copy), VirtualizedFeedBackToTopButton (copy), Loading (copy), IconSize (copy), View (copy), VirtualizedFeedFooterLayout (copy), FlatList (copy), t1 (copy), t2 (copy)
	local v30 = t7.horizontalPadding or 0
	local v31 = not FFlagAXVirtualizedFeedVerticalPadding and 0 or (t7.verticalPadding or 0)
	local v32 = React.useRef(nil)
	local v33 = React.useCallback(function(p2) -- line: 140
		-- upvalues: v32 (copy), t7 (copy)
		v32.current = p2

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
	local v34, v35 = React.useState(false)
	local v36 = nil
	local u37 = nil
	local v38 = nil
	local u39 = nil
	local v40 = nil
	local g44 = nil
	local g53 = nil
	local v54 = nil
	local _nativeRef = nil

	if FFlagAXSduiFeedBackToTopAndNavClearance then
		local v41

		v36, v41 = React.useState(0)
		u37 = v41

		local v42

		v38, v42 = React.useState(0)
		u39 = v42
		v40 = React.useCallback(function(_: number, n2: number) -- line: 170
			-- upvalues: u37 (ref)
			u37(n2)
		end, {})
	end

	local v43 = React.useCallback(function() -- line: 175
		-- upvalues: v32 (copy), UserGameSettings (copy)
		if v32.current then
			v32.current:scrollToOffset({
				offset = 0,
				animated = not UserGameSettings.ReducedMotion
			})
		end
	end, {})

	repeat
		if g44 or FFlagAXSduiFeedBackToTopAndNavClearance then
			g44 = false

			local v45 = nil

			if FFlagAXSduiFeedBackToTopAndNavClearance then
				local v46 = isFeedContentScrollable(v36 or 0, v38 or 0, v31) and t7.isEndOfList == true
				local v47 = if not t7.ListFooterComponent then if not v46 then if not t7.isLoading then nil else React.createElement(Loading, {
					size = IconSize.Medium
				}) else React.createElement(VirtualizedFeedBackToTopButton, {
					text = t7.scrollToTopLabel,
					onActivated = v43
				}) else t7.ListFooterComponent
				local v48 = t7.endOfListBottomPadding or 0
				local v49 = React.useMemo(function() -- line: 236
					-- upvalues: v48 (copy)
					if v48 <= 0 then
						return nil
					end

					return {
						bottom = UDim.new(0, v48)
					}
				end, { v48 })

				if v49 then
					v45 = React.createElement(View, {
						tag = "size-full-0 auto-y",
						padding = v49
					}, {
						FooterContent = if not v47 then nil else React.createElement(VirtualizedFeedFooterLayout, {}, v47)
					})
				elseif v47 then
					v45 = React.createElement(VirtualizedFeedFooterLayout, {}, v47)
				end
			else
				local v50 = if not t7.ListFooterComponent then if not t7.isEndOfList or not v34 then if not t7.isLoading then nil else React.createElement(Loading, {
					size = IconSize.Medium
				}) else React.createElement(VirtualizedFeedBackToTopButton, {
					text = t7.scrollToTopLabel,
					onActivated = v43
				}) else t7.ListFooterComponent

				v45 = if not v50 then nil else React.createElement(VirtualizedFeedFooterLayout, {}, v50)
			end

			local v51 = React.useCallback(function(p3) -- line: 277
				-- upvalues: t7 (copy)
				if t7.onScroll then
					t7.onScroll(p3.CanvasPosition.Y)
				end
			end, { t7.onScroll })
			local v52 = React.useCallback(function(p4) -- line: 283
				-- upvalues: t7 (copy), FFlagAXSduiFeedBackToTopAndNavClearance (copy), u39 (ref)
				if t7.onContainerWidthChanged then
					t7.onContainerWidthChanged(p4.AbsoluteSize.X)
				end

				if FFlagAXSduiFeedBackToTopAndNavClearance and u39 then
					u39(p4.AbsoluteSize.Y)
				end
			end, { t7.onContainerWidthChanged })

			return React.createElement("Frame", {
				BackgroundColor3 = t7.backgroundColor,
				BackgroundTransparency = if t7.backgroundTransparency == nil then not t7.backgroundColor and 1 or 0 else t7.backgroundTransparency,
				BorderSizePixel = 0,
				Size = t7.Size or UDim2.new(1, 0, 1, 0),
				ClipsDescendants = t7.clipsDescendants == nil or t7.clipsDescendants,
				LayoutOrder = t7.LayoutOrder,
				[React.Change.AbsoluteSize] = v52,
				ref = p1
			}, {
				UIPadding = if not (v30 > 0) and not (v31 > 0) then nil else React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v30),
					PaddingRight = UDim.new(0, v30),
					PaddingTop = UDim.new(0, v31),
					PaddingBottom = UDim.new(0, v31)
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
					ref = v33,
					contentContainerStyle = t1,
					style = t2,
					onScroll = v51,
					onContentSizeChange = if not FFlagAXSduiFeedBackToTopAndNavClearance then nil else v40,
					onEndReachedThreshold = t7.onEndReachedThreshold,
					onEndReached = t7.onEndReached,
					ListHeaderComponent = t7.ListHeaderComponent,
					ListFooterComponent = v45,
					scrollEnabled = t7.scrollEnabled
				})
			})
		end

		repeat
			if g53 or v32.current ~= nil then
				if not g53 then
					v54 = v32.current:getNativeScrollRef()
				end

				if g53 or v54 ~= nil then
					if not g53 then
						_nativeRef = v54._nativeRef
					end

					g53 = false

					local v56 = _nativeRef

					React.useEffect(function() -- line: 187
						-- upvalues: v56 (copy), v35 (copy)
						local t8 = {}

						local function sizeChangeHandler() -- line: 190
							-- upvalues: v56 (copy), v35 (copy)
							if v56 == nil or v56.current == nil then
								return
							end

							local current = v56.current

							v35(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
						end

						if v56 and v56.current then
							table.insert(t8, v56.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(sizeChangeHandler))
							table.insert(t8, v56.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(sizeChangeHandler))

							if v56 ~= nil and v56.current ~= nil then
								local current = v56.current

								v35(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
							end
						end

						return function() -- line: 208
							-- upvalues: t8 (copy)
							for _, v68 in t8 do
								v68:Disconnect()
							end
						end
					end, { v56 })
					g44 = true
				end
			end

			if g44 then
				break
			end

			_nativeRef = nil
			g53 = true
		until not g53
	until not g44
end

return React.forwardRef(VirtualizedFeed)

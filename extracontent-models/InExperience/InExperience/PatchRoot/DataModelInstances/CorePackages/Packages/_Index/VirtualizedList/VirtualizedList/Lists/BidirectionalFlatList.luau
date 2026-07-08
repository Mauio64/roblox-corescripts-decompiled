local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Object = require(ParentParentParent.LuauPolyfill).Object
local Promise = require(ParentParentParent.Promise)
local t1 = {}
local React = require(ParentParentParent.React)
local useRef = React.useRef
local useState = React.useState
local View = require(ParentParent.Components.View.View)
local FlatList = require(script.Parent.FlatList)

local function _getLength(b1: boolean?) -- line: 81
	return function(vector2: Vector2) -- line: 82
		-- upvalues: b1 (copy)
		if b1 then
			return vector2.X
		end

		return vector2.Y
	end
end

t1.BidirectionalFlatList = React.forwardRef(function(p1, p2) -- line: 98
	-- upvalues: Promise (copy), useState (copy), useRef (copy), React (copy), FlatList (copy), Object (copy), View (copy)
	local function promiseFn() -- line: 99
		-- upvalues: Promise (copy)
		return Promise.resolve()
	end

	if p1.activityIndicatorColor == nil then
	else
		local _ = p1.activityIndicatorColor
	end

	local v17 = if p1.autoscrollToTopThreshold ~= nil then p1.autoscrollToTopThreshold else 100
	local data = p1.data
	local enableAutoscrollToTop = p1.enableAutoscrollToTop
	local FooterLoadingIndicator = p1.FooterLoadingIndicator
	local HeaderLoadingIndicator = p1.HeaderLoadingIndicator
	local ListHeaderComponent = p1.ListHeaderComponent
	local ListFooterComponent = p1.ListFooterComponent
	local v24 = if p1.onEndReached ~= nil then p1.onEndReached else promiseFn
	local v25 = if p1.onEndReachedThreshold ~= nil then p1.onEndReachedThreshold else 10
	local onScroll = p1.onScroll
	local v27 = if p1.onStartReached ~= nil then p1.onStartReached else promiseFn
	local v28 = if p1.onStartReachedThreshold ~= nil then p1.onStartReachedThreshold else 10
	local v29 = p1.showDefaultLoadingIndicators == nil or p1.showDefaultLoadingIndicators
	local v30 = p1.enableRetryOnStartReached ~= nil and p1.enableRetryOnStartReached
	local v31 = p1.enableRetryOnEndReached ~= nil and p1.enableRetryOnEndReached
	local v32, v33 = useState(false)
	local v34, v35 = useState(false)
	local v36, v37 = useState(0)
	local v38 = useRef({})
	local v39 = useRef({})
	local v40 = useRef(nil)
	local v41 = useRef(nil)

	local function maybeCallOnStartReached() -- line: 133
		-- upvalues: data (copy), v38 (copy), p1 (copy), v36 (copy), v33 (copy), Promise (copy), v40 (copy), v41 (copy), v27 (copy)
		if data and (#data > 0 and v38.current[#data]) then
			return
		end

		local v48 = if not p1.inverted then v36 >= 1 else v36 >= 3

		if not v48 then
			return
		end

		if data and #data > 0 and v48 then
			v38.current[#data] = true
		end

		v33(true)

		local function p() -- line: 151
			-- upvalues: Promise (copy), v40 (copy), v33 (copy)
			return Promise.new(function(resolve) -- line: 152
				-- upvalues: v40 (copy), v33 (copy)
				v40.current = nil
				v33(false)
				resolve()
			end)
		end

		if v41.current then
			v41.current:andThen(function() -- line: 160
				-- upvalues: v40 (copy), v27 (copy), p (copy)
				v40.current = v27():andThen(p)
			end)

			return
		end

		v40.current = v27():andThen(p)
	end
	local function maybeCallOnEndReached() -- line: 168
		-- upvalues: data (copy), v39 (copy), p1 (copy), v36 (copy), v35 (copy), Promise (copy), v41 (copy), v40 (copy), v24 (copy)
		if data and (#data > 0 and v39.current[#data]) then
			return
		end

		local v50 = if not p1.inverted then v36 >= 1 else v36 >= 3

		if not v50 then
			return
		end

		if data and #data > 0 and v50 then
			v39.current[#data] = true
		end

		v35(true)

		local function p() -- line: 186
			-- upvalues: Promise (copy), v41 (copy), v35 (copy)
			return Promise.new(function(resolve) -- line: 187
				-- upvalues: v41 (copy), v35 (copy)
				v41.current = nil
				v35(false)
				resolve()
			end)
		end

		if v40.current then
			v40.current:andThen(function() -- line: 195
				-- upvalues: v41 (copy), v24 (copy), p (copy)
				v41.current = v24():andThen(p)
			end)

			return
		end

		v41.current = v24():andThen(p)
	end
	local function handleScroll(p3) -- line: 204
		-- upvalues: v37 (copy), onScroll (copy), p1 (copy), v28 (copy), v25 (copy), maybeCallOnStartReached (copy), v30 (copy), data (copy), v38 (copy), maybeCallOnEndReached (copy), v31 (copy), v39 (copy)
		v37(function(p4) -- line: 206
			return p4 + 1
		end)

		if onScroll then
			onScroll(p3)
		end

		local v53 = p3:GetChildren()[1]
		local horizontal = p1.horizontal

		local function v55(vector2: Vector2) -- line: 82
			-- upvalues: horizontal (copy)
			if horizontal then
				return vector2.X
			end

			return vector2.Y
		end

		local v56 = v55(p3.AbsoluteSize)
		local v57 = v55(v53.AbsoluteSize)
		local v58 = if not p1.inverted then v55(p3.CanvasPosition) else v55(p3.AbsoluteCanvasSize) - v55(p3.CanvasPosition) - v56
		local v59 = v58 < v28
		local v60 = v57 - v56 - v58 < v25

		if v59 then
			maybeCallOnStartReached()
		elseif v30 and data and #data > 0 and v38.current[#data] then
			v38.current[#data] = false
		end

		if v60 then
			maybeCallOnEndReached()

			return
		end

		if v31 and data and #data > 0 and v39.current[#data] then
			v39.current[#data] = false
		end
	end
	local function renderHeaderLoadingIndicator() -- line: 247
		-- upvalues: v29 (copy), ListHeaderComponent (copy), React (copy), v32 (copy), HeaderLoadingIndicator (copy)
		if not v29 then
			if ListHeaderComponent then
				return React.createElement(ListHeaderComponent, nil)
			end

			return nil
		end

		if not v32 then
			return nil
		end

		if HeaderLoadingIndicator then
			return React.createElement(HeaderLoadingIndicator, nil)
		end

		if _G.__DEV__ then
			warn("default activity indicator not available")
		end

		return nil
	end
	local function renderFooterLoadingIndicator() -- line: 277
		-- upvalues: v29 (copy), ListFooterComponent (copy), React (copy), v34 (copy), FooterLoadingIndicator (copy)
		if not v29 then
			if ListFooterComponent then
				return React.createElement(ListFooterComponent, nil)
			end

			return nil
		end

		if not v34 then
			return nil
		end

		if FooterLoadingIndicator then
			return React.createElement(FooterLoadingIndicator, nil)
		end

		if _G.__DEV__ then
			warn("default activity indicator not available")
		end

		return nil
	end

	return React.createElement(React.Fragment, nil, React.createElement(FlatList, Object.assign(table.clone(p1), {
		renderItem = function(p5) -- line: 314
			-- upvalues: React (copy), View (copy), p2 (copy), p1 (copy), enableAutoscrollToTop (copy), v17 (copy)
			local item = p5.item

			return React.createElement(View, {
				BorderSizePixel = 0,
				name = "resize",
				onLayout = function(p6) -- line: 317
					-- upvalues: p2 (copy), p1 (copy), item (copy), enableAutoscrollToTop (copy), v17 (copy)
					local v66 = if not p2 or not p2.current then nil else p2.current._listRef._scrollRef.getNativeScrollRef()._nativeRef.current
					local horizontal = p1.horizontal

					local function v68(vector2: Vector2) -- line: 82
						-- upvalues: horizontal (copy)
						if horizontal then
							return vector2.X
						end

						return vector2.Y
					end

					if item.shouldResizeOnMount and v66 then
						local v69 = v68(p6.AbsoluteSize)

						if v69 <= 0 or v66 == nil then
							item.shouldResizeOnMount = false

							return
						end

						local CanvasPosition = v66.CanvasPosition
						local AbsoluteSize = v66.AbsoluteSize
						local AbsoluteCanvasSize = v66.AbsoluteCanvasSize
						local v73 = if not enableAutoscrollToTop then nil else v17

						if v73 and v73 > if not p1.inverted then v68(CanvasPosition) else v68(AbsoluteCanvasSize) - v68(CanvasPosition) - v68(AbsoluteSize) then
							item.shouldResizeOnMount = false
							v66.CanvasPosition = if not p1.inverted then if not p1.horizontal then Vector2.new(v66.CanvasPosition.X, 0) else Vector2.new(0, v66.CanvasPosition.Y) else if not p1.horizontal then Vector2.new(v66.CanvasPosition.X, v68(AbsoluteCanvasSize) - v68(AbsoluteSize)) else Vector2.new(v68(AbsoluteCanvasSize) - v68(AbsoluteSize), v66.CanvasPosition.Y)

							return
						end

						local v74 = if not p1.inverted then if not p1.horizontal then Vector2.new(CanvasPosition.X, CanvasPosition.Y + v69) else Vector2.new(CanvasPosition.X + v69, CanvasPosition.Y) else if not p1.horizontal then Vector2.new(CanvasPosition.X, CanvasPosition.Y - v69) else Vector2.new(CanvasPosition.X - v69, CanvasPosition.Y)

						item.shouldResizeOnMount = false
						v66.CanvasPosition = v74
					end
				end,
				AutomaticSize = if not p1.horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
				Size = if not p1.horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0)
			}, {
				child = p1.renderItem(p5)
			})
		end,
		ref = p2,
		ListHeaderComponent = renderHeaderLoadingIndicator,
		ListFooterComponent = renderFooterLoadingIndicator,
		onEndReached = Object.None,
		onScroll = handleScroll,
		maintainVisibleContentPosition = {
			minIndexForVisible = 1,
			autoscrollToTopThreshold = if not enableAutoscrollToTop then nil else v17
		}
	})))
end)

return t1

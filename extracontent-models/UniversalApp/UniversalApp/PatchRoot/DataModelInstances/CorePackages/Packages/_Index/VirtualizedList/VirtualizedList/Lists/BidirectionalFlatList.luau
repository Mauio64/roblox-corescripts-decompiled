local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local Promise = require(parent2.Promise)

local React = require(parent2.React)

local useRef = React.useRef
local useState = React.useState

local View = require(parent.Components.View.View)
local FlatList = require(script.Parent.FlatList)

local function _getLength(horizontal: boolean?) -- 2 equivalent calls inferred from this helper
	return function(vector2: Vector2)
		return if horizontal then vector2.X else vector2.Y
	end
end

return {
	BidirectionalFlatList = React.forwardRef(function(props, ref)
		local function promiseFn()
			return Promise.resolve()
		end

		if props.activityIndicatorColor ~= nil then
			local _activityIndicatorColor = props.activityIndicatorColor
		end

		local v = props.autoscrollToTopThreshold == nil and 100 or props.autoscrollToTopThreshold
		local data = props.data
		local enableAutoscrollToTop = props.enableAutoscrollToTop
		local footerLoadingIndicator = props.FooterLoadingIndicator
		local headerLoadingIndicator = props.HeaderLoadingIndicator
		local listHeaderComponent = props.ListHeaderComponent
		local listFooterComponent = props.ListFooterComponent
		local v2

		if props.onEndReached == nil then
			v2 = promiseFn
		else
			v2 = props.onEndReached
		end

		local v3 = props.onEndReachedThreshold == nil and 10 or props.onEndReachedThreshold
		local onScroll = props.onScroll

		if props.onStartReached ~= nil then
			promiseFn = props.onStartReached
		end

		local v4 = props.onStartReachedThreshold == nil and 10 or props.onStartReachedThreshold
		local v5 = props.showDefaultLoadingIndicators == nil or props.showDefaultLoadingIndicators
		local v6

		if props.enableRetryOnStartReached == nil then
			v6 = false
		else
			v6 = props.enableRetryOnStartReached
		end

		local v7

		if props.enableRetryOnEndReached == nil then
			v7 = false
		else
			v7 = props.enableRetryOnEndReached
		end

		local state, setState = useState(false)
		local state2, setState2 = useState(false)
		local state3, setState3 = useState(0)
		local v8 = useRef({})
		local v9 = useRef({})
		local v10 = useRef(nil)
		local v11 = useRef(nil)

		local function maybeCallOnStartReached()
			if data and #data > 0 and v8.current[#data] then
				return
			end

			local v12

			if props.inverted then
				v12 = state3 >= 3
			else
				v12 = state3 >= 1
			end

			if not v12 then
				return
			end

			if data and #data > 0 and v12 then
				v8.current[#data] = true
			end

			setState(true)
			local function p()
				return Promise.new(function(callback)
					v10.current = nil
					setState(false)
					callback()
				end)
			end

			if v11.current then
				v11.current:andThen(function()
					v10.current = promiseFn():andThen(p)
				end)
			else
				v10.current = promiseFn():andThen(p)
			end
		end

		local function maybeCallOnEndReached()
			if data and #data > 0 and v9.current[#data] then
				return
			end

			local v12

			if props.inverted then
				v12 = state3 >= 3
			else
				v12 = state3 >= 1
			end

			if not v12 then
				return
			end

			if data and #data > 0 and v12 then
				v9.current[#data] = true
			end

			setState2(true)
			local function p()
				return Promise.new(function(callback)
					v11.current = nil
					setState2(false)
					callback()
				end)
			end

			if v10.current then
				v10.current:andThen(function()
					v11.current = v2():andThen(p)
				end)
			else
				v11.current = v2():andThen(p)
			end
		end

		local function handleScroll(instance)
			setState3(function(p)
				return p + 1
			end)

			if onScroll then
				onScroll(instance)
			end

			local v12 = instance:GetChildren()[1]
			local length = _getLength(props.horizontal) -- inferred equivalent call
			local v13 = length(instance.AbsoluteSize)
			local v14 = length(v12.AbsoluteSize)
			local v15

			if props.inverted then
				v15 = length(instance.AbsoluteCanvasSize) - length(instance.CanvasPosition) - v13
			else
				v15 = length(instance.CanvasPosition)
			end

			local v16 = v15 < v4
			local v17 = v14 - v13 - v15 < v3

			if v16 then
				maybeCallOnStartReached()
			elseif v6 and data and #data > 0 and v8.current[#data] then
				v8.current[#data] = false
			end

			if v17 then
				maybeCallOnEndReached()
			elseif v7 and data and #data > 0 and v9.current[#data] then
				v9.current[#data] = false
			end
		end

		local function renderHeaderLoadingIndicator()
			if v5 then
				if not state then
					return nil
				end

				if headerLoadingIndicator then
					return React.createElement(headerLoadingIndicator, nil)
				end

				if _G.__DEV__ then
					warn("default activity indicator not available")
				end

				return nil
			elseif listHeaderComponent then
				return React.createElement(listHeaderComponent, nil)
			else
				return nil
			end
		end

		local function renderFooterLoadingIndicator()
			if v5 then
				if not state2 then
					return nil
				end

				if footerLoadingIndicator then
					return React.createElement(footerLoadingIndicator, nil)
				end

				if _G.__DEV__ then
					warn("default activity indicator not available")
				end

				return nil
			elseif listFooterComponent then
				return React.createElement(listFooterComponent, nil)
			else
				return nil
			end
		end

		local createElement = React.createElement
		local fragment = React.Fragment

		local createElement2 = React.createElement

		local assign = Object.assign
		local clone = table.clone(props)
		local v12 = {
			renderItem = function(p)
				local item = p.item
				local createElement3 = React.createElement
				local v12 = {
					onLayout = function(p2)
						local current

						if ref and ref.current then
							current = ref.current._listRef._scrollRef.getNativeScrollRef()._nativeRef.current
						end

						local length = _getLength(props.horizontal) -- inferred equivalent call

						if item.shouldResizeOnMount and current then
							local v12 = length(p2.AbsoluteSize)

							if v12 <= 0 or current == nil then
								item.shouldResizeOnMount = false
								return
							end

							local canvasPosition = current.CanvasPosition
							local absoluteSize = current.AbsoluteSize
							local absoluteCanvasSize = current.AbsoluteCanvasSize
							local v13

							if enableAutoscrollToTop then
								v13 = v
							end

							if v13 then
								local v14

								if props.inverted then
									v14 = length(absoluteCanvasSize) - length(canvasPosition) - length(absoluteSize)
								else
									v14 = length(canvasPosition)
								end

								if v14 < v13 then
									item.shouldResizeOnMount = false
									local vector2

									if props.inverted then
										if props.horizontal then
											vector2 = Vector2.new(
												length(absoluteCanvasSize) - length(absoluteSize),
												current.CanvasPosition.Y
											)
										else
											vector2 = Vector2.new(
												current.CanvasPosition.X,
												length(absoluteCanvasSize) - length(absoluteSize)
											)
										end
									elseif props.horizontal then
										vector2 = Vector2.new(0, current.CanvasPosition.Y)
									else
										vector2 = Vector2.new(current.CanvasPosition.X, 0)
									end

									current.CanvasPosition = vector2

									return
								end
							end

							local vector2

							if props.inverted then
								if props.horizontal then
									vector2 = Vector2.new(canvasPosition.X - v12, canvasPosition.Y)
								else
									vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y - v12)
								end
							elseif props.horizontal then
								vector2 = Vector2.new(canvasPosition.X + v12, canvasPosition.Y)
							else
								vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v12)
							end

							item.shouldResizeOnMount = false
							current.CanvasPosition = vector2
						end
					end,
					AutomaticSize = 0,
					Size = 0,
					BorderSizePixel = 0,
					name = "resize"
				}
				local automaticSize

				if props.horizontal then
					automaticSize = Enum.AutomaticSize.X
				else
					automaticSize = Enum.AutomaticSize.Y
				end

				v12.AutomaticSize = automaticSize
				local size

				if props.horizontal then
					size = UDim2.new(0, 0, 1, 0)
				else
					size = UDim2.new(1, 0, 0, 0)
				end

				v12.Size = size
				return createElement3(View, v12, { child = props.renderItem(p) })
			end,
			ref = ref,
			ListHeaderComponent = renderHeaderLoadingIndicator,
			ListFooterComponent = renderFooterLoadingIndicator,
			onEndReached = Object.None,
			onScroll = handleScroll,
			maintainVisibleContentPosition = 0
		}
		local autoscrollToTopThreshold

		if enableAutoscrollToTop then
			autoscrollToTopThreshold = v
		end

		v12.maintainVisibleContentPosition = {
			autoscrollToTopThreshold = autoscrollToTopThreshold,
			minIndexForVisible = 1
		}
		return createElement(fragment, nil, createElement2(FlatList, assign(clone, v12)))
	end)
}

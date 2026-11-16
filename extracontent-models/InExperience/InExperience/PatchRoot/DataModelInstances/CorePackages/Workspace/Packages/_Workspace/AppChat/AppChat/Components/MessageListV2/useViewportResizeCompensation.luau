local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
require(parent.ViewRecycler)

local function restoreDistanceFromEnd(current, current2: number?) -- 1 equivalent call inferred from this helper
	if current == nil or current2 == nil then
		return
	end

	local distanceFromEnd = current.getScrollState().distanceFromEnd

	if math.abs(distanceFromEnd - current2) <= 1 then
		return
	end

	if current2 <= 1 then
		current.scrollToEnd()
	else
		current.scrollBy(distanceFromEnd - current2)
	end
end

local function useViewportResizeCompensation(p, p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(false)

	React.useEffect(function()
		if p2 == nil then
			return nil
		end

		local v = p2
		local absoluteWindowSizeChangedConnection = v:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
			ref4.current = ref2.current ~= nil and v.AbsoluteWindowSize.Y ~= ref2.current
		end)
		return function()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { p2 })

	return React.useMemo(function()
		return {
			onScrolled = function(current: number)
				local current2 = ref.current

				if current2 ~= nil and current2.AbsoluteWindowSize.Y == ref2.current then
					ref3.current = current
				end
			end,
			onContentLengthChanged = function()
				local current = p.current

				if current == nil then
					return
				end

				local scrollState = current.getScrollState()

				if scrollState.viewportLength == ref2.current and not ref4.current then
					ref3.current = scrollState.distanceFromEnd
				end
			end,
			onViewportChanged = function(current: number)
				local current2 = ref2.current
				ref2.current = current
				ref4.current = false
				local current3 = p.current

				if current2 ~= nil and current2 ~= current then
					restoreDistanceFromEnd(current3, ref3.current) -- inferred equivalent call
				end

				if current3 ~= nil then
					ref3.current = current3.getScrollState().distanceFromEnd
				end
			end,
			onScrollingFrameChanged = function(current)
				if ref.current ~= nil and current ~= ref.current then
					ref2.current = nil
					ref3.current = nil
					ref4.current = false
				end

				ref.current = current
			end
		}
	end, {})
end

return useViewportResizeCompensation

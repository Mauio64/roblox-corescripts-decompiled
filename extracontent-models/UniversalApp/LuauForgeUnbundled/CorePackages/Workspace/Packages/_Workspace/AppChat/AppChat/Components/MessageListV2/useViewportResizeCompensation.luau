local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local function restoreDistanceFromEnd(data, p2)
	if data == nil or p2 == nil then
		return
	end

	local distanceFromEnd = data.getScrollState().distanceFromEnd

	if math.abs(distanceFromEnd - p2) <= 1 then
		return
	end

	if p2 <= 1 then
		data.scrollToEnd()
	else
		data.scrollBy(distanceFromEnd - p2)
	end
end

local function useViewportResizeCompensation(p2, p3)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(false)

	React.useEffect(function()
		if p3 == nil then
			return nil
		end

		local v5 = p3
		local absoluteWindowSizeChangedConnection = v5:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
			ref4.current = ref2.current ~= nil and v5.AbsoluteWindowSize.Y ~= ref2.current
		end)
		return function()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { p3 })

	return React.useMemo(function()
		return {
			onScrolled = function(current)
				local current2 = ref.current

				if current2 ~= nil and current2.AbsoluteWindowSize.Y == ref2.current then
					ref3.current = current
				end
			end,
			onContentLengthChanged = function()
				local current = p2.current

				if current == nil then
					return
				end

				local scrollState = current.getScrollState()

				if scrollState.viewportLength == ref2.current and not ref4.current then
					ref3.current = scrollState.distanceFromEnd
				end
			end,
			onViewportChanged = function(current)
				local current2 = ref2.current
				ref2.current = current
				ref4.current = false
				local current3 = p2.current

				if current2 ~= nil and current2 ~= current then
					local current4 = ref3.current

					if current3 ~= nil and current4 ~= nil then
						local distanceFromEnd = current3.getScrollState().distanceFromEnd

						if not (math.abs(distanceFromEnd - current4) <= 1) then
							if current4 <= 1 then
								current3.scrollToEnd()
							else
								current3.scrollBy(distanceFromEnd - current4)
							end
						end
					end
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

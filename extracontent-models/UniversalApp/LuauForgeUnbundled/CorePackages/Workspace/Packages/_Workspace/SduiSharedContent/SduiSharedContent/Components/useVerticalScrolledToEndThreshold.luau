local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local defineFastFlag = game:DefineFastFlag("SduiFeedCacheScrollExtents", false)

local function useVerticalScrolledToEndThreshold(p2, p3, current)
	local ref = React.useRef(false)
	local ref2 = React.useRef(current)
	ref2.current = current

	if current == nil then
		p3 = nil
	end

	React.useEffect(function()
		if p3 == nil or p2.current == nil then
			return nil
		end

		local connections = {}
		local current2 = p2.current
		local v5

		if defineFastFlag then
			local y = current2.AbsoluteCanvasSize.Y
			local y2 = current2.AbsoluteWindowSize.Y

			local function refreshSizes()
				y = current2.AbsoluteCanvasSize.Y
				y2 = current2.AbsoluteWindowSize.Y
			end

			local function evaluateThreshold()
				local v6 = y - y2 - p3
				local y3 = current2.CanvasPosition.Y

				if y3 < v6 and ref.current then
					ref.current = false
				elseif v6 < y3 and not ref.current then
					ref.current = true

					if ref2.current then
						ref2.current()
					end
				end
			end

			v5 = function()
				y = current2.AbsoluteCanvasSize.Y
				y2 = current2.AbsoluteWindowSize.Y

				local v6 = y - y2 - p3
				local y3 = current2.CanvasPosition.Y

				if y3 < v6 and ref.current then
					ref.current = false
				elseif v6 < y3 and not ref.current then
					ref.current = true

					if ref2.current then
						ref2.current()
					end
				end
			end
			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v5))

			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v5))

			table.insert(
				connections,
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(evaluateThreshold)
			)
		else
			v5 = function()
				local v6 = current2.AbsoluteCanvasSize.Y - current2.AbsoluteWindowSize.Y - p3
				local y = current2.CanvasPosition.Y

				if y < v6 and ref.current then
					ref.current = false
				elseif v6 < y and not ref.current then
					ref.current = true

					if ref2.current then
						ref2.current()
					end
				end
			end
			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v5))

			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v5))

			table.insert(connections, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(v5))
		end

		local v6 = false
		task.defer(function()
			if not v6 then
				v5()
			end
		end)

		return function()
			v6 = true

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, p3 })
end

return useVerticalScrolledToEndThreshold

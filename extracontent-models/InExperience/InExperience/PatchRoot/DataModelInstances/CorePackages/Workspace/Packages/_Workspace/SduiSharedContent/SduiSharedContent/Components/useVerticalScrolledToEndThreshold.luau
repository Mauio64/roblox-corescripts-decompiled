local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(parent.React)

local defineFastFlag = game:DefineFastFlag("SduiFeedCacheScrollExtents", false)

local function useVerticalScrolledToEndThreshold(p, p2: number?, current)
	local ref = React.useRef(false)
	local ref2 = React.useRef(current)
	ref2.current = current

	if current == nil then
		p2 = nil
	end

	React.useEffect(function()
		if p2 == nil or p.current == nil then
			return nil
		end

		local connections = {}
		local current2 = p.current
		local v

		if defineFastFlag then
			local y = current2.AbsoluteCanvasSize.Y
			local y2 = current2.AbsoluteWindowSize.Y

			local function refreshSizes() -- 1 equivalent call inferred from this helper
				y = current2.AbsoluteCanvasSize.Y
				y2 = current2.AbsoluteWindowSize.Y
			end

			local function evaluateThreshold() -- 1 equivalent call inferred from this helper
				local v2 = y - y2 - p2
				local y3 = current2.CanvasPosition.Y

				if y3 < v2 and ref.current then
					ref.current = false
				elseif v2 < y3 and not ref.current then
					ref.current = true

					if ref2.current then
						ref2.current()
					end
				end
			end

			v = function()
				refreshSizes() -- inferred equivalent call
				evaluateThreshold() -- inferred equivalent call
			end
			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v))

			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v))

			table.insert(connections, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(evaluateThreshold))
		else
			v = function()
				local v2 = current2.AbsoluteCanvasSize.Y - current2.AbsoluteWindowSize.Y - p2
				local y = current2.CanvasPosition.Y

				if y < v2 and ref.current then
					ref.current = false
				elseif v2 < y and not ref.current then
					ref.current = true

					if ref2.current then
						ref2.current()
					end
				end
			end
			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v))

			table.insert(connections, current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v))

			table.insert(connections, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(v))
		end

		local v2 = false
		task.defer(function()
			if not v2 then
				v()
			end
		end)

		return function()
			v2 = true

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p, p2 })
end

return useVerticalScrolledToEndThreshold

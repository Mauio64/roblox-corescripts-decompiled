local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")

local function useHorizontalScrolledToEndThreshold(p2, p3, callback, p4)
	local ref = React.useRef(false)

	React.useEffect(function()
		if not p4 then
			return nil
		end

		local connections = {}
		local v5 = not (p2.current == nil or callback == nil) and p3 ~= nil

		if v5 then
			local current = p2.current

			local function checkThreshold()
				local v6 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p3
				local x = current.CanvasPosition.X

				if x < v6 and ref.current then
					ref.current = false
				elseif v6 < x and not ref.current then
					ref.current = true
					callback()
				end
			end
			table.insert(
				connections,
				current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					local v6 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p3
					local x = current.CanvasPosition.X

					if x < v6 and ref.current then
						ref.current = false
					elseif v6 < x and not ref.current then
						ref.current = true
						callback()
					end
				end)
			)

			table.insert(
				connections,
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
					local v6 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p3
					local x = current.CanvasPosition.X

					if x < v6 and ref.current then
						ref.current = false
					elseif v6 < x and not ref.current then
						ref.current = true
						callback()
					end
				end)
			)

			table.insert(connections, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				local v6 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p3
				local x = current.CanvasPosition.X

				if x < v6 and ref.current then
					ref.current = false
				elseif v6 < x and not ref.current then
					ref.current = true
					callback()
				end
			end))
			local v6 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - p3
			local x = current.CanvasPosition.X

			if x < v6 and ref.current then
				ref.current = false
			elseif v6 < x and not ref.current then
				ref.current = true
				callback()
			end
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, p4, p3, callback })
end

return useHorizontalScrolledToEndThreshold

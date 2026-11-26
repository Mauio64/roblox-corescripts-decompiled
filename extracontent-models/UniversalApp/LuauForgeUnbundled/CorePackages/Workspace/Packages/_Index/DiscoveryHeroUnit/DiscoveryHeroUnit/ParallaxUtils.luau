local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/React")

local function customEasing(p2, p3, p4, p5, p6)
	return (1 - p2) ^ 3 * p3 + 3 * (1 - p2) ^ 2 * p2 * p4 + 3 * (1 - p2) * p2 ^ 2 * p5 + p2 ^ 3 * p6
end

return {
	useNormalizedVerticalProgress = function(p2, p3)
		local v5, v6 = React.useBinding(-1)

		React.useEffect(function()
			local v7

			if p2 and p2.current and p3.current then
				local current = p3.current
				local current2 = p2.current

				local y = current2.AbsolutePosition.Y
				local y2 = current2.AbsoluteWindowSize.Y

				local function calculateOffset()
					return current.AbsolutePosition.Y + current2.CanvasPosition.Y - y
				end
				local v8 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y

				local function updateBinding()
					if y2 == 0 then
						return
					end

					v6((v8 - current2.CanvasPosition.Y) / y2)
				end

				local function updateWindowParams()
					y = current2.AbsolutePosition.Y
					y2 = current2.AbsoluteWindowSize.Y
					v8 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y

					if y2 == 0 then
						return
					end

					v6((v8 - current2.CanvasPosition.Y) / y2)
				end

				y = current2.AbsolutePosition.Y
				y2 = current2.AbsoluteWindowSize.Y
				v8 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y

				if y2 ~= 0 then
					v6((v8 - current2.CanvasPosition.Y) / y2)
				end

				v7 = {
					current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateBinding)
				}
			else
				v7 = {}
			end

			return function()
				for k, connection in v7 do
					connection:Disconnect()
				end
			end
		end, { p3, p2 })

		return v5
	end,
	getYPositionOffsetForMotion = function(value, p2, p3, p4)
		local v5 = math.clamp(value, -1, 1)

		if v5 >= 0 then
			local v6 = (1 - v5) ^ 3 * 0 + 3 * (1 - v5) ^ 2 * v5 * 0.3 + 3 * (1 - v5) * v5 ^ 2 * 0.6 + v5 ^ 3 * 1

			return p3 * v6 + p4 * (1 - v6)
		end

		local v6 = -v5
		local v7 = (1 - v6) ^ 3 * 0 + 3 * (1 - v6) ^ 2 * v6 * 0.3 + 3 * (1 - v6) * v6 ^ 2 * 0.6 + v6 ^ 3 * 1

		return p2 * v7 + p4 * (1 - v7)
	end,
	getNormalizedTopPosition = function(data, p2)
		if not (p2 and data) then
			return nil
		end

		local y = data.AbsolutePosition.Y
		local y2 = data.AbsoluteWindowSize.Y
		local v5 = p2.AbsolutePosition.Y + data.CanvasPosition.Y - y - data.CanvasPosition.Y

		if y2 == 0 then
			return nil
		end

		return v5 / y2
	end
}

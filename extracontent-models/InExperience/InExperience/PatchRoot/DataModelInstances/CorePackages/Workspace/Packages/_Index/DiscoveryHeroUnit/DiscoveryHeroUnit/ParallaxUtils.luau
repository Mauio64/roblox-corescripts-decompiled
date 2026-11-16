local parent = script:FindFirstAncestor("DiscoveryHeroUnit").Parent
local React = require(parent.React)

local function customEasing(p, p2, p3, p4, p5) -- 2 equivalent calls inferred from this helper
	return (1 - p) ^ 3 * p2 + 3 * (1 - p) ^ 2 * p * p3 + 3 * (1 - p) * p ^ 2 * p4 + p ^ 3 * p5
end

local ParallaxUtils = {}

function ParallaxUtils.useNormalizedVerticalProgress(p, p2)
	local v, v2 = React.useBinding(-1)

	React.useEffect(function()
		local v3

		if p and p.current and p2.current then
			local current = p2.current
			local current2 = p.current

			local y = current2.AbsolutePosition.Y
			local y2 = current2.AbsoluteWindowSize.Y

			local function calculateOffset() -- 1 equivalent call inferred from this helper
				return current.AbsolutePosition.Y + current2.CanvasPosition.Y - y
			end
			local v4 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y

			local function updateBinding() -- 1 equivalent call inferred from this helper
				if y2 == 0 then
					return
				end

				v2((v4 - current2.CanvasPosition.Y) / y2)
			end

			local function updateWindowParams()
				y = current2.AbsolutePosition.Y
				y2 = current2.AbsoluteWindowSize.Y
				v4 = calculateOffset() -- inferred equivalent call
				updateBinding() -- inferred equivalent call
			end

			y = current2.AbsolutePosition.Y
			y2 = current2.AbsoluteWindowSize.Y
			v4 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y

			if y2 ~= 0 then
				v2((v4 - current2.CanvasPosition.Y) / y2)
			end

			v3 = {
				current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams),
				current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateWindowParams),
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateBinding)
			}
		else
			v3 = {}
		end

		return function()
			for _, connection in v3 do
				connection:Disconnect()
			end
		end
	end, { p2, p })

	return v
end

function ParallaxUtils.getYPositionOffsetForMotion(value: number, p: number, p2: number, p3: number)
	local v = math.clamp(value, -1, 1)

	if v >= 0 then
		local v2 = customEasing(v, 0, 0.3, 0.6, 1) -- inferred equivalent call
		return p2 * v2 + p3 * (1 - v2)
	end

	local v2 = customEasing(-v, 0, 0.3, 0.6, 1) -- inferred equivalent call
	return p * v2 + p3 * (1 - v2)
end

function ParallaxUtils.getNormalizedTopPosition(data, p)
	if not (p and data) then
		return nil
	end

	local y = data.AbsolutePosition.Y
	local y2 = data.AbsoluteWindowSize.Y
	local v = p.AbsolutePosition.Y + data.CanvasPosition.Y - y - data.CanvasPosition.Y

	if y2 == 0 then
		return nil
	end

	return v / y2
end

return ParallaxUtils

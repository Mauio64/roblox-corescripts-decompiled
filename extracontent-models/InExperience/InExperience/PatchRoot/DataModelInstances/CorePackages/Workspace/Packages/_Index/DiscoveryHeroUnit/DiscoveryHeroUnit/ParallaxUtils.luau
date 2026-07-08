local Parent = script:FindFirstAncestor("DiscoveryHeroUnit").Parent
local React = require(Parent.React)
local FFlagLuaAppHeroUnitParallaxUpdates = require(Parent.SharedFlags).FFlagLuaAppHeroUnitParallaxUpdates

local function getNormalizedCenterPosition(p1, p2) -- line: 10
	if p2 and p1 then
		local AbsolutePositionY = p1.AbsolutePosition.Y
		local AbsoluteWindowSizeY = p1.AbsoluteWindowSize.Y
		local v11 = p2.AbsolutePosition.Y + p1.CanvasPosition.Y - AbsolutePositionY + p2.AbsoluteSize.Y * 0.5 - p1.CanvasPosition.Y

		if AbsoluteWindowSizeY == 0 then
			return nil
		end

		return v11 / AbsoluteWindowSizeY
	end

	return nil
end
local function getNormalizedTopPosition(p3, p4) -- line: 32
	if p4 and p3 then
		local AbsolutePositionY = p3.AbsolutePosition.Y
		local AbsoluteWindowSizeY = p3.AbsoluteWindowSize.Y
		local v16 = p4.AbsolutePosition.Y + p3.CanvasPosition.Y - AbsolutePositionY - p3.CanvasPosition.Y

		if AbsoluteWindowSizeY == 0 then
			return nil
		end

		return v16 / AbsoluteWindowSizeY
	end

	return nil
end
local function customEasing(p5, p6, p7, p8, p9) -- line: 123
	return (1 - p5) ^ 3 * p6 + 3 * (1 - p5) ^ 2 * p5 * p7 + 3 * (1 - p5) * p5 ^ 2 * p8 + p5 ^ 3 * p9
end

return {
	useNormalizedVerticalProgress = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 55
		-- upvalues: React (copy)
		local v19, v20 = React.useBinding(-1)

		React.useEffect(function() -- line: 62
			-- upvalues: t1 (copy), t2 (copy), v20 (copy)
			local t3 = {}

			if t1 and (t1.current and t2.current) then
				local current = t2.current
				local current2 = t1.current
				local AbsolutePositionY = current2.AbsolutePosition.Y
				local AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y

				local function calculateOffset() -- line: 72
					-- upvalues: current (copy), current2 (copy), AbsolutePositionY (ref)
					return current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY
				end

				local u42 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY

				local function updateBinding() -- line: 79
					-- upvalues: AbsoluteWindowSizeY (ref), u42 (ref), current2 (copy), v20 (copy)
					if AbsoluteWindowSizeY == 0 then
						return
					end

					local v46 = (u42 - current2.CanvasPosition.Y) / AbsoluteWindowSizeY

					v20(v46)
				end
				local function updateWindowParams() -- line: 90
					-- upvalues: AbsolutePositionY (ref), current2 (copy), AbsoluteWindowSizeY (ref), u42 (ref), current (copy), v20 (copy)
					AbsolutePositionY = current2.AbsolutePosition.Y
					AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
					u42 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY

					if AbsoluteWindowSizeY == 0 then
						return
					end

					local v47 = (u42 - current2.CanvasPosition.Y) / AbsoluteWindowSizeY

					v20(v47)
				end

				AbsolutePositionY = current2.AbsolutePosition.Y
				AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
				u42 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY

				if AbsoluteWindowSizeY ~= 0 then
					local v45 = (u42 - current2.CanvasPosition.Y) / AbsoluteWindowSizeY

					v20(v45)
				end

				t3 = {
					current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateWindowParams),
					current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateBinding)
				}
			end

			return function() -- line: 106
				-- upvalues: t3 (ref)
				for _, v49 in t3 do
					v49:Disconnect()
				end
			end
		end, {
			t2,
			t1
		})

		return v19
	end,
	getYPositionOffsetForMotion = function(n1: number, n2: number, n3: number, n4: number) -- line: 127
		-- upvalues: FFlagLuaAppHeroUnitParallaxUpdates (copy)
		if FFlagLuaAppHeroUnitParallaxUpdates then
			local v30 = math.clamp(n1, -1, 1)

			if v30 >= 0 then
				local v31 = (1 - v30) ^ 3 * 0 + 3 * (1 - v30) ^ 2 * v30 * 0.3 + 3 * (1 - v30) * v30 ^ 2 * 0.6 + v30 ^ 3 * 1

				return n3 * v31 + n4 * (1 - v31)
			end

			local v32 = -v30
			local v33 = (1 - v32) ^ 3 * 0 + 3 * (1 - v32) ^ 2 * v32 * 0.3 + 3 * (1 - v32) * v32 ^ 2 * 0.6 + v32 ^ 3 * 1

			return n2 * v33 + n4 * (1 - v33)
		end

		local v34 = math.clamp(n1, 0, 1)
		local v35 = ((1 - v34) ^ 3 * 0.25 + 3 * (1 - v34) ^ 2 * v34 * 0.25 + 3 * (1 - v34) * v34 ^ 2 * 0.5 + v34 ^ 3 * 1 - 0.25) / 0.75

		return n3 * v35 + n2 * (1 - v35)
	end,
	getNormalizedCenterPosition = if not FFlagLuaAppHeroUnitParallaxUpdates then getNormalizedCenterPosition else nil,
	getNormalizedTopPosition = if not FFlagLuaAppHeroUnitParallaxUpdates then nil else getNormalizedTopPosition
}

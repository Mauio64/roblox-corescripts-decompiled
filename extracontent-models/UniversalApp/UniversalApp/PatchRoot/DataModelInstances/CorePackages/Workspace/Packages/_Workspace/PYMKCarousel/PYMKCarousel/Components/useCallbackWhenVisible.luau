local Parent = script:FindFirstAncestor("PYMKCarousel").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigationFocus = require(Parent.Navigation).useNavigationFocus
local v5 = game:DefineFastInt("HomePagePYMKPercentageOfViewPortToStartFetch", 25)

local function v6() -- line: 22
	-- upvalues: useSelector (copy), React (copy)
	local v7 = useSelector(function(p1) -- line: 23
		return p1.ScreenSize
	end)
	local v8 = useSelector(function(p2) -- line: 26
		return p2.TopBar.topBarHeight
	end)
	local v9 = useSelector(function(p3) -- line: 29
		return p3.GlobalGuiInset
	end)

	return (React.useMemo(function() -- line: 32
		-- upvalues: v8 (copy), v7 (copy), v9 (copy)
		return {
			min = Vector2.new(0, v8),
			max = Vector2.new(v7.X, v7.Y - v9.bottom)
		}
	end, {
		v8,
		v7,
		v9
	}))
end

return function(t1: {[any]: any}) -- line: 67
	-- upvalues: useNavigationFocus (copy), v6 (copy), React (copy), v5 (copy)
	local elementRef = t1.elementRef
	local scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal
	local callback = t1.callback
	local v22 = useNavigationFocus()
	local v23 = v6()

	React.useEffect(function() -- line: 76
		-- upvalues: v23 (copy), elementRef (copy), v5 (copy), v22 (copy), callback (copy), scrollViewPositionChangedSignal (copy)
		local v27 = v23
		local v28 = elementRef
		local v29 = v28 and v28.current
		local v30

		if not v29 then
			v30 = false
		else
			local AbsolutePositionY = v29.AbsolutePosition.Y
			local v32 = v29.AbsolutePosition.Y + v29.AbsoluteSize.Y
			local minY = v27.min.Y
			local maxY = v27.max.Y
			local v35 = (maxY - minY) / 100 * v5

			v30 = AbsolutePositionY > minY - v35 and v32 < maxY + v35
		end

		if v30 and v22 then
			callback()
		end

		if scrollViewPositionChangedSignal then
			scrollViewPositionChangedSignal:connect(function() -- line: 82
				-- upvalues: v23 (copy), elementRef (copy), v5 (copy), v22 (copy), callback (copy)
				local v36 = v23
				local v37 = elementRef
				local v38 = v37 and v37.current
				local v39

				if not v38 then
					v39 = false
				else
					local AbsolutePositionY = v38.AbsolutePosition.Y
					local v41 = v38.AbsolutePosition.Y + v38.AbsoluteSize.Y
					local minY = v36.min.Y
					local maxY = v36.max.Y
					local v44 = (maxY - minY) / 100 * v5

					v39 = AbsolutePositionY > minY - v44 and v41 < maxY + v44
				end

				if v39 and v22 then
					callback()
				end
			end)
		end
	end, {
		elementRef,
		scrollViewPositionChangedSignal,
		v22,
		v23
	})
end

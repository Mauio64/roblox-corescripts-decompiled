local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local FFlagCollectionViewMathChanges = require(CollectionViewsParent.SharedFlags).FFlagCollectionViewMathChanges

require(CollectionViews.Carousel.calculateCarouselSpacingMetrics)

local function useHorizontalWindowStartIndex(t1: {[any]: any}, p1, n1: number, b1: boolean, n2: number, p2) -- line: 14
	-- upvalues: React (copy), FFlagCollectionViewMathChanges (copy)
	local v12, v13 = React.useState(1)
	local v14 = React.useCallback(function() -- line: 26
		-- upvalues: b1 (copy), t1 (copy), FFlagCollectionViewMathChanges (copy), n2 (copy), p2 (copy), p1 (copy), n1 (copy), v13 (copy)
		if b1 then
			if t1.current ~= nil and (not FFlagCollectionViewMathChanges or n2 > 0) then
				local CanvasPositionX = t1.current.CanvasPosition.X
				local v16 = if not FFlagCollectionViewMathChanges then p1:getValue().X + n1 else p2:getValue().stride

				if v16 > 0 then
					v13((math.max(1, (math.floor(CanvasPositionX / v16)))))

					return
				end

				v13(1)

				return
			end
		else
			v13(1)
		end
	end, {
		b1,
		t1,
		if not FFlagCollectionViewMathChanges then p1 else p2,
		if not FFlagCollectionViewMathChanges then n1 else n2
	})

	React.useEffect(function() -- line: 56
		-- upvalues: v14 (copy)
		v14()
	end, { v14 })
	React.useEffect(function() -- line: 64
		-- upvalues: b1 (copy), t1 (copy), v14 (copy)
		if not b1 then
			return nil
		end

		local t2 = {}

		if t1.current ~= nil then
			v14()
			table.insert(t2, t1.current:GetPropertyChangedSignal("CanvasPosition"):Connect(v14))
			table.insert(t2, t1.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v14))
		end

		return function() -- line: 80
			-- upvalues: t2 (copy)
			for _, v19 in t2 do
				v19:Disconnect()
			end
		end
	end, {
		t1,
		v14,
		b1
	})

	return v12
end

return useHorizontalWindowStartIndex

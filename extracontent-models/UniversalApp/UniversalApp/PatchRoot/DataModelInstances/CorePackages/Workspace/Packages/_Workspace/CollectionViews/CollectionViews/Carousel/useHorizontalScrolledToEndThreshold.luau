local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)
local FFlagCollectionViewMathChanges = require(Parent.SharedFlags).FFlagCollectionViewMathChanges

local function useHorizontalScrolledToEndThreshold(t1: {[any]: any}, n1: number?, p1: ((...any) -> ...any)?, b1: boolean) -- line: 9
	-- upvalues: React (copy), FFlagCollectionViewMathChanges (copy)
	local v9 = React.useRef(false)

	React.useEffect(function() -- line: 24
		-- upvalues: b1 (copy), t1 (copy), FFlagCollectionViewMathChanges (copy), p1 (copy), n1 (copy), v9 (copy)
		if not b1 then
			return nil
		end

		local t2 = {}

		if t1.current ~= nil and (FFlagCollectionViewMathChanges or p1 ~= nil and n1 ~= nil) then
			local current = t1.current

			local function checkThreshold() -- line: 35
				-- upvalues: current (copy), FFlagCollectionViewMathChanges (copy), n1 (copy), v9 (copy), p1 (copy)
				local v13 = current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X - if not FFlagCollectionViewMathChanges then n1 else n1 or 0
				local CanvasPositionX = current.CanvasPosition.X

				if CanvasPositionX < v13 and v9.current then
					v9.current = false

					return
				end

				if v13 < CanvasPositionX and not v9.current then
					v9.current = true

					if FFlagCollectionViewMathChanges then
						if p1 then
							p1()

							return
						end
					else
						p1()
					end
				end
			end

			table.insert(t2, current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 55
				-- upvalues: checkThreshold (copy)
				checkThreshold()
			end))
			table.insert(t2, current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 62
				-- upvalues: checkThreshold (copy)
				checkThreshold()
			end))
			table.insert(t2, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 68
				-- upvalues: checkThreshold (copy)
				checkThreshold()
			end))
			checkThreshold()
		end

		return function() -- line: 74
			-- upvalues: t2 (copy)
			for _, v16 in t2 do
				v16:Disconnect()
			end
		end
	end, {
		t1,
		b1,
		n1,
		p1
	})
end

return useHorizontalScrolledToEndThreshold

local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Constants = require(Foundation.Constants)

require(Foundation.Providers.StudioPanels.Types)
require(Foundation.Enums.PopoverAlign)
require(Foundation.Enums.PopoverSide)

local React = require(FoundationParent.React)
local positioning = require(script.Parent.Parent.positioning)
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function useConnectSignals(p1, t1: {[any]: any}, p2) -- line: 28
	-- upvalues: React (copy)
	React.useLayoutEffect(function() -- line: 34
		-- upvalues: p1 (copy), t1 (copy), p2 (copy)
		local t2 = {}

		if p1 ~= nil then
			for _, v27 in t1 do
				t2[v27] = p1:GetPropertyChangedSignal(v27):Connect(if type(p2) ~= "table" then p2 else function() -- line: 40
					-- upvalues: p2 (copy)
					p2.current()
				end)
			end
		end

		return function() -- line: 47
			-- upvalues: t2 (copy)
			for _, v39 in t2 do
				v39:Disconnect()
			end
		end
	end, {
		p1,
		p2
	})
end
local function usePanelSizing(p3, p4, p5, n1: number?, p6) -- line: 55
	-- upvalues: React (copy), positioning (copy), SHADOW_SIZE (copy)
	local v17, v18 = React.useBinding(UDim2.new())
	local v19, v20 = React.useBinding(UDim2.new())
	local v21 = React.useRef(nil)
	local v22 = React.useRef(function() -- line: 66
	end)
	local v23 = React.useCallback(function() -- line: 68
		-- upvalues: p5 (copy), p3 (copy), p4 (copy), n1 (copy), positioning (copy), SHADOW_SIZE (copy), v20 (copy), v18 (copy), p6 (copy), v21 (copy)
		if not p5 then
			return
		end

		local AbsoluteSize = p5.AbsoluteSize
		local v29 = if type(p3) ~= "table" then p3 else p3.position
		local v30 = type(p3) ~= "table" and 0 or p3.offset
		local n2 = 0

		if type(p4) == "table" then
			n2 = p4.offset
		end

		local v32 = n1 or 0
		local v33 = positioning.calculatePopoverBounds(v29, v30, n2, v32, AbsoluteSize) + Vector2.new(SHADOW_SIZE * 2, SHADOW_SIZE * 2)

		v20(UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y))
		v18(UDim2.fromOffset(v33.X, v33.Y))

		local _ = p5.AbsolutePosition

		if p6 then
			if v21.current then
				task.cancel(v21.current)
			end

			v21.current = task.spawn(function() -- line: 100
				-- upvalues: p6 (copy), v33 (copy)
				p6.setSizeAsync(v33)
			end)
		end
	end, {
		p5,
		p3,
		p4,
		n1,
		p6
	})

	v22.current = v23

	local t3 = { "AbsoluteSize" }

	React.useLayoutEffect(function() -- line: 34
		-- upvalues: p5 (copy), t3 (copy), v22 (copy)
		local t4 = {}

		if p5 ~= nil then
			for _, v37 in t3 do
				t4[v37] = p5:GetPropertyChangedSignal(v37):Connect(if type(v22) ~= "table" then v22 else function() -- line: 40
					-- upvalues: v22 (copy)
					v22.current()
				end)
			end
		end

		return function() -- line: 47
			-- upvalues: t4 (copy)
			for _, v41 in t4 do
				v41:Disconnect()
			end
		end
	end, {
		p5,
		v22
	})
	React.useLayoutEffect(function() -- line: 109
		-- upvalues: v23 (copy)
		v23()
	end, { v23 })
	React.useEffect(function() -- line: 113
		-- upvalues: v21 (copy)
		return function() -- line: 114
			-- upvalues: v21 (copy)
			if v21.current then
				task.cancel(v21.current)
			end
		end
	end, {})

	return v17, v19
end

return usePanelSizing

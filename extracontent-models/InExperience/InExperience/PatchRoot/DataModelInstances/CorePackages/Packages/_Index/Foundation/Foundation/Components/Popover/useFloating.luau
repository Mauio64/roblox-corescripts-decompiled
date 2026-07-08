local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Enums.PopoverAlign)
require(Foundation.Enums.PopoverSide)

local React = require(FoundationParent.React)
local positioning = require(script.Parent.positioning)

require(Foundation.Components.Types)

local function useConnectSignals(p1, t1: {[any]: any}, p2) -- line: 27
	-- upvalues: React (copy)
	local v11 = React.useRef({})

	React.useLayoutEffect(function() -- line: 34
		-- upvalues: p1 (copy), t1 (copy), v11 (copy), p2 (copy)
		if p1 ~= nil then
			for _, v36 in t1 do
				local v37 = if typeof(p1) ~= "Instance" then p1:GetPropertyChangedSignal(v36) else p1:GetPropertyChangedSignal(v36)

				v11.current[v36] = v37:Connect(if type(p2) ~= "table" then p2 else function() -- line: 43
					-- upvalues: p2 (copy)
					p2.current()
				end)
			end
		end

		return function() -- line: 51
			-- upvalues: v11 (copy)
			for _, v66 in v11.current do
				v66:Disconnect()
			end
		end
	end, {
		p1,
		p2
	})
end
local function useFloating(b1: boolean, p3, p4, p5, p6, p7, n1: number?) -- line: 59
	-- upvalues: React (copy), Flags (copy), positioning (copy), useConnectSignals (copy)
	local v19, v20 = React.useBinding(Vector2.new())
	local v21, v22 = React.useBinding(true)
	local v23, v24 = React.useBinding(UDim2.new())
	local v25, v26 = React.useBinding(Vector2.new())
	local v27, v28 = React.useBinding(Vector2.new())
	local v29, v30 = React.useBinding(Vector2.new(0, 0))
	local v31 = React.useRef(function() -- line: 74
	end)
	local v32 = if not Flags.FoundationPopoverClipAwareVisibility then nil else React.useRef({})
	local v33 = if not Flags.FoundationPopoverClipAwareVisibility then nil else React.useRef(false)
	local v34 = React.useCallback(function() -- line: 82
		-- upvalues: b1 (copy), p3 (copy), p4 (copy), p5 (copy), v22 (copy), positioning (copy), Flags (copy), v32 (copy), p6 (copy), p7 (copy), n1 (copy), v24 (copy), v26 (copy), v28 (copy), v20 (copy), v30 (copy)
		if not b1 or (not p3 or not p4 or not p5) then
			v22(false)

			return
		end

		local AbsolutePosition = p3.AbsolutePosition
		local AbsoluteSize = p3.AbsoluteSize
		local AbsoluteSize2 = p4.AbsoluteSize
		local AbsoluteSize3 = p5.AbsoluteSize
		local AbsolutePosition2 = p5.AbsolutePosition
		local rect = Rect.new(AbsolutePosition, AbsolutePosition + AbsoluteSize)
		local rect2 = Rect.new(AbsolutePosition2, AbsolutePosition2 + AbsoluteSize3)

		if not positioning.isOnScreen(rect, rect2) then
			v22(false)

			return
		end

		if Flags.FoundationPopoverClipAwareVisibility then
			local v45 = nil

			for _, v47 in v32.current do
				local rect3 = Rect.new(v47.AbsolutePosition, v47.AbsolutePosition + v47.AbsoluteSize)

				v45 = if v45 ~= nil then Rect.new(Vector2.new(math.max(v45.Min.X, rect3.Min.X), (math.max(v45.Min.Y, rect3.Min.Y))), Vector2.new(math.min(v45.Max.X, rect3.Max.X), (math.min(v45.Max.Y, rect3.Max.Y)))) else rect3
			end

			if v45 and not positioning.isOnScreen(rect, v45) then
				v22(false)

				return
			end
		end

		local v49 = if type(p6) ~= "table" then p6 else p6.position
		local v50 = type(p6) ~= "table" and 0 or p6.offset
		local v51 = p7
		local n2 = 0

		if type(p7) == "table" then
			v51 = p7.position
			n2 = p7.offset
		end

		local v53 = n1 or 0
		local v54 = positioning.calculatePopoverBounds(v49, v50, n2, v53, AbsoluteSize2)
		local v55 = positioning.calculateSide(v49, rect, rect2, v54)
		local v56, v57, v58 = positioning.calculatePositions(v55, v50, v51, n2, rect, rect2, v53, AbsoluteSize2)

		v24(UDim2.fromOffset(AbsoluteSize2.X, AbsoluteSize2.Y))
		v26(AbsoluteSize3)
		v28(v57 + v56)
		v20(v56)
		v30(v58)
		v22(true)

		local _ = p4.AbsolutePosition
	end, {
		b1,
		p3,
		p4,
		p5,
		p6,
		p7,
		n1
	})

	if Flags.FoundationPopoverClipAwareVisibility then
		function v31.current() -- line: 175
			-- upvalues: v33 (copy), v34 (copy)
			if v33.current then
				return
			end

			v33.current = true
			task.defer(function() -- line: 180
				-- upvalues: v33 (copy), v34 (copy)
				v33.current = false
				v34()
			end)
		end
	else
		v31.current = v34
	end

	useConnectSignals(p3, {
		"AbsolutePosition",
		"AbsoluteSize"
	}, v31)
	useConnectSignals(p4, { "AbsoluteSize" }, v31)
	useConnectSignals(p5, { "AbsoluteSize" }, v31)

	if Flags.FoundationPopoverClipAwareVisibility then
		React.useLayoutEffect(function() -- line: 195
			-- upvalues: b1 (copy), p3 (copy), v32 (copy), v31 (copy)
			if not b1 then
				return
			end

			if typeof(p3) ~= "Instance" or not p3:IsA("GuiObject") then
				return
			end

			local v60 = p3
			local v61 = v32
			local t2 = {}

			local function rebuild() -- line: 206
				-- upvalues: t2 (copy), v60 (copy), v31 (copy), v61 (copy)
				for _, v68 in t2 do
					v68:Disconnect()
				end

				table.clear(t2)

				local t3 = {}
				local Parent = v60.Parent

				while Parent and Parent:IsA("GuiObject") do
					if Parent.ClipsDescendants then
						table.insert(t3, Parent)
						table.insert(t2, Parent:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 220
							-- upvalues: v31 (copy)
							v31.current()
						end))
						table.insert(t2, Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 226
							-- upvalues: v31 (copy)
							v31.current()
						end))
					end

					Parent = Parent.Parent
				end

				v61.current = t3

				if #t3 > 0 then
					v31.current()
				end
			end

			rebuild()

			local connection = v60.AncestryChanged:Connect(rebuild)

			return function() -- line: 244
				-- upvalues: connection (copy), t2 (copy), v61 (copy)
				connection:Disconnect()

				for _, v72 in t2 do
					v72:Disconnect()
				end

				v61.current = {}
			end
		end, {
			p3,
			b1
		})
	end

	React.useLayoutEffect(function() -- line: 254
		-- upvalues: v34 (copy)
		v34()
	end, { v34 })

	return v19, v21, v23, v27, v25, v29
end

return useFloating

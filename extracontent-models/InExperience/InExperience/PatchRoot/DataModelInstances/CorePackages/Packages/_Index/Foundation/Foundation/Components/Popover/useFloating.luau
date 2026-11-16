local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(Foundation.Enums.PopoverAlign)
require(Foundation.Enums.PopoverSide)
local React = require(parent.React)
local positioning = require(script.Parent.positioning)

require(Foundation.Components.Types)

local function useConnectSignals(instance, items, ref)
	local ref2 = React.useRef({})

	React.useLayoutEffect(function()
		if instance ~= nil then
			for _, propertyName in items do
				if typeof(instance) == "Instance" then
				end

				local propertyChangedSignal = instance:GetPropertyChangedSignal(propertyName)

				local current = ref2.current
				local v

				if type(ref) == "table" then
					v = function()
						ref.current()
					end
				else
					v = ref
				end

				current[propertyName] = propertyChangedSignal:Connect(v)
			end
		end

		return function()
			for _, connection in ref2.current do
				connection:Disconnect()
			end
		end
	end, { instance, ref })
end

local function useFloating(flag: boolean, guiObject, p, p2, p3, p4, value: number?)
	local v, v2 = React.useBinding(Vector2.new())
	local v3, v4 = React.useBinding(true)
	local v5, v6 = React.useBinding(UDim2.new())
	local v7, v8 = React.useBinding(Vector2.new())
	local v9, v10 = React.useBinding(Vector2.new())
	local v11, v12 = React.useBinding(Vector2.new(0, 0))
	local ref = React.useRef(function() end)
	local ref2 = React.useRef({})
	local ref3 = React.useRef(false)

	local v13 = React.useCallback(function()
		if not (flag and guiObject and p and p2) then
			v4(false)
			return
		end

		local absolutePosition = guiObject.AbsolutePosition
		local absoluteSize = guiObject.AbsoluteSize

		local absoluteSize2 = p.AbsoluteSize

		local absoluteSize3 = p2.AbsoluteSize
		local absolutePosition2 = p2.AbsolutePosition
		local rect = Rect.new(absolutePosition, absolutePosition + absoluteSize)
		local rect2 = Rect.new(absolutePosition2, absolutePosition2 + absoluteSize3)

		if not positioning.isOnScreen(rect, rect2) then
			v4(false)
			return
		end

		local v13 = nil

		for _, v14 in ref2.current do
			local rect3 = Rect.new(v14.AbsolutePosition, v14.AbsolutePosition + v14.AbsoluteSize)

			if v13 == nil then
				v13 = rect3
			else
				v13 = Rect.new(
					Vector2.new(math.max(v13.Min.X, rect3.Min.X), (math.max(v13.Min.Y, rect3.Min.Y))),
					Vector2.new(math.min(v13.Max.X, rect3.Max.X), (math.min(v13.Max.Y, rect3.Max.Y)))
				)
			end
		end

		if v13 and not positioning.isOnScreen(rect, v13) then
			v4(false)
			return
		end

		local v14 = if type(p3) == "table" then p3.position else p3
		local v15 = type(p3) ~= "table" and 0 or p3.offset
		local v16 = p4
		local v17

		if type(p4) == "table" then
			v16 = p4.position
			v17 = p4.offset
		else
			v17 = 0
		end

		local v18 = value or 0

		local popoverBounds = positioning.calculatePopoverBounds(v14, v15, v17, v18, absoluteSize2)

		local side = positioning.calculateSide(v14, rect, rect2, popoverBounds)

		local positions, v19, v20 = positioning.calculatePositions(side, v15, v16, v17, rect, rect2, v18, absoluteSize2)

		v6(UDim2.fromOffset(absoluteSize2.X, absoluteSize2.Y))
		v8(absoluteSize3)
		v10(v19 + positions)
		v2(positions)
		v12(v20)
		v4(true)

		local _absolutePosition = p.AbsolutePosition
	end, { flag, guiObject, p, p2, p3, p4, value })

	function ref.current()
		if ref3.current then
			return
		end

		ref3.current = true
		task.defer(function()
			ref3.current = false
			v13()
		end)
	end
	useConnectSignals(guiObject, { "AbsolutePosition", "AbsoluteSize" }, ref)
	useConnectSignals(p, { "AbsoluteSize" }, ref)
	useConnectSignals(p2, { "AbsoluteSize" }, ref)
	React.useLayoutEffect(function()
		if not flag or (typeof(guiObject) ~= "Instance" or not guiObject:IsA("GuiObject")) then
			return
		end

		local v14 = guiObject
		local v15 = ref2
		local connections = {}

		local function rebuild()
			for _, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)

			local parent2 = v14.Parent
			local parents = {}

			while parent2 and parent2:IsA("GuiObject") do
				if parent2.ClipsDescendants then
					table.insert(parents, parent2)
					table.insert(connections, parent2:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
						ref.current()
					end))

					table.insert(connections, parent2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						ref.current()
					end))
				end

				parent2 = parent2.Parent
			end

			v15.current = parents

			if #parents > 0 then
				ref.current()
			end
		end

		rebuild()
		local ancestryChangedConnection = v14.AncestryChanged:Connect(rebuild)

		return function()
			ancestryChangedConnection:Disconnect()

			for _, connection in connections do
				connection:Disconnect()
			end

			v15.current = {}
		end
	end, { guiObject, flag })

	React.useLayoutEffect(function()
		v13()
	end, { v13 })

	return v, v3, v5, v9, v7, v11
end

return useFloating

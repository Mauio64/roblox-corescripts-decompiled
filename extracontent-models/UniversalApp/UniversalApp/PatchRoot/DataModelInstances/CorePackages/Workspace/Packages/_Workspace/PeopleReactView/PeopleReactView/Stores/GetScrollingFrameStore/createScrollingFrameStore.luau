local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Signals = require(Parent.Signals)
local FFlagFixVirtualizedGridNumItems = require(Parent.PeopleService).getService("Flags").FFlagFixVirtualizedGridNumItems

local function createScrollingFrameStore() -- line: 21
	-- upvalues: Signals (copy), FFlagFixVirtualizedGridNumItems (copy)
	local v5, v6 = Signals.createSignal(0)
	local v7, v8 = Signals.createSignal(0)
	local v9, v10 = Signals.createSignal(0)
	local u11 = nil
	local v12 = nil

	if FFlagFixVirtualizedGridNumItems then
		local v13

		v13, v12 = Signals.createSignal(0)
		u11 = v13
	end

	local v14 = if not FFlagFixVirtualizedGridNumItems then nil else Signals.createComputed(function(p1) -- line: 33
		-- upvalues: v9 (copy), u11 (ref)
		return v9(p1) + u11(p1)
	end)
	local connection = nil
	local connection2 = nil
	local connection3 = nil

	return {
		getAbsolutePositionY = v5,
		getAbsoluteSizeY = v7,
		getCanvasPositionY = if not FFlagFixVirtualizedGridNumItems then v9 else v14,
		setScrollingFrame = function(p2) -- line: 42
			-- upvalues: connection (ref), connection2 (ref), connection3 (ref), v6 (copy), v8 (copy), v10 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end

			v6(p2.AbsolutePosition.Y)
			v8(p2.AbsoluteSize.Y)
			v10(p2.CanvasPosition.Y)
			connection = p2:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 57
				-- upvalues: v6 (copy), p2 (copy)
				v6(p2.AbsolutePosition.Y)
			end)
			connection2 = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 61
				-- upvalues: v8 (copy), p2 (copy)
				v8(p2.AbsoluteSize.Y)
			end)
			connection3 = p2:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 65
				-- upvalues: v10 (copy), p2 (copy)
				v10(p2.CanvasPosition.Y)
			end)
		end,
		setCanvasPositionYOffset = if not FFlagFixVirtualizedGridNumItems then nil else v12,
		cleanUp = function() -- line: 70
			-- upvalues: connection (ref), connection2 (ref), connection3 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end
		end
	}
end

return createScrollingFrameStore

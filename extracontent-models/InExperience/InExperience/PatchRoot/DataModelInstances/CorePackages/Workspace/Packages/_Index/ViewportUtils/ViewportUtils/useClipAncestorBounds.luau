local Parent = script:FindFirstAncestor("ViewportUtils").Parent
local React = require(Parent.React)
local SharedFlags = require(Parent.SharedFlags)
local intersectBounds = require(script.Parent.intersectBounds)
local FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local FIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold

local function getGuiAncestors(p1) -- line: 17
	local t1 = {}
	local p1Parent = p1.Parent

	while p1Parent and p1Parent ~= game and p1Parent:IsA("GuiObject") do
		table.insert(t1, p1Parent)
		p1Parent = p1Parent.Parent
	end

	return t1
end
local function computeBounds(p2) -- line: 30
	local AbsolutePosition = p2.AbsolutePosition
	local AbsoluteSize = p2.AbsoluteSize

	return {
		min = AbsolutePosition,
		max = AbsolutePosition + AbsoluteSize
	}
end
local function computeClipBounds(t2: {[any]: any}) -- line: 39
	-- upvalues: intersectBounds (copy)
	local v18 = nil

	for _, v20 in t2 do
		if v20.ClipsDescendants or v20:GetStyled("ClipsDescendants") == true then
			local AbsolutePosition = v20.AbsolutePosition
			local AbsoluteSize = v20.AbsoluteSize
			local t3 = {
				min = AbsolutePosition,
				max = AbsolutePosition + AbsoluteSize
			}

			v18 = if not v18 then t3 else intersectBounds(v18, t3)
		end
	end

	return v18
end
local function useClipAncestorBounds(t4: {[any]: any}?) -- line: 50
	-- upvalues: React (copy), computeClipBounds (copy), getGuiAncestors (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy)
	local v25, v26 = React.useState(nil)

	React.useEffect(function() -- line: 53
		-- upvalues: t4 (copy), v26 (copy), computeClipBounds (copy), getGuiAncestors (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy)
		local v27 = if not t4 then nil else t4.current

		if not v27 then
			v26(nil)

			return
		end

		local t5 = {}
		local t6 = {}
		local u30 = nil

		local function cancelPendingUpdate() -- line: 64
			-- upvalues: u30 (ref)
			if u30 then
				task.cancel(u30)
				u30 = nil
			end
		end
		local function scheduleUpdateBounds() -- line: 72
			-- upvalues: u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
			if u30 then
				return
			end

			u30 = task.defer(function() -- line: 76
				-- upvalues: u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
				u30 = nil
				v26((computeClipBounds(t6)))
			end)
		end
		local function disconnectAncestorConnections() -- line: 82
			-- upvalues: t5 (ref)
			for _, v37 in t5 do
				if v37.Connected then
					v37:Disconnect()
				end
			end

			t5 = {}
		end
		local function connectToAncestors() -- line: 91
			-- upvalues: u30 (ref), disconnectAncestorConnections (copy), t6 (ref), getGuiAncestors (copy), v27 (copy), v26 (copy), computeClipBounds (copy), t5 (ref), connectToAncestors (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy)
			if u30 then
				task.cancel(u30)
				u30 = nil
			end

			disconnectAncestorConnections()
			t6 = getGuiAncestors(v27)
			v26((computeClipBounds(t6)))

			for _, v39 in t6 do
				table.insert(t5, v39:GetPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors))
				table.insert(t5, v39:GetStyledPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors))

				if v39.ClipsDescendants or v39:GetStyled("ClipsDescendants") == true then
					local AbsolutePosition = v39.AbsolutePosition

					table.insert(t5, v39:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 115
						-- upvalues: v39 (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), AbsolutePosition (ref), u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
						local AbsolutePosition2 = v39.AbsolutePosition
						local v43 = FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
						local v44 = AbsolutePosition2 - AbsolutePosition

						if v43 > math.abs(v44.X) and v43 > math.abs(v44.Y) then
							return
						end

						AbsolutePosition = AbsolutePosition2

						if u30 then
							return
						end

						u30 = task.defer(function() -- line: 76
							-- upvalues: u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
							u30 = nil
							v26((computeClipBounds(t6)))
						end)
					end))

					local AbsoluteSize = v39.AbsoluteSize

					table.insert(t5, v39:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 130
						-- upvalues: v39 (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy), AbsoluteSize (ref), u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
						local AbsoluteSize2 = v39.AbsoluteSize
						local v46 = FIntLuaAppViewportBoundsScreenSizeThreshold
						local v47 = AbsoluteSize2 - AbsoluteSize

						if v46 > math.abs(v47.X) and v46 > math.abs(v47.Y) then
							return
						end

						AbsoluteSize = AbsoluteSize2

						if u30 then
							return
						end

						u30 = task.defer(function() -- line: 76
							-- upvalues: u30 (ref), v26 (copy), computeClipBounds (copy), t6 (ref)
							u30 = nil
							v26((computeClipBounds(t6)))
						end)
					end))
				end
			end
		end

		connectToAncestors()

		local connection = v27.AncestryChanged:Connect(function() -- line: 149
			-- upvalues: connectToAncestors (copy)
			connectToAncestors()
		end)

		return function() -- line: 153
			-- upvalues: u30 (ref), connection (copy), disconnectAncestorConnections (copy)
			if u30 then
				task.cancel(u30)
				u30 = nil
			end

			connection:Disconnect()
			disconnectAncestorConnections()
		end
	end, { t4 })

	return v25
end

return useClipAncestorBounds

local parent = script:FindFirstAncestor("ViewportUtils").Parent
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local intersectBounds = require(script.Parent.intersectBounds)

local FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local FIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold

local function getGuiAncestors(current)
	local parent2 = current.Parent
	local parents = {}

	while parent2 and parent2 ~= game and parent2:IsA("GuiObject") do
		table.insert(parents, parent2)
		parent2 = parent2.Parent
	end

	return parents
end

local function computeBounds(item) -- 1 equivalent call inferred from this helper
	local absolutePosition = item.AbsolutePosition
	return {
		min = absolutePosition,
		max = absolutePosition + item.AbsoluteSize
	}
end

local function computeClipBounds(items)
	local clipBounds = nil

	for _, item in items do
		if not (item.ClipsDescendants or item:GetStyled("ClipsDescendants") == true) then
			continue
		end

		local bounds = computeBounds(item) -- inferred equivalent call

		if clipBounds then
			clipBounds = intersectBounds(clipBounds, bounds)
		else
			clipBounds = bounds
		end
	end

	return clipBounds
end

local function useClipAncestorBounds(p)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local current

		if p then
			current = p.current
		else
			current = nil
		end

		if not current then
			setState(nil)
			return
		end

		local connections = {}
		local v = {}
		local thread = nil

		local function cancelPendingUpdate() -- 2 equivalent calls inferred from this helper
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end

		local function scheduleUpdateBounds() -- 2 equivalent calls inferred from this helper
			if thread then
				return
			end

			thread = task.defer(function()
				thread = nil
				setState(computeClipBounds(v))
			end)
		end

		local function disconnectAncestorConnections()
			for _, connection in connections do
				if connection.Connected then
					connection:Disconnect()
				end
			end

			connections = {}
		end

		local function connectToAncestors()
			cancelPendingUpdate() -- inferred equivalent call
			disconnectAncestorConnections()

			v = getGuiAncestors(current)
			setState(computeClipBounds(v))

			for _, v2 in v do
				table.insert(connections, v2:GetPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors))

				table.insert(
					connections,
					v2:GetStyledPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors)
				)

				if not (v2.ClipsDescendants or v2:GetStyled("ClipsDescendants") == true) then
					continue
				end

				local v3 = v2.AbsolutePosition
				table.insert(connections, v2:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					local absolutePosition = v2.AbsolutePosition
					local v4 = FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
					local v5 = absolutePosition - v3

					if math.abs(v5.X) < v4 and math.abs(v5.Y) < v4 then
						return
					end

					v3 = absolutePosition
					scheduleUpdateBounds() -- inferred equivalent call
				end))

				local v4 = v2.AbsoluteSize
				table.insert(connections, v2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					local absoluteSize = v2.AbsoluteSize
					local v5 = FIntLuaAppViewportBoundsScreenSizeThreshold
					local v6 = absoluteSize - v4

					if math.abs(v6.X) < v5 and math.abs(v6.Y) < v5 then
						return
					end

					v4 = absoluteSize
					scheduleUpdateBounds() -- inferred equivalent call
				end))
			end
		end

		connectToAncestors()

		local ancestryChangedConnection = current.AncestryChanged:Connect(function()
			connectToAncestors()
		end)

		return function()
			cancelPendingUpdate() -- inferred equivalent call
			ancestryChangedConnection:Disconnect()
			disconnectAncestorConnections()
		end
	end, { p })

	return state
end

return useClipAncestorBounds

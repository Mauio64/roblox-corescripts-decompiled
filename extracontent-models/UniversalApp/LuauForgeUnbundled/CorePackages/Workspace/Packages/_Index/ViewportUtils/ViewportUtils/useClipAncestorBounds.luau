local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/SharedFlags")

local intersectBounds = require("@game/CorePackages/Workspace/Packages/_Index/ViewportUtils/ViewportUtils/intersectBounds")

local fIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local fIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold

local function getGuiAncestors(current)
	local parent = current.Parent
	local parents = {}

	while parent and parent ~= game and parent:IsA("GuiObject") do
		table.insert(parents, parent)
		parent = parent.Parent
	end

	return parents
end

local function computeBounds(p2)
	local absolutePosition = p2.AbsolutePosition
	return {
		min = absolutePosition,
		max = absolutePosition + p2.AbsoluteSize
	}
end

local function computeClipBounds(items)
	local clipBounds = nil

	for k, item in items do
		if not (item.ClipsDescendants or item:GetStyled("ClipsDescendants") == true) then
			continue
		end

		local absolutePosition = item.AbsolutePosition
		local v5 = {
			min = absolutePosition,
			max = absolutePosition + item.AbsoluteSize
		}

		clipBounds = if clipBounds then intersectBounds(clipBounds, v5) else v5
	end

	return clipBounds
end

local function useClipAncestorBounds(p2)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local current = if p2 then p2.current else nil

		if not current then
			setState(nil)
			return
		end

		local connections = {}
		local v5 = {}
		local thread = nil

		local function cancelPendingUpdate()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end

		local function scheduleUpdateBounds()
			if thread then
				return
			end

			thread = task.defer(function()
				thread = nil
				setState(computeClipBounds(v5))
			end)
		end

		local function disconnectAncestorConnections()
			for k, connection in connections do
				if connection.Connected then
					connection:Disconnect()
				end
			end

			connections = {}
		end

		local function connectToAncestors()
			if thread then
				task.cancel(thread)
				thread = nil
			end

			disconnectAncestorConnections()

			v5 = getGuiAncestors(current)
			setState(computeClipBounds(v5))

			for k, v6 in v5 do
				table.insert(
					connections,
					v6:GetPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors)
				)

				table.insert(
					connections,
					v6:GetStyledPropertyChangedSignal("ClipsDescendants"):Connect(connectToAncestors)
				)

				if not (v6.ClipsDescendants or v6:GetStyled("ClipsDescendants") == true) then
					continue
				end

				local v7 = v6.AbsolutePosition
				table.insert(connections, v6:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					local absolutePosition = v6.AbsolutePosition
					local v8 = fIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
					local v9 = absolutePosition - v7

					if math.abs(v9.X) < v8 and math.abs(v9.Y) < v8 then
						return
					end

					v7 = absolutePosition

					if thread then
						return
					end

					thread = task.defer(function()
						thread = nil
						setState(computeClipBounds(v5))
					end)
				end))

				local v8 = v6.AbsoluteSize
				table.insert(connections, v6:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					local absoluteSize = v6.AbsoluteSize
					local v9 = fIntLuaAppViewportBoundsScreenSizeThreshold
					local v10 = absoluteSize - v8

					if math.abs(v10.X) < v9 and math.abs(v10.Y) < v9 then
						return
					end

					v8 = absoluteSize

					if thread then
						return
					end

					thread = task.defer(function()
						thread = nil
						setState(computeClipBounds(v5))
					end)
				end))
			end
		end

		connectToAncestors()

		local ancestryChangedConnection = current.AncestryChanged:Connect(function()
			connectToAncestors()
		end)

		return function()
			if thread then
				task.cancel(thread)
				thread = nil
			end

			ancestryChangedConnection:Disconnect()
			disconnectAncestorConnections()
		end
	end, { p2 })

	return state
end

return useClipAncestorBounds

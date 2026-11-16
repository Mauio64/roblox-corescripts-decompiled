local RunService = game:GetService("RunService")
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")

local axisMap = require(ViewRecyclerRoblox.RobloxAdapter.axisMap)

return {
	attach = function(data)
		local instance = data.instance
		local axis = data.axis
		local getState = data.getState
		local onItemMeasured = data.onItemMeasured
		local isRendered = data.isRendered

		local v = {}
		local v2 = nil
		local v3 = nil
		local v4 = {}

		local function publish(state): boolean
			if isRendered ~= nil and not isRendered() then
				return false
			end

			local absoluteSize = instance.AbsoluteSize

			if axisMap.crossOf(absoluteSize, axis) <= 0 then
				return true
			end

			local main = axisMap.mainOf(instance.AbsoluteSize, axis)
			local v5

			if v2 == state then
				v5 = v3 == main
			else
				v5 = false
			end

			if not v5 then
				onItemMeasured(state, main)
				v2 = state
				v3 = main
			end

			return true
		end

		local function fn()
			local state = getState()

			if state == nil or v4[state] ~= nil then
				return
			end

			local heartbeatConnection = nil
			heartbeatConnection = RunService.Heartbeat:Once(function()
				v[heartbeatConnection] = nil

				if v4[state] == heartbeatConnection then
					v4[state] = nil
				end

				local state2 = getState()

				if state2 ~= state then
					return
				end

				if not publish(state2) then
					fn()
				end
			end)
			v[heartbeatConnection] = true
			v4[state] = heartbeatConnection
		end

		local absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn)

		return {
			scheduleSettle = fn,
			measureNow = function()
				local state = getState()

				if state ~= nil then
					publish(state)
				end
			end,
			getPendingCount = function()
				local count = 0

				for _ in v do
					count += 1
				end

				return count
			end,
			disconnect = function()
				absoluteSizeChangedConnection:Disconnect()

				for connection in v do
					connection:Disconnect()
				end

				table.clear(v)
				table.clear(v4)
			end
		}
	end
}

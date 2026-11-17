local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local SignalsExperimental = require(ViewRecyclerRoblox.Parent.SignalsExperimental)
local axisMap = require(ViewRecyclerRoblox.RobloxAdapter.axisMap)
local RunService = game:GetService("RunService")

local function disconnectAll(connections) -- 4 equivalent calls inferred from this helper
	for _, connection in connections do
		connection:Disconnect()
	end

	table.clear(connections)
end

return {
	new = function(data)
		local axis = data.axis
		local activationMargin = data.activationMargin or 0
		local retentionMargin = data.retentionMargin or activationMargin
		assert(activationMargin >= 0, "activationMargin must be non-negative")
		assert(activationMargin <= retentionMargin, "retentionMargin must be at least activationMargin")

		local v = nil
		local connections = {}
		local v2 = {}
		local v3 = {}
		local heartbeatConnection = nil
		local flag = false

		local function updateTargetGeometry(p)
			local v4 = v

			if v4 == nil or not p.target:IsDescendantOf(v4) then
				p.contentStart = nil
				p.contentEnd = nil
			else
				local main = axisMap.mainOf(v4.CanvasPosition, axis)
				local main2 = axisMap.mainOf(v4.AbsolutePosition, axis)

				local contentStart = main + axisMap.mainOf(p.target.AbsolutePosition, axis) - main2

				p.contentStart = contentStart
				p.contentEnd = contentStart + axisMap.mainOf(p.target.AbsoluteSize, axis)
			end
		end

		local function dispatch(items, items2) -- 1 equivalent call inferred from this helper
			if items == nil and items2 == nil then
				return
			end

			SignalsExperimental.batch(function()
				if items ~= nil then
					for _, item in items do
						item.setActive(false)
					end
				end

				if items2 ~= nil then
					for _, item in items2 do
						item.setActive(true)
					end
				end
			end)
		end

		local function deactivateAll()
			local v4 = nil

			for _, v5 in v2 do
				if not v5.active then
					continue
				end

				v5.active = false
				v4 = v4 or {}
				table.insert(v4, v5)
			end

			if v4 == nil then
				return
			end

			local v5 = nil
			SignalsExperimental.batch(function()
				if v4 ~= nil then
					for _, v6 in v4 do
						v6.setActive(false)
					end
				end

				if v5 ~= nil then
					for _, v6 in v5 do
						v6.setActive(true)
					end
				end
			end)
		end

		local function evaluate()
			if flag then
				return
			end

			local v4 = v

			if v4 == nil then
				deactivateAll()
				return
			end

			local main = axisMap.mainOf(v4.CanvasPosition, axis)
			local v5 = main + axisMap.mainOf(v4.AbsoluteWindowSize, axis)
			local v6 = nil
			local v7 = nil

			for _, v8 in v2 do
				local contentStart = v8.contentStart
				local contentEnd = v8.contentEnd
				local active

				if contentStart == nil or contentEnd == nil then
					active = false
				else
					local v9

					if v8.active then
						v9 = retentionMargin
					else
						v9 = activationMargin
					end

					if main - v9 < contentEnd then
						active = contentStart < v5 + v9
					else
						active = false
					end
				end

				if active == v8.active then
					continue
				end

				v8.active = active

				if active then
					v6 = v6 or {}
					table.insert(v6, v8)
				else
					v7 = v7 or {}
					table.insert(v7, v8)
				end
			end

			dispatch(v7, v6) -- inferred equivalent call
		end

		local function scheduleSettledEvaluation(p) -- 1 equivalent call inferred from this helper
			if flag then
				return
			end

			if p ~= nil then
				v3[p] = true
			end

			if heartbeatConnection ~= nil then
				return
			end

			heartbeatConnection = RunService.Heartbeat:Connect(function()
				local connection = heartbeatConnection
				heartbeatConnection = nil

				if connection ~= nil then
					connection:Disconnect()
				end

				if flag then
					return
				end

				for k in v3 do
					v3[k] = nil

					if v2[k.target] == k then
						updateTargetGeometry(k)
					end
				end

				evaluate()
			end)
		end

		local function setViewport(instance)
			if flag or instance == v then
				return
			end

			disconnectAll(connections) -- inferred equivalent call
			deactivateAll()
			v = instance

			if instance == nil then
				return
			end

			table.insert(connections, instance:GetPropertyChangedSignal("CanvasPosition"):Connect(evaluate))
			table.insert(
				connections,
				instance:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(scheduleSettledEvaluation)
			)

			table.insert(connections, instance.Destroying:Connect(function()
				setViewport(nil)
			end))

			for _, v4 in v2 do
				updateTargetGeometry(v4)
			end

			evaluate()
		end

		local function register(instance, setActive)
			if flag then
				return function() end
			end

			assert(v2[instance] == nil, "target is already registered")

			local v4 = {
				target = instance,
				setActive = setActive,
				active = false,
				contentStart = nil,
				contentEnd = nil,
				connections = {}
			}

			v2[instance] = v4

			local flag2 = false
			local function unregister()
				if flag2 then
					return
				end

				flag2 = true

				if v2[instance] ~= v4 then
					return
				end

				v2[instance] = nil
				disconnectAll(v4.connections) -- inferred equivalent call

				if v4.active then
					v4.active = false
					local v5 = { v4 }

					if v5 == nil then
						return
					end

					local v6 = nil
					SignalsExperimental.batch(function()
						if v5 ~= nil then
							for _, v7 in v5 do
								v7.setActive(false)
							end
						end

						if v6 ~= nil then
							for _, v7 in v6 do
								v7.setActive(true)
							end
						end
					end)
				end
			end

			local function updateGeometry()
				scheduleSettledEvaluation(v4) -- inferred equivalent call
			end
			table.insert(v4.connections, instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateGeometry))
			table.insert(v4.connections, instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateGeometry))
			table.insert(v4.connections, instance.Destroying:Connect(unregister))
			updateTargetGeometry(v4)
			evaluate()
			return unregister
		end

		local function destroy()
			if flag then
				return
			end

			flag = true

			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			table.clear(v3)
			disconnectAll(connections) -- inferred equivalent call
			local v4 = nil

			for k, v5 in v2 do
				v2[k] = nil
				disconnectAll(v5.connections) -- inferred equivalent call

				if not v5.active then
					continue
				end

				v5.active = false
				v4 = v4 or {}
				table.insert(v4, v5)
			end

			v = nil

			if v4 == nil then
				return
			end

			local v5 = nil
			SignalsExperimental.batch(function()
				if v4 ~= nil then
					for _, v6 in v4 do
						v6.setActive(false)
					end
				end

				if v5 ~= nil then
					for _, v6 in v5 do
						v6.setActive(true)
					end
				end
			end)
		end

		return { setViewport = setViewport, register = register, destroy = destroy }
	end
}

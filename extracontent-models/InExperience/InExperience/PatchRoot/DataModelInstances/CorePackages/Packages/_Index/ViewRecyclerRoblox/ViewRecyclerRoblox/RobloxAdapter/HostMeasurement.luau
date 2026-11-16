local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local MeasurementBatcher = require(ViewRecyclerRoblox.RobloxAdapter.MeasurementBatcher)
local Measurer = require(ViewRecyclerRoblox.RobloxAdapter.Measurer)
local axisMap = require(ViewRecyclerRoblox.RobloxAdapter.axisMap)

local RunService = game:GetService("RunService")

return {
	new = function(data)
		local axis = data.axis
		local v = {}
		local v2 = 0
		local flag = false

		local v3 = true
		local preRenderConnection = nil
		local count = 0

		local v4 = nil
		local deliver
		local queue
		local reportedState
		local publish
		local measureNow
		local scheduleRead
		local disconnect
		local v5 = nil

		if FFlagViewRecyclerReact08 then
			v4 = nil

			deliver = function()
				local v6 = v4

				if flag or v6 == nil then
					return nil
				end

				v4 = nil
				data.onItemMeasurements(v6)
				return v6
			end

			queue = function(p)
				local v6 = v4

				if v6 == nil then
					v6 = {}
					v4 = v6
					task.defer(function()
						if v4 == v6 then
							deliver()
						end
					end)
				end

				table.insert(v6, p)
			end

			reportedState = function(data2)
				if v[data2.itemView] == data2 and not data2.paused then
					return data2.state
				end

				return nil
			end

			publish = function(state, lastPublishedState): boolean
				if lastPublishedState.assignment ~= state.renderedAssignment then
					return false
				end

				local host = state.host

				if axisMap.crossOf(host.AbsoluteSize, axis) <= 0 then
					return true
				end

				local main = axisMap.mainOf(host.AbsoluteSize, axis)

				if state.lastPublishedState ~= lastPublishedState or state.lastPublishedLength ~= main then
					state.lastPublishedState = lastPublishedState
					state.lastPublishedLength = main
					queue({ itemView = state.itemView, state = lastPublishedState, length = main })
				end

				return true
			end

			measureNow = function(p)
				local v6 = reportedState(p)

				if v6 ~= nil then
					publish(p, v6)
				end
			end

			scheduleRead = function(p)
				local v6 = reportedState(p)

				if v6 == nil or p.pendingReads[v6] ~= nil then
					return
				end

				p.pendingReads[v6] = RunService.Heartbeat:Once(function()
					p.pendingReads[v6] = nil

					if reportedState(p) == v6 and not publish(p, v6) then
						scheduleRead(p)
					end
				end)
			end

			disconnect = function(p)
				p.sizeConnection:Disconnect()

				for _, pendingRead in p.pendingReads do
					pendingRead:Disconnect()
				end

				table.clear(p.pendingReads)
			end
		else
			v5 = MeasurementBatcher.new(data.onItemMeasurements)
		end

		local function measureRounds()
			for _ = 1, 4 do
				if flag or data.isUnchanged() and not v3 then
					break
				end

				v3 = false

				for _, v6 in v do
					count += 1

					if FFlagViewRecyclerReact08 then
						measureNow(v6)
					else
						v6.measurer.measureNow()
					end
				end

				local v6

				if FFlagViewRecyclerReact08 then
					v6 = deliver
				else
					v6 = v5.flush
				end

				local v7 = false

				for _, v8 in v6() or {} do
					if v8.length ~= v8.state.itemLayout.length then
						v7 = true
						break
					end
				end

				if not v7 then
					break
				end
			end
		end

		local function measureBeforePaint()
			measureRounds()

			if flag then
				return
			end

			for _, v6 in v do
				local assignment = v6.state.assignment

				if v6.renderedAssignment == assignment then
					continue
				end

				v6.renderedAssignment = assignment
				v3 = true
			end
		end

		local function syncConnection() -- 3 equivalent calls inferred from this helper
			local v6 = not flag and v2 > 0

			if v6 and preRenderConnection == nil then
				v3 = true
				preRenderConnection = RunService.PreRender:Connect(measureBeforePaint)
			elseif not v6 and preRenderConnection ~= nil then
				preRenderConnection:Disconnect()
				preRenderConnection = nil
			end
		end

		local function stop(p) -- 2 equivalent calls inferred from this helper
			local v6 = v[p]

			if v6 ~= nil then
				v[p] = nil
				v2 -= 1

				if FFlagViewRecyclerReact08 then
					disconnect(v6)
				else
					v6.measurer.disconnect()
				end

				syncConnection() -- inferred equivalent call
			end
		end

		local function setState(p, state) -- 2 equivalent calls inferred from this helper
			p.state = state

			if FFlagViewRecyclerReact08 then
				scheduleRead(p)
			else
				p.measurer.scheduleSettle()
			end
		end

		local function measure(itemView, host, state)
			if flag then
				return
			end

			local v6 = v[itemView]

			if v6 ~= nil and (host == nil or state == nil or v6.host ~= host) then
				stop(itemView) -- inferred equivalent call
				v6 = nil
			end

			if host == nil or state == nil then
				return
			end

			if v6 == nil then
				local v7 = {
					itemView = 0,
					host = 0,
					state = 0,
					paused = false,
					renderedAssignment = nil,
					sizeConnection = 0,
					pendingReads = 0,
					lastPublishedState = 0,
					lastPublishedLength = 0,
					measurer = nil
				}
				local itemView2

				if FFlagViewRecyclerReact08 then
					itemView2 = itemView
				end

				v7.itemView = itemView2
				v7.host = host
				v7.state = state

				v7.sizeConnection = nil
				v7.pendingReads = FFlagViewRecyclerReact08 and {} or nil
				v7.lastPublishedState = nil
				v7.lastPublishedLength = nil

				if FFlagViewRecyclerReact08 then
					v7.sizeConnection = host:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						scheduleRead(v7)
					end)
				else
					v7.measurer = Measurer.attach({
						instance = host,
						axis = axis,
						getState = function()
							if v[itemView] == v7 and not v7.paused then
								return v7.state
							end

							return nil
						end,
						isRendered = function(): boolean
							return v7.state.assignment == v7.renderedAssignment
						end,
						onItemMeasured = function(state2, length)
							v5.add({ itemView = itemView, state = state2, length = length })
						end
					})
				end

				v[itemView] = v7
				v2 += 1
				v3 = true
				syncConnection() -- inferred equivalent call

				if FFlagViewRecyclerReact08 then
					scheduleRead(v7)
				else
					v7.measurer.scheduleSettle()
				end
			elseif v6.paused then
				v6.paused = false
				v3 = true
				setState(v6, state) -- inferred equivalent call
			elseif v6.state ~= state then
				setState(v6, state) -- inferred equivalent call
			end
		end

		return {
			measure = measure,
			pause = function(itemView, p)
				local v6 = v[itemView]

				if flag or v6 == nil or v6.host ~= p then
					measure(itemView, p, nil)
				else
					v6.paused = true
				end
			end,
			setAxis = function(p)
				if p == axis then
					return
				end

				axis = p
				local v6 = {}

				for k in v do
					table.insert(v6, k)
				end

				for _, v7 in v6 do
					stop(v7) -- inferred equivalent call
				end
			end,
			cancelPending = function()
				if FFlagViewRecyclerReact08 then
					v4 = nil
				else
					v5.cancelPending()
				end
			end,
			isPassConnected = function(): boolean
				return preRenderConnection ~= nil
			end,
			getPassReadCount = function()
				return count
			end,
			getPendingReadCount = FFlagViewRecyclerReact08 and function()
				local count2 = 0

				for _, v6 in v do
					for _ in v6.pendingReads do
						count2 += 1
					end
				end

				return count2
			end or nil,
			destroy = function()
				if flag then
					return
				end

				flag = true

				if FFlagViewRecyclerReact08 then
					v4 = nil
				else
					v5.destroy()
				end

				for _, v6 in v do
					if FFlagViewRecyclerReact08 then
						disconnect(v6)
					else
						v6.measurer.disconnect()
					end
				end

				table.clear(v)
				v2 = 0
				syncConnection() -- inferred equivalent call
			end
		}
	end
}

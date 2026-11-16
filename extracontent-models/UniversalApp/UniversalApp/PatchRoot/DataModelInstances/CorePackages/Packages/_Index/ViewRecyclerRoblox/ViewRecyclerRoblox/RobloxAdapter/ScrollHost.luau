local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScrollHostLifecyclePhase = require(ViewRecyclerRoblox.RobloxAdapter.ScrollHostLifecyclePhase)
local axisMap = require(ViewRecyclerRoblox.RobloxAdapter.axisMap)

local function normalizeScrollOffset(value: number, viewportLength: number, contentLength: number) -- 1 equivalent call inferred from this helper
	return (math.clamp(value, 0, (math.max(0, contentLength - viewportLength))))
end

return {
	new = function(data)
		local getCurrent = data.getCurrent
		local configuration = data.getConfiguration()
		local axis = configuration.axis
		local v = ScrollHostLifecyclePhase.Disconnected
		local count = 0
		local v2 = nil
		local canvasSize = nil
		local connections = {}
		local v3 = 0
		local scrollOffset = nil
		local v4 = nil
		local v5 = nil
		local canvasOriginOffset = 0
		local count2 = 0
		local heartbeatConnection = nil
		local v6 = {}
		local v7 = false
		local count3 = 0
		local heartbeatConnection2 = nil
		local v8 = nil
		local axis2 = nil
		local v9 = nil

		local function sampleConfiguration() -- 7 equivalent calls inferred from this helper
			configuration = data.getConfiguration()
			return configuration
		end

		local function resolveInstance(p) -- 4 equivalent calls inferred from this helper
			return p or data.getInstance()
		end

		local function getViewportState(p)
			local instance = resolveInstance(p) -- inferred equivalent call

			if instance == nil then
				return nil
			end

			local axis3 = configuration.axis
			return {
				scrollOffset = axisMap.mainOf(instance.CanvasPosition, axis3),
				viewportLength = axisMap.mainOf(instance.AbsoluteWindowSize, axis3),
				crossAxisLength = axisMap.crossOf(instance.AbsoluteWindowSize, axis3)
			}
		end

		local function setHostScrollOffset(p: number): boolean
			local instance = resolveInstance() -- inferred equivalent call

			if instance == nil then
				return false
			end

			local canvasPosition = instance.CanvasPosition
			local canvasPosition2

			if configuration.axis == ViewRecycler.Axis.X then
				canvasPosition2 = Vector2.new(p, canvasPosition.Y)
			else
				canvasPosition2 = Vector2.new(canvasPosition.X, p)
			end

			instance.CanvasPosition = canvasPosition2

			return true
		end

		local function observeHostOffset(kind, logicalScrollOffset: number) -- 2 equivalent calls inferred from this helper
			data.observeScrollOffset({ kind = kind, offset = logicalScrollOffset })
		end

		local function getLogicalScrollOffset(p) -- 3 equivalent calls inferred from this helper
			return normalizeScrollOffset( -- inferred equivalent call
				p.scrollOffset - canvasOriginOffset,
				p.viewportLength,
				getCurrent().contentLength
			)
		end

		local function notifyLogicalScrollOffset(p: number) -- 3 equivalent calls inferred from this helper
			local onScrollOffsetChanged = configuration.onScrollOffsetChanged

			if onScrollOffsetChanged ~= nil and p ~= v5 then
				onScrollOffsetChanged(p)
				v5 = p
			end
		end

		local function setCanvasOriginOffset(p: number, flag: boolean?)
			if canvasOriginOffset == p then
				return
			end

			canvasOriginOffset = p
			local onCanvasOriginMoved = data.onCanvasOriginMoved

			if onCanvasOriginMoved ~= nil and flag ~= false then
				onCanvasOriginMoved()
			end
		end

		local function reportHostWrite(p) -- 4 equivalent calls inferred from this helper
			local logicalScrollOffset = getLogicalScrollOffset(p) -- inferred equivalent call
			observeHostOffset(ViewRecycler.ScrollObservationKind.Programmatic, logicalScrollOffset) -- inferred equivalent call

			scrollOffset = p.scrollOffset
			v4 = logicalScrollOffset
		end

		local function publishCanvas()
			local v10 = math.max(0, getCurrent().contentLength + canvasOriginOffset)
			local instance = data.getInstance()

			if instance == nil then
				return v10
			end

			local v11

			if v8 == instance then
				v11 = axis2 == configuration.axis
			else
				v11 = false
			end

			local v12

			if v11 then
				v12 = v9
			end

			if v12 == v10 then
				return v10
			end

			if v == ScrollHostLifecyclePhase.Synchronized and v12 ~= nil then
				if v12 <= v10 then
					v3 += 1
					instance.CanvasSize = axisMap.canvasSizeFor(v10, configuration.axis)
					v3 -= 1
				else
					local viewportState = getViewportState(instance)
					v3 += 1
					instance.CanvasSize = axisMap.canvasSizeFor(v10, configuration.axis)

					if viewportState ~= nil then
						local scrollOffset2 = math.clamp(
							viewportState.scrollOffset,
							0,
							(math.max(0, v10 - viewportState.viewportLength))
						)

						if scrollOffset2 ~= viewportState.scrollOffset then
							setHostScrollOffset(scrollOffset2)
							reportHostWrite({ -- inferred equivalent call
								scrollOffset = scrollOffset2,
								viewportLength = viewportState.viewportLength,
								crossAxisLength = viewportState.crossAxisLength
							})
						end
					end

					v3 -= 1
				end
			else
				instance.CanvasSize = axisMap.canvasSizeFor(v10, configuration.axis)
			end

			v8 = instance
			axis2 = configuration.axis
			v9 = v10

			return v10
		end

		local function applyProgrammaticScrollOffset(p: number)
			if v ~= ScrollHostLifecyclePhase.Synchronized then
				return
			end

			local v10 = p == p and p ~= 1e999 and p ~= -1e999
			assert(v10, "ScrollHost: invalid offset")
			v3 += 1
			setHostScrollOffset(p)
			local viewportState = getViewportState(data.getInstance())

			if viewportState ~= nil then
				reportHostWrite(viewportState) -- inferred equivalent call
			end

			v3 -= 1
		end

		local function stopIdleObservation() -- 3 equivalent calls inferred from this helper
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			count2 = 0
		end

		local function stopRecentHostScroll() -- 2 equivalent calls inferred from this helper
			v7 = false

			if heartbeatConnection2 ~= nil then
				heartbeatConnection2:Disconnect()
				heartbeatConnection2 = nil
			end
		end

		local function markRecentHostScroll() -- 1 equivalent call inferred from this helper
			v7 = true
			count3 = 0

			if heartbeatConnection2 == nil then
				heartbeatConnection2 = RunService.Heartbeat:Connect(function()
					count3 += 1

					if count3 >= 2 then
						stopRecentHostScroll() -- inferred equivalent call
					end
				end)
			end
		end

		local function getScrollVelocity(instance) -- 1 equivalent call inferred from this helper
			return axisMap.mainOf(instance:GetScrollVelocity(), configuration.axis)
		end

		local function isHostScrolling() -- 2 equivalent calls inferred from this helper
			if next(v6) ~= nil then
				return true
			end

			local instance = resolveInstance() -- inferred equivalent call
			return instance ~= nil and (math.abs((getScrollVelocity(instance))) >= 0.5 or v7) -- inferred equivalent call
		end

		local function isAtLeadingScrollBoundary(): boolean -- 1 equivalent call inferred from this helper
			local instance = resolveInstance() -- inferred equivalent call
			return instance ~= nil and axisMap.mainOf(instance.CanvasPosition, configuration.axis) <= 0.5
		end

		local function settleCanvasOriginOffset(p: number?)
			if canvasOriginOffset == 0 then
				stopIdleObservation() -- inferred equivalent call
			else
				local viewportState = getViewportState(nil)

				if viewportState == nil then
					return
				end

				if not p then
					p = getLogicalScrollOffset(viewportState) -- inferred equivalent call
				end

				local v10 = canvasOriginOffset > 0

				if canvasOriginOffset ~= 0 then
					canvasOriginOffset = 0
					local onCanvasOriginMoved = data.onCanvasOriginMoved

					if onCanvasOriginMoved ~= nil then
						onCanvasOriginMoved()
					end
				end

				if v10 then
					applyProgrammaticScrollOffset(p)
					publishCanvas()
				else
					publishCanvas()
					applyProgrammaticScrollOffset(p)
				end

				notifyLogicalScrollOffset(p) -- inferred equivalent call
				stopIdleObservation() -- inferred equivalent call
			end
		end

		local function observeUntilIdle() -- 1 equivalent call inferred from this helper
			if heartbeatConnection ~= nil or canvasOriginOffset == 0 then
				return
			end

			heartbeatConnection = RunService.Heartbeat:Connect(function()
				if isHostScrolling() then -- inferred equivalent call
					count2 = 0
					return
				end

				count2 += 1

				if count2 >= 2 then
					settleCanvasOriginOffset(nil)
				end
			end)
		end

		local function disconnectHost()
			stopIdleObservation() -- inferred equivalent call
			stopRecentHostScroll() -- inferred equivalent call

			for _, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)
			table.clear(v6)

			if FFlagViewRecyclerReact08 then
				local v10 = v2
				local canvasSize2 = canvasSize

				if v10 ~= nil and canvasSize2 ~= nil then
					v10.CanvasSize = canvasSize2
				end

				canvasSize = nil
			end

			v2 = nil
			v8 = nil
			axis2 = nil
			v9 = nil
			scrollOffset = nil
			v4 = nil
			v5 = nil

			if canvasOriginOffset == 0 then
				return
			end

			canvasOriginOffset = 0
			local onCanvasOriginMoved = data.onCanvasOriginMoved

			if onCanvasOriginMoved ~= nil then
				onCanvasOriginMoved()
			end
		end

		local function synchronizeViewport(instance)
			if v ~= ScrollHostLifecyclePhase.Synchronized then
				return
			end

			local v10 = getViewportState(instance)

			if v10 == nil then
				return
			end

			data.setViewportSize(v10.viewportLength, v10.crossAxisLength)
			local v11

			if not FFlagViewRecyclerReact08 then
				v11 = getViewportState(instance)
			end

			local v12

			if FFlagViewRecyclerReact08 then
				v12 = v3 == 0
			else
				v12 = v11 ~= nil
			end

			if v12 then
				if FFlagViewRecyclerReact08 then
					local viewportState = getViewportState(instance)

					if viewportState ~= nil then
						v10 = viewportState
					end

					reportHostWrite(v10) -- inferred equivalent call
				else
					v10 = v11
				end
			end

			if not FFlagViewRecyclerReact08 then
				reportHostWrite(v10) -- inferred equivalent call
			end

			local onViewportChanged = configuration.onViewportChanged

			if onViewportChanged ~= nil then
				onViewportChanged(instance.AbsoluteWindowSize)
			end
		end

		local function synchronizeScrollOffset(instance, flag: boolean?)
			if v ~= ScrollHostLifecyclePhase.Synchronized then
				return
			end

			local viewportState = getViewportState(instance)

			if viewportState == nil then
				return
			end

			local logicalScrollOffset = getLogicalScrollOffset(viewportState) -- inferred equivalent call
			local v10 = v3 == 0

			if v10 and scrollOffset ~= nil then
				local v11 = scrollOffset

				if math.abs(viewportState.scrollOffset - v11) < 0.5 then
					v10 = false
				else
					scrollOffset = nil
				end
			end

			if v10 and flag == true then
				markRecentHostScroll() -- inferred equivalent call
			end

			if v10 and logicalScrollOffset ~= v4 then
				observeHostOffset(ViewRecycler.ScrollObservationKind.User, logicalScrollOffset) -- inferred equivalent call
				v4 = logicalScrollOffset
			end

			if v10 and canvasOriginOffset ~= 0 then
				count2 = 0

				if viewportState.scrollOffset <= 0.5 then
					settleCanvasOriginOffset(nil)
				end
			end

			notifyLogicalScrollOffset(logicalScrollOffset) -- inferred equivalent call
		end

		local function isPointerInput(input): boolean -- 1 equivalent call inferred from this helper
			return input.UserInputType == Enum.UserInputType.Touch
				or input.UserInputType == Enum.UserInputType.MouseButton1
		end

		local function connectHost(instance)
			if v2 == instance then
				return
			end

			disconnectHost()
			v2 = instance

			if instance == nil or typeof(instance) ~= "Instance" then
				return
			end

			if FFlagViewRecyclerReact08 then
				canvasSize = instance.CanvasSize
			end

			table.insert(connections, instance:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
				sampleConfiguration() -- inferred equivalent call
				publishCanvas()
				synchronizeViewport(instance)
			end))

			table.insert(connections, instance:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				sampleConfiguration() -- inferred equivalent call
				synchronizeScrollOffset(instance, true)
			end))

			table.insert(connections, instance.InputBegan:Connect(function(input)
				if isPointerInput(input) then -- inferred equivalent call
					v6[input] = true
				end
			end))

			table.insert(connections, instance.InputEnded:Connect(function(input)
				v6[input] = nil
			end))

			table.insert(connections, UserInputService.InputEnded:Connect(function(input)
				v6[input] = nil
			end))
		end

		return {
			connect = function()
				assert(v == ScrollHostLifecyclePhase.Disconnected, "ScrollHost: already connected")
				count += 1
				local v10 = count

				axis = sampleConfiguration().axis -- inferred equivalent call
				v = ScrollHostLifecyclePhase.Priming
				connectHost(data.getInstance())
				local success, result = pcall(function()
					v = ScrollHostLifecyclePhase.Synchronized
					publishCanvas()
					local instance = data.getInstance()

					if instance ~= nil then
						synchronizeViewport(instance)
						synchronizeScrollOffset(instance)
					end
				end)

				if not success then
					v = ScrollHostLifecyclePhase.Disconnected
					disconnectHost()
					error(result, 0)
				end

				local flag = false
				return function()
					if flag then
						return
					end

					flag = true

					if v ~= ScrollHostLifecyclePhase.Disconnected and count == v10 then
						v = ScrollHostLifecyclePhase.Disconnected
						disconnectHost()
					end
				end
			end,
			scrollingFrameChanged = function()
				if v == ScrollHostLifecyclePhase.Disconnected then
					return
				end

				sampleConfiguration() -- inferred equivalent call
				local instance = data.getInstance()
				connectHost(instance)

				if instance ~= nil then
					publishCanvas()
					synchronizeViewport(instance)
					synchronizeScrollOffset(instance)
				end
			end,
			configurationChanged = function()
				local configuration2 = sampleConfiguration() -- inferred equivalent call
				local v10 = configuration2.axis ~= axis
				axis = configuration2.axis

				if v ~= ScrollHostLifecyclePhase.Disconnected and v10 then
					local instance = data.getInstance()

					if instance ~= nil then
						publishCanvas()
						synchronizeViewport(instance)
						synchronizeScrollOffset(instance)
					end
				end
			end,
			applyRecord = function(data2, callback)
				if v == ScrollHostLifecyclePhase.Disconnected then
					callback()
					return
				end

				sampleConfiguration() -- inferred equivalent call
				local scrollCorrection = data2.scrollCorrection
				local scrollOffset2

				if data2.scrollPositionChanged then
					scrollOffset2 = data2.scrollState.scrollOffset
				end

				local v10

				if scrollCorrection == 0 and canvasOriginOffset == 0 then
					v10 = false
				else
					v10 = isHostScrolling() -- inferred equivalent call
				end

				local v11

				if scrollCorrection == 0 then
					v11 = false
				else
					v11 = data2.scrollPositionFollowsCorrection

					if v11 then
						if v10 then
							v11 = not isAtLeadingScrollBoundary() -- inferred equivalent call
						else
							v11 = v10
						end
					end
				end

				if v11 then
					local v12 = canvasOriginOffset - scrollCorrection

					if canvasOriginOffset ~= v12 then
						canvasOriginOffset = v12
						local _ = data.onCanvasOriginMoved == nil
					end

					callback()

					if data.onCanvasOriginMoved ~= nil then
						data.onCanvasOriginMoved()
					end

					publishCanvas()
					count2 = 0
					observeUntilIdle() -- inferred equivalent call

					if scrollOffset2 ~= nil then
						v4 = scrollOffset2
						notifyLogicalScrollOffset(scrollOffset2) -- inferred equivalent call
					end
				else
					callback()

					if canvasOriginOffset == 0 or scrollOffset2 == nil and v10 then
						if data2.scrollPositionChanged or data2.contentLengthChanged then
							publishCanvas()
						end

						if scrollOffset2 ~= nil then
							applyProgrammaticScrollOffset(scrollOffset2)
						end
					else
						settleCanvasOriginOffset(scrollOffset2)
					end
				end

				if data2.contentLengthChanged then
					local onContentLengthChanged = configuration.onContentLengthChanged

					if onContentLengthChanged ~= nil then
						onContentLengthChanged(data2.contentLength)
					end
				end

				if data2.startReached and configuration.onStartReached ~= nil then
					configuration.onStartReached()
				end

				if data2.endReached and configuration.onEndReached ~= nil then
					configuration.onEndReached()
				end
			end,
			getCanvasOriginOffset = function()
				return canvasOriginOffset
			end,
			isReady = function(): boolean
				sampleConfiguration() -- inferred equivalent call
				return getViewportState(nil) ~= nil
			end
		}
	end
}

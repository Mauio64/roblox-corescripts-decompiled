local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
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
		local scrollOffset2 = nil
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
		local viewportLength = nil
		local heartbeatConnection3 = nil

		local function sampleConfiguration() -- 8 equivalent calls inferred from this helper
			configuration = data.getConfiguration()
			return configuration
		end

		local function resolveInstance(p) -- 5 equivalent calls inferred from this helper
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

		local function observeHostOffset(kind, offset: number) -- 2 equivalent calls inferred from this helper
			data.observeScrollOffset({ kind = kind, offset = offset })
		end

		local function getLogicalScrollOffset(p) -- 4 equivalent calls inferred from this helper
			return normalizeScrollOffset( -- inferred equivalent call
				p.scrollOffset - canvasOriginOffset,
				p.viewportLength,
				getCurrent().contentLength
			)
		end

		local function notifyLogicalScrollOffset(p: number) -- 4 equivalent calls inferred from this helper
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

		local function reportHostWrite(p) -- 5 equivalent calls inferred from this helper
			local logicalScrollOffset = getLogicalScrollOffset(p) -- inferred equivalent call
			observeHostOffset(ViewRecycler.ScrollObservationKind.Programmatic, logicalScrollOffset) -- inferred equivalent call

			scrollOffset = p.scrollOffset
			v4 = logicalScrollOffset

			if FFlagViewRecyclerReact084 then
				scrollOffset2 = p.scrollOffset
				notifyLogicalScrollOffset(logicalScrollOffset) -- inferred equivalent call
			end
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
						local scrollOffset3 = math.clamp(
							viewportState.scrollOffset,
							0,
							(math.max(0, v10 - viewportState.viewportLength))
						)

						if scrollOffset3 ~= viewportState.scrollOffset then
							setHostScrollOffset(scrollOffset3)
							reportHostWrite({ -- inferred equivalent call
								scrollOffset = scrollOffset3,
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

		local publishViewportSize = FFlagViewRecyclerReact084 and function(p)
			viewportLength = p.viewportLength
			data.setViewportSize(p.viewportLength, p.crossAxisLength)
		end or nil

		local function applyProgrammaticScrollOffset(p: number)
			if v ~= ScrollHostLifecyclePhase.Synchronized then
				return
			end

			local v10 = p == p and p ~= 1e999 and p ~= -1e999
			assert(v10, "ScrollHost: invalid offset")
			v3 += 1
			setHostScrollOffset(p)

			local viewportState = getViewportState(resolveInstance()) -- inferred equivalent call

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

		local stopAnimationClock
		local syncAnimationClock, stopAnimation

		if FFlagViewRecyclerReact084 then
			stopAnimationClock = function()
				if heartbeatConnection3 ~= nil then
					heartbeatConnection3:Disconnect()
					heartbeatConnection3 = nil
				end
			end

			syncAnimationClock = function(p)
				if p.animatedScrollTarget == nil or v ~= ScrollHostLifecyclePhase.Synchronized then
					stopAnimationClock()
				elseif heartbeatConnection3 == nil then
					heartbeatConnection3 = RunService.Heartbeat:Connect(function(dt)
						data.stepAnimatedScroll(dt)
					end)
				end
			end

			stopAnimation = function()
				if heartbeatConnection3 ~= nil then
					data.stopAnimatedScroll()
				end
			end
		else
			stopAnimation = nil
			syncAnimationClock = nil
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
			if FFlagViewRecyclerReact084 then
				stopAnimation()
			end

			stopIdleObservation() -- inferred equivalent call
			stopRecentHostScroll() -- inferred equivalent call

			for _, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)
			table.clear(v6)
			local v10, canvasSize2

			if FFlagViewRecyclerReact084 then
				v10 = v2
				canvasSize2 = canvasSize
			end

			local v11

			if FFlagViewRecyclerReact084 then
				if v10 == nil then
					v11 = false
				else
					v11 = canvasSize2 ~= nil
				end
			else
				v11 = FFlagViewRecyclerReact08
			end

			if v11 then
				if FFlagViewRecyclerReact084 then
					v10.CanvasSize = canvasSize2
				else
					local v12 = v2
					local canvasSize3 = canvasSize

					if v12 ~= nil and canvasSize3 ~= nil then
						v12.CanvasSize = canvasSize3
					end

					canvasSize = nil
				end
			end

			if FFlagViewRecyclerReact084 then
				canvasSize = nil
			end

			v2 = nil
			v8 = nil
			axis2 = nil
			v9 = nil

			if FFlagViewRecyclerReact084 then
				viewportLength = nil
			end

			scrollOffset = nil
			v4 = nil

			if FFlagViewRecyclerReact084 then
				scrollOffset2 = nil
			end

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

			if FFlagViewRecyclerReact084 then
				publishViewportSize(v10)
			else
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
			end

			local v11

			if FFlagViewRecyclerReact084 then
				v11 = v3 == 0
			else
				v11 = not FFlagViewRecyclerReact08
			end

			if v11 then
				if FFlagViewRecyclerReact084 then
					local viewportState = getViewportState(instance)

					if viewportState ~= nil then
						v10 = viewportState
					end
				end

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

			local v10 = getViewportState(instance)

			if v10 == nil then
				return
			end

			local logicalScrollOffset = getLogicalScrollOffset(v10) -- inferred equivalent call

			if FFlagViewRecyclerReact084 then
				scrollOffset2 = v10.scrollOffset
			end

			local v11 = v3 == 0

			if v11 and scrollOffset ~= nil then
				local v12 = scrollOffset

				if math.abs(v10.scrollOffset - v12) < 0.5 then
					v11 = false
				else
					scrollOffset = nil
				end
			end

			if FFlagViewRecyclerReact084 then
				local v12 = viewportLength

				if v11 and v12 ~= nil and v10.viewportLength ~= v12 then
					local v13 = math.max(
						0,
						axisMap.mainOf(instance.AbsoluteCanvasSize, configuration.axis) - v10.viewportLength
					)
					local v14

					if v12 < v10.viewportLength then
						v14 = math.abs(v10.scrollOffset - v13) < 0.5
					else
						v14 = false
					end

					local v15 = v10.scrollOffset - canvasOriginOffset
					publishViewportSize(v10)
					v10 = getViewportState(instance) or v10

					if v14 then
						reportHostWrite(v10) -- inferred equivalent call
						v11 = false
					elseif v10.scrollOffset ~= v15 + canvasOriginOffset then
						v3 += 1
						setHostScrollOffset(v15 + canvasOriginOffset)
						v3 -= 1
						v10 = getViewportState(instance) or v10
						scrollOffset = v10.scrollOffset
					end

					logicalScrollOffset = getLogicalScrollOffset(v10) -- inferred equivalent call
				end
			end

			if v11 and flag == true then
				markRecentHostScroll() -- inferred equivalent call
			end

			if v11 and logicalScrollOffset ~= v4 then
				observeHostOffset(ViewRecycler.ScrollObservationKind.User, logicalScrollOffset) -- inferred equivalent call
				v4 = logicalScrollOffset
			end

			if v11 and canvasOriginOffset ~= 0 then
				count2 = 0

				if v10.scrollOffset <= 0.5 then
					settleCanvasOriginOffset(nil)
				end
			end

			notifyLogicalScrollOffset(logicalScrollOffset) -- inferred equivalent call
		end

		local function isPointerInput(p): boolean -- 2 equivalent calls inferred from this helper
			return p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1
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

			if FFlagViewRecyclerReact084 then
				canvasSize = instance.CanvasSize
			elseif FFlagViewRecyclerReact08 then
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
			local v10

			if FFlagViewRecyclerReact084 then
				v10 = RunService.RenderStepped
			else
				v10 = instance.InputBegan
			end

			local v11

			if FFlagViewRecyclerReact084 then
				v11 = function()
					if
						v == ScrollHostLifecyclePhase.Synchronized
						and axisMap.mainOf(instance.CanvasPosition, configuration.axis) ~= scrollOffset2
					then
						sampleConfiguration() -- inferred equivalent call
						synchronizeScrollOffset(instance, true)
					end
				end
			else
				v11 = function(p)
					if isPointerInput(p) then -- inferred equivalent call
						v6[p] = true
					end
				end
			end

			table.insert(connections, v10:Connect(v11))

			if FFlagViewRecyclerReact084 then
				table.insert(connections, instance.InputBegan:Connect(function(input)
					if isPointerInput(input) then -- inferred equivalent call
						v6[input] = true
						stopAnimation()
					end
				end))

				table.insert(connections, instance.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseWheel then
						stopAnimation()
					end
				end))
			end

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
				if FFlagViewRecyclerReact084 then
					syncAnimationClock(data2)
				end

				if v == ScrollHostLifecyclePhase.Disconnected then
					callback()
					return
				end

				sampleConfiguration() -- inferred equivalent call
				local scrollCorrection = data2.scrollCorrection
				local scrollOffset3

				if data2.scrollPositionChanged then
					scrollOffset3 = data2.scrollState.scrollOffset
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

					if scrollOffset3 ~= nil then
						v4 = scrollOffset3
						notifyLogicalScrollOffset(scrollOffset3) -- inferred equivalent call
					end
				else
					callback()

					if canvasOriginOffset == 0 or scrollOffset3 == nil and v10 then
						if data2.scrollPositionChanged or data2.contentLengthChanged then
							publishCanvas()
						end

						if scrollOffset3 ~= nil then
							applyProgrammaticScrollOffset(scrollOffset3)
						end
					else
						settleCanvasOriginOffset(scrollOffset3)
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

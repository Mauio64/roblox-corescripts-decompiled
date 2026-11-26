local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollTelemetry/React")

local fFlagLuaAppScrollDetectorLifecycleHardening = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollTelemetry/SharedFlags").FFlagLuaAppScrollDetectorLifecycleHardening

game:DefineFastInt("ScrollDetectorTimeThresholdMillis", 300000)
game:DefineFastInt("ScrollDetectorDelayMillis", 250)

local function getDelaySeconds()
	return game:GetFastInt("ScrollDetectorDelayMillis") / 1000
end

local function getThresholdSeconds()
	return game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000
end

return function(data): nil
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(0)

	local ref7 = React.useRef(nil)

	local ref8 = React.useRef(data.onScrollStart)
	ref8.current = data.onScrollStart

	local ref9 = React.useRef(data.onScrollSettled)
	ref9.current = data.onScrollSettled

	if fFlagLuaAppScrollDetectorLifecycleHardening then
		local ref10 = React.useRef(data.sendScrollEvent)
		ref10.current = data.sendScrollEvent

		React.useEffect(function()
			local function fn()
				if data.scrollingFrameRef and data.scrollingFrameRef.current then
					local v5 = time()
					local v6 = v5 - ref5.current
					local v7

					if data.scrollingFrameRef and data.scrollingFrameRef.current then
						if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
							v7 = data.scrollingFrameRef.current.CanvasPosition.Y
						else
							v7 = data.scrollingFrameRef.current.CanvasPosition.X
						end
					end

					local v8 = ref.current - ref2.current
					local v9 = v7 - ref.current

					if ref7.current or v9 ~= 0 then
						if ref7.current and v9 ~= 0 then
							ref7.current = nil
						end
					else
						ref7.current = ref6.current
					end

					if
						ref7.current
						and ref7.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 < v5
					then
						ref.current = v7
						local current = ref7.current
						local v10 = ref.current - ref2.current

						if v10 ~= 0 and ref10.current then
							ref10.current(v10, current - ref5.current, ref2.current)
						end

						if ref9.current then
							local v11 = ref.current - ref2.current

							ref9.current(v11)
						end

						ref2.current = v7
						local current2 = ref3.current

						if current2 then
							current2:Disconnect()
						end

						ref3.current = nil
					else
						if v8 == 0 or v9 == 0 or math.sign(v8) == math.sign(v9) then
							if
								not ref7.current
								and game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 <= v6
							then
								ref.current = v7
								local v10 = ref.current - ref2.current

								if v10 ~= 0 and ref10.current then
									ref10.current(v10, v5 - ref5.current, ref2.current)
								end

								ref2.current = v7
								ref5.current = v5
							end
						else
							local current = ref6.current
							local v10 = ref.current - ref2.current

							if v10 ~= 0 and ref10.current then
								ref10.current(v10, current - ref5.current, ref2.current)
							end

							ref2.current = ref.current
							ref5.current = ref6.current
						end

						ref.current = v7
						ref6.current = v5
					end
				else
					local current = ref6.current
					local v5 = ref.current - ref2.current

					if v5 ~= 0 and ref10.current then
						ref10.current(v5, current - ref5.current, ref2.current)
					end

					if ref3.current then
						ref3.current:Disconnect()
					end

					ref3.current = nil
				end
			end

			local function fn2()
				if not ref3.current then
					ref5.current = time()
					ref6.current = ref5.current
					ref2.current = ref.current

					ref7.current = nil

					if ref8.current then
						ref8.current()
					end

					ref3.current = RunService.Stepped:Connect(function()
						fn()
					end)
				end
			end

			local canvasPositionChangedConnection

			if
				data.scrollingFrameRef
				and data.scrollingFrameRef.current
				and ref4.current ~= data.scrollingFrameRef.current
			then
				local v5 = ref
				local v6 = if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then data.scrollingFrameRef.current.CanvasPosition.Y else data.scrollingFrameRef.current.CanvasPosition.X
				v5.current = v6

				canvasPositionChangedConnection = data.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					fn2()
				end)

				ref4.current = data.scrollingFrameRef.current
			else
				canvasPositionChangedConnection = nil
			end

			return function()
				if ref3.current then
					local current = ref6.current
					local v5 = ref.current - ref2.current

					if v5 ~= 0 and ref10.current then
						ref10.current(v5, current - ref5.current, ref2.current)
					end

					ref3.current:Disconnect()

					if ref9.current then
						local v6 = ref.current - ref2.current
						ref9.current(v6)
					end
				end

				ref3.current = nil

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
				end

				canvasPositionChangedConnection = nil

				if not (data.scrollingFrameRef and data.scrollingFrameRef.current) then
					ref4.current = nil
				end
			end
		end, { data.scrollingFrameRef })
	else
		local function fn()
			if data.scrollingFrameRef and data.scrollingFrameRef.current then
				local v5 = time()
				local v6 = v5 - ref5.current
				local v7

				if data.scrollingFrameRef and data.scrollingFrameRef.current then
					if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
						v7 = data.scrollingFrameRef.current.CanvasPosition.Y
					else
						v7 = data.scrollingFrameRef.current.CanvasPosition.X
					end
				end

				local v8 = ref.current - ref2.current
				local v9 = v7 - ref.current

				if ref7.current or v9 ~= 0 then
					if ref7.current and v9 ~= 0 then
						ref7.current = nil
					end
				else
					ref7.current = ref6.current
				end

				if
					ref7.current
					and ref7.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 < v5
				then
					ref.current = v7
					local current = ref7.current
					local v10 = ref.current - ref2.current

					if v10 ~= 0 and data.sendScrollEvent then
						data.sendScrollEvent(v10, current - ref5.current, ref2.current)
					end

					if ref9.current then
						local v11 = ref.current - ref2.current

						ref9.current(v11)
					end

					ref2.current = v7
					local current2 = ref3.current

					if current2 then
						current2:Disconnect()
					end

					ref3.current = nil
				else
					if v8 == 0 or v9 == 0 or math.sign(v8) == math.sign(v9) then
						if
							not ref7.current
							and game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 <= v6
						then
							ref.current = v7
							local v10 = ref.current - ref2.current

							if v10 ~= 0 and data.sendScrollEvent then
								data.sendScrollEvent(v10, v5 - ref5.current, ref2.current)
							end

							ref2.current = v7
							ref5.current = v5
						end
					else
						local current = ref6.current
						local v10 = ref.current - ref2.current

						if v10 ~= 0 and data.sendScrollEvent then
							data.sendScrollEvent(v10, current - ref5.current, ref2.current)
						end

						ref2.current = ref.current
						ref5.current = ref6.current
					end

					ref.current = v7
					ref6.current = v5
				end
			else
				local current = ref6.current
				local v5 = ref.current - ref2.current

				if v5 ~= 0 and data.sendScrollEvent then
					data.sendScrollEvent(v5, current - ref5.current, ref2.current)
				end

				if ref3.current then
					ref3.current:Disconnect()
				end

				ref3.current = nil
			end
		end

		local function fn2()
			if not ref3.current then
				ref5.current = time()
				ref6.current = ref5.current
				ref2.current = ref.current

				ref7.current = nil

				if ref8.current then
					ref8.current()
				end

				ref3.current = RunService.Stepped:Connect(function()
					fn()
				end)
			end
		end

		React.useEffect(function()
			local canvasPositionChangedConnection

			if
				data.scrollingFrameRef
				and data.scrollingFrameRef.current
				and ref4.current ~= data.scrollingFrameRef.current
			then
				local v5 = ref
				local v6 = if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then data.scrollingFrameRef.current.CanvasPosition.Y else data.scrollingFrameRef.current.CanvasPosition.X
				v5.current = v6

				canvasPositionChangedConnection = data.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					fn2()
				end)

				ref4.current = data.scrollingFrameRef.current
			else
				canvasPositionChangedConnection = nil
			end

			return function()
				if ref3.current then
					local current = ref6.current
					local v5 = ref.current - ref2.current

					if v5 ~= 0 and data.sendScrollEvent then
						data.sendScrollEvent(v5, current - ref5.current, ref2.current)
					end

					ref3.current:Disconnect()

					if ref9.current then
						local v6 = ref.current - ref2.current
						ref9.current(v6)
					end
				end

				ref3.current = nil

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
				end

				canvasPositionChangedConnection = nil

				if not (data.scrollingFrameRef and data.scrollingFrameRef.current) then
					ref4.current = nil
				end
			end
		end, { data.scrollingFrameRef })
	end

	return nil
end

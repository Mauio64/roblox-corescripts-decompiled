local RunService = game:GetService("RunService")
local parent = script:FindFirstAncestor("ScrollTelemetry").Parent
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppScrollDetectorLifecycleHardening = SharedFlags.FFlagLuaAppScrollDetectorLifecycleHardening

game:DefineFastInt("ScrollDetectorTimeThresholdMillis", 300000)
game:DefineFastInt("ScrollDetectorDelayMillis", 250)

local function getDelaySeconds() -- 2 equivalent calls inferred from this helper
	return game:GetFastInt("ScrollDetectorDelayMillis") / 1000
end

local function getThresholdSeconds() -- 2 equivalent calls inferred from this helper
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

	local function fn(p: number) -- 5 equivalent calls inferred from this helper
		local v = ref.current - ref2.current

		if v == 0 then
			return
		end

		if data.sendScrollEvent then
			data.sendScrollEvent(v, p - ref5.current, ref2.current)
		end
	end

	if FFlagLuaAppScrollDetectorLifecycleHardening then
		local ref10 = React.useRef(data.sendScrollEvent)
		ref10.current = data.sendScrollEvent

		React.useEffect(function()
			local function fn2(p: number) -- 5 equivalent calls inferred from this helper
				local v = ref.current - ref2.current

				if v == 0 then
					return
				end

				if ref10.current then
					ref10.current(v, p - ref5.current, ref2.current)
				end
			end

			local function fn3()
				if data.scrollingFrameRef and data.scrollingFrameRef.current then
					local current2 = time()
					local v = current2 - ref5.current
					local current3

					if data.scrollingFrameRef and data.scrollingFrameRef.current then
						if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
							current3 = data.scrollingFrameRef.current.CanvasPosition.Y
						else
							current3 = data.scrollingFrameRef.current.CanvasPosition.X
						end
					end

					local v2 = ref.current - ref2.current
					local v3 = current3 - ref.current

					if ref7.current or v3 ~= 0 then
						if ref7.current and v3 ~= 0 then
							ref7.current = nil
						end
					else
						ref7.current = ref6.current
					end

					if ref7.current and ref7.current + getDelaySeconds() < current2 then -- inferred equivalent call
						ref.current = current3
						fn2(ref7.current) -- inferred equivalent call

						if ref9.current then
							local v4 = ref.current - ref2.current

							ref9.current(v4)
						end

						ref2.current = current3
						local current = ref3.current

						if current then
							current:Disconnect()
						end

						ref3.current = nil
					else
						if v2 == 0 or v3 == 0 or math.sign(v2) == math.sign(v3) then
							if not ref7.current and getThresholdSeconds() <= v then -- inferred equivalent call
								ref.current = current3
								fn2(current2) -- inferred equivalent call
								ref2.current = current3
								ref5.current = current2
							end
						else
							fn2(ref6.current) -- inferred equivalent call
							ref2.current = ref.current
							ref5.current = ref6.current
						end

						ref.current = current3
						ref6.current = current2
					end
				else
					fn2(ref6.current) -- inferred equivalent call

					if ref3.current then
						ref3.current:Disconnect()
					end

					ref3.current = nil
				end
			end

			local function fn4()
				if not ref3.current then
					ref5.current = time()
					ref6.current = ref5.current
					ref2.current = ref.current

					ref7.current = nil

					if ref8.current then
						ref8.current()
					end

					ref3.current = RunService.Stepped:Connect(function()
						fn3()
					end)
				end
			end

			local canvasPositionChangedConnection

			if
				data.scrollingFrameRef
				and data.scrollingFrameRef.current
				and ref4.current ~= data.scrollingFrameRef.current
			then
				local current

				if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
					current = data.scrollingFrameRef.current.CanvasPosition.Y
				else
					current = data.scrollingFrameRef.current.CanvasPosition.X
				end

				ref.current = current

				canvasPositionChangedConnection = data.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					fn4()
				end)

				ref4.current = data.scrollingFrameRef.current
			else
				canvasPositionChangedConnection = nil
			end

			return function()
				if ref3.current then
					fn2(ref6.current) -- inferred equivalent call
					ref3.current:Disconnect()

					if ref9.current then
						local v = ref.current - ref2.current
						ref9.current(v)
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
		local function fn2()
			if data.scrollingFrameRef and data.scrollingFrameRef.current then
				local current2 = time()
				local v = current2 - ref5.current
				local current3

				if data.scrollingFrameRef and data.scrollingFrameRef.current then
					if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
						current3 = data.scrollingFrameRef.current.CanvasPosition.Y
					else
						current3 = data.scrollingFrameRef.current.CanvasPosition.X
					end
				end

				local v2 = ref.current - ref2.current
				local v3 = current3 - ref.current

				if ref7.current or v3 ~= 0 then
					if ref7.current and v3 ~= 0 then
						ref7.current = nil
					end
				else
					ref7.current = ref6.current
				end

				if ref7.current and ref7.current + getDelaySeconds() < current2 then -- inferred equivalent call
					ref.current = current3
					fn(ref7.current) -- inferred equivalent call

					if ref9.current then
						local v4 = ref.current - ref2.current

						ref9.current(v4)
					end

					ref2.current = current3
					local current = ref3.current

					if current then
						current:Disconnect()
					end

					ref3.current = nil
				else
					if v2 == 0 or v3 == 0 or math.sign(v2) == math.sign(v3) then
						if not ref7.current and getThresholdSeconds() <= v then -- inferred equivalent call
							ref.current = current3
							fn(current2) -- inferred equivalent call
							ref2.current = current3
							ref5.current = current2
						end
					else
						fn(ref6.current) -- inferred equivalent call
						ref2.current = ref.current
						ref5.current = ref6.current
					end

					ref.current = current3
					ref6.current = current2
				end
			else
				fn(ref6.current) -- inferred equivalent call

				if ref3.current then
					ref3.current:Disconnect()
				end

				ref3.current = nil
			end
		end

		local function fn3()
			if not ref3.current then
				ref5.current = time()
				ref6.current = ref5.current
				ref2.current = ref.current

				ref7.current = nil

				if ref8.current then
					ref8.current()
				end

				ref3.current = RunService.Stepped:Connect(function()
					fn2()
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
				local current

				if data.scrollingFrameRef.current.ScrollingDirection == Enum.ScrollingDirection.Y then
					current = data.scrollingFrameRef.current.CanvasPosition.Y
				else
					current = data.scrollingFrameRef.current.CanvasPosition.X
				end

				ref.current = current

				canvasPositionChangedConnection = data.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					fn3()
				end)

				ref4.current = data.scrollingFrameRef.current
			else
				canvasPositionChangedConnection = nil
			end

			return function()
				if ref3.current then
					fn(ref6.current) -- inferred equivalent call
					ref3.current:Disconnect()

					if ref9.current then
						local v = ref.current - ref2.current
						ref9.current(v)
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

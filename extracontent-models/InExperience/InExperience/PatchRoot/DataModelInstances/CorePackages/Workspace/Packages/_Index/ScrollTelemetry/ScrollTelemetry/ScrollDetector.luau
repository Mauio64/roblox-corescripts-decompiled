local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("ScrollTelemetry").Parent
local React = require(Parent.React)
local FFlagLuaAppScrollDetectorLifecycleHardening = require(Parent.SharedFlags).FFlagLuaAppScrollDetectorLifecycleHardening

game:DefineFastInt("ScrollDetectorTimeThresholdMillis", 300000)
game:DefineFastInt("ScrollDetectorDelayMillis", 250)

local function getDelaySeconds() -- line: 12
	return game:GetFastInt("ScrollDetectorDelayMillis") / 1000
end
local function getThresholdSeconds() -- line: 16
	return game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000
end

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), FFlagLuaAppScrollDetectorLifecycleHardening (copy), RunService (copy)
	local v8 = React.useRef(0)
	local v9 = React.useRef(0)
	local v10 = React.useRef(nil)
	local v11 = React.useRef(nil)
	local v12 = React.useRef(0)
	local v13 = React.useRef(0)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(t1.onScrollStart)

	v15.current = t1.onScrollStart

	local v16 = React.useRef(t1.onScrollSettled)

	v16.current = t1.onScrollSettled

	if FFlagLuaAppScrollDetectorLifecycleHardening then
		local v17 = React.useRef(t1.sendScrollEvent)

		v17.current = t1.sendScrollEvent
		React.useEffect(function() -- line: 51
			-- upvalues: v8 (copy), v9 (copy), v17 (copy), v12 (copy), t1 (copy), v13 (copy), v10 (copy), v14 (copy), v16 (copy), v15 (copy), RunService (copy), v11 (copy)
			local function v20() -- line: 67
				-- upvalues: t1 (copy), v13 (copy), v8 (copy), v9 (copy), v17 (copy), v12 (copy), v10 (copy), v14 (copy), v16 (copy)
				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					local current = v13.current
					local v43 = v8.current - v9.current

					if v43 ~= 0 and v17.current then
						v17.current(v43, current - v12.current, v9.current)
					end

					if v10.current then
						v10.current:Disconnect()
					end

					v10.current = nil

					return
				end

				local v44 = nil
				local v45 = time()
				local v46 = v45 - v12.current

				if t1.scrollingFrameRef and t1.scrollingFrameRef.current then
					v44 = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				end

				local v47 = v8.current - v9.current
				local v48 = v44 - v8.current

				if not v14.current and v48 == 0 then
					v14.current = v13.current
				elseif v14.current and v48 ~= 0 then
					v14.current = nil
				end

				if v14.current and v45 > v14.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 then
					v8.current = v44

					local current = v14.current
					local v50 = v8.current - v9.current

					if v50 ~= 0 and v17.current then
						v17.current(v50, current - v12.current, v9.current)
					end

					if v16.current then
						local v51 = v8.current - v9.current

						v16.current(v51)
					end

					v9.current = v44

					local current2 = v10.current

					if current2 then
						current2:Disconnect()
					end

					v10.current = nil

					return
				end

				if v47 ~= 0 and v48 ~= 0 and math.sign(v47) ~= math.sign(v48) then
					local current = v13.current
					local v54 = v8.current - v9.current

					if v54 ~= 0 and v17.current then
						v17.current(v54, current - v12.current, v9.current)
					end

					v9.current = v8.current
					v12.current = v13.current
				elseif not v14.current and v46 >= game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 then
					v8.current = v44

					local v55 = v8.current - v9.current

					if v55 ~= 0 and v17.current then
						v17.current(v55, v45 - v12.current, v9.current)
					end

					v9.current = v44
					v12.current = v45
				end

				v8.current = v44
				v13.current = v45
			end
			local function v21() -- line: 139
				-- upvalues: v10 (copy), v12 (copy), v13 (copy), v9 (copy), v8 (copy), v14 (copy), v15 (copy), RunService (copy), v20 (copy)
				if not v10.current then
					v12.current = time()
					v13.current = v12.current
					v9.current = v8.current
					v14.current = nil

					if v15.current then
						v15.current()
					end

					v10.current = RunService.Stepped:Connect(function() -- line: 152
						-- upvalues: v20 (copy)
						v20()
					end)
				end
			end

			local connection = nil

			if t1.scrollingFrameRef and (t1.scrollingFrameRef.current and v11.current ~= t1.scrollingFrameRef.current) then
				v8.current = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				connection = t1.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 170
					-- upvalues: v21 (copy)
					v21()
				end)
				v11.current = t1.scrollingFrameRef.current
			end

			return function() -- line: 177
				-- upvalues: v10 (copy), v13 (copy), v8 (copy), v9 (copy), v17 (copy), v12 (copy), v16 (copy), connection (ref), t1 (copy), v11 (copy)
				if v10.current then
					local current = v13.current
					local v57 = v8.current - v9.current

					if v57 ~= 0 and v17.current then
						v17.current(v57, current - v12.current, v9.current)
					end

					v10.current:Disconnect()

					if v16.current then
						local v58 = v8.current - v9.current

						v16.current(v58)
					end
				end

				v10.current = nil

				if connection then
					connection:Disconnect()
				end

				connection = nil

				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					v11.current = nil
				end
			end
		end, { t1.scrollingFrameRef })
	else
		local function v18() -- line: 212
			-- upvalues: t1 (copy), v13 (copy), v8 (copy), v9 (copy), v12 (copy), v10 (copy), v14 (copy), v16 (copy)
			if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
				local current = v13.current
				local v26 = v8.current - v9.current

				if v26 ~= 0 and t1.sendScrollEvent then
					t1.sendScrollEvent(v26, current - v12.current, v9.current)
				end

				if v10.current then
					v10.current:Disconnect()
				end

				v10.current = nil

				return
			end

			local v27 = nil
			local v28 = time()
			local v29 = v28 - v12.current

			if t1.scrollingFrameRef and t1.scrollingFrameRef.current then
				v27 = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
			end

			local v30 = v8.current - v9.current
			local v31 = v27 - v8.current

			if not v14.current and v31 == 0 then
				v14.current = v13.current
			elseif v14.current and v31 ~= 0 then
				v14.current = nil
			end

			if v14.current and v28 > v14.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 then
				v8.current = v27

				local current = v14.current
				local v33 = v8.current - v9.current

				if v33 ~= 0 and t1.sendScrollEvent then
					t1.sendScrollEvent(v33, current - v12.current, v9.current)
				end

				if v16.current then
					local v34 = v8.current - v9.current

					v16.current(v34)
				end

				v9.current = v27

				local current3 = v10.current

				if current3 then
					current3:Disconnect()
				end

				v10.current = nil

				return
			end

			if v30 ~= 0 and v31 ~= 0 and math.sign(v30) ~= math.sign(v31) then
				local current = v13.current
				local v37 = v8.current - v9.current

				if v37 ~= 0 and t1.sendScrollEvent then
					t1.sendScrollEvent(v37, current - v12.current, v9.current)
				end

				v9.current = v8.current
				v12.current = v13.current
			elseif not v14.current and v29 >= game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 then
				v8.current = v27

				local v38 = v8.current - v9.current

				if v38 ~= 0 and t1.sendScrollEvent then
					t1.sendScrollEvent(v38, v28 - v12.current, v9.current)
				end

				v9.current = v27
				v12.current = v28
			end

			v8.current = v27
			v13.current = v28
		end
		local function v19() -- line: 284
			-- upvalues: v10 (copy), v12 (copy), v13 (copy), v9 (copy), v8 (copy), v14 (copy), v15 (copy), RunService (copy), v18 (copy)
			if not v10.current then
				v12.current = time()
				v13.current = v12.current
				v9.current = v8.current
				v14.current = nil

				if v15.current then
					v15.current()
				end

				v10.current = RunService.Stepped:Connect(function() -- line: 297
					-- upvalues: v18 (copy)
					v18()
				end)
			end
		end

		React.useEffect(function() -- line: 303
			-- upvalues: t1 (copy), v11 (copy), v8 (copy), v19 (copy), v10 (copy), v13 (copy), v9 (copy), v12 (copy), v16 (copy)
			local connection = nil

			if t1.scrollingFrameRef and (t1.scrollingFrameRef.current and v11.current ~= t1.scrollingFrameRef.current) then
				v8.current = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				connection = t1.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 316
					-- upvalues: v19 (copy)
					v19()
				end)
				v11.current = t1.scrollingFrameRef.current
			end

			return function() -- line: 323
				-- upvalues: v10 (copy), v13 (copy), v8 (copy), v9 (copy), t1 (copy), v12 (copy), v16 (copy), connection (ref), v11 (copy)
				if v10.current then
					local current = v13.current
					local v60 = v8.current - v9.current

					if v60 ~= 0 and t1.sendScrollEvent then
						t1.sendScrollEvent(v60, current - v12.current, v9.current)
					end

					v10.current:Disconnect()

					if v16.current then
						local v61 = v8.current - v9.current

						v16.current(v61)
					end
				end

				v10.current = nil

				if connection then
					connection:Disconnect()
				end

				connection = nil

				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					v11.current = nil
				end
			end
		end, { t1.scrollingFrameRef })
	end

	return nil
end

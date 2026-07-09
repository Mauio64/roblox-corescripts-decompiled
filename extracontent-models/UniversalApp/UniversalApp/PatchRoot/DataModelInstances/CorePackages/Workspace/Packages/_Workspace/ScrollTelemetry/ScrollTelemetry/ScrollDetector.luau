local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("ScrollTelemetry").Parent
local React = require(Parent.React)
local FFlagLuaAppScrollDetectorLifecycleHardening = require(Parent.SharedFlags).FFlagLuaAppScrollDetectorLifecycleHardening
local FFlagLuaAppHomeTouchAutoplay = require(Parent.SharedFlags).FFlagLuaAppHomeTouchAutoplay

game:DefineFastInt("ScrollDetectorTimeThresholdMillis", 300000)
game:DefineFastInt("ScrollDetectorDelayMillis", 250)

local function getDelaySeconds() -- line: 13
	return game:GetFastInt("ScrollDetectorDelayMillis") / 1000
end
local function getThresholdSeconds() -- line: 17
	return game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000
end

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppScrollDetectorLifecycleHardening (copy), RunService (copy)
	local v9 = React.useRef(0)
	local v10 = React.useRef(0)
	local v11 = React.useRef(nil)
	local v12 = React.useRef(nil)
	local v13 = React.useRef(0)
	local v14 = React.useRef(0)
	local v15 = React.useRef(nil)
	local u16 = nil
	local u17 = nil

	if FFlagLuaAppHomeTouchAutoplay then
		u16 = React.useRef(t1.onScrollStart)
		u16.current = t1.onScrollStart
		u17 = React.useRef(t1.onScrollSettled)
		u17.current = t1.onScrollSettled
	end

	if FFlagLuaAppScrollDetectorLifecycleHardening then
		local v18 = React.useRef(t1.sendScrollEvent)

		v18.current = t1.sendScrollEvent
		React.useEffect(function() -- line: 56
			-- upvalues: v9 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v18 (copy), v13 (copy), t1 (copy), v14 (copy), v11 (copy), v15 (copy), u17 (ref), u16 (ref), RunService (copy), v12 (copy)
			local function v21() -- line: 80
				-- upvalues: t1 (copy), v14 (copy), v9 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v18 (copy), v13 (copy), v11 (copy), v15 (copy), u17 (ref)
				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					local current = v14.current
					local v44 = v9.current - v10.current

					if v44 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if v18.current then
								v18.current(v44, current - v13.current, v10.current)
							end
						else
							v18.current(v44, current - v13.current, v10.current)
						end
					end

					if v11.current then
						v11.current:Disconnect()
					end

					v11.current = nil

					return
				end

				local v45 = nil
				local v46 = time()
				local v47 = v46 - v13.current

				if t1.scrollingFrameRef and t1.scrollingFrameRef.current then
					v45 = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				end

				local v48 = v9.current - v10.current
				local v49 = v45 - v9.current

				if not v15.current and v49 == 0 then
					v15.current = v14.current
				elseif v15.current and v49 ~= 0 then
					v15.current = nil
				end

				if v15.current and v46 > v15.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 then
					v9.current = v45

					local current = v15.current
					local v51 = v9.current - v10.current

					if v51 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if v18.current then
								v18.current(v51, current - v13.current, v10.current)
							end
						else
							v18.current(v51, current - v13.current, v10.current)
						end
					end

					if FFlagLuaAppHomeTouchAutoplay and u17.current then
						local v52 = v9.current - v10.current

						u17.current(v52)
					end

					v10.current = v45

					local current2 = v11.current

					if current2 then
						current2:Disconnect()
					end

					v11.current = nil

					return
				end

				if v48 ~= 0 and v49 ~= 0 and math.sign(v48) ~= math.sign(v49) then
					local current = v14.current
					local v55 = v9.current - v10.current

					if v55 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if v18.current then
								v18.current(v55, current - v13.current, v10.current)
							end
						else
							v18.current(v55, current - v13.current, v10.current)
						end
					end

					v10.current = v9.current
					v13.current = v14.current
				elseif not v15.current and v47 >= game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 then
					v9.current = v45

					local v56 = v9.current - v10.current

					if v56 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if v18.current then
								v18.current(v56, v46 - v13.current, v10.current)
							end
						else
							v18.current(v56, v46 - v13.current, v10.current)
						end
					end

					v10.current = v45
					v13.current = v46
				end

				v9.current = v45
				v14.current = v46
			end
			local function v22() -- line: 154
				-- upvalues: v11 (copy), v13 (copy), v14 (copy), v10 (copy), v9 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v15 (copy), u16 (ref), RunService (copy), v21 (copy)
				if not v11.current then
					v13.current = time()
					v14.current = v13.current
					v10.current = v9.current

					if FFlagLuaAppHomeTouchAutoplay then
						v15.current = nil

						if u16.current then
							u16.current()
						end
					end

					v11.current = RunService.Stepped:Connect(function() -- line: 169
						-- upvalues: v21 (copy)
						v21()
					end)
				end
			end

			local connection = nil

			if t1.scrollingFrameRef and (t1.scrollingFrameRef.current and v12.current ~= t1.scrollingFrameRef.current) then
				v9.current = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				connection = t1.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 187
					-- upvalues: v22 (copy)
					v22()
				end)
				v12.current = t1.scrollingFrameRef.current
			end

			return function() -- line: 194
				-- upvalues: v11 (copy), v14 (copy), v9 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v18 (copy), v13 (copy), u17 (ref), connection (ref), t1 (copy), v12 (copy)
				if v11.current then
					local current = v14.current
					local v58 = v9.current - v10.current

					if v58 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if v18.current then
								v18.current(v58, current - v13.current, v10.current)
							end
						else
							v18.current(v58, current - v13.current, v10.current)
						end
					end

					v11.current:Disconnect()

					if FFlagLuaAppHomeTouchAutoplay and u17.current then
						local v59 = v9.current - v10.current

						u17.current(v59)
					end
				end

				v11.current = nil

				if connection then
					connection:Disconnect()
				end

				connection = nil

				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					v12.current = nil
				end
			end
		end, { t1.scrollingFrameRef })
	else
		local function v19() -- line: 239
			-- upvalues: t1 (copy), v14 (copy), v9 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v13 (copy), v11 (copy), v15 (copy), u17 (ref)
			if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
				local current = v14.current
				local v27 = v9.current - v10.current

				if v27 ~= 0 then
					if FFlagLuaAppHomeTouchAutoplay then
						if t1.sendScrollEvent then
							t1.sendScrollEvent(v27, current - v13.current, v10.current)
						end
					else
						t1.sendScrollEvent(v27, current - v13.current, v10.current)
					end
				end

				if v11.current then
					v11.current:Disconnect()
				end

				v11.current = nil

				return
			end

			local v28 = nil
			local v29 = time()
			local v30 = v29 - v13.current

			if t1.scrollingFrameRef and t1.scrollingFrameRef.current then
				v28 = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
			end

			local v31 = v9.current - v10.current
			local v32 = v28 - v9.current

			if not v15.current and v32 == 0 then
				v15.current = v14.current
			elseif v15.current and v32 ~= 0 then
				v15.current = nil
			end

			if v15.current and v29 > v15.current + game:GetFastInt("ScrollDetectorDelayMillis") / 1000 then
				v9.current = v28

				local current = v15.current
				local v34 = v9.current - v10.current

				if v34 ~= 0 then
					if FFlagLuaAppHomeTouchAutoplay then
						if t1.sendScrollEvent then
							t1.sendScrollEvent(v34, current - v13.current, v10.current)
						end
					else
						t1.sendScrollEvent(v34, current - v13.current, v10.current)
					end
				end

				if FFlagLuaAppHomeTouchAutoplay and u17.current then
					local v35 = v9.current - v10.current

					u17.current(v35)
				end

				v10.current = v28

				local current3 = v11.current

				if current3 then
					current3:Disconnect()
				end

				v11.current = nil

				return
			end

			if v31 ~= 0 and v32 ~= 0 and math.sign(v31) ~= math.sign(v32) then
				local current = v14.current
				local v38 = v9.current - v10.current

				if v38 ~= 0 then
					if FFlagLuaAppHomeTouchAutoplay then
						if t1.sendScrollEvent then
							t1.sendScrollEvent(v38, current - v13.current, v10.current)
						end
					else
						t1.sendScrollEvent(v38, current - v13.current, v10.current)
					end
				end

				v10.current = v9.current
				v13.current = v14.current
			elseif not v15.current and v30 >= game:GetFastInt("ScrollDetectorTimeThresholdMillis") / 1000 then
				v9.current = v28

				local v39 = v9.current - v10.current

				if v39 ~= 0 then
					if FFlagLuaAppHomeTouchAutoplay then
						if t1.sendScrollEvent then
							t1.sendScrollEvent(v39, v29 - v13.current, v10.current)
						end
					else
						t1.sendScrollEvent(v39, v29 - v13.current, v10.current)
					end
				end

				v10.current = v28
				v13.current = v29
			end

			v9.current = v28
			v14.current = v29
		end
		local function v20() -- line: 313
			-- upvalues: v11 (copy), v13 (copy), v14 (copy), v10 (copy), v9 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v15 (copy), u16 (ref), RunService (copy), v19 (copy)
			if not v11.current then
				v13.current = time()
				v14.current = v13.current
				v10.current = v9.current

				if FFlagLuaAppHomeTouchAutoplay then
					v15.current = nil

					if u16.current then
						u16.current()
					end
				end

				v11.current = RunService.Stepped:Connect(function() -- line: 328
					-- upvalues: v19 (copy)
					v19()
				end)
			end
		end

		React.useEffect(function() -- line: 334
			-- upvalues: t1 (copy), v12 (copy), v9 (copy), v20 (copy), v11 (copy), v14 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), v13 (copy), u17 (ref)
			local connection = nil

			if t1.scrollingFrameRef and (t1.scrollingFrameRef.current and v12.current ~= t1.scrollingFrameRef.current) then
				v9.current = if t1.scrollingFrameRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then t1.scrollingFrameRef.current.CanvasPosition.X else t1.scrollingFrameRef.current.CanvasPosition.Y
				connection = t1.scrollingFrameRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 347
					-- upvalues: v20 (copy)
					v20()
				end)
				v12.current = t1.scrollingFrameRef.current
			end

			return function() -- line: 354
				-- upvalues: v11 (copy), v14 (copy), v9 (copy), v10 (copy), FFlagLuaAppHomeTouchAutoplay (copy), t1 (copy), v13 (copy), u17 (ref), connection (ref), v12 (copy)
				if v11.current then
					local current = v14.current
					local v61 = v9.current - v10.current

					if v61 ~= 0 then
						if FFlagLuaAppHomeTouchAutoplay then
							if t1.sendScrollEvent then
								t1.sendScrollEvent(v61, current - v13.current, v10.current)
							end
						else
							t1.sendScrollEvent(v61, current - v13.current, v10.current)
						end
					end

					v11.current:Disconnect()

					if FFlagLuaAppHomeTouchAutoplay and u17.current then
						local v62 = v9.current - v10.current

						u17.current(v62)
					end
				end

				v11.current = nil

				if connection then
					connection:Disconnect()
				end

				connection = nil

				if not t1.scrollingFrameRef or not t1.scrollingFrameRef.current then
					v12.current = nil
				end
			end
		end, { t1.scrollingFrameRef })
	end

	return nil
end

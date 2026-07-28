local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local ParentParent = TiltLoadingScreen.Parent.Parent
local React = require(ParentParent.React)
local Motion = require(ParentParent.Motion)
local RunService = game:GetService("RunService")
local Constants = require(TiltLoadingScreen.Constants)
local ANIMATION = Constants.ANIMATION
local LOCKUP = Constants.LOCKUP
local TILT_DEGREES = Constants.KEYART.TILT_DEGREES
local v10 = Motion.createState({
	keyart = 0,
	frame = 0,
	title = 0,
	creator = 0,
	verified = 0
})

local function revealed(p1, n1: number) -- line: 23
	-- upvalues: Motion (copy)
	return Motion.createState(p1, {
		default = Motion.transition({
			duration = n1
		})
	})
end

local v12 = revealed({
	keyart = 1
}, ANIMATION.artDur)
local v13 = revealed({
	frame = 1
}, ANIMATION.artDur)
local v14 = revealed({
	title = 1
}, ANIMATION.textDur)
local v15 = revealed({
	creator = 1,
	verified = 1
}, ANIMATION.textDur)
local v16 = Motion.createState({
	keyart = 0,
	frame = 0,
	title = 0,
	creator = 0,
	verified = 0
}, {
	default = Motion.transition({
		duration = ANIMATION.closeDur
	})
})
local v17 = Motion.createState({
	keyart = 1,
	frame = 1,
	title = 1,
	creator = 1,
	verified = 1
}, {
	default = Motion.transition({
		duration = 0
	})
})

local function clamp01(n2: number) -- line: 52
	return (math.clamp(n2, 0, 1))
end
local function scaleFromReveal(n3: number) -- line: 56
	return (math.min(1, math.clamp(n3, 0, 1) * 0.5 + 0.5))
end
local function slideFromReveal(n4: number, n5: number) -- line: 60
	return UDim.new(0, (1 - math.clamp(n4, 0, 1)) * n5)
end

require(TiltLoadingScreen.Types)

local function useLoadingScreenAnimation(t1: {[any]: any}) -- line: 73
	-- upvalues: Motion (copy), v10 (copy), React (copy), v15 (copy), v14 (copy), ANIMATION (copy), v12 (copy), v13 (copy), v16 (copy), v17 (copy), RunService (copy), TILT_DEGREES (copy), scaleFromReveal (copy), clamp01 (copy), slideFromReveal (copy), LOCKUP (copy)
	local v29, v30 = Motion.useMotion(v10)
	local v31 = React.useRef(v30)

	v31.current = v30

	local v32 = React.useRef(t1)

	v32.current = t1

	local v33 = React.useRef({})
	local v34 = React.useRef({
		timeline = false,
		cascade = false,
		title = false,
		creator = false
	})
	local v35, v36 = React.useBinding(0)
	local v37, v38 = React.useBinding(t1.reducedMotion)

	React.useEffect(function() -- line: 86
		-- upvalues: v38 (copy), t1 (copy)
		v38(t1.reducedMotion)
	end, { t1.reducedMotion })

	local function cancelScheduled() -- line: 90
		-- upvalues: v33 (copy)
		for _, v49 in v33.current do
			pcall(task.cancel, v49)
		end

		v33.current = {}
	end
	local function schedule(n6: number, p2: ((...any) -> ...any)) -- line: 97
		-- upvalues: v33 (copy)
		local thread = task.delay(n6, p2)

		table.insert(v33.current, thread)
	end
	local function canAnimate() -- line: 102
		-- upvalues: v32 (copy)
		local current = v32.current

		return not current.reducedMotion and not current.isDismissing
	end
	local function startCreator() -- line: 107
		-- upvalues: v34 (copy), v32 (copy), v31 (copy), v15 (copy)
		if not v34.current.creator then
			local current = v32.current

			if not current.reducedMotion and not current.isDismissing then
				v34.current.creator = true
				v31.current(v15)

				return
			end
		end
	end
	local function startTitle() -- line: 115
		-- upvalues: v34 (copy), v32 (copy), v31 (copy), v14 (copy), ANIMATION (copy), startCreator (copy), v33 (copy)
		if not v34.current.title and v32.current.contentReady then
			local current = v32.current

			if not current.reducedMotion and not current.isDismissing then
				v34.current.title = true
				v31.current(v14)

				local titleDelay = ANIMATION.titleDelay
				local v57 = startCreator
				local thread = task.delay(titleDelay, v57)

				table.insert(v33.current, thread)

				return
			end
		end
	end
	local function startTimeline() -- line: 124
		-- upvalues: v34 (copy), v32 (copy), v31 (copy), v12 (copy), ANIMATION (copy), v13 (copy), v33 (copy), v14 (copy), startCreator (copy)
		if not v34.current.timeline then
			local current = v32.current

			if not current.reducedMotion and not current.isDismissing then
				v34.current.timeline = true
				v31.current(v12)

				local artDelay = ANIMATION.artDelay
				local thread = task.delay(artDelay, function() -- line: 130
					-- upvalues: v32 (copy), v31 (copy), v13 (copy)
					local current2 = v32.current

					if not current2.reducedMotion and not current2.isDismissing then
						v31.current(v13)
					end
				end)

				table.insert(v33.current, thread)

				local cascade = ANIMATION.cascade
				local thread3 = task.delay(cascade, function() -- line: 135
					-- upvalues: v34 (copy), v32 (copy), v31 (copy), v14 (copy), ANIMATION (copy), startCreator (copy), v33 (copy)
					v34.current.cascade = true

					if not v34.current.title and v32.current.contentReady then
						local current3 = v32.current

						if current3.reducedMotion or current3.isDismissing then
							return
						end

						v34.current.title = true
						v31.current(v14)

						local titleDelay = ANIMATION.titleDelay
						local v81 = startCreator
						local thread2 = task.delay(titleDelay, v81)

						table.insert(v33.current, thread2)
					end
				end)

				table.insert(v33.current, thread3)

				return
			end
		end
	end
	local function startExitTimeline() -- line: 141
		-- upvalues: v31 (copy), v16 (copy)
		v31.current(v16)
	end
	local function freeze() -- line: 145
		-- upvalues: v31 (copy), Motion (copy), v29 (copy)
		v31.current(Motion.createState({
			keyart = v29.keyart:getValue(),
			frame = v29.frame:getValue(),
			title = v29.title:getValue(),
			creator = v29.creator:getValue(),
			verified = v29.verified:getValue()
		}, {
			default = Motion.transition({
				duration = 0
			})
		}))
	end

	React.useEffect(function() -- line: 157
		-- upvalues: t1 (copy), cancelScheduled (copy), v31 (copy), v10 (copy), v16 (copy), v34 (copy), v17 (copy), startTimeline (copy), v32 (copy), v14 (copy), ANIMATION (copy), startCreator (copy), v33 (copy)
		if t1.isDismissing then
			cancelScheduled()

			if t1.reducedMotion then
				v31.current(v10)

				return
			end

			v31.current(v16)

			return
		end

		if t1.reducedMotion then
			cancelScheduled()
			v34.current = {
				timeline = true,
				cascade = true,
				title = true,
				creator = true
			}
			v31.current(v17)

			return
		end

		startTimeline()

		if t1.contentReady and v34.current.cascade and not v34.current.title and v32.current.contentReady then
			local current = v32.current

			if current.reducedMotion or current.isDismissing then
				return
			end

			v34.current.title = true
			v31.current(v14)

			local titleDelay = ANIMATION.titleDelay
			local v66 = startCreator
			local thread = task.delay(titleDelay, v66)

			table.insert(v33.current, thread)
		end
	end, {
		t1.contentReady,
		t1.isDismissing,
		t1.reducedMotion
	})
	React.useEffect(function() -- line: 177
		-- upvalues: t1 (copy), RunService (copy), v36 (copy)
		if t1.reducedMotion or t1.isDismissing then
			return
		end

		local elapsed = os.clock()
		local connection = RunService.Heartbeat:Connect(function() -- line: 183
			-- upvalues: v36 (copy), elapsed (copy)
			v36(os.clock() - elapsed)
		end)

		return function() -- line: 187
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t1.isDismissing,
		t1.reducedMotion
	})
	React.useEffect(function() -- line: 192
		-- upvalues: cancelScheduled (copy), freeze (copy)
		return function() -- line: 193
			-- upvalues: cancelScheduled (copy), freeze (copy)
			cancelScheduled()
			freeze()
		end
	end, {})

	local v47 = React.useRef(nil)

	if v47.current == nil then
		v47.current = {
			keyart = {
				rotation = v29.keyart:map(function(n7: number) -- line: 203
					-- upvalues: TILT_DEGREES (copy)
					return TILT_DEGREES * math.clamp(n7, 0, 1)
				end),
				sizeScale = v29.keyart:map(scaleFromReveal),
				coverTransparency = v29.keyart:map(clamp01)
			},
			frame = {
				rotation = React.joinBindings({
					reveal = v29.frame,
					elapsed = v35,
					shouldReduceMotion = v37
				}):map(function(p3) -- line: 214
					-- upvalues: ANIMATION (copy), TILT_DEGREES (copy)
					local reveal = p3.reveal
					local elapsed = p3.elapsed
					local n8 = 0

					if not p3.shouldReduceMotion then
						n8 = math.sin(elapsed * ANIMATION.wobbleSpeed * 2 * 3.141592653589793 * 0.28 + 0.9) * ANIMATION.wobbleAngle * 1.4 * math.clamp(reveal, 0, 1)
					end

					return -TILT_DEGREES * reveal + n8
				end),
				sizeScale = v29.frame:map(scaleFromReveal),
				groupTransparency = v29.frame:map(function(n9: number) -- line: 228
					return (math.min(1, (1 - math.clamp(n9, 0, 1)) * 2))
				end)
			},
			title = {
				reveal = v29.title,
				slide = v29.title:map(function(n10: number) -- line: 234
					-- upvalues: slideFromReveal (copy), LOCKUP (copy)
					return slideFromReveal(n10, LOCKUP.TITLE_SLIDE)
				end)
			},
			creator = {
				reveal = v29.creator,
				slide = v29.creator:map(function(n11: number) -- line: 240
					-- upvalues: slideFromReveal (copy), LOCKUP (copy)
					return slideFromReveal(n11, LOCKUP.SUB_SLIDE)
				end)
			},
			verified = {
				reveal = v29.verified
			}
		}
	end

	return v47.current
end

return useLoadingScreenAnimation

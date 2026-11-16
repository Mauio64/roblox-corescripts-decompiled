local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Motion = require(parent2.Motion)
require(parent.LoadingScreenMilestones.Types)
local Constants = require(parent.LoadingScreenMilestones.Constants)
local ContentId = Constants.ContentId

local RunService = game:GetService("RunService")

local SharedFlags = require(parent2.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagTiltLoadingScreenEnterExitHold = SharedFlags2.FFlagTiltLoadingScreenEnterExitHold

local Constants2 = require(TiltLoadingScreen.Constants)
local animation = Constants2.ANIMATION
local lockup = Constants2.LOCKUP
local TILT_DEGREES = Constants2.KEYART.TILT_DEGREES

local state = Motion.createState({
	keyart = 0,
	frame = 0,
	title = 0,
	creator = 0,
	verified = 0
})

local function revealed(p, duration: number)
	return Motion.createState(p, {
		default = Motion.transition({ duration = duration })
	})
end

local v = revealed({ keyart = 1 }, animation.artDur)
local v2 = revealed({ frame = 1 }, animation.artDur)
local v3 = revealed({ title = 1 }, animation.textDur)
local v4 = revealed({ creator = 1, verified = 1 }, animation.textDur)

local state2 = Motion.createState({
	keyart = 0,
	frame = 0,
	title = 0,
	creator = 0,
	verified = 0
}, {
	default = Motion.transition({ duration = animation.closeDur })
})

local state3 = Motion.createState({
	keyart = 1,
	frame = 1,
	title = 1,
	creator = 1,
	verified = 1
}, {
	default = Motion.transition({ duration = 0 })
})

local function clamp01(value: number) -- 5 equivalent calls inferred from this helper
	return (math.clamp(value, 0, 1))
end

local function scaleFromReveal(value: number)
	return (math.min(1, clamp01(value) * 0.5 + 0.5)) -- inferred equivalent call
end

local function slideFromReveal(value: number, p: number)
	return UDim.new(0, (1 - clamp01(value)) * p) -- inferred equivalent call
end

require(TiltLoadingScreen.Types)

local function useLoadingScreenAnimation(current)
	local v5, current3 = Motion.useMotion(state)
	local ref = React.useRef(current3)
	ref.current = current3
	local ref2

	if FFlagLoadingScreenMilestones then
		ref2 = React.useRef({})
	else
		ref2 = nil
	end

	local ref3

	if FFlagLoadingScreenMilestones then
		ref3 = React.useRef(current.onContentRevealComplete)
	else
		ref3 = nil
	end

	if FFlagLoadingScreenMilestones then
		React.useLayoutEffect(function()
			if ref3 then
				ref3.current = current.onContentRevealComplete
			end

			return function()
				if ref3 then
					ref3.current = nil
				end
			end
		end, { current.onContentRevealComplete })
	end

	local ref4 = React.useRef(current)
	ref4.current = current

	local ref5 = React.useRef(current.onEnterComplete)
	ref5.current = current.onEnterComplete

	local ref6 = React.useRef({})

	local ref7 = React.useRef({
		timeline = false,
		cascade = false,
		title = false,
		creator = false,
		enterComplete = false
	})
	local elapsed2, v6 = React.useBinding(0)
	local shouldReduceMotion, v7 = React.useBinding(current.reducedMotion)

	React.useEffect(function()
		v7(current.reducedMotion)
	end, { current.reducedMotion })

	local function cancelScheduled()
		for _, v8 in ref6.current do
			pcall(task.cancel, v8)
		end

		ref6.current = {}
	end

	local function schedule(duration: number, callback) -- 5 equivalent calls inferred from this helper
		local thread = task.delay(duration, callback)
		table.insert(ref6.current, thread)
	end

	local function canAnimate(): boolean -- 4 equivalent calls inferred from this helper
		local current2 = ref4.current
		return not (current2.reducedMotion or current2.isDismissing)
	end

	local function fireEnterComplete() -- 2 equivalent calls inferred from this helper
		if ref7.current.enterComplete then
			return
		end

		ref7.current.enterComplete = true

		if ref5.current then
			ref5.current()
		end
	end

	local function animateContentReveal(p, items)
		local v8 = ref2
		local v9 = {}

		for _, item in items do
			v8.current[item] = v9
		end

		ref.current(p, {
			onAnimationComplete = function(p2)
				if p2 ~= true or ref4.current.isDismissing then
					return
				end

				local current2

				if ref3 then
					current2 = ref3.current
				end

				if current2 then
					for _, item in items do
						if v8.current[item] == v9 then
							current2(item)
						end
					end
				end
			end
		})
	end

	local function startCreator()
		if not ref7.current.creator and canAnimate() then -- inferred equivalent call
			ref7.current.creator = true

			if FFlagLoadingScreenMilestones then
				animateContentReveal(v4, { ContentId.Creator })
			else
				ref.current(v4)
			end

			if FFlagTiltLoadingScreenEnterExitHold then
				schedule(animation.textDur, fireEnterComplete) -- inferred equivalent call
			end
		end
	end

	local function startTitle()
		if not ref7.current.title and ref4.current.contentReady and canAnimate() then -- inferred equivalent call
			ref7.current.title = true

			if FFlagLoadingScreenMilestones then
				animateContentReveal(v3, { ContentId.Title })
			else
				ref.current(v3)
			end

			schedule(animation.titleDelay, startCreator) -- inferred equivalent call
		end
	end

	local function startTimeline()
		if not ref7.current.timeline and canAnimate() then -- inferred equivalent call
			ref7.current.timeline = true

			if FFlagLoadingScreenMilestones then
				animateContentReveal(v, { ContentId.Thumbnail })
			else
				ref.current(v)
			end

			local function fn()
				if canAnimate() then -- inferred equivalent call
					ref.current(v2)
				end
			end

			schedule(animation.artDelay, fn) -- inferred equivalent call

			local function fn2()
				ref7.current.cascade = true
				startTitle()
			end

			schedule(animation.cascade, fn2) -- inferred equivalent call

			if FFlagTiltLoadingScreenEnterExitHold then
				local function fn3()
					if not ref7.current.title then
						fireEnterComplete() -- inferred equivalent call
					end
				end

				schedule(animation.artDur, fn3) -- inferred equivalent call
			end
		end
	end

	local function startExitTimeline() -- 1 equivalent call inferred from this helper
		ref.current(state2)
	end

	local function freeze()
		ref.current(Motion.createState({
			keyart = v5.keyart:getValue(),
			frame = v5.frame:getValue(),
			title = v5.title:getValue(),
			creator = v5.creator:getValue(),
			verified = v5.verified:getValue()
		}, {
			default = Motion.transition({ duration = 0 })
		}))
	end

	React.useEffect(function()
		if FFlagLoadingScreenMilestones and ref2 and (current.isDismissing or current.reducedMotion) then
			ref2.current = {}
		end

		if current.isDismissing then
			cancelScheduled()

			if current.reducedMotion then
				ref.current(state)
			else
				startExitTimeline() -- inferred equivalent call
			end
		elseif current.reducedMotion then
			cancelScheduled()
			ref7.current = {
				timeline = true,
				cascade = true,
				title = true,
				creator = true,
				enterComplete = false
			}

			if FFlagLoadingScreenMilestones then
				animateContentReveal(state3, { ContentId.Title, ContentId.Creator, ContentId.Thumbnail })
			else
				ref.current(state3)
			end

			if FFlagTiltLoadingScreenEnterExitHold then
				fireEnterComplete() -- inferred equivalent call
			end
		else
			startTimeline()

			if current.contentReady and ref7.current.cascade then
				startTitle()
			end
		end
	end, { current.contentReady, current.isDismissing, current.reducedMotion })

	React.useEffect(function()
		if current.reducedMotion or current.isDismissing then
			return
		end

		local lastTime = os.clock()
		local heartbeatConnection = RunService.Heartbeat:Connect(function()
			v6(os.clock() - lastTime)
		end)

		return function()
			heartbeatConnection:Disconnect()
		end
	end, { current.isDismissing, current.reducedMotion })

	React.useEffect(function()
		return function()
			if FFlagLoadingScreenMilestones and ref2 then
				ref2.current = {}
			end

			cancelScheduled()
			freeze()
		end
	end, {})

	local ref8 = React.useRef(nil)

	if ref8.current == nil then
		ref8.current = {
			keyart = {
				rotation = v5.keyart:map(function(value: number)
					return TILT_DEGREES * clamp01(value) -- inferred equivalent call
				end),
				sizeScale = v5.keyart:map(scaleFromReveal),
				coverTransparency = v5.keyart:map(clamp01)
			},
			frame = {
				rotation = React.joinBindings({
					reveal = v5.frame,
					elapsed = elapsed2,
					shouldReduceMotion = shouldReduceMotion
				}):map(function(data)
					local reveal = data.reveal
					local elapsed = data.elapsed
					local v8 = data.shouldReduceMotion and 0
						or math.sin(elapsed * animation.wobbleSpeed * 2 * 3.141592653589793 * 0.28 + 0.9) * animation.wobbleAngle * 1.4 * clamp01(reveal) -- inferred equivalent call

					return -TILT_DEGREES * reveal + v8
				end),
				sizeScale = v5.frame:map(scaleFromReveal),
				groupTransparency = v5.frame:map(function(value: number)
					return (math.min(1, (1 - clamp01(value)) * 2)) -- inferred equivalent call
				end)
			},
			title = {
				reveal = v5.title,
				slide = v5.title:map(function(p: number)
					return slideFromReveal(p, lockup.TITLE_SLIDE)
				end)
			},
			creator = {
				reveal = v5.creator,
				slide = v5.creator:map(function(p: number)
					return slideFromReveal(p, lockup.SUB_SLIDE)
				end)
			},
			verified = { reveal = v5.verified }
		}
	end

	return ref8.current
end

return useLoadingScreenAnimation

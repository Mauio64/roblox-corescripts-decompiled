local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Motion")
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")
local contentId = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants").ContentId

local RunService = game:GetService("RunService")

local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones
local fFlagTiltLoadingScreenEnterExitHold = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenEnterExitHold

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local animation = Constants.ANIMATION
local lockup = Constants.LOCKUP
local TILT_DEGREES = Constants.KEYART.TILT_DEGREES

local state = Motion.createState({
	keyart = 0,
	frame = 0,
	title = 0,
	creator = 0,
	verified = 0
})

local function revealed(p2, p3)
	return Motion.createState(p2, {
		default = Motion.transition({ duration = p3 })
	})
end

local v5 = revealed({ keyart = 1 }, animation.artDur)
local v6 = revealed({ frame = 1 }, animation.artDur)
local v7 = revealed({ title = 1 }, animation.textDur)
local v8 = revealed({ creator = 1, verified = 1 }, animation.textDur)

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

local function clamp01(value)
	return (math.clamp(value, 0, 1))
end

local function scaleFromReveal(value)
	return (math.min(1, 0.5 + 0.5 * math.clamp(value, 0, 1)))
end

local function slideFromReveal(value, p2)
	return UDim.new(0, (1 - math.clamp(value, 0, 1)) * p2)
end

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local function useLoadingScreenAnimation(current)
	local v9, v10 = Motion.useMotion(state)
	local ref = React.useRef(v10)
	ref.current = v10

	local ref2 = if fFlagLoadingScreenMilestones then React.useRef({}) else nil
	local ref3

	if fFlagLoadingScreenMilestones then
		ref3 = React.useRef(current.onContentRevealComplete)
	else
		ref3 = nil
	end

	if fFlagLoadingScreenMilestones then
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
	local v11, v12 = React.useBinding(0)
	local v13, v14 = React.useBinding(current.reducedMotion)

	React.useEffect(function()
		v14(current.reducedMotion)
	end, { current.reducedMotion })

	local function cancelScheduled()
		for k, v15 in ref6.current do
			pcall(task.cancel, v15)
		end

		ref6.current = {}
	end

	local function schedule(duration, callback)
		local thread = task.delay(duration, callback)
		table.insert(ref6.current, thread)
	end

	local function canAnimate(): boolean
		local current2 = ref4.current
		return not (current2.reducedMotion or current2.isDismissing)
	end

	local function fireEnterComplete()
		if ref7.current.enterComplete then
			return
		end

		ref7.current.enterComplete = true

		if ref5.current then
			ref5.current()
		end
	end

	local function animateContentReveal(p2, items)
		local v15 = ref2
		local v16 = {}

		for k, item in items do
			v15.current[item] = v16
		end

		ref.current(p2, {
			onAnimationComplete = function(p3)
				if p3 ~= true or ref4.current.isDismissing then
					return
				end

				local current2 = if ref3 then ref3.current else nil

				if current2 then
					for k, item in items do
						if v15.current[item] == v16 then
							current2(item)
						end
					end
				end
			end
		})
	end

	local function startCreator()
		if not ref7.current.creator then
			local current2 = ref4.current

			if not (current2.reducedMotion or current2.isDismissing) then
				ref7.current.creator = true

				if fFlagLoadingScreenMilestones then
					animateContentReveal(v8, { contentId.Creator })
				else
					ref.current(v8)
				end

				if fFlagTiltLoadingScreenEnterExitHold then
					local textDur = animation.textDur
					local thread = task.delay(textDur, fireEnterComplete)
					table.insert(ref6.current, thread)
				end
			end
		end
	end

	local function startTitle()
		if not ref7.current.title and ref4.current.contentReady then
			local current2 = ref4.current

			if not (current2.reducedMotion or current2.isDismissing) then
				ref7.current.title = true

				if fFlagLoadingScreenMilestones then
					animateContentReveal(v7, { contentId.Title })
				else
					ref.current(v7)
				end

				local titleDelay = animation.titleDelay
				local thread = task.delay(titleDelay, startCreator)
				table.insert(ref6.current, thread)
			end
		end
	end

	local function startTimeline()
		if not ref7.current.timeline then
			local current2 = ref4.current

			if not (current2.reducedMotion or current2.isDismissing) then
				ref7.current.timeline = true

				if fFlagLoadingScreenMilestones then
					animateContentReveal(v5, { contentId.Thumbnail })
				else
					ref.current(v5)
				end

				local artDelay = animation.artDelay
				local function fn()
					local current3 = ref4.current

					if not (current3.reducedMotion or current3.isDismissing) then
						ref.current(v6)
					end
				end

				local thread = task.delay(artDelay, fn)
				table.insert(ref6.current, thread)

				local cascade = animation.cascade
				local function fn2()
					ref7.current.cascade = true
					startTitle()
				end

				local thread2 = task.delay(cascade, fn2)
				table.insert(ref6.current, thread2)

				if fFlagTiltLoadingScreenEnterExitHold then
					local artDur = animation.artDur
					local function fn3()
						if not ref7.current.title then
							if ref7.current.enterComplete then
								return
							end

							ref7.current.enterComplete = true

							if ref5.current then
								ref5.current()
							end
						end
					end

					local thread3 = task.delay(artDur, fn3)
					table.insert(ref6.current, thread3)
				end
			end
		end
	end

	local function startExitTimeline()
		ref.current(state2)
	end

	local function freeze()
		ref.current(Motion.createState({
			keyart = v9.keyart:getValue(),
			frame = v9.frame:getValue(),
			title = v9.title:getValue(),
			creator = v9.creator:getValue(),
			verified = v9.verified:getValue()
		}, {
			default = Motion.transition({ duration = 0 })
		}))
	end

	React.useEffect(function()
		if fFlagLoadingScreenMilestones and ref2 and (current.isDismissing or current.reducedMotion) then
			ref2.current = {}
		end

		if current.isDismissing then
			cancelScheduled()

			if current.reducedMotion then
				ref.current(state)
			else
				ref.current(state2)
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

			if fFlagLoadingScreenMilestones then
				animateContentReveal(state3, { contentId.Title, contentId.Creator, contentId.Thumbnail })
			else
				ref.current(state3)
			end

			if fFlagTiltLoadingScreenEnterExitHold then
				if ref7.current.enterComplete then
					return
				end

				ref7.current.enterComplete = true

				if ref5.current then
					ref5.current()
				end
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
			v12(os.clock() - lastTime)
		end)

		return function()
			heartbeatConnection:Disconnect()
		end
	end, { current.isDismissing, current.reducedMotion })

	React.useEffect(function()
		return function()
			if fFlagLoadingScreenMilestones and ref2 then
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
				rotation = v9.keyart:map(function(value)
					return TILT_DEGREES * math.clamp(value, 0, 1)
				end),
				sizeScale = v9.keyart:map(scaleFromReveal),
				coverTransparency = v9.keyart:map(clamp01)
			},
			frame = {
				rotation = React.joinBindings({
					reveal = v9.frame,
					elapsed = v11,
					shouldReduceMotion = v13
				}):map(function(data)
					local reveal = data.reveal
					local elapsed = data.elapsed
					local v15 = data.shouldReduceMotion and 0
						or math.sin(elapsed * animation.wobbleSpeed * 2 * 3.141592653589793 * 0.28 + 0.9) * animation.wobbleAngle * 1.4 * math.clamp(reveal, 0, 1)

					return -TILT_DEGREES * reveal + v15
				end),
				sizeScale = v9.frame:map(scaleFromReveal),
				groupTransparency = v9.frame:map(function(value)
					return (math.min(1, (1 - math.clamp(value, 0, 1)) * 2))
				end)
			},
			title = {
				reveal = v9.title,
				slide = v9.title:map(function(p2)
					return slideFromReveal(p2, lockup.TITLE_SLIDE)
				end)
			},
			creator = {
				reveal = v9.creator,
				slide = v9.creator:map(function(p2)
					return slideFromReveal(p2, lockup.SUB_SLIDE)
				end)
			},
			verified = { reveal = v9.verified }
		}
	end

	return ref8.current
end

return useLoadingScreenAnimation

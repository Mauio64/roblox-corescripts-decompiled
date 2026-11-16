local AppChat = script:FindFirstAncestor("AppChat")

local parent = AppChat.Parent
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
require(AppChat.Telemetry.AppChatPerfEvent)

local Logger = require(AppChat.Logger)
local v = Logger:new("ScrollIntervalTracker")
local Cryo = require(parent.Cryo)
local ScrollIntervalTracker = require(parent.ScrollIntervalTracker)
local RunService = game:GetService("RunService")

local v2 = {
	minDistancePx = game:DefineFastInt("AppChatScrollPerfMinDistancePx", 50),
	stableFramesRequired = game:DefineFastInt("AppChatScrollPerfMinStableFrames", 5)
}

if game:DefineFastFlag("AppChatMigrateScrollIntervalTracker2", false) then
	local function createScrollIntervalTracker(debugName, p, p2, options)
		local function tryStart(p3)
			return AppChatPerfTracker.start(debugName, p3, p)
		end

		local function finish(p3)
			AppChatPerfTracker.finish(debugName, p3)
		end
		local joined = Cryo.Dictionary.join(v2, { debugName = debugName }, options or {})
		return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p, p2, joined)
	end

	return createScrollIntervalTracker
end

local function createScrollIntervalTracker(p, p2, p3, options)
	local joined = Cryo.Dictionary.join(v2, options or {})

	local flag = false

	local v3 = nil
	local total = 0

	local count = 0
	local v4 = nil

	local function resetStopDetection() -- 1 equivalent call inferred from this helper
		count = 0
		v4 = nil
	end

	local function resetStartDetection() -- 3 equivalent calls inferred from this helper
		v3 = nil
		total = 0
	end

	local function stopInterval(p4: string) -- 2 equivalent calls inferred from this helper
		v:debug("Scroll: {} stopping (reason={})", p, p4)
		AppChatPerfTracker.finish(p, p3)
		flag = false
		resetStopDetection() -- inferred equivalent call
		resetStartDetection() -- inferred equivalent call
	end

	local function recordCanvasPositionChanged(p4: number) -- 2 equivalent calls inferred from this helper
		count = 0
		v4 = p4
	end

	local function isPastMinScrollDistance(y: number): boolean -- 1 equivalent call inferred from this helper
		if v3 ~= nil then
			total += math.abs(y - v3)
		end

		v3 = y
		return total >= joined.minDistancePx
	end

	local function tryStartInterval(p4: number)
		v:debug("Scroll: {} starting", p)

		if not AppChatPerfTracker.start(p, p3, p2) then
			return
		end

		flag = true
		resetStartDetection() -- inferred equivalent call
		recordCanvasPositionChanged(p4) -- inferred equivalent call
	end

	local renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if not flag then
			return
		end

		local y = p2.CanvasPosition.Y

		if v4 == nil then
			v4 = y
			count = 0
		else
			if math.abs(y - v4) <= 0.5 then
				count += 1
			else
				count = 0
			end

			v4 = y

			if count >= joined.stableFramesRequired then
				stopInterval("stableFrames") -- inferred equivalent call
			end
		end
	end)

	return {
		onScrollTick = function()
			local y = p2.CanvasPosition.Y

			if not flag then
				if not isPastMinScrollDistance(y) then -- inferred equivalent call
					return
				end

				v:debug("Scroll: {} starting", p)

				if not AppChatPerfTracker.start(p, p3, p2) then
					return
				end

				flag = true
				resetStartDetection() -- inferred equivalent call
			end

			recordCanvasPositionChanged(y) -- inferred equivalent call
		end,
		cleanup = function()
			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end

			if flag then
				v:debug("Scroll: {} cleanup/unmount", p)
				stopInterval("cleanup") -- inferred equivalent call
			end
		end
	}
end

return createScrollIntervalTracker

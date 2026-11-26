local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEvent")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ScrollIntervalTracker")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ScrollIntervalTracker")
local RunService = game:GetService("RunService")

local v6 = {
	minDistancePx = game:DefineFastInt("AppChatScrollPerfMinDistancePx", 50),
	stableFramesRequired = game:DefineFastInt("AppChatScrollPerfMinStableFrames", 5)
}

if game:DefineFastFlag("AppChatMigrateScrollIntervalTracker2", false) then
	local function createScrollIntervalTracker(p2, p3, p4, options)
		local function tryStart(p5)
			return AppChatPerfTracker.start(p2, p5, p3)
		end

		local function finish(p5)
			AppChatPerfTracker.finish(p2, p5)
		end
		local joined = Cryo.Dictionary.join(v6, { debugName = p2 }, options or {})
		return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p3, p4, joined)
	end

	return createScrollIntervalTracker
end

local function createScrollIntervalTracker(p2, p3, p4, options)
	local joined = Cryo.Dictionary.join(v6, options or {})

	local flag = false

	local v7 = nil
	local total = 0

	local count = 0
	local v8 = nil

	local function resetStopDetection()
		count = 0
		v8 = nil
	end

	local function resetStartDetection()
		v7 = nil
		total = 0
	end

	local function stopInterval(p5)
		v5:debug("Scroll: {} stopping (reason={})", p2, p5)
		AppChatPerfTracker.finish(p2, p4)
		flag = false
		count = 0
		v8 = nil

		v7 = nil
		total = 0
	end

	local function recordCanvasPositionChanged(p5)
		count = 0
		v8 = p5
	end

	local function isPastMinScrollDistance(p5): boolean
		if v7 ~= nil then
			total += math.abs(p5 - v7)
		end

		v7 = p5
		return total >= joined.minDistancePx
	end

	local function tryStartInterval(p5)
		v5:debug("Scroll: {} starting", p2)

		if not AppChatPerfTracker.start(p2, p4, p3) then
			return
		end

		flag = true
		v7 = nil
		total = 0

		count = 0
		v8 = p5
	end

	local renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if not flag then
			return
		end

		local y = p3.CanvasPosition.Y

		if v8 == nil then
			v8 = y
			count = 0
		else
			count = if math.abs(y - v8) <= 0.5 then count + 1 else 0

			v8 = y

			if count >= joined.stableFramesRequired then
				v5:debug("Scroll: {} stopping (reason={})", p2, "stableFrames")
				AppChatPerfTracker.finish(p2, p4)
				flag = false
				count = 0
				v8 = nil

				v7 = nil
				total = 0
			end
		end
	end)

	return {
		onScrollTick = function()
			local y = p3.CanvasPosition.Y

			if not flag then
				if v7 ~= nil then
					total += math.abs(y - v7)
				end

				v7 = y

				if not (total >= joined.minDistancePx) then
					return
				end

				v5:debug("Scroll: {} starting", p2)

				if not AppChatPerfTracker.start(p2, p4, p3) then
					return
				end

				flag = true
				v7 = nil
				total = 0
			end

			count = 0
			v8 = y
		end,
		cleanup = function()
			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end

			if flag then
				v5:debug("Scroll: {} cleanup/unmount", p2)
				v5:debug("Scroll: {} stopping (reason={})", p2, "cleanup")
				AppChatPerfTracker.finish(p2, p4)
				flag = false
				count = 0
				v8 = nil

				v7 = nil
				total = 0
			end
		end
	}
end

return createScrollIntervalTracker

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ScrollIntervalTracker/ScrollIntervalTracker/Logger")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ScrollIntervalTracker/Cryo")

local RunService = game:GetService("RunService")

local v5 = { minDistancePx = 50, stableFramesRequired = 5 }

local function createScrollIntervalTracker(callback, callback2, p2, p3, options)
	local joined = Cryo.Dictionary.join(v5, options or {})

	local flag = false

	local v6 = nil
	local total = 0

	local count = 0
	local v7 = nil

	local function resetStopDetection()
		count = 0
		v7 = nil
	end

	local function resetStartDetection()
		v6 = nil
		total = 0
	end

	local function stopInterval(p4)
		Logger:debug("Scroll {} stopping (reason={})", joined.debugName, p4)
		callback2(p3)
		flag = false
		count = 0
		v7 = nil

		v6 = nil
		total = 0
	end

	local function recordCanvasPositionChanged(p4)
		count = 0
		v7 = p4
	end

	local function isPastMinScrollDistance(p4): boolean
		if v6 ~= nil then
			total += math.abs(p4 - v6)
		end

		v6 = p4
		return total >= joined.minDistancePx
	end

	local function tryStartInterval(p4)
		Logger:debug("Scroll {} starting", joined.debugName)

		if not callback(p3) then
			return
		end

		flag = true
		v6 = nil
		total = 0

		count = 0
		v7 = p4
	end

	local renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if not flag then
			return
		end

		local y = p2.CanvasPosition.Y

		if v7 == nil then
			v7 = y
			count = 0
		else
			count = if math.abs(y - v7) <= 0.5 then count + 1 else 0

			v7 = y

			if count >= joined.stableFramesRequired then
				Logger:debug("Scroll {} stopping (reason={})", joined.debugName, "stableFrames")
				callback2(p3)
				flag = false
				count = 0
				v7 = nil

				v6 = nil
				total = 0
			end
		end
	end)

	return {
		onScrollTick = function()
			local y = p2.CanvasPosition.Y

			if not flag then
				if v6 ~= nil then
					total += math.abs(y - v6)
				end

				v6 = y

				if not (total >= joined.minDistancePx) then
					return
				end

				Logger:debug("Scroll {} starting", joined.debugName)

				if not callback(p3) then
					return
				end

				flag = true
				v6 = nil
				total = 0
			end

			count = 0
			v7 = y
		end,
		cleanup = function()
			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end

			if flag then
				Logger:debug("Scroll {} cleanup/unmount", joined.debugName)
				Logger:debug("Scroll {} stopping (reason={})", joined.debugName, "cleanup")
				callback2(p3)
				flag = false
				count = 0
				v7 = nil

				v6 = nil
				total = 0
			end
		end
	}
end

return createScrollIntervalTracker

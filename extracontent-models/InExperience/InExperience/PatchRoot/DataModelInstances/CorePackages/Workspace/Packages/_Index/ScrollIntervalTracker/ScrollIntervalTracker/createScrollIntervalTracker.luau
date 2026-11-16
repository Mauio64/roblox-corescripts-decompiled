local ScrollIntervalTracker = script:FindFirstAncestor("ScrollIntervalTracker")
local parent = ScrollIntervalTracker.Parent

local Logger = require(ScrollIntervalTracker.Logger)
local Cryo = require(parent.Cryo)

local RunService = game:GetService("RunService")

local v = { minDistancePx = 50, stableFramesRequired = 5 }

local function createScrollIntervalTracker(callback, callback2, p, p2, options)
	local joined = Cryo.Dictionary.join(v, options or {})

	local flag = false

	local v2 = nil
	local total = 0

	local count = 0
	local v3 = nil

	local function resetStopDetection() -- 1 equivalent call inferred from this helper
		count = 0
		v3 = nil
	end

	local function resetStartDetection() -- 3 equivalent calls inferred from this helper
		v2 = nil
		total = 0
	end

	local function stopInterval(p3: string) -- 2 equivalent calls inferred from this helper
		Logger:debug("Scroll {} stopping (reason={})", joined.debugName, p3)
		callback2(p2)
		flag = false
		resetStopDetection() -- inferred equivalent call
		resetStartDetection() -- inferred equivalent call
	end

	local function recordCanvasPositionChanged(p3: number) -- 2 equivalent calls inferred from this helper
		count = 0
		v3 = p3
	end

	local function isPastMinScrollDistance(y: number): boolean -- 1 equivalent call inferred from this helper
		if v2 ~= nil then
			total += math.abs(y - v2)
		end

		v2 = y
		return total >= joined.minDistancePx
	end

	local function tryStartInterval(p3: number)
		Logger:debug("Scroll {} starting", joined.debugName)

		if not callback(p2) then
			return
		end

		flag = true
		resetStartDetection() -- inferred equivalent call
		recordCanvasPositionChanged(p3) -- inferred equivalent call
	end

	local renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if not flag then
			return
		end

		local y = p.CanvasPosition.Y

		if v3 == nil then
			v3 = y
			count = 0
		else
			if math.abs(y - v3) <= 0.5 then
				count += 1
			else
				count = 0
			end

			v3 = y

			if count >= joined.stableFramesRequired then
				stopInterval("stableFrames") -- inferred equivalent call
			end
		end
	end)

	return {
		onScrollTick = function()
			local y = p.CanvasPosition.Y

			if not flag then
				if not isPastMinScrollDistance(y) then -- inferred equivalent call
					return
				end

				Logger:debug("Scroll {} starting", joined.debugName)

				if not callback(p2) then
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
				Logger:debug("Scroll {} cleanup/unmount", joined.debugName)
				stopInterval("cleanup") -- inferred equivalent call
			end
		end
	}
end

return createScrollIntervalTracker

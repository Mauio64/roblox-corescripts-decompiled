local ScrollIntervalTracker = script:FindFirstAncestor("ScrollIntervalTracker")
local ScrollIntervalTrackerParent = ScrollIntervalTracker.Parent
local Logger = require(ScrollIntervalTracker.Logger)
local Cryo = require(ScrollIntervalTrackerParent.Cryo)
local RunService = game:GetService("RunService")
local t1 = {
	minDistancePx = 50,
	stableFramesRequired = 5
}

local function createScrollIntervalTracker(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3, p4, t2: {[any]: any}?) -- line: 49
	-- upvalues: Cryo (copy), t1 (copy), Logger (copy), RunService (copy)
	local v13 = Cryo.Dictionary.join(t1, t2 or {})
	local u14 = false
	local u15 = nil
	local n1 = 0
	local n2 = 0
	local u18 = nil

	local function resetStopDetection() -- line: 68
		-- upvalues: n2 (ref), u18 (ref)
		n2 = 0
		u18 = nil
	end
	local function resetStartDetection() -- line: 73
		-- upvalues: u15 (ref), n1 (ref)
		u15 = nil
		n1 = 0
	end
	local function stopInterval(s1: string) -- line: 78
		-- upvalues: Logger (copy), v13 (copy), p2 (copy), p4 (copy), u14 (ref), n2 (ref), u18 (ref), u15 (ref), n1 (ref)
		Logger:debug("Scroll {} stopping (reason={})", v13.debugName, s1)
		p2(p4)
		u14 = false
		n2 = 0
		u18 = nil
		u15 = nil
		n1 = 0
	end
	local function recordCanvasPositionChanged(n3: number) -- line: 86
		-- upvalues: n2 (ref), u18 (ref)
		n2 = 0
		u18 = n3
	end
	local function isPastMinScrollDistance(n4: number) -- line: 92
		-- upvalues: u15 (ref), n1 (ref), v13 (copy)
		if u15 ~= nil then
			n1 += math.abs(n4 - u15)
		end

		u15 = n4

		return n1 >= v13.minDistancePx
	end
	local function tryStartInterval(n5: number) -- line: 100
		-- upvalues: Logger (copy), v13 (copy), p1 (copy), p4 (copy), u14 (ref), u15 (ref), n1 (ref), n2 (ref), u18 (ref)
		Logger:debug("Scroll {} starting", v13.debugName)

		if not p1(p4) then
			return
		end

		u14 = true
		u15 = nil
		n1 = 0
		n2 = 0
		u18 = n5
	end

	local connection = RunService.RenderStepped:Connect(function() -- line: 116
		-- upvalues: u14 (ref), p3 (copy), u18 (ref), n2 (ref), v13 (copy), Logger (copy), p2 (copy), p4 (copy), u15 (ref), n1 (ref)
		if not u14 then
			return
		end

		local CanvasPositionY = p3.CanvasPosition.Y

		if u18 == nil then
			u18 = CanvasPositionY
			n2 = 0

			return
		end

		if math.abs(CanvasPositionY - u18) <= 0.5 then
			n2 += 1
		else
			n2 = 0
		end

		u18 = CanvasPositionY

		if n2 >= v13.stableFramesRequired then
			Logger:debug("Scroll {} stopping (reason={})", v13.debugName, "stableFrames")
			p2(p4)
			u14 = false
			n2 = 0
			u18 = nil
			u15 = nil
			n1 = 0
		end
	end)

	return {
		onScrollTick = function() -- line: 141
			-- upvalues: p3 (copy), u14 (ref), u15 (ref), n1 (ref), v13 (copy), Logger (copy), p1 (copy), p4 (copy), n2 (ref), u18 (ref)
			local CanvasPositionY = p3.CanvasPosition.Y

			if not u14 then
				if u15 ~= nil then
					n1 += math.abs(CanvasPositionY - u15)
				end

				u15 = CanvasPositionY

				if not (n1 >= v13.minDistancePx) then
					return
				end

				Logger:debug("Scroll {} starting", v13.debugName)

				if not p1(p4) then
					return
				end

				u14 = true
				u15 = nil
				n1 = 0
				n2 = 0
				u18 = CanvasPositionY

				return
			end

			n2 = 0
			u18 = CanvasPositionY
		end,
		cleanup = function() -- line: 156
			-- upvalues: connection (copy), u14 (ref), Logger (copy), v13 (copy), p2 (copy), p4 (copy), n2 (ref), u18 (ref), u15 (ref), n1 (ref)
			if connection then
				connection:Disconnect()
			end

			if u14 then
				Logger:debug("Scroll {} cleanup/unmount", v13.debugName)
				Logger:debug("Scroll {} stopping (reason={})", v13.debugName, "cleanup")
				p2(p4)
				u14 = false
				n2 = 0
				u18 = nil
				u15 = nil
				n1 = 0
			end
		end
	}
end

return createScrollIntervalTracker

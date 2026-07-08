local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

require(AppChat.Telemetry.AppChatPerfEvent)

local v4 = require(AppChat.Logger):new("ScrollIntervalTracker")
local Cryo = require(AppChatParent.Cryo)
local ScrollIntervalTracker = require(AppChatParent.ScrollIntervalTracker)
local RunService = game:GetService("RunService")
local v8 = game:DefineFastInt("AppChatScrollPerfMinDistancePx", 50)
local v9 = game:DefineFastInt("AppChatScrollPerfMinStableFrames", 5)
local v10 = game:DefineFastFlag("AppChatMigrateScrollIntervalTracker2", false)
local t1 = {
	minDistancePx = v8,
	stableFramesRequired = v9
}

if v10 then
	local function createScrollIntervalTracker(p1, p2, p3, t2: {[any]: any}?) -- line: 51
		-- upvalues: AppChatPerfTracker (copy), Cryo (copy), t1 (copy), ScrollIntervalTracker (copy)
		local function tryStart(p4) -- line: 57
			-- upvalues: AppChatPerfTracker (copy), p1 (copy)
			return AppChatPerfTracker.start(p1, p4)
		end
		local function finish(p5) -- line: 60
			-- upvalues: AppChatPerfTracker (copy), p1 (copy)
			AppChatPerfTracker.finish(p1, p5)
		end

		local v20 = Cryo.Dictionary.join(t1, {
			debugName = p1
		}, t2 or {})

		return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p2, p3, v20)
	end

	return createScrollIntervalTracker
end

local function createScrollIntervalTracker(p6, p7, p8, t3: {[any]: any}?) -- line: 72
	-- upvalues: Cryo (copy), t1 (copy), v4 (copy), AppChatPerfTracker (copy), RunService (copy)
	local v25 = Cryo.Dictionary.join(t1, t3 or {})
	local u26 = false
	local u27 = nil
	local n1 = 0
	local n2 = 0
	local u30 = nil

	local function resetStopDetection() -- line: 90
		-- upvalues: n2 (ref), u30 (ref)
		n2 = 0
		u30 = nil
	end
	local function resetStartDetection() -- line: 95
		-- upvalues: u27 (ref), n1 (ref)
		u27 = nil
		n1 = 0
	end
	local function stopInterval(s1: string) -- line: 100
		-- upvalues: v4 (copy), p6 (copy), AppChatPerfTracker (copy), p8 (copy), u26 (ref), n2 (ref), u30 (ref), u27 (ref), n1 (ref)
		v4:debug("Scroll: {} stopping (reason={})", p6, s1)
		AppChatPerfTracker.finish(p6, p8)
		u26 = false
		n2 = 0
		u30 = nil
		u27 = nil
		n1 = 0
	end
	local function recordCanvasPositionChanged(n3: number) -- line: 108
		-- upvalues: n2 (ref), u30 (ref)
		n2 = 0
		u30 = n3
	end
	local function isPastMinScrollDistance(n4: number) -- line: 114
		-- upvalues: u27 (ref), n1 (ref), v25 (copy)
		if u27 ~= nil then
			n1 += math.abs(n4 - u27)
		end

		u27 = n4

		return n1 >= v25.minDistancePx
	end
	local function tryStartInterval(n5: number) -- line: 122
		-- upvalues: v4 (copy), p6 (copy), AppChatPerfTracker (copy), p8 (copy), u26 (ref), u27 (ref), n1 (ref), n2 (ref), u30 (ref)
		v4:debug("Scroll: {} starting", p6)

		if not AppChatPerfTracker.start(p6, p8) then
			return
		end

		u26 = true
		u27 = nil
		n1 = 0
		n2 = 0
		u30 = n5
	end

	local connection = RunService.RenderStepped:Connect(function() -- line: 138
		-- upvalues: u26 (ref), p7 (copy), u30 (ref), n2 (ref), v25 (copy), v4 (copy), p6 (copy), AppChatPerfTracker (copy), p8 (copy), u27 (ref), n1 (ref)
		if not u26 then
			return
		end

		local CanvasPositionY = p7.CanvasPosition.Y

		if u30 == nil then
			u30 = CanvasPositionY
			n2 = 0

			return
		end

		if math.abs(CanvasPositionY - u30) <= 0.5 then
			n2 += 1
		else
			n2 = 0
		end

		u30 = CanvasPositionY

		if n2 >= v25.stableFramesRequired then
			v4:debug("Scroll: {} stopping (reason={})", p6, "stableFrames")
			AppChatPerfTracker.finish(p6, p8)
			u26 = false
			n2 = 0
			u30 = nil
			u27 = nil
			n1 = 0
		end
	end)

	return {
		onScrollTick = function() -- line: 163
			-- upvalues: p7 (copy), u26 (ref), u27 (ref), n1 (ref), v25 (copy), v4 (copy), p6 (copy), AppChatPerfTracker (copy), p8 (copy), n2 (ref), u30 (ref)
			local CanvasPositionY = p7.CanvasPosition.Y

			if not u26 then
				if u27 ~= nil then
					n1 += math.abs(CanvasPositionY - u27)
				end

				u27 = CanvasPositionY

				if not (n1 >= v25.minDistancePx) then
					return
				end

				v4:debug("Scroll: {} starting", p6)

				if not AppChatPerfTracker.start(p6, p8) then
					return
				end

				u26 = true
				u27 = nil
				n1 = 0
				n2 = 0
				u30 = CanvasPositionY

				return
			end

			n2 = 0
			u30 = CanvasPositionY
		end,
		cleanup = function() -- line: 178
			-- upvalues: connection (copy), u26 (ref), v4 (copy), p6 (copy), AppChatPerfTracker (copy), p8 (copy), n2 (ref), u30 (ref), u27 (ref), n1 (ref)
			if connection then
				connection:Disconnect()
			end

			if u26 then
				v4:debug("Scroll: {} cleanup/unmount", p6)
				v4:debug("Scroll: {} stopping (reason={})", p6, "cleanup")
				AppChatPerfTracker.finish(p6, p8)
				u26 = false
				n2 = 0
				u30 = nil
				u27 = nil
				n1 = 0
			end
		end
	}
end

return createScrollIntervalTracker

local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 6
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.lastInputTimeSec = -1
	self.subscriptions = {}
	self.lastProgress = -1

	return self
end
function t1.getCurrentProgress(p1) -- line: 15
	local v5 = os.clock() - p1.lastInputTimeSec

	if v5 < p1.dwellTimeSec then
		return 1
	end

	if v5 < p1.dwellTimeSec + p1.fadeDurationSec then
		return 1 - (v5 - p1.dwellTimeSec) / p1.fadeDurationSec
	end

	return 0
end
function t1.inProgress(p2) -- line: 26
	return p2:getCurrentProgress() > 0
end
function t1.isFading(p3) -- line: 30
	local v8 = os.clock() - p3.lastInputTimeSec

	return v8 >= p3.dwellTimeSec and v8 < p3.dwellTimeSec + p3.fadeDurationSec
end
function t1.updateLastInputTime(p4) -- line: 35
	p4.lastInputTimeSec = os.clock()
end
function t1.skipToFade(p5) -- line: 39
	if not p5:isFading() then
		p5.lastInputTimeSec = os.clock() - p5.dwellTimeSec
	end
end
function t1.zeroOut(p6) -- line: 45
	p6.lastInputTimeSec = -1
end
function t1.subscribe(p7, p8) -- line: 49
	-- upvalues: RunService (copy)
	table.insert(p7.subscriptions, p8)

	if not p7.heartbeatConnection then
		p7.heartbeatConnection = RunService.RenderStepped:Connect(function() -- line: 53
			-- upvalues: p7 (copy)
			local v18 = p7:getCurrentProgress()

			if v18 ~= p7.lastProgress then
				p7.lastProgress = v18

				for _, v in ipairs(p7.subscriptions) do
					v(v18)
				end
			end
		end)
	end
end
function t1.unsubscribe(p9, p10) -- line: 65
	for i, v in ipairs(p9.subscriptions) do
		if v == p10 then
			table.remove(p9.subscriptions, i)

			break
		end
	end

	if #p9.subscriptions == 0 and p9.heartbeatConnection then
		p9.heartbeatConnection:Disconnect()
		p9.heartbeatConnection = nil
	end
end

t1.fadeDurationSec = 1
t1.dwellTimeSec = 1

return t1

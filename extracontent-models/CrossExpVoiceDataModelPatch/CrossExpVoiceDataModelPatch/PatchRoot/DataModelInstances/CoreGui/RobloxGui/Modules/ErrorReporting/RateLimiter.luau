local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local t = require(CorePackages.Packages.t)
local v4 = t.strictInterface({
	period = t.number,
	threshold = t.number,
	processInterval = t.number
})
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 16
	-- upvalues: v4 (copy), t1 (copy)
	assert(v4(p1))

	return (setmetatable({
		_lastProcessed = 0,
		_period = p1.period,
		_threshold = p1.threshold,
		_processInterval = p1.processInterval,
		_counts = {},
		_lastOccurrences = {}
	}, t1))
end
function t1.increment(p2, p3, p4) -- line: 29
	local v10 = p4 or os.clock()

	p2._lastOccurrences[p3] = v10

	if p2._counts[p3] == nil then
		p2._counts[p3] = 1

		return
	end

	local _counts = p2._counts

	_counts[p3] = _counts[p3] + 1
end
function t1.isRateLimited(p5, p6) -- line: 40
	local v14 = p5._counts[p6]

	return v14 ~= nil and v14 > p5._threshold
end
function t1.startDecrementClock(p7) -- line: 45
	-- upvalues: RunService (copy)
	p7._decrementConnection = RunService.Heartbeat:Connect(function() -- line: 46
		-- upvalues: p7 (copy)
		p7:stepDecrementClock(os.clock())
	end)
end
function t1.stepDecrementClock(p8, p9) -- line: 51
	if p9 - p8._lastProcessed > p8._processInterval then
		for k, v in pairs(p8._lastOccurrences) do
			if p9 - v > p8._period then
				local _counts = p8._counts

				_counts[k] = _counts[k] - 1

				if p8._counts[k] <= 0 then
					p8._counts[k] = nil
					p8._lastOccurrences[k] = nil
				end
			end
		end

		p8._lastProcessed = p9
	end
end

return t1

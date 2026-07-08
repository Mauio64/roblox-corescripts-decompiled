local ParentParent = script.Parent.Parent
local RunService = game:GetService("RunService")
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local t1 = {}

t1.__index = t1

local v6 = t.tuple(t.callback, t.optional(t.strictInterface({
	queueTimeLimit = t.optional(t.numberPositive),
	queueErrorLimit = t.optional(t.numberPositive),
	queueKeyLimit = t.optional(t.numberPositive)
})))

function t1.new(p1: ((...any) -> ...any), t2: {[any]: any}?) -- line: 54
	-- upvalues: v6 (copy), t1 (copy)
	assert(v6(p1, t2))

	local v9 = t2 or {}
	local t3 = {
		_totalErrorCount = 0,
		_totalKeyCount = 0,
		_runningTime = 0,
		_renderSteppedConnection = nil,
		_reportMethod = p1,
		_queueTimeLimit = v9.queueTimeLimit or 30,
		_queueErrorLimit = v9.queueErrorLimit or 30,
		_queueKeyLimit = v9.queueKeyLimit or 10,
		_errors = {}
	}

	setmetatable(t3, t1)

	return t3
end
function t1.hasError(t4: {[any]: any}, s1: string) -- line: 80
	if type(s1) ~= "string" or s1 == "" then
		return false
	end

	return t4._errors[s1] ~= nil
end
function t1.addError(t5: {[any]: any}, s2: string, p2) -- line: 88
	if type(s2) ~= "string" or s2 == "" then
		return
	end

	if not t5._errors[s2] then
		t5._errors[s2] = {
			count = 1,
			data = p2
		}
		t5._totalKeyCount = t5._totalKeyCount + 1
	else
		t5._errors[s2].count = t5._errors[s2].count + 1
	end

	t5._totalErrorCount = t5._totalErrorCount + 1

	if t5:isReadyToReport() then
		t5:reportAllErrors()
	end
end
function t1.isReadyToReport(p3) -- line: 112
	return p3._totalKeyCount >= p3._queueKeyLimit or (p3._totalErrorCount >= p3._queueErrorLimit or p3._totalErrorCount > 0 and p3._runningTime >= p3._queueTimeLimit)
end
function t1.reportAllErrors(p4) -- line: 118
	-- upvalues: Cryo (copy)
	local v18 = Cryo.Dictionary.join(p4._errors, {})

	p4._errors = {}
	p4._totalErrorCount = 0
	p4._totalKeyCount = 0
	p4._runningTime = 0

	for k, v in pairs(v18) do
		p4._reportMethod(k, v.data, v.count)
	end
end
function t1._onRenderStep(t6: {[any]: any}, n1: number) -- line: 133
	t6._runningTime = t6._runningTime + n1

	if t6:isReadyToReport() then
		t6:reportAllErrors()
	end
end
function t1.startTimer(p5) -- line: 141
	-- upvalues: RunService (copy)
	if p5._renderSteppedConnection == nil then
		p5._runningTime = 0
		p5._renderSteppedConnection = RunService.renderStepped:Connect(function(p6) -- line: 145
			-- upvalues: p5 (copy)
			p5:_onRenderStep(p6)
		end)
	end
end
function t1.stopTimer(p7) -- line: 151
	if p7._renderSteppedConnection ~= nil then
		p7._renderSteppedConnection:Disconnect()
		p7._runningTime = 0
		p7._renderSteppedConnection = nil
	end
end

return t1

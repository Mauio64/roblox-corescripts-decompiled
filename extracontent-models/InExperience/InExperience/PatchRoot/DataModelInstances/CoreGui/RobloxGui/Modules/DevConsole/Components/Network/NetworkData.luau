local LogService = game:GetService("LogService")
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).NetworkFormatting.ChartHeaderNames
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxHttpCount"))
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 12
		return p1.Num < p2.Num
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 15
		return p3.Method < p4.Method
	end,
	[ChartHeaderNames[3]] = function(p5, p6) -- line: 18
		return p5.Status < p6.Status
	end,
	[ChartHeaderNames[4]] = function(p7, p8) -- line: 21
		return p7.Time < p8.Time
	end,
	[ChartHeaderNames[5]] = function(p9, p10) -- line: 24
		return p9.RequestType < p10.RequestType
	end,
	[ChartHeaderNames[6]] = function(p11, p12) -- line: 27
		return p11.Url < p12.Url
	end
}

local function newHttpEntry(p13, p14, p15, p16, p17, p18, p19) -- line: 32
	return {
		Num = p13,
		Method = p14,
		Status = p15,
		Time = p16,
		RequestType = p17,
		Url = p18,
		Response = p19
	}
end

local t2 = {}

t2.__index = t2

function t2.new(p20) -- line: 47
	-- upvalues: t2 (copy), LogService (copy), Signal (copy), CircularBuffer (copy), num (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._isRunning = false
	t3._isClient = p20
	t3._httpResultSignal = p20 and LogService.HttpResultOut or LogService.ServerHttpResultOut
	t3._httpEntryAdded = Signal.new()
	t3._httpSummaryTable = {}
	t3._httpSummaryCount = 0
	t3._httpEntryBuffer = CircularBuffer.new(num)
	t3._httpLifeTimeEntryCount = 0
	t3._sortType = ChartHeaderNames[1]

	return t3
end
function t2.addHttpEntry(p21, p22) -- line: 65
	p21._httpLifeTimeEntryCount = p21._httpLifeTimeEntryCount + 1

	local _httpLifeTimeEntryCount = p21._httpLifeTimeEntryCount
	local Method = p22.Method
	local Status = p22.Status
	local Time = p22.Time
	local RequestType = p22.RequestType
	local URL = p22.URL
	local Response = p22.Response
	local t4 = {
		Num = _httpLifeTimeEntryCount,
		Method = Method,
		Status = Status,
		Time = Time,
		RequestType = RequestType,
		Url = URL,
		Response = Response
	}

	p21._httpEntryBuffer:push_back(t4)

	local RequestType2 = p22.RequestType
	local v41 = p21._httpSummaryTable[RequestType2]

	if not v41 then
		p21._httpSummaryCount = p21._httpSummaryCount + 1
		p21._httpSummaryTable[RequestType2] = {
			RequestCount = 1,
			FailedCount = 0,
			RequestType = RequestType2,
			AverageTime = p22.Time,
			MinTime = p22.Time,
			MaxTime = p22.Time
		}

		if p22.Status >= 400 then
			p21._httpSummaryTable[p22.RequestType].FailedCount = 1

			return
		end
	else
		v41.RequestCount = v41.RequestCount + 1

		if p22.Status >= 400 then
			v41.FailedCount = v41.FailedCount + 1
		end

		v41.AverageTime = (v41.AverageTime * v41.RequestCount + p22.Time - v41.AverageTime) / v41.RequestCount

		if p22.Time < v41.MinTime then
			v41.MinTime = p22.Time
		end

		if p22.Time > v41.MaxTime then
			v41.MaxTime = p22.Time
		end
	end
end
function t2.setSortType(p23, p24) -- line: 117
	-- upvalues: t1 (copy)
	if t1[p24] then
		p23._sortType = p24
		p23._httpEntryAdded:Fire(p23._httpSummaryTable, p23._httpSummaryCount, p23:getSortedEntries())

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p24))), 2)
end
function t2.getSortType(p25) -- line: 130
	return p25._sortType
end
function t2.resetHttpEntryList(p26) -- line: 134
	-- upvalues: LogService (copy)
	p26._httpSummaryTable = {}
	p26._httpEntryBuffer:reset()
	p26._httpLifeTimeEntryCount = 0

	if p26._isClient then
		local HttpResultHistory = LogService:GetHttpResultHistory()

		if HttpResultHistory then
			for _, v in pairs(HttpResultHistory) do
				p26:addHttpEntry(v)
			end
		end
	end
end
function t2.Signal(p27) -- line: 149
	return p27._httpEntryAdded
end
function t2.getSortedEntries(p28) -- line: 153
	-- upvalues: t1 (copy)
	local v51 = p28._httpEntryBuffer:iterator()
	local v52 = v51:next()
	local t5 = {}
	local n1 = 1

	while v52 do
		t5[n1] = v52
		n1 += 1
		v52 = v51:next()
	end

	table.sort(t5, t1[p28._sortType])

	return t5
end
function t2.getCurrentData(p29) -- line: 170
	return {
		summaryTable = p29._httpSummaryTable,
		summaryCount = p29._httpSummaryCount,
		entryList = p29:getSortedEntries()
	}
end
function t2.isRunning(p30) -- line: 178
	return p30._isRunning
end
function t2.start(p31) -- line: 182
	-- upvalues: LogService (copy)
	if not p31._httpResultConnection then
		if p31._additionHttpSetup then
			p31._additionHttpSetup()
		end

		p31._httpResultConnection = p31._httpResultSignal:connect(function(p32) -- line: 188
			-- upvalues: p31 (copy)
			p31:addHttpEntry(p32)
			p31._httpEntryAdded:Fire(p31._httpSummaryTable, p31._httpSummaryCount, p31:getSortedEntries())
		end)
		p31:resetHttpEntryList()

		if not p31._isClient then
			p31._onHttpResultApprovedConnection = LogService.OnHttpResultApproved:connect(function(p33) -- line: 200
				-- upvalues: LogService (copy), p31 (copy)
				LogService:RequestHttpResultApproved()

				if p33 then
					p31._onHttpResultApprovedConnection:Disconnect()
					p31._onHttpResultApprovedConnection = nil
				end
			end)
			LogService:RequestServerHttpResult()
		end

		p31._isRunning = true
	end
end
function t2.stop(p34) -- line: 213
	if p34._httpResultConnection then
		p34._httpResultConnection:Disconnect()
		p34._httpResultConnection = nil
	end

	p34._isRunning = false
end

return t2

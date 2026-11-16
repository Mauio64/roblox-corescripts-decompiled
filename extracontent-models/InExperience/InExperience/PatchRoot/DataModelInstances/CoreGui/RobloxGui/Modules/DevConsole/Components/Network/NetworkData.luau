local LogService = game:GetService("LogService")
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local Constants = require(script.Parent.Parent.Parent.Constants)
local ChartHeaderNames = Constants.NetworkFormatting.ChartHeaderNames

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxHttpCount"))

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.Num < p2.Num
	end,
	[ChartHeaderNames[2]] = function(p, p2): boolean
		return p.Method < p2.Method
	end,
	[ChartHeaderNames[3]] = function(p, p2): boolean
		return p.Status < p2.Status
	end,
	[ChartHeaderNames[4]] = function(p, p2): boolean
		return p.Time < p2.Time
	end,
	[ChartHeaderNames[5]] = function(p, p2): boolean
		return p.RequestType < p2.RequestType
	end,
	[ChartHeaderNames[6]] = function(p, p2): boolean
		return p.Url < p2.Url
	end
}

local function newHttpEntry(httpLifeTimeEntryCount, method, status, time, requestType, url, response) -- 1 equivalent call inferred from this helper
	return {
		Num = httpLifeTimeEntryCount,
		Method = method,
		Status = status,
		Time = time,
		RequestType = requestType,
		Url = url,
		Response = response
	}
end

local NetworkData = {}
NetworkData.__index = NetworkData

function NetworkData.new(isClient)
	local v2 = {}
	setmetatable(v2, NetworkData)

	v2._isRunning = false
	v2._isClient = isClient
	v2._httpResultSignal = isClient and LogService.HttpResultOut or LogService.ServerHttpResultOut

	v2._httpEntryAdded = Signal.new()
	v2._httpSummaryTable = {}
	v2._httpSummaryCount = 0
	v2._httpEntryBuffer = CircularBuffer.new(fVariable)

	v2._httpLifeTimeEntryCount = 0
	v2._sortType = ChartHeaderNames[1]
	return v2
end

function NetworkData:addHttpEntry(data)
	self._httpLifeTimeEntryCount += 1

	local httpEntry = newHttpEntry( -- inferred equivalent call
		self._httpLifeTimeEntryCount,
		data.Method,
		data.Status,
		data.Time,
		data.RequestType,
		data.URL,
		data.Response
	)

	self._httpEntryBuffer:push_back(httpEntry)

	local requestType = data.RequestType
	local v2 = self._httpSummaryTable[requestType]

	if v2 then
		v2.RequestCount += 1

		if data.Status >= 400 then
			v2.FailedCount += 1
		end

		v2.AverageTime = (v2.AverageTime * v2.RequestCount + data.Time - v2.AverageTime) / v2.RequestCount

		if data.Time < v2.MinTime then
			v2.MinTime = data.Time
		end

		if data.Time > v2.MaxTime then
			v2.MaxTime = data.Time
		end
	else
		self._httpSummaryCount += 1

		self._httpSummaryTable[requestType] = {
			RequestType = requestType,
			RequestCount = 1,
			FailedCount = 0,
			AverageTime = data.Time,
			MinTime = data.Time,
			MaxTime = data.Time
		}

		if data.Status >= 400 then
			self._httpSummaryTable[data.RequestType].FailedCount = 1
		end
	end
end

function NetworkData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType
	self._httpEntryAdded:Fire(self._httpSummaryTable, self._httpSummaryCount, self:getSortedEntries())
end

function NetworkData:getSortType()
	return self._sortType
end

function NetworkData:resetHttpEntryList()
	self._httpSummaryTable = {}
	self._httpEntryBuffer:reset()
	self._httpLifeTimeEntryCount = 0
	local httpResultHistory = self._isClient and LogService:GetHttpResultHistory()

	if httpResultHistory then
		for _, v2 in pairs(httpResultHistory) do
			self:addHttpEntry(v2)
		end
	end
end

function NetworkData:Signal()
	return self._httpEntryAdded
end

function NetworkData:getSortedEntries()
	local iterator = self._httpEntryBuffer:iterator()
	local v2 = iterator:next()
	local sortedEntries = {}
	local v3 = 1

	while v2 do
		sortedEntries[v3] = v2
		v3 += 1
		v2 = iterator:next()
	end

	table.sort(sortedEntries, v[self._sortType])

	return sortedEntries
end

function NetworkData:getCurrentData()
	return {
		summaryTable = self._httpSummaryTable,
		summaryCount = self._httpSummaryCount,
		entryList = self:getSortedEntries()
	}
end

function NetworkData:isRunning()
	return self._isRunning
end

function NetworkData:start()
	if not self._httpResultConnection then
		if self._additionHttpSetup then
			self._additionHttpSetup()
		end

		self._httpResultConnection = self._httpResultSignal:connect(function(p)
			self:addHttpEntry(p)
			self._httpEntryAdded:Fire(self._httpSummaryTable, self._httpSummaryCount, self:getSortedEntries())
		end)

		self:resetHttpEntryList()

		if not self._isClient then
			self._onHttpResultApprovedConnection = LogService.OnHttpResultApproved:connect(function(p)
				LogService:RequestHttpResultApproved()

				if p then
					self._onHttpResultApprovedConnection:Disconnect()
					self._onHttpResultApprovedConnection = nil
				end
			end)
			LogService:RequestServerHttpResult()
		end

		self._isRunning = true
	end
end

function NetworkData:stop()
	if self._httpResultConnection then
		self._httpResultConnection:Disconnect()
		self._httpResultConnection = nil
	end

	self._isRunning = false
end

return NetworkData

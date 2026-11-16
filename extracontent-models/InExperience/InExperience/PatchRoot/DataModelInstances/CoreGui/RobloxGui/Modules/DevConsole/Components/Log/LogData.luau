local LogService = game:GetService("LogService")
local TextService = game:GetService("TextService")

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Log = Constants.Font.Log
local MaxStringSize = Constants.LogFormatting.MaxStringSize

local EnumToMsgTypeName = Constants.EnumToMsgTypeName

local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxLogCount"))
local v = { "ClassDescriptor failed to learn", "EventDescriptor failed to learn", "Type failed to learn" }

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

local LogData = {}
LogData.__index = LogData

local function messageEntry(value: string, p: string, p2: number, context)
	local count = #value
	local message

	if count < MaxStringSize then
		message = string.format("%s -- %s", p, value)
	else
		message = string.format("%s -- %s", p, (string.sub(value, 1, MaxStringSize)))
	end

	local textSize = TextService:GetTextSize(message, MainWindow, Log, Vector2.new())

	if context and next(context) == nil then
		context = nil
	end

	return {
		Message = message,
		CharCount = count,
		Type = p2,
		Dims = textSize,
		Context = context,
		Expanded = false
	}
end

local function ignoreWarningMessageOnAdd(p): boolean
	if p.Type ~= Enum.MessageType.MessageWarning.Value then
		return false
	end

	for _, v2 in ipairs(v) do
		if string.find(p.Message, v2) ~= nil then
			return true
		end
	end

	return false
end

local function isMessageFiltered(p, items, value): boolean
	if #value == 0 and not next(items) or next(items) and not items[EnumToMsgTypeName[p.Type]] then
		return false
	end

	return not (#value > 0) or string.find(p.Message:lower(), value:lower()) ~= nil
end

local function validActiveFilters(items) -- 3 equivalent calls inferred from this helper
	local v2 = false

	for _, item in pairs(items) do
		v2 = v2 or item
	end

	return v2
end

local function filterMessages(logDataSearched, object, filters, searchTerm)
	logDataSearched:reset()
	local v2 = validActiveFilters(filters) -- inferred equivalent call

	if #searchTerm == 0 and not v2 then
		return
	end

	local v3 = object:next()
	local count = 0

	while v3 do
		if isMessageFiltered(v3, filters, searchTerm) then
			count += 1
			logDataSearched:push_back(v3)
		end

		v3 = object:next()
	end

	if count == 0 then
		if #searchTerm > 0 then
			logDataSearched:push_back(messageEntry(string.format("\"%s\" was not found", searchTerm), "", 0))
		else
			logDataSearched:push_back(messageEntry("No Messages were found", "", 0))
		end
	end
end

function LogData:checkErrorWarningCounter(p)
	if p == Enum.MessageType.MessageWarning.Value then
		self._warningCount += 1
		self._errorWarningSignal:Fire(self._errorCount, self._warningCount)
	elseif p == Enum.MessageType.MessageError.Value then
		self._errorCount += 1
		self._errorWarningSignal:Fire(self._errorCount, self._warningCount)
	end
end

function LogData.new(isClient)
	local v2 = {}
	setmetatable(v2, LogData)

	v2._initialized = false
	v2._isRunning = false
	v2._isClient = isClient

	v2._logData = CircularBuffer.new(fVariable)
	v2._logDataSearched = CircularBuffer.new(fVariable)
	v2._searchTerm = ""

	v2._commandLineHistory = CircularBuffer.new(100)
	v2._commandLineIndex = 0

	v2._filters = {}

	for _, v3 in pairs(EnumToMsgTypeName) do
		v2._filters[v3] = true
	end

	v2._errorCount = isClient and 0
	v2._warningCount = isClient and 0
	v2._logDataUpdate = Signal.new()
	v2._errorWarningSignal = isClient and Signal.new()
	v2._filterUpdated = Signal.new()

	return v2
end

function LogData:Signal()
	return self._logDataUpdate
end

function LogData:errorWarningSignal()
	return self._errorWarningSignal
end

function LogData:filterUpdatedSignal()
	return self._filterUpdated
end

function LogData:setSearchTerm(searchTerm)
	if self._searchTerm ~= searchTerm then
		self._searchTerm = searchTerm

		if self._searchTerm == "" then
			self._logDataSearched:reset()
			self._logDataUpdate:Fire(self._logData)
		else
			filterMessages(self._logDataSearched, self._logData:iterator(), self._filters, self._searchTerm)

			self._logDataUpdate:Fire(self._logDataSearched)
		end
	end
end

function LogData:getSearchTerm()
	return self._searchTerm
end

function LogData:getCommandLineHistory()
	return self._commandLineHistory
end

function LogData:getCommandLineIndex()
	return self._commandLineIndex
end

function LogData:setCommandLineIndex(commandLineIndex)
	self._commandLineIndex = commandLineIndex
end

function LogData:getFilters()
	return self._filters
end

function LogData:setFilter(p, p2)
	local filter = self._filters[p]
	self._filters[p] = p2

	if not validActiveFilters(self._filters) then -- inferred equivalent call
		self._filters[p] = filter
		return
	end

	filterMessages(self._logDataSearched, self._logData:iterator(), self._filters, self._searchTerm)

	self._logDataUpdate:Fire(self._logDataSearched)
	self._filterUpdated:Fire()
end

function LogData:setFilters(filters)
	self._filters = filters

	if validActiveFilters(filters) then -- inferred equivalent call
		filterMessages(self._logDataSearched, self._logData:iterator(), self._filters, self._searchTerm)

		self._logDataUpdate:Fire(self._logDataSearched)
		self._filterUpdated:Fire()
	else
		self._logDataSearched:reset()
		self._logDataUpdate:Fire(self._logData)
	end
end

function LogData:getLogData()
	if #self._logDataSearched:getData() > 0 then
		return self._logDataSearched
	end

	return self._logData
end

function LogData:getErrorWarningCount()
	return self._errorCount, self._warningCount
end

function LogData:isRunning()
	return self._initialized
end

function LogData:start()
	if self._isClient then
		if not self._initialized then
			self._initialized = true

			if #{} == 0 then
				local logHistory = LogService:GetLogHistory()

				for _, v2 in ipairs(logHistory) do
					local v3 = messageEntry(
						v2.message or "[DevConsole Error 1]",
						convertTimeStamp(v2.timestamp),
						v2.messageType.Value,
						v2.context
					)

					if ignoreWarningMessageOnAdd(v3) then
						continue
					end

					self:checkErrorWarningCounter(v2.messageType.Value)
					self._logData:push_back(v3)
				end
			end
		end

		self._connection = LogService.MessageOut:connect(function(value, p, p2)
			local v2 = messageEntry(value or "[DevConsole Error 2]", convertTimeStamp(os.time()), p.Value, p2)

			if not ignoreWarningMessageOnAdd(v2) then
				self:checkErrorWarningCounter(p.Value)
				self._logData:push_back(v2)

				if #self._logDataSearched:getData() > 0 then
					if isMessageFiltered(v2, self._filters, self._searchTerm) then
						self._logDataSearched:push_back(v2)
						self._logDataUpdate:Fire(self._logDataSearched)
					end
				else
					self._logDataUpdate:Fire(self._logData)
				end
			end
		end)
	else
		self._connection = LogService.ServerMessageOut:connect(function(value, p, p2, p3)
			local v2 = messageEntry(value or "[DevConsole Error 3]", convertTimeStamp(p2), p.Value, p3)

			if not ignoreWarningMessageOnAdd(v2) then
				self._logData:push_back(v2)

				if #self._logDataSearched:getData() > 0 then
					if isMessageFiltered(v2, self._filters, self._searchTerm) then
						self._logDataSearched:push_back(v2)
						self._logDataUpdate:Fire(self._logDataSearched)
					end
				else
					self._logDataUpdate:Fire(self._logData)
				end
			end
		end)

		pcall(function()
			self._variantConnection = LogService.ServerContextOut:connect(function(data)
				if type(data) == "table" and data._structuredContext then
					local message = data._message or ""
					local messageType = data._messageType or 0
					local timestamp = data._timestamp or 0
					local structuredContext = data._structuredContext

					local v2 = messageEntry(message, convertTimeStamp(timestamp), messageType, structuredContext)

					if not ignoreWarningMessageOnAdd(v2) then
						self._logData:push_back(v2)

						if #self._logDataSearched:getData() > 0 then
							if isMessageFiltered(v2, self._filters, self._searchTerm) then
								self._logDataSearched:push_back(v2)
								self._logDataUpdate:Fire(self._logDataSearched)
							end
						else
							self._logDataUpdate:Fire(self._logData)
						end
					end
				end
			end)
		end)

		LogService:RequestServerOutput()
	end

	self._isRunning = true
end

function LogData:stop()
	self._initialized = false
	self._isRunning = false

	if self._connection then
		self._connection:Disconnect()
	end

	if self._variantConnection then
		self._variantConnection:Disconnect()
	end
end

return LogData

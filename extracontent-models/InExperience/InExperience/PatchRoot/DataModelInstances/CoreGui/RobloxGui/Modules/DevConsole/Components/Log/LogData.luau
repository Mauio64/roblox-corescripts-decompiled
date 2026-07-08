local LogService = game:GetService("LogService")
local TextService = game:GetService("TextService")
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Log = Constants.Font.Log
local MaxStringSize = Constants.LogFormatting.MaxStringSize
local EnumToMsgTypeName = Constants.EnumToMsgTypeName
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxLogCount"))
local t1 = {
	"ClassDescriptor failed to learn",
	"EventDescriptor failed to learn",
	"Type failed to learn"
}
local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)
local t2 = {}

t2.__index = t2

local function messageEntry(s1: string, s2: string, n1: number, t3: {[any]: any}?) -- line: 34
	-- upvalues: MaxStringSize (copy), TextService (copy), MainWindow (copy), Log (copy)
	local v23 = #s1
	local v24 = if not (v23 < MaxStringSize) then string.format("%s -- %s", s2, (string.sub(s1, 1, MaxStringSize))) else string.format("%s -- %s", s2, s1)
	local TextSize = TextService:GetTextSize(v24, MainWindow, Log, Vector2.new())

	if t3 and next(t3) == nil then
		t3 = nil
	end

	return {
		Expanded = false,
		Message = v24,
		CharCount = v23,
		Type = n1,
		Dims = TextSize,
		Context = t3
	}
end
local function ignoreWarningMessageOnAdd(p1) -- line: 61
	-- upvalues: t1 (copy)
	if p1.Type ~= Enum.MessageType.MessageWarning.Value then
		return false
	end

	for _, v in ipairs(t1) do
		if string.find(p1.Message, v) ~= nil then
			return true
		end
	end

	return false
end
local function isMessageFiltered(p2, p3, p4) -- line: 78
	-- upvalues: EnumToMsgTypeName (copy)
	if #p4 == 0 and not next(p3) then
		return false
	end

	if next(p3) and not p3[EnumToMsgTypeName[p2.Type]] then
		return false
	end

	if #p4 > 0 and string.find(p2.Message:lower(), p4:lower()) == nil then
		return false
	end

	return true
end
local function validActiveFilters(p5) -- line: 99
	local v33 = false

	for _, v in pairs(p5) do
		v33 = v33 or v
	end

	return v33
end
local function filterMessages(p6, p7, p8, p9) -- line: 107
	-- upvalues: isMessageFiltered (copy), messageEntry (copy)
	p6:reset()

	local v40 = false

	for _, v in pairs(p8) do
		v40 = v40 or v
	end

	if #p9 == 0 and not v40 then
		return
	end

	local n2 = 0
	local v44 = p7:next()

	while v44 do
		if isMessageFiltered(v44, p8, p9) then
			n2 += 1
			p6:push_back(v44)
		end

		v44 = p7:next()
	end

	if n2 == 0 then
		if #p9 > 0 then
			p6:push_back((messageEntry(string.format("\"%s\" was not found", p9), "", 0)))

			return
		end

		p6:push_back((messageEntry("No Messages were found", "", 0)))
	end
end

function t2.checkErrorWarningCounter(p10, p11) -- line: 137
	if p11 == Enum.MessageType.MessageWarning.Value then
		p10._warningCount = p10._warningCount + 1
		p10._errorWarningSignal:Fire(p10._errorCount, p10._warningCount)

		return
	end

	if p11 == Enum.MessageType.MessageError.Value then
		p10._errorCount = p10._errorCount + 1
		p10._errorWarningSignal:Fire(p10._errorCount, p10._warningCount)
	end
end
function t2.new(p12) -- line: 147
	-- upvalues: t2 (copy), CircularBuffer (copy), num (copy), EnumToMsgTypeName (copy), Signal (copy)
	local t4 = {}

	setmetatable(t4, t2)
	t4._initialized = false
	t4._isRunning = false
	t4._isClient = p12
	t4._logData = CircularBuffer.new(num)
	t4._logDataSearched = CircularBuffer.new(num)
	t4._searchTerm = ""
	t4._commandLineHistory = CircularBuffer.new(100)
	t4._commandLineIndex = 0
	t4._filters = {}

	for _, v in pairs(EnumToMsgTypeName) do
		t4._filters[v] = true
	end

	t4._errorCount = p12 and 0
	t4._warningCount = p12 and 0
	t4._logDataUpdate = Signal.new()
	t4._errorWarningSignal = p12 and Signal.new()
	t4._filterUpdated = Signal.new()

	return t4
end
function t2.Signal(p13) -- line: 176
	return p13._logDataUpdate
end
function t2.errorWarningSignal(p14) -- line: 180
	return p14._errorWarningSignal
end
function t2.filterUpdatedSignal(p15) -- line: 184
	return p15._filterUpdated
end
function t2.setSearchTerm(p16, p17) -- line: 188
	-- upvalues: filterMessages (copy)
	if p17 ~= p16._searchTerm then
		p16._searchTerm = p17

		if p16._searchTerm == "" then
			p16._logDataSearched:reset()
			p16._logDataUpdate:Fire(p16._logData)

			return
		end

		filterMessages(p16._logDataSearched, p16._logData:iterator(), p16._filters, p16._searchTerm)
		p16._logDataUpdate:Fire(p16._logDataSearched)
	end
end
function t2.getSearchTerm(p18) -- line: 207
	return p18._searchTerm
end
function t2.getCommandLineHistory(p19) -- line: 211
	return p19._commandLineHistory
end
function t2.getCommandLineIndex(p20) -- line: 215
	return p20._commandLineIndex
end
function t2.setCommandLineIndex(p21, p22) -- line: 219
	p21._commandLineIndex = p22
end
function t2.getFilters(p23) -- line: 223
	return p23._filters
end
function t2.setFilter(p24, p25, p26) -- line: 227
	-- upvalues: filterMessages (copy)
	local v65 = p24._filters[p25]

	p24._filters[p25] = p26

	local _filters = p24._filters
	local v67 = false

	for _, v in pairs(_filters) do
		v67 = v67 or v
	end

	if not v67 then
		p24._filters[p25] = v65

		return
	end

	filterMessages(p24._logDataSearched, p24._logData:iterator(), p24._filters, p24._searchTerm)
	p24._logDataUpdate:Fire(p24._logDataSearched)
	p24._filterUpdated:Fire()
end
function t2.setFilters(p27, p28) -- line: 246
	-- upvalues: filterMessages (copy)
	p27._filters = p28

	local v72 = false

	for _, v in pairs(p28) do
		v72 = v72 or v
	end

	if not v72 then
		p27._logDataSearched:reset()
		p27._logDataUpdate:Fire(p27._logData)

		return
	end

	filterMessages(p27._logDataSearched, p27._logData:iterator(), p27._filters, p27._searchTerm)
	p27._logDataUpdate:Fire(p27._logDataSearched)
	p27._filterUpdated:Fire()
end
function t2.getLogData(p29) -- line: 265
	if #p29._logDataSearched:getData() > 0 then
		return p29._logDataSearched
	end

	return p29._logData
end
function t2.getErrorWarningCount(p30) -- line: 272
	return p30._errorCount, p30._warningCount
end
function t2.isRunning(p31) -- line: 276
	return p31._initialized
end
function t2.start(p32) -- line: 280
	-- upvalues: LogService (copy), messageEntry (copy), convertTimeStamp (copy), ignoreWarningMessageOnAdd (copy), isMessageFiltered (copy)
	if p32._isClient then
		if not p32._initialized then
			p32._initialized = true

			if #{} == 0 then
				local LogHistory = LogService:GetLogHistory()

				for _, v in ipairs(LogHistory) do
					local v82 = messageEntry(v.message or "[DevConsole Error 1]", convertTimeStamp(v.timestamp), v.messageType.Value, v.context)

					if not ignoreWarningMessageOnAdd(v82) then
						p32:checkErrorWarningCounter(v.messageType.Value)
						p32._logData:push_back(v82)
					end
				end
			end
		end

		p32._connection = LogService.MessageOut:connect(function(p33, p34, p35) -- line: 302
			-- upvalues: messageEntry (copy), convertTimeStamp (copy), ignoreWarningMessageOnAdd (copy), p32 (copy), isMessageFiltered (copy)
			local v87 = messageEntry(p33 or "[DevConsole Error 2]", convertTimeStamp(os.time()), p34.Value, p35)

			if not ignoreWarningMessageOnAdd(v87) then
				p32:checkErrorWarningCounter(p34.Value)
				p32._logData:push_back(v87)

				if #p32._logDataSearched:getData() > 0 then
					if isMessageFiltered(v87, p32._filters, p32._searchTerm) then
						p32._logDataSearched:push_back(v87)
						p32._logDataUpdate:Fire(p32._logDataSearched)

						return
					end
				else
					p32._logDataUpdate:Fire(p32._logData)
				end
			end
		end)
	else
		p32._connection = LogService.ServerMessageOut:connect(function(p36, p37, p38, p39) -- line: 325
			-- upvalues: messageEntry (copy), convertTimeStamp (copy), ignoreWarningMessageOnAdd (copy), p32 (copy), isMessageFiltered (copy)
			local v92 = messageEntry(p36 or "[DevConsole Error 3]", convertTimeStamp(p38), p37.Value, p39)

			if not ignoreWarningMessageOnAdd(v92) then
				p32._logData:push_back(v92)

				if #p32._logDataSearched:getData() > 0 then
					if isMessageFiltered(v92, p32._filters, p32._searchTerm) then
						p32._logDataSearched:push_back(v92)
						p32._logDataUpdate:Fire(p32._logDataSearched)

						return
					end
				else
					p32._logDataUpdate:Fire(p32._logData)
				end
			end
		end)
		pcall(function() -- line: 347
			-- upvalues: p32 (copy), LogService (copy), messageEntry (copy), convertTimeStamp (copy), ignoreWarningMessageOnAdd (copy), isMessageFiltered (copy)
			p32._variantConnection = LogService.ServerContextOut:connect(function(p40) -- line: 348
				-- upvalues: messageEntry (copy), convertTimeStamp (copy), ignoreWarningMessageOnAdd (copy), p32 (copy), isMessageFiltered (copy)
				if type(p40) == "table" and p40._structuredContext then
					local v94 = p40._message or ""
					local v95 = p40._messageType or 0
					local v96 = p40._timestamp or 0
					local _structuredContext = p40._structuredContext
					local v98 = messageEntry(v94, convertTimeStamp(v96), v95, _structuredContext)

					if not ignoreWarningMessageOnAdd(v98) then
						p32._logData:push_back(v98)

						if #p32._logDataSearched:getData() > 0 then
							if isMessageFiltered(v98, p32._filters, p32._searchTerm) then
								p32._logDataSearched:push_back(v98)
								p32._logDataUpdate:Fire(p32._logDataSearched)

								return
							end
						else
							p32._logDataUpdate:Fire(p32._logData)
						end
					end
				end
			end)
		end)
		LogService:RequestServerOutput()
	end

	p32._isRunning = true
end
function t2.stop(p41) -- line: 384
	p41._initialized = false
	p41._isRunning = false

	if p41._connection then
		p41._connection:Disconnect()
	end

	if p41._variantConnection then
		p41._variantConnection:Disconnect()
	end
end

return t2

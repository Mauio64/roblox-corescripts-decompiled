local parent = script.Parent.Parent
local Cryo = require(parent.Cryo)

local Logger = {}
Logger.__index = Logger

Logger.Levels = {
	Error = "Error",
	Warning = "Warning",
	Info = "Info",
	Debug = "Debug",
	Trace = "Trace"
}

local v = {
	Logger.Levels.Error,
	Logger.Levels.Warning,
	Logger.Levels.Info,
	Logger.Levels.Debug,
	Logger.Levels.Trace
}

local v2 = {}

for k, v3 in pairs(v) do
	v2[v3] = k
end

function Logger.Levels.fromString(value)
	if type(value) ~= "string" then
		return nil
	end

	for _, v3 in pairs(v) do
		if string.lower(v3) == string.lower(value) then
			return v3
		end
	end

	return nil
end

function Logger.new(parent2, name)
	local v3 = {
		name = name,
		sinks = {},
		children = {},
		parent = parent2,
		context = {},
		dirty = true,
		active = {},
		cache = { sinks = {}, context = {} }
	}

	for k, _ in pairs(Logger.Levels) do
		if parent2 then
			v3.active[k] = parent2.active[k]
		else
			v3.active[k] = false
		end
	end

	if parent2 then
		parent2.children[v3] = true
	end

	setmetatable(v3, Logger)
	return v3
end

local function setActive(p, state)
	local v3 = v2[p]

	if v3 then
		for i = 1, v3 do
			state.active[v[i]] = true
		end

		for k, _ in pairs(state.children) do
			setActive(p, k)
		end
	end
end

local function setDirty(k)
	k.dirty = true

	for k2, _ in pairs(k.children) do
		setDirty(k2)
	end
end

local function updateCache(state)
	if not state.dirty then
		return
	end

	if state.parent then
		updateCache(state.parent)

		state.cache.context = Cryo.Dictionary.join(state.parent.cache.context, state.context)

		if state.parent.cache.context.prefix and state.context.prefix then
			state.cache.context.prefix = state.parent.cache.context.prefix .. state.context.prefix
		end

		state.cache.sinks = Cryo.List.join(state.parent.cache.sinks, state.sinks)
	else
		state.cache.context = state.context
		state.cache.sinks = state.sinks
	end

	state.dirty = false
end

function Logger:setParent(parent2)
	if self.parent then
		self.parent.children[self] = nil
	end

	updateCache(parent2)
	self.parent = parent2
	self.parent.children[self] = true
	local maxValue = -1

	for _, sink in pairs(parent2.cache.sinks) do
		if v2[sink.maxLevel] then
			maxValue = math.max(maxValue, v2[sink.maxLevel])
		end
	end

	if maxValue > -1 then
		setActive(v[maxValue], self)
	end

	self.dirty = true

	for k, _ in pairs(self.children) do
		setDirty(k)
	end
end

function Logger:addSink(p)
	setActive(p.maxLevel, self)
	table.insert(self.sinks, p)
	self.dirty = true

	for k, _ in pairs(self.children) do
		setDirty(k)
	end
end

function Logger:setContext(context)
	self.context = context
	self.dirty = true

	for k, _ in pairs(self.children) do
		setDirty(k)
	end
end

local function log(level, data, rawMessage)
	if data.dirty then
		updateCache(data)
	end

	local v3 = { level = level, rawMessage = rawMessage, loggerName = data.name }

	for k, v4 in pairs(data.cache.context) do
		if type(v4) == "function" then
			v3[k] = v4()
		else
			v3[k] = v4
		end
	end

	local v4 = rawMessage.n == 0 and "LUMBERYAK INTERNAL: No log message given" or rawMessage[1]

	if v3.prefix then
		v4 = v3.prefix .. v4
	end

	if v4:find("{") then
		local v5 = 1
		v4 = v4:gsub("{(.-)}", function(p)
			if p == "" then
				v5 += 1
				return (tostring(rawMessage[v5]))
			end

			local v6 = v3[p]
			return v6 and tostring(v6)
		end)

		if v5 < rawMessage.n then
			v4 ..= "\nLUMBERYAK INTERNAL: Too many arguments given for format string"
		elseif rawMessage.n < v5 then
			v4 ..= "\nLUMBERYAK INTERNAL: Too few arguments given for format string"
		end
	elseif rawMessage.n > 1 then
		v4 ..= "\nLUMBERYAK INTERNAL: Too many arguments given for format string"
	end

	local v5 = v2[level]

	for _, sink in pairs(data.cache.sinks) do
		if v2[sink.maxLevel] and v5 <= v2[sink.maxLevel] then
			sink:log(v4, v3)
		end
	end
end

function Logger.error(p, ...)
	if not p.active[Logger.Levels.Error] then
		return
	end

	log(Logger.Levels.Error, p, table.pack(...))
end

function Logger.warning(p, ...)
	if not p.active[Logger.Levels.Warning] then
		return
	end

	log(Logger.Levels.Warning, p, table.pack(...))
end

function Logger.info(p, ...)
	if not p.active[Logger.Levels.Info] then
		return
	end

	log(Logger.Levels.Info, p, table.pack(...))
end

function Logger.debug(p, ...)
	if not p.active[Logger.Levels.Debug] then
		return
	end

	log(Logger.Levels.Debug, p, table.pack(...))
end

function Logger.trace(p, ...)
	if not p.active[Logger.Levels.Trace] then
		return
	end

	log(Logger.Levels.Trace, p, table.pack(...))
end

return Logger

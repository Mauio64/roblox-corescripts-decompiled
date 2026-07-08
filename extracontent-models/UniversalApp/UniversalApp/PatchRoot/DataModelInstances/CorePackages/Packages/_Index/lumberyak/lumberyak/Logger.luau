local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local t1 = {}

t1.__index = t1
t1.Levels = {
	Error = "Error",
	Warning = "Warning",
	Info = "Info",
	Debug = "Debug",
	Trace = "Trace"
}

local t2 = {
	t1.Levels.Error,
	t1.Levels.Warning,
	t1.Levels.Info,
	t1.Levels.Debug,
	t1.Levels.Trace
}
local t3 = {}

for k, v in pairs(t2) do
	t3[v] = k
end

function t1.Levels.fromString(p1) -- line: 28
	-- upvalues: t2 (copy)
	if type(p1) ~= "string" then
		return nil
	end

	for _, v in pairs(t2) do
		if string.lower(v) == string.lower(p1) then
			return v
		end
	end

	return nil
end
function t1.new(p2, p3) -- line: 40
	-- upvalues: t1 (copy)
	local t4 = {
		dirty = true,
		name = p3,
		sinks = {},
		children = {},
		parent = p2,
		context = {},
		active = {},
		cache = {
			sinks = {},
			context = {}
		}
	}

	for k, _ in pairs(t1.Levels) do
		if p2 then
			t4.active[k] = p2.active[k]
		else
			t4.active[k] = false
		end
	end

	if p2 then
		p2.children[t4] = true
	end

	setmetatable(t4, t1)

	return t4
end

local function setActive(p4, p5) -- line: 72
	-- upvalues: t3 (copy), t2 (copy), setActive (copy)
	local v22 = t3[p4]

	if v22 then
		for i = 1, v22 do
			p5.active[t2[i]] = true
		end

		for k, _ in pairs(p5.children) do
			setActive(p4, k)
		end
	end
end
local function setDirty(p6) -- line: 85
	-- upvalues: setDirty (copy)
	p6.dirty = true

	for k, _ in pairs(p6.children) do
		setDirty(k)
	end
end
local function updateCache(p7) -- line: 93
	-- upvalues: updateCache (copy), Cryo (copy)
	if not p7.dirty then
		return
	end

	if not p7.parent then
		p7.cache.context = p7.context
		p7.cache.sinks = p7.sinks
		p7.dirty = false

		return
	end

	updateCache(p7.parent)
	p7.cache.context = Cryo.Dictionary.join(p7.parent.cache.context, p7.context)

	if p7.parent.cache.context.prefix and p7.context.prefix then
		p7.cache.context.prefix = p7.parent.cache.context.prefix .. p7.context.prefix
	end

	p7.cache.sinks = Cryo.List.join(p7.parent.cache.sinks, p7.sinks)
	p7.dirty = false
end

function t1.setParent(p8, p9) -- line: 117
	-- upvalues: updateCache (copy), t3 (copy), setActive (copy), t2 (copy), setDirty (copy)
	if p8.parent then
		p8.parent.children[p8] = nil
	end

	updateCache(p9)
	p8.parent = p9
	p8.parent.children[p8] = true

	local n1 = -1

	for _, v in pairs(p9.cache.sinks) do
		if t3[v.maxLevel] then
			n1 = math.max(n1, t3[v.maxLevel])
		end
	end

	if n1 > -1 then
		setActive(t2[n1], p8)
	end

	p8.dirty = true

	for k, _ in pairs(p8.children) do
		setDirty(k)
	end
end
function t1.addSink(p10, p11) -- line: 141
	-- upvalues: setActive (copy), setDirty (copy)
	setActive(p11.maxLevel, p10)
	table.insert(p10.sinks, p11)
	p10.dirty = true

	for k, _ in pairs(p10.children) do
		setDirty(k)
	end
end
function t1.setContext(p12, p13) -- line: 147
	-- upvalues: setDirty (copy)
	p12.context = p13
	p12.dirty = true

	for k, _ in pairs(p12.children) do
		setDirty(k)
	end
end

local function log(p14, p15, p16) -- line: 152
	-- upvalues: updateCache (copy), t3 (copy)
	if p15.dirty then
		updateCache(p15)
	end

	local t5 = {
		level = p14,
		rawMessage = p16,
		loggerName = p15.name
	}

	for k, v in pairs(p15.cache.context) do
		if type(v) == "function" then
			t5[k] = v()
		else
			t5[k] = v
		end
	end

	local v51 = if p16.n ~= 0 then p16[1] else "LUMBERYAK INTERNAL: No log message given"

	if t5.prefix then
		v51 = t5.prefix .. v51
	end

	if v51:find("{") then
		local n2 = 1

		v51 = v51:gsub("{(.-)}", function(p17) -- line: 186
			-- upvalues: n2 (ref), p16 (copy), t5 (copy)
			if p17 == "" then
				n2 += 1

				return (tostring(p16[n2]))
			end

			local v62 = t5[p17]

			return v62 and tostring(v62)
		end)

		if n2 < p16.n then
			v51 ..= "\nLUMBERYAK INTERNAL: Too many arguments given for format string"
		elseif p16.n < n2 then
			v51 ..= "\nLUMBERYAK INTERNAL: Too few arguments given for format string"
		end
	elseif p16.n > 1 then
		v51 ..= "\nLUMBERYAK INTERNAL: Too many arguments given for format string"
	end

	local v53 = t3[p14]

	for _, v in pairs(p15.cache.sinks) do
		if t3[v.maxLevel] and v53 <= t3[v.maxLevel] then
			v:log(v51, t5)
		end
	end
end

function t1.error(p18, ...) -- line: 213
	-- upvalues: t1 (copy), log (copy)
	if not p18.active[t1.Levels.Error] then
		return
	end

	log(t1.Levels.Error, p18, table.pack(...))
end
function t1.warning(p19, ...) -- line: 220
	-- upvalues: t1 (copy), log (copy)
	if not p19.active[t1.Levels.Warning] then
		return
	end

	log(t1.Levels.Warning, p19, table.pack(...))
end
function t1.info(p20, ...) -- line: 227
	-- upvalues: t1 (copy), log (copy)
	if not p20.active[t1.Levels.Info] then
		return
	end

	log(t1.Levels.Info, p20, table.pack(...))
end
function t1.debug(p21, ...) -- line: 234
	-- upvalues: t1 (copy), log (copy)
	if not p21.active[t1.Levels.Debug] then
		return
	end

	log(t1.Levels.Debug, p21, table.pack(...))
end
function t1.trace(p22, ...) -- line: 241
	-- upvalues: t1 (copy), log (copy)
	if not p22.active[t1.Levels.Trace] then
		return
	end

	log(t1.Levels.Trace, p22, table.pack(...))
end

return t1

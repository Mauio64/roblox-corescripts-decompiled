local Logger = require(game.LoadedCode.Packages.Lumberyak.Logger)

local function timeit(callback, callback2)
	local v = callback()

	local lastTime = tick()

	for _ = 1, 2000000 do
		callback2(v)
	end

	return (tick() - lastTime) / 2000000
end

local function callSimple(object)
	object:info("foo")
end

local function callInterp(object)
	object:info("foo {}", 2)
end

local function simple()
	local total = 0
	local v = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v2 = Logger.new()
	v2:setContext({ number = 1 })
	v2:addSink(v)
	return v2
end

local function empty()
	return {
		info = function() end
	}
end

local function off()
	local total = 0
	local v = {
		maxLevel = Logger.Levels.Error,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v2 = Logger.new()
	v2:setContext({ number = 1 })
	v2:addSink(v)
	return v2
end

local function short()
	local total = 0
	local v = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v2 = Logger.new()
	local v3 = v2:new()
	v2:setContext({ number = 1 })
	v2:addSink(v)
	return v3
end

local function long()
	local total = 0
	local v = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v2 = Logger.new()
	v2:setContext({ number = 1 })
	v2:addSink(v)
	return (v2:new():new():new():new())
end

local function many()
	local total = 0
	local v = {
		maxLevel = Logger.Levels.Error,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v2 = {
		maxLevel = Logger.Levels.Warning,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v3 = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v4 = {
		maxLevel = Logger.Levels.Debug,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v5 = {
		maxLevel = Logger.Levels.Trace,
		log = function(_, _, p)
			total += p.number
		end
	}

	local v6 = Logger.new()
	v6:setContext({ number = 1 })
	v6:addSink(v)
	v6:addSink(v2)
	v6:addSink(v3)
	v6:addSink(v4)
	v6:addSink(v5)
	return v6
end

local v = timeit(empty, callSimple)
local v2 = timeit(empty, callInterp)

local function fmt(p, p2, p3)
	print(string.format("%-40s %0.3e [%0.4fx]", p .. " - " .. p2, p3, p3 / v))
end

print(string.format("%-40s %0.3e [%0.4fx]", "Empty function - Simple", v, v / v))
print(string.format("%-40s %0.3e [%0.4fx]", "Empty function - Interpolation", v2, v2 / v))

for k, v3 in pairs({
	["Log level off"] = off,
	["Simple logger"] = simple,
	["Short chain"] = short,
	["Long chain"] = long,
	["Many sinks"] = many
}) do
	local v4 = timeit(v3, callSimple)
	print(string.format("%-40s %0.3e [%0.4fx]", k .. " - Simple", v4, v4 / v))

	local v5 = timeit(v3, callInterp)
	print(string.format("%-40s %0.3e [%0.4fx]", k .. " - Interpolation", v5, v5 / v))
end

local Logger = require(game.LoadedCode.Packages.Lumberyak.Logger)

local function timeit(p1, p2) -- line: 5
	local v21 = p1()
	local timestamp = tick()

	for _ = 1, 2000000 do
		p2(v21)
	end

	return (tick() - timestamp) / 2000000
end
local function callSimple(p3) -- line: 15
	p3:info("foo")
end
local function callInterp(p4) -- line: 19
	p4:info("foo {}", 2)
end
local function simple() -- line: 23
	-- upvalues: Logger (copy)
	local n1 = 0
	local t1 = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p7) -- line: 27
			-- upvalues: n1 (ref)
			n1 += p7.number
		end
	}
	local v28 = Logger.new()

	v28:setContext({
		number = 1
	})
	v28:addSink(t1)

	return v28
end
local function empty() -- line: 38
	return {
		info = function() -- line: 40
		end
	}
end
local function off() -- line: 44
	-- upvalues: Logger (copy)
	local n2 = 0
	local t2 = {
		maxLevel = Logger.Levels.Error,
		log = function(_, _, p10) -- line: 48
			-- upvalues: n2 (ref)
			n2 += p10.number
		end
	}
	local v31 = Logger.new()

	v31:setContext({
		number = 1
	})
	v31:addSink(t2)

	return v31
end
local function short() -- line: 59
	-- upvalues: Logger (copy)
	local n3 = 0
	local t3 = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p13) -- line: 63
			-- upvalues: n3 (ref)
			n3 += p13.number
		end
	}
	local v34 = Logger.new()
	local v35 = v34:new()

	v34:setContext({
		number = 1
	})
	v34:addSink(t3)

	return v35
end
local function long() -- line: 75
	-- upvalues: Logger (copy)
	local n4 = 0
	local t4 = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p16) -- line: 79
			-- upvalues: n4 (ref)
			n4 += p16.number
		end
	}
	local v38 = Logger.new()

	v38:setContext({
		number = 1
	})
	v38:addSink(t4)

	return (v38:new():new():new():new())
end
local function many() -- line: 94
	-- upvalues: Logger (copy)
	local n5 = 0
	local t5 = {
		maxLevel = Logger.Levels.Error,
		log = function(_, _, p19) -- line: 98
			-- upvalues: n5 (ref)
			n5 += p19.number
		end
	}
	local t6 = {
		maxLevel = Logger.Levels.Warning,
		log = function(_, _, p22) -- line: 104
			-- upvalues: n5 (ref)
			n5 += p22.number
		end
	}
	local t7 = {
		maxLevel = Logger.Levels.Info,
		log = function(_, _, p25) -- line: 110
			-- upvalues: n5 (ref)
			n5 += p25.number
		end
	}
	local t8 = {
		maxLevel = Logger.Levels.Debug,
		log = function(_, _, p28) -- line: 116
			-- upvalues: n5 (ref)
			n5 += p28.number
		end
	}
	local t9 = {
		maxLevel = Logger.Levels.Trace,
		log = function(_, _, p31) -- line: 122
			-- upvalues: n5 (ref)
			n5 += p31.number
		end
	}
	local v45 = Logger.new()

	v45:setContext({
		number = 1
	})
	v45:addSink(t5)
	v45:addSink(t6)
	v45:addSink(t7)
	v45:addSink(t8)
	v45:addSink(t9)

	return v45
end

local v11 = timeit(empty, callSimple)
local v12 = timeit(empty, callInterp)
local t10 = {
	["Log level off"] = off,
	["Simple logger"] = simple,
	["Short chain"] = short,
	["Long chain"] = long,
	["Many sinks"] = many
}

local function fmt(p32, p33, p34) -- line: 148
	-- upvalues: v11 (copy)
	print(string.format("%-40s %0.3e [%0.4fx]", p32 .. " - " .. p33, p34, p34 / v11))
end

print(string.format("%-40s %0.3e [%0.4fx]", "Empty function - Simple", v11, v11 / v11))
print(string.format("%-40s %0.3e [%0.4fx]", "Empty function - Interpolation", v12, v12 / v11))

for k, v in pairs(t10) do
	local v17 = timeit(v, callSimple)

	print(string.format("%-40s %0.3e [%0.4fx]", k .. " - " .. "Simple", v17, v17 / v11))

	local v18 = timeit(v, callInterp)

	print(string.format("%-40s %0.3e [%0.4fx]", k .. " - " .. "Interpolation", v18, v18 / v11))
end

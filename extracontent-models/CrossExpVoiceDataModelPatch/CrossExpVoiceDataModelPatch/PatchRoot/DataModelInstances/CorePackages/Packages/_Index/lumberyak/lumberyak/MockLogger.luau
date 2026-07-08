local t1 = {
	Levels = {
		Error = "MockError",
		Warning = "MockWarning",
		Info = "MockInfo",
		Debug = "MockDebug",
		Trace = "MockTrace",
		fromString = function() -- line: 12
			return "MockInfo"
		end
	}
}

t1.__index = t1

function t1.new() -- line: 19
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.setParent() -- line: 23
end
function t1.setContext() -- line: 26
end
function t1.addSink() -- line: 29
end
function t1.error() -- line: 32
end
function t1.warning() -- line: 35
end
function t1.info() -- line: 38
end
function t1.debug() -- line: 41
end
function t1.trace() -- line: 44
end

return t1

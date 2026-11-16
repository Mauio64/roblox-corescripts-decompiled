local MockLogger = {}

MockLogger.Levels = {
	Error = "MockError",
	Warning = "MockWarning",
	Info = "MockInfo",
	Debug = "MockDebug",
	Trace = "MockTrace",
	fromString = function(): string
		return "MockInfo"
	end
}

MockLogger.__index = MockLogger

function MockLogger.new()
	return (setmetatable({}, MockLogger))
end

function MockLogger.setParent() end

function MockLogger.setContext() end

function MockLogger.addSink() end

function MockLogger.error() end

function MockLogger.warning() end

function MockLogger.info() end

function MockLogger.debug() end

function MockLogger.trace() end

return MockLogger

local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return JestConfigs.createBenchmarkConfig("ChatUIPrimitivesBenchmarks")

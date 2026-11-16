local parent = script:FindFirstAncestor("ExpChat").Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return JestConfigs.createBenchmarkConfig("ExpChatBenchmarks")

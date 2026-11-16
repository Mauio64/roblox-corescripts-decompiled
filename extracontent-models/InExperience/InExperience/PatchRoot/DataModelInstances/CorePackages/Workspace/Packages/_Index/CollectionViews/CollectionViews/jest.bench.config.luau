local parent = script:FindFirstAncestor("CollectionViews").Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return JestConfigs.createBenchmarkConfig("CollectionViewsBenchmarks")

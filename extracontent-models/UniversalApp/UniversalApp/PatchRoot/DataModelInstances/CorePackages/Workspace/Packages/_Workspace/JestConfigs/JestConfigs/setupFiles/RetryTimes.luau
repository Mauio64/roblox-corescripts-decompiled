local Parent = script:FindFirstAncestor("JestConfigs").Parent
local jest = require(Parent.JestGlobals).jest
local v3 = game:DefineFastInt("JestTestRetryTimes", 2)

jest.retryTimes(v3, {
	logErrorsBeforeRetry = true
})

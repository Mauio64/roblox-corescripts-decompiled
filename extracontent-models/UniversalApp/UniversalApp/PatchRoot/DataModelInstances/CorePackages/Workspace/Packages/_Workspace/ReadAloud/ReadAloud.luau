local ReadAloudManager = require(script.ReadAloudManager)
local ConnectReadAloudToSettings = require(script.ConnectReadAloudToSettings)

return {
	ReadAloudManager = ReadAloudManager,
	ConnectReadAloudToSettings = function() -- line: 5
		-- upvalues: ConnectReadAloudToSettings (copy), ReadAloudManager (copy)
		return ConnectReadAloudToSettings(ReadAloudManager)
	end,
	["jest.config"] = script["jest.config"]
}

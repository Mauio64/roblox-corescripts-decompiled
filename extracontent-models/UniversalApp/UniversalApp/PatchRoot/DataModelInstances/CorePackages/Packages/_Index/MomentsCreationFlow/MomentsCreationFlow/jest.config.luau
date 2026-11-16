local parent = script.Parent

local Tests = require(parent.Components.Tests)
local jestconfig = Tests["jest.config"]
local Tests2 = require(parent.Thunks.Tests)
local jestconfig2 = Tests2["jest.config"]
local Tests3 = require(parent.Utils.Tests)
return {
	projects = { jestconfig, jestconfig2, Tests3["jest.config"] }
}

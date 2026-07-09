local ParentParent = script.Parent.Parent.Parent
local jest = require(ParentParent.Dev.JestGlobals).jest
local React = require(ParentParent.React)
local cleanup = require(ParentParent.Dev.ReactTestingLibrary).cleanup

return {
	setupTest = function() -- line: 13
		-- upvalues: jest (copy)
		jest.clearAllMocks()
	end,
	teardownTest = function() -- line: 17
		-- upvalues: cleanup (copy)
		cleanup()
	end,
	setupTestWithMocks = function() -- line: 43
		-- upvalues: jest (copy)
		jest.clearAllMocks()
	end,
	mockLocalComponent = function(p1, p2) -- line: 22
		-- upvalues: jest (copy), React (copy)
		jest.mock(p1, function() -- line: 23
			-- upvalues: React (copy), p2 (copy)
			return function(p3) -- line: 24
				-- upvalues: React (copy), p2 (copy)
				return React.createElement("Frame", {
					[React.Tag] = "data-testid=" .. (p3.testId or p2)
				})
			end
		end)
	end,
	getCommonTestDependencies = function() -- line: 33
		-- upvalues: ParentParent (copy)
		return {
			JestGlobals = require(ParentParent.Dev.JestGlobals),
			React = require(ParentParent.React),
			ReactTestingLibrary = require(ParentParent.Dev.ReactTestingLibrary),
			UnitTestHelpers = require(ParentParent.Dev.UnitTestHelpers)
		}
	end
}

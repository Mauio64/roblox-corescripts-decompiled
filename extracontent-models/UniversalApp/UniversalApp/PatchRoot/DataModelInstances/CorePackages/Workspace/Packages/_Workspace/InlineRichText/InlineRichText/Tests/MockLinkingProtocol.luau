local Parent = script:FindFirstAncestor("InlineRichText").Parent
local jest = require(Parent.Dev.JestGlobals).jest

return {
	createMockLinkingProtocol = function() -- line: 18
		-- upvalues: jest (copy)
		return {
			mockIsURLRegistered = jest.fn(),
			mockDetectURL = jest.fn(),
			mockOpenURL = jest.fn()
		}
	end,
	createLinkingProtocolMockImpl = function(t1: {[any]: any}) -- line: 26
		return function() -- line: 27
			-- upvalues: t1 (copy)
			return {
				LinkingProtocol = {
					default = {
						isURLRegistered = function(_, s1: string) -- line: 31
							-- upvalues: t1 (copy)
							return t1.mockIsURLRegistered(s1)
						end,
						detectURL = function(_, s2: string) -- line: 34
							-- upvalues: t1 (copy)
							return t1.mockDetectURL(s2)
						end,
						openURL = function(_, s3: string) -- line: 37
							-- upvalues: t1 (copy)
							return t1.mockOpenURL(s3)
						end
					}
				}
			}
		end
	end
}

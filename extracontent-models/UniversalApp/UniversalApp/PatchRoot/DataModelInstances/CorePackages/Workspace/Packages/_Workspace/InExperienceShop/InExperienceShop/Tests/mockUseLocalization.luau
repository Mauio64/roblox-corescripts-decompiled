local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local jest = require(Parent.Dev.JestGlobals).jest

local function mockUseLocalization() -- line: 22
	-- upvalues: jest (copy), Parent (copy)
	jest.mock(Parent.Localization, function() -- line: 23
		return {
			Hooks = {
				useLocalization = function(t1: {[any]: any}) -- line: 26
					local t2 = {}

					for v6, v7 in t1 do
						if typeof(v7) == "table" then
							t2[v6] = v7[1]
						else
							t2[v6] = v7
						end
					end

					return t2
				end
			},
			NumberLocalization = {
				localize = function(s1: string, _: string) -- line: 39
					return s1
				end
			}
		}
	end)
end

return mockUseLocalization

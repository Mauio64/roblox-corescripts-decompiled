local parent = script:FindFirstAncestor("InExperienceShop").Parent

local JestGlobals = require(parent.Dev.JestGlobals)
local jest = JestGlobals.jest

local function mockUseLocalization()
	jest.mock(parent.Localization, function()
		return {
			Hooks = {
				useLocalization = function(items)
					local result = {}

					for k, item in items do
						if typeof(item) == "table" then
							result[k] = item[1]
						else
							result[k] = item
						end
					end

					return result
				end
			},
			NumberLocalization = {
				localize = function(p: string, _: string)
					return p
				end
			}
		}
	end)
end

return mockUseLocalization

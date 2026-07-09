local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)

local function withTheme_DEPRECATED(p1) -- line: 18
	-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), Cryo (copy)
	local function ComponentWithTheme(p2) -- line: 19
		-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), p1 (copy), Cryo (copy)
		return Roact.createElement(ThemeContext_DEPRECATED.Consumer, {
			render = function(p3) -- line: 21
				-- upvalues: Roact (copy), p1 (copy), Cryo (copy), p2 (copy)
				return Roact.createElement(p1, Cryo.Dictionary.join(p2, {
					appTheme = p3
				}))
			end
		})
	end

	return ComponentWithTheme
end

return withTheme_DEPRECATED

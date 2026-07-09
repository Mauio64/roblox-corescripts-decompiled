local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local WidgetInfoContext = require(Modules.AvatarExperience.Common.Context.WidgetInfoContext)

local function withWidgetInfo(p1) -- line: 14
	-- upvalues: React (copy), WidgetInfoContext (copy), Dash (copy)
	return function(p2) -- line: 15
		-- upvalues: React (copy), WidgetInfoContext (copy), p1 (copy), Dash (copy)
		return React.createElement(WidgetInfoContext.Consumer, {
			render = function(p3) -- line: 17
				-- upvalues: React (copy), p1 (copy), Dash (copy), p2 (copy)
				return React.createElement(p1, Dash.join(p2, {
					widgetInfo = p3
				}))
			end
		})
	end
end

return withWidgetInfo

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style")
local uiModeStyleProvider = Style.UiModeStyleProvider
local designTokenProvider = Style.DesignTokenProvider

local function maybeForceDarkTheme(p2, p3)
	if p3 then
		return React.createElement(uiModeStyleProvider, {
			style = { themeName = "Dark", fontName = nil }
		}, {
			DesignTokenProvider = React.createElement(designTokenProvider, {
				tokenMappers = {}
			}, {
				Content = p2
			})
		})
	end

	return p2
end

return maybeForceDarkTheme

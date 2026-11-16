local parent = script:FindFirstAncestor("CollectionViews").Parent

local React = require(parent.React)
local Style = require(parent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local DesignTokenProvider = Style.DesignTokenProvider

local function maybeForceDarkTheme(content, flag: boolean?)
	if flag then
		return React.createElement(UiModeStyleProvider, {
			style = { themeName = "Dark", fontName = nil }
		}, {
			DesignTokenProvider = React.createElement(DesignTokenProvider, { tokenMappers = {} }, {
				Content = content
			})
		})
	end

	return content
end

return maybeForceDarkTheme

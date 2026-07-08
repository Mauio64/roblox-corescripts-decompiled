local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)
local Style = require(Parent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local DesignTokenProvider = Style.DesignTokenProvider

local function maybeForceDarkTheme(p1, b1: boolean?) -- line: 9
	-- upvalues: React (copy), UiModeStyleProvider (copy), DesignTokenProvider (copy)
	if b1 then
		return React.createElement(UiModeStyleProvider, {
			style = {
				themeName = "Dark",
				fontName = nil
			}
		}, {
			DesignTokenProvider = React.createElement(DesignTokenProvider, {
				tokenMappers = {}
			}, {
				Content = p1
			})
		})
	end

	return p1
end

return maybeForceDarkTheme

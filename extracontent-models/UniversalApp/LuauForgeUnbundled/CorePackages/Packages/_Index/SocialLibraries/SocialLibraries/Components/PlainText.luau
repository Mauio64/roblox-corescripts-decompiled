local module = require("@luauforge/bundled/dJa")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/LuaSocialLibrariesDeps")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/Foundation").Utility.normalizeFontFace
local module4 = require("@luauforge/bundled/dJy")

local fitTextLabel = LuaSocialLibrariesDeps.RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle

return function(data)
	local contentWidth = data.contentWidth
	local layoutOrder = data.layoutOrder
	local errorText = data.errorText

	return withStyle(function(props)
		local createElement = module.createElement
		local v6 = {
			BackgroundTransparency = 1,
			width = fitTextLabel.Width.FitToText,
			maximumWidth = contentWidth,
			Font = 0,
			LayoutOrder = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextWrapped = true,
			TextXAlignment = 0,
			AnchorPoint = 0
		}

		local v7 = if module4 then normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font) else props.Font.Footer.Font
		v6.Font = v7

		v6.LayoutOrder = layoutOrder or nil
		v6.Text = errorText
		v6.TextColor3 = props.Theme.Alert.Color
		v6.TextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize
		v6.TextTransparency = props.Theme.TextDefault.Transparency

		v6.TextXAlignment = Enum.TextXAlignment.Center
		v6.AnchorPoint = Vector2.new(0, 0)
		return createElement(fitTextLabel, v6)
	end)
end

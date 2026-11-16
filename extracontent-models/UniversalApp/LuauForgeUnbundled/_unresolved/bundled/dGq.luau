local module = require("@luauforge/bundled/dFV")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/LuaSocialLibrariesDeps")
local Foundation = require("@game/CorePackages/Workspace/Packages/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local module5 = require("@luauforge/bundled/dGt")

local module6 = require("@luauforge/bundled/dGu")

local fitTextLabel = LuaSocialLibrariesDeps.RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle

return function(data)
	local contentWidth = data.contentWidth
	local layoutOrder = data.layoutOrder
	local richText = data.richText
	local text = data.text
	local v5 = if module5 then useTokens() else nil

	return withStyle(function(p2)
		local v6 = if module5 then normalizeFontFace(v5.Typography.BodyLarge.Font) else p2.Font.Body.Font

		if data.useBold == true then
			if module5 then
				v6 = normalizeFontFace(v5.Typography.HeadingSmall.Font)
			else
				v6 = p2.Font.Header1.Font
			end
		end

		local color = p2.Theme.TextDefault.Color

		if data.useEmphasis == true then
			color = p2.Theme.TextEmphasis.Color
		end

		local relativeSize = p2.Font.Body.RelativeSize

		if data.size == module6.Header1 then
			relativeSize = p2.Font.Header1.RelativeSize
		elseif data.size == module6.Footer then
			relativeSize = p2.Font.Footer.RelativeSize
		end

		local v7 = Enum.TextXAlignment.Center

		if data.alignLeft == true then
			v7 = Enum.TextXAlignment.Left
		end

		local v8 = if contentWidth == 0 or contentWidth == nil then Enum.AutomaticSize.X else nil

		return module.createElement(fitTextLabel, {
			BackgroundTransparency = 1,
			width = fitTextLabel.Width.FitToText,
			maximumWidth = contentWidth,
			Font = v6,
			LayoutOrder = layoutOrder or nil,
			RichText = richText,
			AutomaticSize = v8,
			Text = text,
			TextColor3 = color,
			TextSize = relativeSize * p2.Font.BaseSize,
			TextTransparency = p2.Theme.TextDefault.Transparency,
			TextWrapped = true,
			TextXAlignment = v7,
			AnchorPoint = Vector2.new(0, 0),
			onActivated = data.onActivated
		})
	end)
end

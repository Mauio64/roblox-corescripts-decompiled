local parent = script.Parent
local parent2 = parent.Parent.Parent
local style = parent2.App.Style
local Roact = require(parent2.Parent.Roact)
local t = require(parent2.Parent.t)
local validateStyle = require(style.Validator.validateStyle)
local StyleContext = require(parent.StyleContext)
local getTextSizeOffset = require(parent2.Utility.getTextSizeOffset)

require(style.StyleTypes)
local Themes = require(style.Themes)
local Constants = require(style.Constants)
local getFontFromName = require(style.Fonts.getFontFromName)
local Tokens = require(style.Tokens)

local getTokens = Tokens.getTokens
local getFoundationTokens = Tokens.getFoundationTokens
local Mappers = Tokens.Mappers

local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local GetEngineFeatureSafe = require(parent3.UIBlox.Core.Utility.GetEngineFeatureSafe)
local engineFeatureSafe = GetEngineFeatureSafe("EnablePreferredTextSizeSetting")

local extended = Roact.Component:extend("StyleProvider")

extended.validateProps = t.strictInterface({
	style = t.optional(validateStyle),
	derivedValues = t.optional(t.table),
	[Roact.Children] = t.table
})

local v = { Theme = Themes.DarkTheme, Settings = 0 }
local preferredTextSize

if engineFeatureSafe then
	preferredTextSize = Enum.PreferredTextSize.Medium
end

v.Settings = {
	PreferredTransparency = 1,
	ReducedMotion = false,
	PreferredTextSize = preferredTextSize,
	Scale = 1
}

local v2 = { textSizeOffset = 0 }

function extended.init(object)
	object:setState({ style = object.props.style, derivedValues = object.props.derivedValues })
end

function extended:updateTextSizeOffset(p)
	local textSizeOffset, textSizeOffset2 = getTextSizeOffset(p)

	if textSizeOffset then
		self:setState({
			derivedValues = { textSizeOffset = textSizeOffset2 }
		})
	end
end

function extended:didUpdate(_, p)
	if p.style and p.style.Settings.PreferredTextSize ~= self.state.style.Settings.PreferredTextSize then
		self:updateTextSizeOffset(self.state.style.Font.Body.Font)
	end
end

function extended.render(props)
	local style2 = Object.assign({}, v, props.state.style)
	local derivedValues = Object.assign({}, v2, props.state.derivedValues)

	if style2.Tokens == nil then
		local v3

		if style2.Theme == Themes.LightTheme then
			v3 = Constants.ThemeName.Light
		else
			v3 = Constants.ThemeName.Dark
		end

		local defaultDeviceType = Constants.DefaultDeviceType
		local scale = style2.Settings.Scale

		local tokens = getTokens(defaultDeviceType, v3, scale)
		local foundationTokens = getFoundationTokens(defaultDeviceType, v3, scale)
		local mapColorTokensToFoundation = Mappers.mapColorTokensToFoundation(tokens, foundationTokens)
		style2.Theme = Mappers.mapThemeToFoundation(style2.Theme, foundationTokens)
		style2.Tokens = Mappers.addFoundationFlatKeys(mapColorTokensToFoundation, foundationTokens)
	end

	if style2.Font == nil then
		style2.Font = getFontFromName(Constants.FontName.Gotham, style2.Tokens)
	end

	return Roact.createElement(StyleContext.Provider, {
		value = {
			style = style2,
			update = function(_, style3)
				if props.mounted then
					props:setState({ style = style3 })
				end
			end,
			derivedValues = derivedValues
		}
	}, Roact.oneChild(props.props[Roact.Children]))
end

function extended:didMount()
	self.mounted = true
end

function extended:willUnmount()
	self.mounted = false
end

return extended

local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local AppStyle = ParentParent.App.Style
local Roact = require(ParentParent.Parent.Roact)
local t = require(ParentParent.Parent.t)
local validateStyle = require(AppStyle.Validator.validateStyle)
local StyleContext = require(scriptParent.StyleContext)
local getTextSizeOffset = require(ParentParent.Utility.getTextSizeOffset)

require(AppStyle.StyleTypes)

local Themes = require(AppStyle.Themes)
local Constants = require(AppStyle.Constants)
local getFontFromName = require(AppStyle.Fonts.getFontFromName)
local Tokens = require(AppStyle.Tokens)
local getTokens = Tokens.getTokens
local getFoundationTokens = Tokens.getFoundationTokens
local Mappers = Tokens.Mappers
local ParentParentParent = ParentParent.Parent
local Object = require(ParentParentParent.LuauPolyfill).Object
local v18 = require(ParentParentParent.UIBlox.Core.Utility.GetEngineFeatureSafe)("EnablePreferredTextSizeSetting")
local v19 = Roact.Component:extend("StyleProvider")

v19.validateProps = t.strictInterface({
	style = t.optional(validateStyle),
	derivedValues = t.optional(t.table),
	[Roact.Children] = t.table
})

local t1 = {
	Theme = Themes.DarkTheme,
	Settings = {
		PreferredTransparency = 1,
		ReducedMotion = false,
		Scale = 1,
		PreferredTextSize = if not v18 then nil else Enum.PreferredTextSize.Medium
	}
}
local t2 = {
	textSizeOffset = 0
}

function v19.init(p1) -- line: 54
	p1:setState({
		style = p1.props.style,
		derivedValues = p1.props.derivedValues
	})
end
function v19.updateTextSizeOffset(p2, p3) -- line: 63
	-- upvalues: getTextSizeOffset (copy)
	local v25, v26 = getTextSizeOffset(p3)

	if v25 then
		p2:setState({
			derivedValues = {
				textSizeOffset = v26
			}
		})
	end
end
function v19.didUpdate(p4, _, p6) -- line: 74
	if p6.style and p6.style.Settings.PreferredTextSize ~= p4.state.style.Settings.PreferredTextSize then
		p4:updateTextSizeOffset(p4.state.style.Font.Body.Font)
	end
end
function v19.render(p7) -- line: 83
	-- upvalues: Object (copy), t1 (copy), t2 (copy), Themes (copy), Constants (copy), getTokens (copy), getFoundationTokens (copy), Mappers (copy), getFontFromName (copy), Roact (copy), StyleContext (copy)
	local v31 = Object.assign({}, t1, p7.state.style)
	local v32 = Object.assign({}, t2, p7.state.derivedValues)

	if v31.Tokens == nil then
		local v33 = if v31.Theme ~= Themes.LightTheme then Constants.ThemeName.Dark else Constants.ThemeName.Light
		local DefaultDeviceType = Constants.DefaultDeviceType
		local SettingsScale = v31.Settings.Scale
		local v36 = getTokens(DefaultDeviceType, v33, SettingsScale)
		local v37 = getFoundationTokens(DefaultDeviceType, v33, SettingsScale)
		local v38 = Mappers.mapColorTokensToFoundation(v36, v37)

		v31.Theme = Mappers.mapThemeToFoundation(v31.Theme, v37)
		v31.Tokens = Mappers.addFoundationFlatKeys(v38, v37)
	end

	if v31.Font == nil then
		v31.Font = getFontFromName(Constants.FontName.Gotham, v31.Tokens)
	end

	local t3 = {
		style = v31,
		update = function(_, p9) -- line: 108
			-- upvalues: p7 (copy)
			if p7.mounted then
				p7:setState({
					style = p9
				})
			end
		end,
		derivedValues = v32
	}

	return Roact.createElement(StyleContext.Provider, {
		value = t3
	}, Roact.oneChild(p7.props[Roact.Children]))
end
function v19.didMount(p10) -- line: 121
	p10.mounted = true
end
function v19.willUnmount(p11) -- line: 125
	p11.mounted = false
end

return v19

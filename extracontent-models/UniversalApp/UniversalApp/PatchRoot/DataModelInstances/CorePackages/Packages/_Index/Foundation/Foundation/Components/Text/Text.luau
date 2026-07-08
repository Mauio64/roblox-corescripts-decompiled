local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local Interactable = require(Foundation.Components.Interactable)
local GuiObjectChildren = require(Foundation.Utility.GuiObjectChildren)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)
local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local FontScales = require(script.Parent.FontScales)
local t1 = {
	AutoLocalize = false,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	isDisabled = false
}

local function Text(p1, p2) -- line: 50
	-- upvalues: withDefaults (copy), t1 (copy), useDefaultTags (copy), useStyleTags (copy), React (copy), ReactIs (copy), FontScales (copy), withGuiObjectProps (copy), indexBindable (copy), Interactable (copy), GuiObjectChildren (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = v17.onStateChanged ~= nil or (v17.onActivated ~= nil or v17.onSecondaryActivated ~= nil)
	local v19 = v17.backgroundStyle == nil and "gui-object-defaults text-defaults text-size-defaults text-color-defaults" or "gui-object-defaults text-defaults text-size-defaults text-color-defaults x-default-transparency"

	if v17.fontStyle and v17.fontStyle.FontSize then
		v19 ..= " x-default-text-size"
	end

	local v20 = useDefaultTags(v17.tag, v19)
	local v21 = useStyleTags(v20)
	local v22 = React.useMemo(function() -- line: 63
		-- upvalues: v17 (copy), ReactIs (copy)
		local v27 = if v17.fontStyle == nil then nil else v17.fontStyle.Font

		if typeof(v27) == "table" and not ReactIs.isBinding(v27) then
			return Font.new(v27.Family, v27.Weight, v27.Style)
		end

		if typeof(v27) == "EnumItem" then
			return Font.fromEnum(v27)
		end

		return v27
	end, { v17.fontStyle })
	local v23 = React.useMemo(function() -- line: 77
		-- upvalues: v17 (copy), v22 (copy), ReactIs (copy), FontScales (copy)
		if v17.fontStyle == nil or (v17.fontStyle.LineHeight == nil or v17.fontStyle.FontSize == nil or v22 == nil) then
			return 0
		end

		local v28 = FontScales[if not ReactIs.isBinding(v22) then v22.Family else v22:getValue().Family]

		if v28 == nil then
			return 0
		end

		return (v17.fontStyle.FontSize / v28 * (v17.fontStyle.LineHeight * v28) - v17.fontStyle.FontSize) / 2
	end, {
		v22,
		v17.fontStyle
	})

	if v17.padding == nil and v23 ~= 0 then
		v17.padding = Vector2.new(0, v23)
	end

	local v24 = not v18 and "TextLabel" or "TextButton"
	local v25 = withGuiObjectProps(v17, {
		AutoButtonColor = if v24 ~= "TextButton" then nil else v17.AutoButtonColor,
		FontFace = v22,
		LineHeight = if v17.fontStyle == nil then nil else v17.fontStyle.LineHeight,
		RichText = v17.RichText,
		Text = v17.Text,
		TextColor3 = if not v17.textStyle then nil else indexBindable(v17.textStyle, "Color3"),
		TextTransparency = if not v17.textStyle then nil else indexBindable(v17.textStyle, "Transparency"),
		TextDirection = v17.TextDirection,
		TextScaled = v17.TextScaled,
		TextSize = if v17.fontStyle == nil then nil else v17.fontStyle.FontSize,
		TextTruncate = v17.TextTruncate,
		TextWrapped = v17.TextWrapped,
		TextXAlignment = v17.TextXAlignment,
		TextYAlignment = v17.TextYAlignment,
		ref = p2,
		[React.Tag] = v21
	})
	local v26 = v24

	if v18 then
		v26 = Interactable
		v25.component = v24
		v25.onActivated = v17.onActivated
		v25.onSecondaryActivated = v17.onSecondaryActivated
		v25.onStateChanged = v17.onStateChanged
		v25.stateLayer = v17.stateLayer
		v25.isDisabled = v17.isDisabled
		v25.cursor = v17.cursor
	end

	return React.createElement(v26, v25, GuiObjectChildren(v17))
end

return React.memo(React.forwardRef(Text))

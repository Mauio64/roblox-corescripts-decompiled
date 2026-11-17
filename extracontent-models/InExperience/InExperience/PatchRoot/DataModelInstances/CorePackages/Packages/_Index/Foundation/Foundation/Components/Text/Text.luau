local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Interactable = require(Foundation.Components.Interactable)

local GuiObjectChildren = require(Foundation.Utility.GuiObjectChildren)
require(Foundation.Components.Types)
local indexBindable = require(Foundation.Utility.indexBindable)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)

local useStyleTags = require(Foundation.Providers.Style.useStyleTags)

local FontScales = require(script.Parent.FontScales)

local v = { AutoLocalize = false, AutoButtonColor = false, BorderSizePixel = 0, isDisabled = false }

local function Text(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = v2.onStateChanged ~= nil or v2.onActivated ~= nil or v2.onSecondaryActivated ~= nil

	local v4 = v2.backgroundStyle == nil
		and "gui-object-defaults text-defaults text-size-defaults text-color-defaults"
		or "gui-object-defaults text-defaults text-size-defaults text-color-defaults x-default-transparency"

	if v2.fontStyle and v2.fontStyle.FontSize then
		v4 ..= " x-default-text-size"
	end

	local v5 = useStyleTags((useDefaultTags(v2.tag, v4)))

	local fontFace = React.useMemo(function()
		local v6

		if v2.fontStyle ~= nil then
			v6 = v2.fontStyle.Font
		end

		return normalizeFontFace(v6)
	end, { v2.fontStyle })

	local v6 = React.useMemo(function()
		if v2.fontStyle == nil or v2.fontStyle.LineHeight == nil or v2.fontStyle.FontSize == nil or fontFace == nil then
			return 0
		end

		local v6

		if ReactIs.isBinding(fontFace) then
			v6 = fontFace:getValue().Family
		else
			v6 = fontFace.Family
		end

		local fontScale = FontScales[v6]

		if fontScale == nil then
			return 0
		end

		return (v2.fontStyle.FontSize / fontScale * (v2.fontStyle.LineHeight * fontScale) - v2.fontStyle.FontSize) / 2
	end, { fontFace, v2.fontStyle })

	if v2.padding == nil and v6 ~= 0 then
		v2.padding = Vector2.new(0, v6)
	end

	local component = v3 and "TextButton" or "TextLabel"
	local autoButtonColor

	if component == "TextButton" then
		autoButtonColor = v2.AutoButtonColor
	end

	local v7 = {
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		AutoButtonColor = autoButtonColor,
		FontFace = fontFace
	}
	local lineHeight

	if v2.fontStyle ~= nil then
		lineHeight = v2.fontStyle.LineHeight
	end

	v7.LineHeight = lineHeight
	v7.OpenTypeFeatures = v2.OpenTypeFeatures
	v7.RichText = v2.RichText
	v7.Text = v2.Text
	local textColor

	if v2.textStyle then
		textColor = indexBindable(v2.textStyle, "Color3")
	end

	v7.TextColor3 = textColor
	local textTransparency

	if v2.textStyle then
		textTransparency = indexBindable(v2.textStyle, "Transparency")
	end

	v7.TextTransparency = textTransparency
	v7.TextDirection = v2.TextDirection
	v7.TextScaled = v2.TextScaled
	local textSize

	if v2.fontStyle ~= nil then
		textSize = v2.fontStyle.FontSize
	end

	v7.TextSize = textSize
	v7.TextTruncate = v2.TextTruncate
	v7.TextWrapped = v2.TextWrapped
	v7.TextXAlignment = v2.TextXAlignment
	v7.TextYAlignment = v2.TextYAlignment

	v7.ref = ref
	v7[React.Tag] = v5
	local v8 = withGuiObjectProps(v2, v7)
	local v9

	if v3 then
		v9 = Interactable
		v8.component = component
		v8.onActivated = v2.onActivated
		v8.onSecondaryActivated = v2.onSecondaryActivated
		v8.onStateChanged = v2.onStateChanged
		v8.stateLayer = v2.stateLayer
		v8.isDisabled = v2.isDisabled
		v8.cursor = v2.cursor
	else
		v9 = component
	end

	return React.createElement(v9, v8, GuiObjectChildren(v2))
end

return React.memo(React.forwardRef(Text))

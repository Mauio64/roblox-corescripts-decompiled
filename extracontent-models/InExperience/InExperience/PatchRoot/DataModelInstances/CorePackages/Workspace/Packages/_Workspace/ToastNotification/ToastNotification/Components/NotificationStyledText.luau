local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local useStyle = dependencies.UIBlox.Core.Style.useStyle
require(parent.type)

local react = dependencies.React
local Foundation = require(parent2.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local v = {
	highlight = function(p: string)
		return "<b>" .. p .. "</b>"
	end
}

local function formatString(text)
	local text2 = text.text
	local styledElements = text.styledElements

	local v2 = {
		{ Position = 0, ReferenceCount = 0, Format = "highlight" },
		{
			Position = #text.text,
			ReferenceCount = 0,
			Format = "highlight"
		}
	}

	if styledElements then
		for _, styledElement in pairs(styledElements) do
			table.insert(v2, {
				Position = styledElement.offset,
				ReferenceCount = 1,
				Format = styledElement.styledElementType
			})

			table.insert(v2, {
				Position = styledElement.offset + styledElement.length,
				ReferenceCount = -1,
				Format = styledElement.styledElementType
			})
		end
	end

	table.sort(v2, function(a, b): boolean
		return a.Position < b.Position
	end)

	local v3 = {}

	for k in pairs(v) do
		v3[k] = 0
	end

	local v4 = ""

	for i = 1, #v2 - 1 do
		local v5 = v2[i]
		local v6 = v2[i + 1]

		if v5.Format then
			local format = v5.Format
			v3[format] += v5.ReferenceCount
		end

		if v5.Position == v6.Position then
			continue
		end

		local v7 = text2:sub(v5.Position + 1, v6.Position)

		for k, v8 in pairs(v) do
			if v3[k] > 0 then
				v7 = v8(v7)
			end
		end

		v4 ..= v7
	end

	return v4
end

return function(props)
	local v2 = useStyle()
	local text = not props.Text and "" or formatString(props.Text)

	local createElement = react.createElement
	local v3 = {
		RichText = true,
		Text = text,
		BackgroundTransparency = 1,
		TextColor3 = props.TextColor3 or v2.Theme.TextDefault.Color,
		TextTransparency = props.TextTransparency or v2.Theme.TextDefault.Transparency,
		Font = 0,
		FontFace = 0,
		AutomaticSize = 0,
		Size = 0,
		TextSize = 0,
		Position = 0,
		AnchorPoint = 0,
		TextXAlignment = 0,
		TextTruncate = 0,
		TextWrapped = true
	}
	local font

	if not (FoundationFontFaceMigration and props.FontFace) then
		font = props.Font or v2.Font.Body.Font
	end

	v3.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = props.FontFace
	end

	v3.FontFace = fontFace

	v3.AutomaticSize = props.AutomaticSize
	v3.Size = props.Size
	v3.TextSize = props.TextSize
	v3.Position = props.Position
	v3.AnchorPoint = props.AnchorPoint
	v3.TextXAlignment = props.TextXAlignment
	v3.TextTruncate = Enum.TextTruncate.AtEnd
	local uiSizeConstraint

	if props.MaxSize then
		uiSizeConstraint = react.createElement("UISizeConstraint", { MaxSize = props.MaxSize })
	end

	return createElement("TextLabel", v3, { UISizeConstraint = uiSizeConstraint })
end

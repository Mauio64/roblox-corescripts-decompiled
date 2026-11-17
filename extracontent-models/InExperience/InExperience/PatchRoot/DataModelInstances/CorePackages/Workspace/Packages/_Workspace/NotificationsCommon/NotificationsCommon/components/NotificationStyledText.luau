local parent = script:FindFirstAncestor("NotificationsCommon").Parent
local parent2 = script.Parent.Parent
local dependencies = require(parent2.dependencies)
local useStyle = dependencies.UIBlox.Core.Style.useStyle
require(parent2.type)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local react = dependencies.React
require(parent.Foundation)

local defineFastFlag = game:DefineFastFlag("EnableNotificationStyledTextUtf16Offsets", false)

local v = {
	highlight = function(p: string)
		return "<b>" .. p .. "</b>"
	end,
	warning = function(p: string)
		return "<b>" .. p .. "</b>"
	end
}

function utf8Sub(value: string, p: number, p2: number)
	local v2 = utf8.offset(value, p)
	local v3 = utf8.offset(value, p2 + 1)

	if v2 == nil or v3 == nil then
		return (string.sub(value, p, p2))
	end

	return (string.sub(value, v2, v3 - 1))
end

local function utf16IndexToCodepointIndex(text: string, p: number)
	local total = 0
	local count = 0

	for _, v2 in utf8.codes(text) do
		if p <= total then
			break
		end

		total += v2 > 65535 and 2 or 1
		count += 1
	end

	return count
end

local function formatString(text)
	if defineFastFlag then
		local text2 = text.text
		local position = utf8.len(text2)

		if position == nil then
			return text2
		end

		local styledElements = text.styledElements

		local v2 = {
			{ Position = 0, ReferenceCount = 0, Format = "highlight" },
			{ Position = position, ReferenceCount = 0, Format = "highlight" }
		}

		if styledElements then
			for _, styledElement in pairs(styledElements) do
				table.insert(v2, {
					Position = utf16IndexToCodepointIndex(text2, styledElement.offset),
					ReferenceCount = 1,
					Format = styledElement.styledElementType
				})

				table.insert(v2, {
					Position = utf16IndexToCodepointIndex(text2, styledElement.offset + styledElement.length),
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

			local v7 = utf8Sub(text2, v5.Position + 1, v6.Position)

			for k, v8 in pairs(v) do
				if v3[k] > 0 then
					v7 = v8(v7)
				end
			end

			v4 ..= v7
		end

		return Text.Trim(v4)
	else
		local v2 = text.text .. " "
		local styledElements = text.styledElements

		local v3 = {
			{ Position = 0, ReferenceCount = 0, Format = "highlight" },
			{ Position = utf8.len(text.text), ReferenceCount = 0, Format = "highlight" }
		}

		if styledElements then
			for _, styledElement in pairs(styledElements) do
				table.insert(v3, {
					Position = styledElement.offset,
					ReferenceCount = 1,
					Format = styledElement.styledElementType
				})

				table.insert(v3, {
					Position = styledElement.offset + styledElement.length,
					ReferenceCount = -1,
					Format = styledElement.styledElementType
				})
			end
		end

		table.sort(v3, function(a, b): boolean
			return a.Position < b.Position
		end)

		local v4 = {}

		for k in pairs(v) do
			v4[k] = 0
		end

		local v5 = ""

		for i = 1, #v3 - 1 do
			local v6 = v3[i]
			local v7 = v3[i + 1]

			if v6.Format then
				local format = v6.Format
				v4[format] += v6.ReferenceCount
			end

			if v6.Position == v7.Position then
				continue
			end

			local v8 = utf8Sub(v2, v6.Position + 1, v7.Position)

			for k, v9 in pairs(v) do
				if v4[k] > 0 then
					v8 = v9(v8)
				end
			end

			v5 ..= v8
		end

		return Text.Trim(v5)
	end
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
		TextWrapped = true,
		LayoutOrder = 0
	}
	local font

	if not props.FontFace then
		font = props.Font or v2.Font.Body.Font
	end

	v3.Font = font
	v3.FontFace = props.FontFace

	v3.AutomaticSize = props.AutomaticSize
	v3.Size = props.Size
	v3.TextSize = props.TextSize
	v3.Position = props.Position
	v3.AnchorPoint = props.AnchorPoint
	v3.TextXAlignment = props.TextXAlignment

	v3.LayoutOrder = props.LayoutOrder
	return createElement("TextLabel", v3)
end

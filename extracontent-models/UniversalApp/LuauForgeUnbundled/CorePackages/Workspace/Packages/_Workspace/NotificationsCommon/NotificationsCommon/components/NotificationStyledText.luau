local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local useStyle = dependencies.UIBlox.Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/AppCommonLib").Text

local react = dependencies.React
require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Foundation")

local defineFastFlag = game:DefineFastFlag("EnableNotificationStyledTextUtf16Offsets", false)

local v5 = {
	highlight = function(p2)
		return "<b>" .. p2 .. "</b>"
	end,
	warning = function(self)
		return "<b>" .. self .. "</b>"
	end
}

function LUAUFORGE_MODULE_GLOBALS_cHW_utf8Sub(value, p2, p3)
	local v6 = utf8.offset(value, p2)
	local v7 = utf8.offset(value, p3 + 1)

	if v6 == nil or v7 == nil then
		return (string.sub(value, p2, p3))
	end

	return (string.sub(value, v6, v7 - 1))
end

local function utf16IndexToCodepointIndex(text2, p2)
	local total = 0
	local count = 0

	for k, v6 in utf8.codes(text2) do
		if p2 <= total then
			break
		end

		total += v6 > 65535 and 2 or 1
		count += 1
	end

	return count
end

local function formatString(text2)
	if defineFastFlag then
		local text3 = text2.text
		local v6 = utf8.len(text3)

		if v6 == nil then
			return text3
		end

		local styledElements = text2.styledElements
		local v7 = {
			{ Position = 0, ReferenceCount = 0, Format = "highlight" },
			{ Position = v6, ReferenceCount = 0, Format = "highlight" }
		}

		if styledElements then
			for k, styledElement in pairs(styledElements) do
				table.insert(v7, {
					Position = utf16IndexToCodepointIndex(text3, styledElement.offset),
					ReferenceCount = 1,
					Format = styledElement.styledElementType
				})

				table.insert(v7, {
					Position = utf16IndexToCodepointIndex(
						text3,
						styledElement.offset + styledElement.length
					),
					ReferenceCount = -1,
					Format = styledElement.styledElementType
				})
			end
		end

		table.sort(v7, function(a, b): boolean
			return a.Position < b.Position
		end)

		local v8 = {}

		for k in pairs(v5) do
			v8[k] = 0
		end

		local v9 = ""

		for i = 1, #v7 - 1 do
			local v10 = v7[i]
			local v11 = v7[i + 1]

			if v10.Format then
				local format = v10.Format
				v8[format] += v10.ReferenceCount
			end

			if v10.Position == v11.Position then
				continue
			end

			local v12 = LUAUFORGE_MODULE_GLOBALS_cHW_utf8Sub(text3, v10.Position + 1, v11.Position)

			for k, v13 in pairs(v5) do
				if v8[k] > 0 then
					v12 = v13(v12)
				end
			end

			v9 ..= v12
		end

		return text.Trim(v9)
	else
		local v6 = text2.text .. " "
		local styledElements = text2.styledElements

		local v7 = {
			{ Position = 0, ReferenceCount = 0, Format = "highlight" },
			{
				Position = utf8.len(text2.text),
				ReferenceCount = 0,
				Format = "highlight"
			}
		}

		if styledElements then
			for k, styledElement in pairs(styledElements) do
				table.insert(v7, {
					Position = styledElement.offset,
					ReferenceCount = 1,
					Format = styledElement.styledElementType
				})

				table.insert(v7, {
					Position = styledElement.offset + styledElement.length,
					ReferenceCount = -1,
					Format = styledElement.styledElementType
				})
			end
		end

		table.sort(v7, function(a, b): boolean
			return a.Position < b.Position
		end)

		local v8 = {}

		for k in pairs(v5) do
			v8[k] = 0
		end

		local v9 = ""

		for i = 1, #v7 - 1 do
			local v10 = v7[i]
			local v11 = v7[i + 1]

			if v10.Format then
				local format = v10.Format
				v8[format] += v10.ReferenceCount
			end

			if v10.Position == v11.Position then
				continue
			end

			local v12 = LUAUFORGE_MODULE_GLOBALS_cHW_utf8Sub(v6, v10.Position + 1, v11.Position)

			for k, v13 in pairs(v5) do
				if v8[k] > 0 then
					v12 = v13(v12)
				end
			end

			v9 ..= v12
		end

		return text.Trim(v9)
	end
end

return function(props)
	local v6 = useStyle()
	local v7 = not props.Text and "" or formatString(props.Text)

	local createElement = react.createElement
	local v9 = {
		RichText = true,
		Text = v7,
		BackgroundTransparency = 1,
		TextColor3 = props.TextColor3 or v6.Theme.TextDefault.Color,
		TextTransparency = props.TextTransparency or v6.Theme.TextDefault.Transparency,
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
	local v10 = if not props.FontFace then props.Font or v6.Font.Body.Font else nil
	v9.Font = v10
	v9.FontFace = props.FontFace

	v9.AutomaticSize = props.AutomaticSize
	v9.Size = props.Size
	v9.TextSize = props.TextSize
	v9.Position = props.Position
	v9.AnchorPoint = props.AnchorPoint
	v9.TextXAlignment = props.TextXAlignment

	v9.LayoutOrder = props.LayoutOrder
	return createElement("TextLabel", v9)
end

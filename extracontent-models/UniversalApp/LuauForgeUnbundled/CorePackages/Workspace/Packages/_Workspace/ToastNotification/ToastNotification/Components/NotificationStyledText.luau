local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local useStyle = dependencies.UIBlox.Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")

local react = dependencies.React
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")

local v5 = {
	highlight = function(p2)
		return "<b>" .. p2 .. "</b>"
	end
}

local function formatString(text)
	local text2 = text.text
	local styledElements = text.styledElements
	local v6 = {
		{ Position = 0, ReferenceCount = 0, Format = "highlight" },
		{
			Position = #text.text,
			ReferenceCount = 0,
			Format = "highlight"
		}
	}

	if styledElements then
		for k, styledElement in pairs(styledElements) do
			table.insert(v6, {
				Position = styledElement.offset,
				ReferenceCount = 1,
				Format = styledElement.styledElementType
			})

			table.insert(v6, {
				Position = styledElement.offset + styledElement.length,
				ReferenceCount = -1,
				Format = styledElement.styledElementType
			})
		end
	end

	table.sort(v6, function(a, b): boolean
		return a.Position < b.Position
	end)

	local v7 = {}

	for k in pairs(v5) do
		v7[k] = 0
	end

	local v8 = ""

	for i = 1, #v6 - 1 do
		local v9 = v6[i]
		local v10 = v6[i + 1]

		if v9.Format then
			local format = v9.Format
			v7[format] += v9.ReferenceCount
		end

		if v9.Position == v10.Position then
			continue
		end

		local v11 = text2:sub(v9.Position + 1, v10.Position)

		for k, v12 in pairs(v5) do
			if v7[k] > 0 then
				v11 = v12(v11)
			end
		end

		v8 ..= v11
	end

	return v8
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
		TextTruncate = 0,
		TextWrapped = true
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
	v9.TextTruncate = Enum.TextTruncate.AtEnd

	local v12 = if props.MaxSize then react.createElement("UISizeConstraint", {
		MaxSize = props.MaxSize
	}) else nil
	return createElement("TextLabel", v9, { UISizeConstraint = v12 })
end

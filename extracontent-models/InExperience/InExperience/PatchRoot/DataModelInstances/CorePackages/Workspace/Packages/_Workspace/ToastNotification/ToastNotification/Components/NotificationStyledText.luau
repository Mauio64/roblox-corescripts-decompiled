local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local useStyle = dependencies.UIBlox.Core.Style.useStyle

require(ParentParent.type)

local React = dependencies.React
local t1 = {
	highlight = function(s1: string) -- line: 44
		return "<b>" .. s1 .. "</b>"
	end
}

local function formatString(p1) -- line: 49
	-- upvalues: t1 (copy)
	local text = p1.text
	local styledElements = p1.styledElements
	local t2 = {
		{
			Position = 0,
			ReferenceCount = 0,
			Format = "highlight"
		},
		{
			ReferenceCount = 0,
			Format = "highlight",
			Position = #p1.text
		}
	}

	if styledElements then
		for _, v in pairs(styledElements) do
			table.insert(t2, {
				ReferenceCount = 1,
				Position = v.offset,
				Format = v.styledElementType
			})
			table.insert(t2, {
				ReferenceCount = -1,
				Position = v.offset + v.length,
				Format = v.styledElementType
			})
		end
	end

	table.sort(t2, function(p2, p3) -- line: 84
		return p2.Position < p3.Position
	end)

	local t3 = {}

	for k in pairs(t1) do
		t3[k] = 0
	end

	local s2 = ""

	for i = 1, #t2 - 1 do
		local v18 = t2[i]
		local v19 = t2[i + 1]

		if v18.Format then
			local Format = v18.Format

			t3[Format] = t3[Format] + v18.ReferenceCount
		end

		if v18.Position ~= v19.Position then
			local v21 = text:sub(v18.Position + 1, v19.Position)

			for k, v in pairs(t1) do
				if t3[k] > 0 then
					v21 = v(v21)
				end
			end

			s2 ..= v21
		end
	end

	return s2
end

return function(t4: {[any]: any}) -- line: 115
	-- upvalues: useStyle (copy), formatString (copy), React (copy)
	local v25 = useStyle()
	local v26 = not t4.Text and "" or formatString(t4.Text)

	return React.createElement("TextLabel", {
		RichText = true,
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = v26,
		TextColor3 = t4.TextColor3 or v25.Theme.TextDefault.Color,
		TextTransparency = t4.TextTransparency or v25.Theme.TextDefault.Transparency,
		Font = t4.Font or v25.Font.Body.Font,
		AutomaticSize = t4.AutomaticSize,
		Size = t4.Size,
		TextSize = t4.TextSize,
		Position = t4.Position,
		AnchorPoint = t4.AnchorPoint,
		TextXAlignment = t4.TextXAlignment,
		TextTruncate = Enum.TextTruncate.AtEnd
	}, {
		UISizeConstraint = if not t4.MaxSize then nil else React.createElement("UISizeConstraint", {
			MaxSize = t4.MaxSize
		})
	})
end

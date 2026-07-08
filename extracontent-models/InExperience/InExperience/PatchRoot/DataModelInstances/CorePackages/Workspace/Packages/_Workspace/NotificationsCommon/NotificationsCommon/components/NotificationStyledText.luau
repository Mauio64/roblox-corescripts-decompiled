local Parent = script:FindFirstAncestor("NotificationsCommon").Parent
local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local useStyle = dependencies.UIBlox.Core.Style.useStyle

require(ParentParent.type)

local Text = require(Parent.AppCommonLib).Text
local React = dependencies.React
local t1 = {
	highlight = function(s1: string) -- line: 49
		return "<b>" .. s1 .. "</b>"
	end,
	warning = function(s2: string) -- line: 52
		return "<b>" .. s2 .. "</b>"
	end
}

function utf8Sub(s3: string, n1: number, n2: number) -- line: 57
	local v14 = utf8.offset(s3, n1)
	local v15 = utf8.offset(s3, n2 + 1)

	if v14 == nil or v15 == nil then
		return (string.sub(s3, n1, n2))
	end

	return (string.sub(s3, v14, v15 - 1))
end

local function formatString(p1) -- line: 66
	-- upvalues: t1 (copy), Text (copy)
	local v17 = p1.text .. " "
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
			Position = utf8.len(p1.text)
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

	table.sort(t2, function(p2, p3) -- line: 101
		return p2.Position < p3.Position
	end)

	local t3 = {}

	for k in pairs(t1) do
		t3[k] = 0
	end

	local s4 = ""

	for i = 1, #t2 - 1 do
		local v26 = t2[i]
		local v27 = t2[i + 1]

		if v26.Format then
			local Format = v26.Format

			t3[Format] = t3[Format] + v26.ReferenceCount
		end

		if v26.Position ~= v27.Position then
			local v29 = utf8Sub(v17, v26.Position + 1, v27.Position)

			for k, v in pairs(t1) do
				if t3[k] > 0 then
					v29 = v(v29)
				end
			end

			s4 ..= v29
		end
	end

	return Text.Trim(s4)
end

return function(t4: {[any]: any}) -- line: 132
	-- upvalues: useStyle (copy), formatString (copy), React (copy)
	local v33 = useStyle()
	local v34 = not t4.Text and "" or formatString(t4.Text)

	return React.createElement("TextLabel", {
		RichText = true,
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = v34,
		TextColor3 = t4.TextColor3 or v33.Theme.TextDefault.Color,
		TextTransparency = t4.TextTransparency or v33.Theme.TextDefault.Transparency,
		Font = t4.Font or v33.Font.Body.Font,
		AutomaticSize = t4.AutomaticSize,
		Size = t4.Size,
		TextSize = t4.TextSize,
		Position = t4.Position,
		AnchorPoint = t4.AnchorPoint,
		TextXAlignment = t4.TextXAlignment,
		LayoutOrder = t4.LayoutOrder
	})
end

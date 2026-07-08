local Parent = script:FindFirstAncestor("MarkdownCore").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local Foundation = require(Parent.Foundation)
local map = Dash.map
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local t1 = {
	ItemOffset = 12,
	MarkerImage = "rbxasset://textures/StudioSharedUI/dot.png",
	MarkerSize = 4,
	Padding = 6,
	LineHeight = 18,
	TextSize = 18,
	ItemIndentation = 0,
	Font = Enum.Font.BuilderSans,
	TextColor = Color3.fromRGB(0, 0, 0),
	SubItemStyle = {
		ItemIndentation = 20,
		ItemOffset = 12
	}
}

local function calculateItemOffset(n1: number, n2: number) -- line: 57
	return n2 + n1
end
local function isOrdered(s1: string?) -- line: 98
	return s1 and (not s1:find("^*") and not s1:find("^-"))
end
local function BulletList(t2: {[any]: any}) -- line: 102
	-- upvalues: Foundation (copy), t1 (copy), map (copy), React (copy), FoundationText (copy), View (copy), FoundationImage (copy), Dash (copy)
	local v17 = Foundation.Hooks.useTokens()
	local TextWrapped = t2.TextWrapped
	local TextTruncate = t2.TextTruncate
	local v20 = t2.ListStyle or t1
	local Items = t2.Items
	local v22 = v20.ItemIndentation or t1.ItemIndentation
	local Small = v17.Gap.Small
	local v24 = (v20.MarkerSize or t1.MarkerSize) + Small
	local uDim2 = UDim2.new(1, -v24, 0, 0)
	local v26 = map(Items, function(p1, n3: number) -- line: 116
		-- upvalues: v22 (copy), v20 (copy), t1 (copy), React (copy), FoundationText (copy), uDim2 (copy), TextTruncate (copy), TextWrapped (copy), View (copy), FoundationImage (copy)
		local v32 = v22
		local v33 = v20.MarkerImage or t1.MarkerImage
		local v34 = nil
		local Prefix = nil
		local v36

		if type(p1) == "string" then
			v36 = React.createElement(FoundationText, {
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = v20.Font or t1.Font,
				Size = uDim2,
				Text = p1,
				TextColor = v20.TextColor or t1.TextColor,
				TextSize = v20.TextSize or t1.TextSize,
				TextTruncate = TextTruncate,
				TextWrapped = TextWrapped,
				Padding = v20.Padding or t1.Padding,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		elseif typeof(p1) == "table" and p1.Text then
			Prefix = p1.Prefix

			local SubItemStyle = v20.SubItemStyle
			local uDim2_2 = UDim2.new(1, -SubItemStyle.ItemOffset or t1.SubItemStyle.ItemOffset, 0, 0)
			local v39 = SubItemStyle.ItemIndentation or v32

			v33 = SubItemStyle.MarkerStyle or v33

			if v39 then
				v34 = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v39)
				})
			end

			v36 = React.createElement(FoundationText, {
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = uDim2_2,
				textStyle = {
					Color3 = v20.TextColor or t1.TextColor
				},
				FontStyle = {
					Font = v20.Font or t1.Font,
					FontSize = v20.TextSize or t1.TextSize
				},
				Text = p1.Text,
				TextWrapped = TextWrapped,
				TextTruncate = TextTruncate,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		elseif typeof(p1) == "table" and p1.Item then
			Prefix = p1.Prefix
			v36 = React.createElement(View, {
				tag = "auto-y",
				LayoutOrder = 2,
				Size = uDim2
			}, {
				ContentElement = p1.Item
			})
		else
			v36 = React.createElement(View, {
				tag = "auto-y",
				LayoutOrder = 2,
				Size = uDim2
			}, {
				ContentElement = p1
			})
		end

		local createElement = React.createElement
		local v41 = View
		local t3 = {
			testId = "--markdown--bullet-list-item",
			tag = "gap-xsmall auto-xy row align-x-left align-y-top",
			key = tostring(n3),
			LayoutOrder = n3
		}
		local t4 = {}
		local createElement2 = React.createElement
		local v45 = View
		local t5 = {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v20.MarkerSize or t1.MarkerSize, v20.LineHeight or t1.LineHeight)
		}
		local t6 = {}

		t6.Image = if not (Prefix and (not Prefix:find("^*") and not Prefix:find("^-"))) then React.createElement(FoundationImage, {
			tag = "position-center-left anchor-center-left",
			LayoutOrder = 1,
			Image = v33,
			imageStyle = {
				Color3 = v20.TextColor or t1.TextColor
			},
			Size = UDim2.fromOffset(v20.MarkerSize or t1.MarkerSize, v20.MarkerSize or t1.MarkerSize)
		}) else React.createElement(FoundationText, {
			tag = "position-center-left anchor-center-left",
			Text = `{ Prefix }.`,
			fontStyle = {
				Font = v20.Font or t1.Font,
				FontSize = v20.TextSize or t1.TextSize
			},
			textStyle = {
				Color3 = v20.TextColor or t1.TextColor
			},
			Size = UDim2.fromOffset(v20.MarkerSize or t1.MarkerSize, v20.MarkerSize or t1.MarkerSize)
		})
		t4.Marker = createElement2(v45, t5, t6)
		t4.Content = v36
		t4.Padding = v34

		return createElement(v41, t3, t4)
	end)
	local t2Size = t2.Size
	local t2Position = t2.Position
	local XY = Enum.AutomaticSize.XY

	if t2Size and (t2Size.X.Scale > 0 or t2Size.X.Offset > 0) then
		XY = Enum.AutomaticSize.Y
	end

	return React.createElement(View, {
		testId = "--markdown--bullet-list",
		tag = "col align-x-left gap-xsmall",
		AutomaticSize = XY,
		backgroundStyle = {
			Transparency = 1
		},
		LayoutOrder = t2.LayoutOrder or 1,
		Position = t2Position,
		Size = t2Size
	}, Dash.assign(v26, t2.children or {}))
end

return BulletList

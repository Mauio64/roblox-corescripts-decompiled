local parent = script:FindFirstAncestor("MarkdownCore").Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)

local map = Dash.map

local MarkdownCore = script:FindFirstAncestor("MarkdownCore")
local Flags = require(MarkdownCore.Flags)

local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text

local v = {
	ItemOffset = 12,
	MarkerImage = "rbxasset://textures/StudioSharedUI/dot.png",
	MarkerSize = 4,
	Padding = 6,
	LineHeight = 18,
	Font = Enum.Font.BuilderSans,
	TextColor = Color3.fromRGB(0, 0, 0),
	TextSize = 18,
	ItemIndentation = 0,
	SubItemStyle = { ItemIndentation = 20, ItemOffset = 12 }
}

local function calculateItemOffset(small: number, markerSize: number) -- 1 equivalent call inferred from this helper
	return markerSize + small
end

local function isOrdered(prefix: string?) -- 1 equivalent call inferred from this helper
	return prefix and not (prefix:find("^*") or prefix:find("^-"))
end

local function BulletList(props)
	local v2 = Foundation.Hooks.useTokens()

	local textWrapped = props.TextWrapped
	local textTruncate = props.TextTruncate
	local listStyle = props.ListStyle or v

	local items = props.Items

	local itemIndentation = listStyle.ItemIndentation or v.ItemIndentation

	local udim = UDim2.new(1, -calculateItemOffset(v2.Gap.Small, listStyle.MarkerSize or v.MarkerSize), 0, 0) -- inferred equivalent call
	local font, textSize, textColor, lineHeight

	if Flags.FFlagMarkdownAssistantParity then
		local bodyMedium = v2.Typography.BodyMedium
		font = listStyle.Font or bodyMedium.Font
		textSize = listStyle.TextSize or bodyMedium.FontSize
		textColor = listStyle.TextColor or v2.Color.Content.Default.Color3
		lineHeight = listStyle.LineHeight or textSize * bodyMedium.LineHeight
	else
		font = listStyle.Font or v.Font
		textSize = listStyle.TextSize or v.TextSize
		textColor = listStyle.TextColor or v.TextColor
		lineHeight = listStyle.LineHeight or v.LineHeight
	end

	local mapped = map(items, function(props2, layoutOrder: number)
		local image = listStyle.MarkerImage or v.MarkerImage
		local padding = nil

		local prefix = nil
		local content

		if type(props2) == "string" then
			content = React.createElement(Text, {
				AutomaticSize = Enum.AutomaticSize.XY,
				fontStyle = { Font = font, FontSize = textSize },
				LayoutOrder = 2,
				Size = udim,
				Text = props2,
				textStyle = { Color3 = textColor },
				TextTruncate = textTruncate,
				TextWrapped = textWrapped,
				Padding = listStyle.Padding or v.Padding,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		elseif typeof(props2) == "table" and props2.Text then
			prefix = props2.Prefix

			local subItemStyle = listStyle.SubItemStyle

			local udim2 = UDim2.new(1, -subItemStyle.ItemOffset or v.SubItemStyle.ItemOffset, 0, 0)

			local itemIndentation2 = subItemStyle.ItemIndentation or itemIndentation

			image = subItemStyle.MarkerStyle or image

			if itemIndentation2 then
				padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, itemIndentation2)
				})
			end

			content = React.createElement(Text, {
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 2,
				Size = udim2,
				textStyle = { Color3 = textColor },
				fontStyle = { Font = font, FontSize = textSize },
				Text = props2.Text,
				TextWrapped = textWrapped,
				TextTruncate = textTruncate,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		elseif typeof(props2) == "table" and props2.Item then
			prefix = props2.Prefix

			content = React.createElement(View, { tag = "auto-y", LayoutOrder = 2, Size = udim }, {
				ContentElement = props2.Item
			})
		else
			content = React.createElement(View, { tag = "auto-y", LayoutOrder = 2, Size = udim }, {
				ContentElement = props2
			})
		end

		local createElement = React.createElement
		local v3 = {
			key = tostring(layoutOrder),
			testId = "--markdown--bullet-list-item",
			LayoutOrder = layoutOrder,
			tag = "gap-xsmall auto-xy row align-x-left align-y-top"
		}

		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(listStyle.MarkerSize or v.MarkerSize, lineHeight)
		}
		local image2

		if isOrdered(prefix) then -- inferred equivalent call
			image2 = React.createElement(Text, {
				tag = "position-center-left anchor-center-left",
				Text = `{prefix}.`,
				fontStyle = { Font = font, FontSize = textSize },
				textStyle = { Color3 = textColor },
				Size = UDim2.fromOffset(listStyle.MarkerSize or v.MarkerSize, listStyle.MarkerSize or v.MarkerSize)
			})
		else
			image2 = React.createElement(Image, {
				tag = "position-center-left anchor-center-left",
				Image = image,
				imageStyle = { Color3 = textColor },
				LayoutOrder = 1,
				Size = UDim2.fromOffset(listStyle.MarkerSize or v.MarkerSize, listStyle.MarkerSize or v.MarkerSize)
			})
		end

		return createElement(View, v3, {
			Marker = createElement2(View, v4, { Image = image2 }),
			Content = content,
			Padding = padding
		})
	end)

	local size = props.Size
	local position = props.Position
	local automaticSize = Enum.AutomaticSize.XY

	if size and (size.X.Scale > 0 or size.X.Offset > 0) then
		automaticSize = Enum.AutomaticSize.Y
	end

	return React.createElement(View, {
		testId = "--markdown--bullet-list",
		tag = "col align-x-left gap-xsmall",
		AutomaticSize = automaticSize,
		backgroundStyle = { Transparency = 1 },
		LayoutOrder = props.LayoutOrder or 1,
		Position = position,
		Size = size
	}, Dash.assign(mapped, props.children or {}))
end

return BulletList

local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Skeleton = require(Foundation.Components.Skeleton)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTextSizeOffset = require(Foundation.Providers.Style.useTextSizeOffset)
local useTile = require(Foundation.Components.Tile.useTile)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local function getTypographyComponent(p1, t1: {[any]: any}, p2, p3, n1: number, n2: number, s1: string) -- line: 31
	-- upvalues: React (copy), Skeleton (copy), useTextSizeOffset (copy), Text (copy)
	local v21

	if typeof(p1) == "string" then
		v21 = p1
	else
		if p1.isLoading then
			return React.createElement(Skeleton, {
				Size = UDim2.new(1 / n2, 0, 0, t1.FontSize),
				LayoutOrder = n2
			})
		end

		v21 = p1.text
		t1 = p1.fontStyle or t1
		p2 = p1.colorStyle or p2
		n1 = p1.numLines or n1
	end

	assert(t1 ~= nil, "fontStyle cannot be nil")
	assert(p2 ~= nil, "colorStyle cannot be nil")
	assert(n1 ~= nil, "numLines cannot be nil")
	t1.LineHeight = 1

	local v22 = useTextSizeOffset()
	local v23 = n1 * (t1.FontSize + (v22 or 0)) * t1.LineHeight

	return React.createElement(Text, {
		fontStyle = t1,
		textStyle = p2,
		Text = v21,
		TextXAlignment = p3,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = n1 > 1,
		Size = UDim2.new(1, 0, 0, v23),
		LayoutOrder = n2,
		testId = s1
	})
end

local t2 = {
	TextXAlignment = Enum.TextXAlignment.Left
}

local function TileHeader(t3: {[any]: any}) -- line: 98
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), useTile (copy), getTypographyComponent (copy), React (copy), View (copy)
	local v25 = withDefaults(t3, t2)
	local v26 = useTokens()
	local v27 = useTile()
	local v28 = getTypographyComponent(v25.title, v26.Typography.TitleLarge, v26.Color.Content.Emphasis, v25.TextXAlignment, v25.subtitle ~= nil and 1 or 2, 1, `{ v27.testId }--header-title`)

	return React.createElement(View, {
		tag = "gap-xxsmall size-full-0 auto-y",
		flexItem = {
			FlexMode = Enum.UIFlexMode.Shrink
		},
		layout = {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		testId = `{ v27.testId }--header`
	}, {
		Title = v28,
		Subtitle = if v25.subtitle == nil then nil else getTypographyComponent(v25.subtitle, v26.Typography.CaptionLarge, v26.Color.Content.Default, v25.TextXAlignment, 1, 2, `{ v27.testId }--header-subtitle`)
	})
end

return TileHeader

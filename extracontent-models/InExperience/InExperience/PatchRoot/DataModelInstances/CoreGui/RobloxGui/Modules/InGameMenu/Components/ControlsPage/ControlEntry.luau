local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local KeyLabel = UIBlox.App.Menu.KeyLabel
local PointerLabel = require(parent.Components.PointerLabel)
local Divider = require(parent.Components.Divider)

local withLocalization = require(parent.Localization.withLocalization)

local strictInterface = t.strictInterface({
	actionDescription = t.string,
	inputs = t.table,
	isList = t.optional(t.boolean),
	hasDivider = t.boolean,
	LayoutOrder = t.integer
})

local function renderHorizontalSpacer(text, layoutOrder, p)
	local udim = p and UDim2.new(0, 19, 0, 24) or UDim2.new(0, 19, 0, 16)
	local bottom = p and Enum.TextYAlignment.Bottom

	return Roact.createElement(ThemedTextLabel, {
		themeKey = "TextEmphasis",
		fontKey = "Header1",
		Text = text,
		Size = udim,
		TextYAlignment = bottom,
		LayoutOrder = layoutOrder
	})
end

local function renderKey(p, layoutOrder)
	if p.EnumType == Enum.KeyCode then
		return Roact.createElement(KeyLabel, {
			keyCode = p,
			textThemeKey = "TextEmphasis",
			LayoutOrder = layoutOrder
		})
	end

	return Roact.createElement(PointerLabel, { input = p, LayoutOrder = layoutOrder })
end

local function renderInputIconContainer(inputs, isList)
	local children = {}

	children.ListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, isList and 0 or 7)
	})
	local layoutOrder = 1

	for i, item in ipairs(inputs) do
		if typeof(item) == "table" then
			for j, v in ipairs(item) do
				local v2 = string.format("%d_%d", i, j)
				children["groupedInput" .. v2] = renderKey(v, layoutOrder)
				layoutOrder += 1

				if not (j < #item) then
					continue
				end

				local v3 = "groupedDivider" .. v2
				local udim = UDim2.new(0, 19, 0, 16)

				children[v3] = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextEmphasis",
					fontKey = "Header1",
					Text = "+",
					Size = udim,
					TextYAlignment = nil,
					LayoutOrder = layoutOrder
				})
				layoutOrder += 1
			end
		else
			children["input" .. i] = renderKey(item, layoutOrder)
			layoutOrder += 1

			if isList and i == #inputs then
				children.Elipses = renderHorizontalSpacer("...", layoutOrder, true)
			end
		end

		if isList or not (i < #inputs) then
			continue
		end

		local v = "divider" .. i
		local udim = UDim2.new(0, 19, 0, 16)

		children[v] = Roact.createElement(ThemedTextLabel, {
			themeKey = "TextEmphasis",
			fontKey = "Header1",
			Text = "/",
			Size = udim,
			TextYAlignment = nil,
			LayoutOrder = layoutOrder
		})
		layoutOrder += 1
	end

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0)
		},
		children
	)
end

local function ControlEntry(data)
	if GlobalConfig.propValidation then
		assert(strictInterface(data))
	end

	return withLocalization({ actionDescription = data.actionDescription })(function(p)
		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = data.LayoutOrder,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 50)
			},
			{
				ActionLabel = Roact.createElement(ThemedTextLabel, {
					fontKey = "Header2",
					themeKey = "TextEmphasis",
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(0, 200, 0, 22),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Text = p.actionDescription
				}),
				Divider = data.hasDivider and Roact.createElement(Divider, {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1)
				}),
				Inputs = renderInputIconContainer(data.inputs, data.isList)
			}
		)
	end)
end

return ControlEntry

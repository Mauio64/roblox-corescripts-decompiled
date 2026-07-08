local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local KeyLabel = UIBlox.App.Menu.KeyLabel
local PointerLabel = require(ParentParent.Components.PointerLabel)
local Divider = require(ParentParent.Components.Divider)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v13 = t.strictInterface({
	actionDescription = t.string,
	inputs = t.table,
	isList = t.optional(t.boolean),
	hasDivider = t.boolean,
	LayoutOrder = t.integer
})

local function renderHorizontalSpacer(p1, p2, p3) -- line: 30
	-- upvalues: Roact (copy), ThemedTextLabel (copy)
	local v21 = p3 and UDim2.new(0, 19, 0, 24) or UDim2.new(0, 19, 0, 16)
	local v22 = p3 and Enum.TextYAlignment.Bottom

	return Roact.createElement(ThemedTextLabel, {
		themeKey = "TextEmphasis",
		fontKey = "Header1",
		Text = p1,
		Size = v21,
		TextYAlignment = v22,
		LayoutOrder = p2
	})
end
local function renderKey(p4, p5) -- line: 44
	-- upvalues: Roact (copy), KeyLabel (copy), PointerLabel (copy)
	if p4.EnumType == Enum.KeyCode then
		return Roact.createElement(KeyLabel, {
			textThemeKey = "TextEmphasis",
			keyCode = p4,
			LayoutOrder = p5
		})
	end

	return Roact.createElement(PointerLabel, {
		input = p4,
		LayoutOrder = p5
	})
end
local function renderInputIconContainer(p6, p7) -- line: 60
	-- upvalues: Roact (copy), renderKey (copy), renderHorizontalSpacer (copy), ThemedTextLabel (copy)
	local t1 = {}
	local v28 = p7 and 0 or 7

	t1.ListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v28)
	})

	local n1 = 1

	for i, v in ipairs(p6) do
		if typeof(v) ~= "table" then
			t1["input" .. i] = renderKey(v, n1)
			n1 += 1

			if p7 and i == #p6 then
				t1.Elipses = renderHorizontalSpacer("...", n1, true)
			end
		else
			for i2, v2 in ipairs(v) do
				local v34 = string.format("%d_%d", i, i2)

				t1["groupedInput" .. v34] = renderKey(v2, n1)
				n1 += 1

				if i2 < #v then
					local v35 = "groupedDivider" .. v34
					local uDim2 = UDim2.new(0, 19, 0, 16)

					t1[v35] = Roact.createElement(ThemedTextLabel, {
						themeKey = "TextEmphasis",
						fontKey = "Header1",
						Text = "+",
						TextYAlignment = nil,
						Size = uDim2,
						LayoutOrder = n1
					})
					n1 += 1
				end
			end
		end

		if not p7 and i < #p6 then
			local v37 = "divider" .. i
			local uDim2 = UDim2.new(0, 19, 0, 16)

			t1[v37] = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextEmphasis",
				fontKey = "Header1",
				Text = "/",
				TextYAlignment = nil,
				Size = uDim2,
				LayoutOrder = n1
			})
			n1 += 1
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0)
	}, t1)
end
local function ControlEntry(p8) -- line: 115
	-- upvalues: GlobalConfig (copy), v13 (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy), Divider (copy), renderInputIconContainer (copy)
	if GlobalConfig.propValidation then
		assert(v13(p8))
	end

	return withLocalization({
		actionDescription = p8.actionDescription
	})(function(p9) -- line: 122
		-- upvalues: Roact (copy), p8 (copy), ThemedTextLabel (copy), Divider (copy), renderInputIconContainer (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p8.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 50)
		}, {
			ActionLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, 200, 0, 22),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Text = p9.actionDescription
			}),
			Divider = p8.hasDivider and Roact.createElement(Divider, {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, -1)
			}),
			Inputs = renderInputIconContainer(p8.inputs, p8.isList)
		})
	end)
end

return ControlEntry

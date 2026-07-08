local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local v10 = t.strictInterface({
	themeKey = t.optional(t.string),
	fontKey = t.optional(t.string),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	Text = t.string,
	TextColor3 = t.optional(t.Color3),
	TextTransparency = t.optional(t.numberConstrained(0, 1)),
	TextWrapped = t.optional(t.boolean),
	TextXAlignment = t.optional(t.enum(Enum.TextXAlignment)),
	TextYAlignment = t.optional(t.enum(Enum.TextYAlignment)),
	TextTruncate = t.optional(t.enum(Enum.TextTruncate)),
	Visible = t.optional(t.boolean),
	ZIndex = t.optional(t.integer),
	AutomaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	[Roact.Children] = t.optional(t.table)
})

local function ThemedTextLabel(p1) -- line: 34
	-- upvalues: GlobalConfig (copy), v10 (copy), withStyle (copy), Cryo (copy), Roact (copy)
	if GlobalConfig.propValidation then
		assert(v10(p1))
	end

	return withStyle(function(p2) -- line: 39
		-- upvalues: p1 (copy), Cryo (copy), Roact (copy)
		local v14 = p2.Theme[p1.themeKey or "TextDefault"]
		local v15 = p2.Font[p1.fontKey or "Body"]
		local v16 = Cryo.Dictionary.join({
			TextColor3 = v14.Color,
			TextTransparency = v14.Transparency
		}, p1, {
			BackgroundTransparency = 1,
			fontKey = Cryo.None,
			themeKey = Cryo.None,
			Font = v15.Font,
			TextSize = v15.RelativeSize * p2.Font.BaseSize
		})

		return Roact.createElement("TextLabel", v16)
	end)
end

return ThemedTextLabel

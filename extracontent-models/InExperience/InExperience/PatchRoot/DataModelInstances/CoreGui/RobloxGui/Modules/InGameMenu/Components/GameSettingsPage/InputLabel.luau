local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v9 = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	localizationKey = t.string,
	LayoutOrder = t.optional(t.number)
})

return function(p1) -- line: 22
	-- upvalues: GlobalConfig (copy), v9 (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return withLocalization({
		text = p1.localizationKey
	})(function(p2) -- line: 29
		-- upvalues: Roact (copy), ThemedTextLabel (copy), p1 (copy)
		return Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextDefault",
			LayoutOrder = p1.LayoutOrder,
			AnchorPoint = p1.AnchorPoint or Vector2.new(0, 0.5),
			Position = p1.Position or UDim2.new(0, 0, 0.5, 0),
			Size = p1.Size or UDim2.new(1, -72, 0.5, 0),
			Text = p2.text,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end)
end

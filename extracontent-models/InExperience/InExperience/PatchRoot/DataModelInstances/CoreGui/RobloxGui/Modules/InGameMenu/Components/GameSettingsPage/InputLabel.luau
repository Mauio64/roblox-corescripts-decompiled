local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent
local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local withLocalization = require(parent.Localization.withLocalization)

local strictInterface = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	localizationKey = t.string,
	LayoutOrder = t.optional(t.number)
})

return function(data)
	if GlobalConfig.propValidation then
		assert(strictInterface(data))
	end

	return withLocalization({ text = data.localizationKey })(function(p)
		return Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextDefault",
			LayoutOrder = data.LayoutOrder,
			AnchorPoint = data.AnchorPoint or Vector2.new(0, 0.5),
			Position = data.Position or UDim2.new(0, 0, 0.5, 0),
			Size = data.Size or UDim2.new(1, -72, 0.5, 0),
			Text = p.text,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end)
end

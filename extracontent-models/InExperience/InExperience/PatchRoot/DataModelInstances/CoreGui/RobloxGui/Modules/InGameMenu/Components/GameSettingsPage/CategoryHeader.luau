local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)

local withLocalization = require(parent.Localization.withLocalization)

local strictInterface = t.strictInterface({ LayoutOrder = t.integer, localizationKey = t.string })

return function(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = p.LayoutOrder, Size = UDim2.new(1, 0, 0, 36) },
		{
			Label = withLocalization({ text = p.localizationKey })(function(p2)
				return Roact.createElement(ThemedTextLabel, {
					fontKey = "Footer",
					themeKey = "TextEmphasis",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -48, 0, 14),
					Text = p2.text,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			end)
		}
	)
end

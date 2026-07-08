local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v9 = t.strictInterface({
	LayoutOrder = t.integer,
	localizationKey = t.string
})

return function(p1) -- line: 20
	-- upvalues: GlobalConfig (copy), v9 (copy), Roact (copy), withLocalization (copy), ThemedTextLabel (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = p1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 36)
	}, {
		Label = withLocalization({
			text = p1.localizationKey
		})(function(p2) -- line: 32
			-- upvalues: Roact (copy), ThemedTextLabel (copy)
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
	})
end

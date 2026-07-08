local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local v9 = t.strictInterface({
	Position = t.UDim2,
	Size = t.UDim2,
	AnchorPoint = t.Vector2
})

return function(p1) -- line: 20
	-- upvalues: GlobalConfig (copy), v9 (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return withLocalization({
		lockedText = "CoreScripts.InGameMenu.GameSettings.LockedByDeveloper"
	})(function(p2) -- line: 27
		-- upvalues: Roact (copy), ThemedTextLabel (copy)
		return Roact.createElement(ThemedTextLabel, {
			themeKey = "TextDefault",
			fontKey = "CaptionBody",
			TextTransparency = 0.5,
			Text = p2.lockedText,
			Size = UDim2.new(1, -72, 0.25, 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom
		})
	end)
end

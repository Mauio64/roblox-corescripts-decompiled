local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)
local withLocalization = require(parent.Localization.withLocalization)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local strictInterface = t.strictInterface({
	Position = t.UDim2,
	Size = t.UDim2,
	AnchorPoint = t.Vector2
})

return function(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return withLocalization({ lockedText = "CoreScripts.InGameMenu.GameSettings.LockedByDeveloper" })(function(p2)
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

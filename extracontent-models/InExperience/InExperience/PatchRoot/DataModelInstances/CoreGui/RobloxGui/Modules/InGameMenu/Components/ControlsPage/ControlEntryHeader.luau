local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local withLocalization = require(parent.Localization.withLocalization)

local strictInterface = t.strictInterface({ title = t.string, LayoutOrder = t.integer })

local function ControlEntry(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return withLocalization({ title = p.title })(function(p2)
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundTransparency = 1,
				LayoutOrder = p.LayoutOrder
			},
			{
				HeaderText = Roact.createElement(ThemedTextLabel, {
					fontKey = "CaptionHeader",
					themeKey = "TextMuted",
					Text = p2.title,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 0, 0, 20),
					Size = UDim2.new(1, 0, 0, 17)
				})
			}
		)
	end)
end

return ControlEntry

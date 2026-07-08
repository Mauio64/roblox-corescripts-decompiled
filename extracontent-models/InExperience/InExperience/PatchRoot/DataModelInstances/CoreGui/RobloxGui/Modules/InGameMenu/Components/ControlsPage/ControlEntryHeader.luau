local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v9 = t.strictInterface({
	title = t.string,
	LayoutOrder = t.integer
})

local function ControlEntry(p1) -- line: 26
	-- upvalues: GlobalConfig (copy), v9 (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return withLocalization({
		title = p1.title
	})(function(p2) -- line: 33
		-- upvalues: Roact (copy), p1 (copy), ThemedTextLabel (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 45),
			LayoutOrder = p1.LayoutOrder
		}, {
			HeaderText = Roact.createElement(ThemedTextLabel, {
				fontKey = "CaptionHeader",
				themeKey = "TextMuted",
				Text = p2.title,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 0, 17)
			})
		})
	end)
end

return ControlEntry

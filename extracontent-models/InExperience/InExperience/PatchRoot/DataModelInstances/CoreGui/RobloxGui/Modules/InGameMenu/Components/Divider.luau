local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local v10 = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Visible = t.optional(t.boolean)
})

local function Divider(p1) -- line: 23
	-- upvalues: GlobalConfig (copy), v10 (copy), withStyle (copy), Roact (copy), Cryo (copy)
	if GlobalConfig.propValidation then
		assert(v10(p1))
	end

	return withStyle(function(p2) -- line: 28
		-- upvalues: Roact (copy), Cryo (copy), p1 (copy)
		return Roact.createElement("Frame", Cryo.Dictionary.join({
			Size = UDim2.new(1, 0, 0, 1)
		}, p1, {
			BorderSizePixel = 0,
			BackgroundColor3 = p2.Theme.Divider.Color,
			BackgroundTransparency = p2.Theme.Divider.Transparency
		}))
	end)
end

return Divider

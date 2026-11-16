local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local strictInterface = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Visible = t.optional(t.boolean)
})

local function Divider(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return withFoundationOrUIBloxStyle(function(p2)
		return {
			Theme = {
				Divider = {
					Color = p2.Color.Stroke.Emphasis.Color3,
					Transparency = p2.Color.Stroke.Emphasis.Transparency
				}
			}
		}
	end, function(p2)
		return Roact.createElement(
			"Frame",
			Cryo.Dictionary.join({ Size = UDim2.new(1, 0, 0, 1) }, p, {
				BorderSizePixel = 0,
				BackgroundColor3 = p2.Theme.Divider.Color,
				BackgroundTransparency = p2.Theme.Divider.Transparency
			})
		)
	end)
end

return Divider

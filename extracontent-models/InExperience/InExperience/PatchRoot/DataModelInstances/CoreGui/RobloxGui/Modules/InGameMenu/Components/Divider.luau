local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local v9 = t.strictInterface({
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Visible = t.optional(t.boolean)
})

local function Divider(p1) -- line: 22
	-- upvalues: GlobalConfig (copy), v9 (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), Cryo (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return withFoundationOrUIBloxStyle(function(p2) -- line: 27
		return {
			Theme = {
				Divider = {
					Color = p2.Color.Stroke.Emphasis.Color3,
					Transparency = p2.Color.Stroke.Emphasis.Transparency
				}
			}
		}
	end, function(p3) -- line: 33
		-- upvalues: Roact (copy), Cryo (copy), p1 (copy)
		return Roact.createElement("Frame", Cryo.Dictionary.join({
			Size = UDim2.new(1, 0, 0, 1)
		}, p1, {
			BorderSizePixel = 0,
			BackgroundColor3 = p3.Theme.Divider.Color,
			BackgroundTransparency = p3.Theme.Divider.Transparency
		}))
	end)
end

return Divider

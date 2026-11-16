local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent

local Assets = require(parent.Resources.Assets)

local GlobalConfig = require(parent.GlobalConfig)

local v = t.strictInterface({
	Size = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.UDim2),
	CanvasSize = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	[Roact.Children] = t.optional(t.table)
})

local function PaddedScrollFrame(props)
	if GlobalConfig.propValidation then
		assert(v(props))
	end

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				UIEmphasis = {
					Color = p.Color.Shift.Shift_400.Color3,
					Transparency = p.Color.Shift.Shift_400.Transparency
				}
			}
		}
	end, function(p)
		return Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = p.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = p.Theme.UIEmphasis.Transparency,
			BottomImage = Assets.Images.ScrollBottom,
			MidImage = Assets.Images.ScrollMid,
			TopImage = Assets.Images.ScrollTop,
			ClipsDescendants = false,
			ScrollBarThickness = 12,
			Size = props.Size,
			AnchorPoint = props.AnchorPoint,
			CanvasSize = props.CanvasSize,
			Position = props.Position
		}, props[Roact.Children])
	end)
end

return PaddedScrollFrame

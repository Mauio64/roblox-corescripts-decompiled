local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/dzz")
local getImageSetData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageSetData
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local module3 = require("@luauforge/bundled/egH")

local Cryo = require(CorePackages.Packages.Cryo)

local extended = module.PureComponent:extend("ImageSetButton")
local luaApps = BuilderIcons.Migration.luaApps

function extended.render(p2)
	local imageSetData, v5 = getImageSetData(GuiService:GetResolutionScale())
	local v6 = imageSetData[p2.props.Image]

	if v6 then
		local forwardRef = p2.props.forwardRef
		local forwardRefsByRef = module2.RemoveFromDictionary(
			p2.props,
			"Image",
			"ImageRectOffset",
			"ImageRectSize",
			"SliceCenter",
			"forwardRef"
		)

		forwardRefsByRef[module.Ref] = forwardRef

		if p2.props.Image then
			forwardRefsByRef.Image = "rbxasset://textures/ui/ImageSet/" .. v6.ImageSet .. ".png"
		end

		if p2.props.ImageRectOffset then
			forwardRefsByRef.ImageRectOffset = Vector2.new(
				v6.ImageRectOffset.X + p2.props.ImageRectOffset.X * v5,
				v6.ImageRectOffset.Y + p2.props.ImageRectOffset.Y * v5
			)
		else
			forwardRefsByRef.ImageRectOffset = v6.ImageRectOffset
		end

		if p2.props.ImageRectSize then
			forwardRefsByRef.ImageRectSize = Vector2.new(
				p2.props.ImageRectSize.X * v5,
				p2.props.ImageRectSize.Y * v5
			)
		else
			forwardRefsByRef.ImageRectSize = v6.ImageRectSize
		end

		if p2.props.SliceCenter then
			forwardRefsByRef.SliceCenter = Rect.new(
				p2.props.SliceCenter.Min.X * v5,
				p2.props.SliceCenter.Min.Y * v5,
				p2.props.SliceCenter.Max.X * v5,
				p2.props.SliceCenter.Max.Y * v5
			)

			if p2.props.SliceScale then
				forwardRefsByRef.SliceScale = p2.props.SliceScale / v5
			else
				forwardRefsByRef.SliceScale = 1 / v5
			end
		end

		return module.createElement("ImageButton", forwardRefsByRef)
	else
		local forwardRef = p2.props.forwardRef
		local forwardRefsByRef = module2.RemoveFromDictionary(p2.props, "forwardRef")
		forwardRefsByRef[module.Ref] = forwardRef
		return module.createElement("ImageButton", forwardRefsByRef)
	end
end

return module.forwardRef(function(p2, p3)
	if luaApps[p2.Image] then
		return module.createElement(module3, {
			fullProps = p2,
			migrationLookup = luaApps[p2.Image],
			elementType = "TextButton"
		})
	end

	return module.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)

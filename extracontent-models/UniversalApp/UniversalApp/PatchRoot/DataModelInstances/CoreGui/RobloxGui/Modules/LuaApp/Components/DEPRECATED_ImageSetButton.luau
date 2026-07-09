local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local Immutable = require(Modules.Common.Immutable)
local GetImageSetData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageSetData
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local BuilderIconMigration = require(Modules.LuaApp.Components.BuilderIconMigration)
local Cryo = require(CorePackages.Packages.Cryo)
local v10 = Roact.PureComponent:extend("ImageSetButton")
local luaApps = BuilderIcons.Migration.luaApps

function v10.render(p1) -- line: 16
	-- upvalues: GetImageSetData (copy), GuiService (copy), Immutable (copy), Roact (copy)
	local v13, v14 = GetImageSetData(GuiService:GetResolutionScale())
	local v15 = v13[p1.props.Image]

	if not v15 then
		local forwardRef = p1.props.forwardRef
		local v17 = Immutable.RemoveFromDictionary(p1.props, "forwardRef")

		v17[Roact.Ref] = forwardRef

		return Roact.createElement("ImageButton", v17)
	end

	local forwardRef = p1.props.forwardRef
	local v19 = Immutable.RemoveFromDictionary(p1.props, "Image", "ImageRectOffset", "ImageRectSize", "SliceCenter", "forwardRef")

	v19[Roact.Ref] = forwardRef

	if p1.props.Image then
		v19.Image = "rbxasset://textures/ui/ImageSet/" .. v15.ImageSet .. ".png"
	end

	if p1.props.ImageRectOffset then
		v19.ImageRectOffset = Vector2.new(v15.ImageRectOffset.X + p1.props.ImageRectOffset.X * v14, v15.ImageRectOffset.Y + p1.props.ImageRectOffset.Y * v14)
	else
		v19.ImageRectOffset = v15.ImageRectOffset
	end

	if p1.props.ImageRectSize then
		v19.ImageRectSize = Vector2.new(p1.props.ImageRectSize.X * v14, p1.props.ImageRectSize.Y * v14)
	else
		v19.ImageRectSize = v15.ImageRectSize
	end

	if p1.props.SliceCenter then
		v19.SliceCenter = Rect.new(p1.props.SliceCenter.Min.X * v14, p1.props.SliceCenter.Min.Y * v14, p1.props.SliceCenter.Max.X * v14, p1.props.SliceCenter.Max.Y * v14)

		if p1.props.SliceScale then
			v19.SliceScale = p1.props.SliceScale / v14
		else
			v19.SliceScale = 1 / v14
		end
	end

	return Roact.createElement("ImageButton", v19)
end

return Roact.forwardRef(function(p2, p3) -- line: 76
	-- upvalues: luaApps (copy), Roact (copy), BuilderIconMigration (copy), v10 (copy), Cryo (copy)
	if luaApps[p2.Image] then
		return Roact.createElement(BuilderIconMigration, {
			elementType = "TextButton",
			fullProps = p2,
			migrationLookup = luaApps[p2.Image]
		})
	end

	return Roact.createElement(v10, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)

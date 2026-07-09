local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local Immutable = require(Modules.Common.Immutable)
local GetImageSetData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageSetData
local GetImageSetPathPattern = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageSetPathPattern
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Cryo = require(CorePackages.Packages.Cryo)
local BuilderIconMigration = require(Modules.LuaApp.Components.BuilderIconMigration)
local v11 = Roact.PureComponent:extend("ImageSetLabel")
local luaApps = BuilderIcons.Migration.luaApps

function v11.render(p1) -- line: 18
	-- upvalues: GetImageSetData (copy), GuiService (copy), Immutable (copy), Roact (copy), GetImageSetPathPattern (copy)
	local v14, v15 = GetImageSetData(GuiService:GetResolutionScale())
	local v16 = v14[p1.props.Image]

	if not v16 then
		local forwardRef = p1.props.forwardRef
		local v18 = Immutable.RemoveFromDictionary(p1.props, "forwardRef")

		v18[Roact.Ref] = forwardRef

		return Roact.createElement("ImageLabel", v18)
	end

	local forwardRef = p1.props.forwardRef
	local v20 = Immutable.RemoveFromDictionary(p1.props, "Image", "ImageRectOffset", "ImageRectSize", "SliceCenter", "forwardRef")

	v20[Roact.Ref] = forwardRef

	if p1.props.Image then
		v20.Image = GetImageSetPathPattern(v16.ImageSet)
	end

	if p1.props.ImageRectOffset then
		v20.ImageRectOffset = Vector2.new(v16.ImageRectOffset.X + p1.props.ImageRectOffset.X * v15, v16.ImageRectOffset.Y + p1.props.ImageRectOffset.Y * v15)
	else
		v20.ImageRectOffset = v16.ImageRectOffset
	end

	if p1.props.ImageRectSize then
		v20.ImageRectSize = Vector2.new(p1.props.ImageRectSize.X * v15, p1.props.ImageRectSize.Y * v15)
	else
		v20.ImageRectSize = v16.ImageRectSize
	end

	if p1.props.SliceCenter then
		v20.SliceCenter = Rect.new(p1.props.SliceCenter.Min.X * v15, p1.props.SliceCenter.Min.Y * v15, p1.props.SliceCenter.Max.X * v15, p1.props.SliceCenter.Max.Y * v15)

		if p1.props.SliceScale then
			v20.SliceScale = p1.props.SliceScale / v15
		else
			v20.SliceScale = 1 / v15
		end
	end

	return Roact.createElement("ImageLabel", v20)
end

return Roact.forwardRef(function(p2, p3) -- line: 78
	-- upvalues: luaApps (copy), Roact (copy), BuilderIconMigration (copy), v11 (copy), Cryo (copy)
	if luaApps[p2.Image] then
		return Roact.createElement(BuilderIconMigration, {
			elementType = "TextLabel",
			fullProps = p2,
			migrationLookup = luaApps[p2.Image]
		})
	end

	return Roact.createElement(v11, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)

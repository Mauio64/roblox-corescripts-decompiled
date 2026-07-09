local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local ImageSetLabel = require(CorePackages.Packages.UIBlox).Core.ImageSet.ImageSetLabel
local GenericIconButton = require(Modules.LuaApp.Components.GenericIconButton)
local v7 = Roact.PureComponent:extend("GenericIconButtonUIBlox")

function v7.render(p1) -- line: 16
	-- upvalues: Roact (copy), GenericIconButton (copy), Cryo (copy), ImageSetLabel (copy)
	return Roact.createElement(GenericIconButton, Cryo.Dictionary.join(p1.props, {
		iconComponent = ImageSetLabel
	}))
end

return v7

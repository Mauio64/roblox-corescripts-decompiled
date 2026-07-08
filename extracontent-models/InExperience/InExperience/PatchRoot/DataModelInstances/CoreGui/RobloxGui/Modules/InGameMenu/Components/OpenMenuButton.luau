local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local GlobalConfig = require(ParentParent.GlobalConfig)
local v10 = t.strictInterface({
	onClick = t.callback
})

local function OpenMenuButton(p1) -- line: 24
	-- upvalues: GlobalConfig (copy), v10 (copy), Roact (copy), ImageSetButton (copy), Assets (copy)
	if GlobalConfig.propValidation then
		assert(v10(p1))
	end

	return Roact.createElement(ImageSetButton, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Assets.Images.RobloxLogo,
		Position = UDim2.new(0, 50, 0.5, 0),
		Size = UDim2.new(0, 32, 0, 32),
		[Roact.Event.Activated] = p1.onClick
	})
end

return OpenMenuButton

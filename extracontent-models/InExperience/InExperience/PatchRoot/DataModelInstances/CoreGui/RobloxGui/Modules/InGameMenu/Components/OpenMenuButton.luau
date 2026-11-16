local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent

local Assets = require(parent.Resources.Assets)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local GlobalConfig = require(parent.GlobalConfig)

local strictInterface = t.strictInterface({ onClick = t.callback })

local function OpenMenuButton(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return Roact.createElement(ImageSetButton, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Assets.Images.RobloxLogo,
		Position = UDim2.new(0, 50, 0.5, 0),
		Size = UDim2.new(0, 32, 0, 32),
		[Roact.Event.Activated] = p.onClick
	})
end

return OpenMenuButton

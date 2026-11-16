local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images

local presenceType = {
	Offline = "OFFLINE",
	Online = "ONLINE",
	InGame = "IN_GAME",
	InStudio = "IN_STUDIO"
}

local v = {
	[presenceType.Online] = {
		Image = "component_assets/circle_16",
		Color = Color3.fromRGB(0, 180, 109),
		Size = UDim2.new(0, 12, 0, 12)
	},
	[presenceType.InGame] = { Image = "icons/menu/games_small" },
	[presenceType.InStudio] = { Image = "icons/logo/studiologo_small" }
}

return {
	PresenceType = presenceType,
	GetIcon = function(p: string)
		local v2 = v[p]

		if v2 then
			return React.createElement(ImageSetLabel, {
				Image = Images[v2.Image],
				BackgroundTransparency = 1,
				ImageColor3 = v2.Color,
				Size = v2.Size or UDim2.new(0, IconSize.Small, 0, IconSize.Small)
			})
		end
	end
}

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local t1 = {
	Offline = "OFFLINE",
	Online = "ONLINE",
	InGame = "IN_GAME",
	InStudio = "IN_STUDIO"
}
local t2 = {
	[t1.Online] = {
		Image = "component_assets/circle_16",
		Color = Color3.fromRGB(0, 180, 109),
		Size = UDim2.new(0, 12, 0, 12)
	},
	[t1.InGame] = {
		Image = "icons/menu/games_small"
	},
	[t1.InStudio] = {
		Image = "icons/logo/studiologo_small"
	}
}

return {
	PresenceType = t1,
	GetIcon = function(s1: string) -- line: 36
		-- upvalues: t2 (copy), React (copy), ImageSetLabel (copy), Images (copy), IconSize (copy)
		local v10 = t2[s1]

		if not v10 then
			return
		end

		return React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Images[v10.Image],
			ImageColor3 = v10.Color,
			Size = v10.Size or UDim2.new(0, IconSize.Small, 0, IconSize.Small)
		})
	end
}

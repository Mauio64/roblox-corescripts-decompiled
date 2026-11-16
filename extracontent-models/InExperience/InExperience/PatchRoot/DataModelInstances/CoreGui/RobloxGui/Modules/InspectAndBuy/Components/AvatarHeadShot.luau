local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Colors = require(parent.Colors)

local extended = Roact.PureComponent:extend("AvatarHeadShot")

local modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")

local LegacyThumbnailUrls = require(modules.Common.LegacyThumbnailUrls)

local Headshot = LegacyThumbnailUrls.Headshot

function extended.render(p)
	local playerId = p.props.playerId
	local image

	if playerId and playerId ~= "" then
		image = Headshot:format(playerId, 48, 48)
	end

	if image then
		return Roact.createElement("ImageLabel", {
			Size = UDim2.new(0, 48, 0, 48),
			BackgroundColor3 = Colors.GrayBackground,
			BorderSizePixel = 0,
			Image = image,
			LayoutOrder = 1
		}, {
			MaskFrame = Roact.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxasset://textures/ui/LuaApp/graphic/gr-avatar mask-90x90.png",
				ImageColor3 = Colors.Carbon
			})
		})
	end

	return nil
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { playerId = p.playerId }
end)(extended)

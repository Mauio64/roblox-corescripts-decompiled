local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Colors = require(ParentParent.Colors)
local v7 = Roact.PureComponent:extend("AvatarHeadShot")
local Modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local Headshot = require(Modules.Common.LegacyThumbnailUrls).Headshot

function v7.render(p1) -- line: 19
	-- upvalues: Headshot (copy), Roact (copy), Colors (copy)
	local playerId = p1.props.playerId
	local v12 = nil

	if playerId and playerId ~= "" then
		v12 = Headshot:format(playerId, 48, 48)
	end

	if not v12 then
		return nil
	end

	return Roact.createElement("ImageLabel", {
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(0, 48, 0, 48),
		BackgroundColor3 = Colors.GrayBackground,
		Image = v12
	}, {
		MaskFrame = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gr-avatar mask-90x90.png",
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = Colors.Carbon
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2, _) -- line: 50
	return {
		playerId = p2.playerId
	}
end)(v7)

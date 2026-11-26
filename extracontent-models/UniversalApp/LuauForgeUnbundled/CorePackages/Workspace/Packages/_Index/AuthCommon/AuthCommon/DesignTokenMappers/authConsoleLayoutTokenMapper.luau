require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style")

return function(p2, p3)
	return {
		robloxLogoTextImageUrl = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png",
		robloxLogoTextImageSize = UDim2.new(0, 476, 0, 88),
		robloxLogoTextImagePosition = UDim2.new(0.5, 0, 0.28, 0),
		buttonContainerPosition = UDim2.new(0.5, 0, 0.58, 0),
		containerWidth = 846,
		containerHeight = 300,
		dividerWidth = 640,
		dividerHeight = 60,
		dividerPadding = 3,
		buttonPadding = p3.Size.Size_150
	}
end

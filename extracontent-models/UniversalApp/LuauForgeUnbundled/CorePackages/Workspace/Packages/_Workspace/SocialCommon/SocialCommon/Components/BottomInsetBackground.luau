local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/RoactUtils")

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/ThemeBackground").useThemeBackground

local useStyle = UIBlox.Core.Style.useStyle
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	local v5 = useStyle()

	local v6 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local v7 = useSelector(function(p2)
		if p2.GlobalGuiInset then
			return p2.GlobalGuiInset.bottom
		end

		return 0
	end)

	return React.createElement("Frame", {
		BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v6 and 1 or v5.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, v7),
		ZIndex = 3
	})
end

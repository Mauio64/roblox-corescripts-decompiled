local parent = script:FindFirstAncestor("SocialCommon").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026FriendsBackground = SharedFlags.FFlagAppThemeHalloween2026FriendsBackground
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground

local useStyle = UIBlox.Core.Style.useStyle
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	local v = useStyle()
	local v2

	if FFlagAppThemeHalloween2026FriendsBackground then
		v2 = useThemeBackground() ~= nil
	else
		v2 = false
	end

	local v3 = useSelector(function(p)
		return if p.GlobalGuiInset then p.GlobalGuiInset.bottom else 0
	end)

	return React.createElement("Frame", {
		BackgroundColor3 = v.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v2 and 1 or v.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, v3),
		ZIndex = 3
	})
end

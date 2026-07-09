local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local AppNavBar = require(AppMusicPlayer.Parent.AppNavBar)
local AppSystemBar = require(AppMusicPlayer.Parent.AppSystemBar)
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local React = require(AppMusicPlayer.Parent.React)
local PersistentMusicPlayer = require(AppMusicPlayer.Components.PersistentMusicPlayer)
local GetFFlagMusicPlayerUseDynamicNavBarHeight = require(AppMusicPlayer.Parent.SharedFlags).GetFFlagMusicPlayerUseDynamicNavBarHeight
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize

local function AppMusicPlayer2() -- line: 16
	-- upvalues: useNavBarPlacement (copy), GetFFlagMusicPlayerUseDynamicNavBarHeight (copy), useNavBarSize (copy), AppSystemBar (copy), React (copy), Foundation (copy), AppNavBar (copy), PersistentMusicPlayer (copy)
	local v11 = useNavBarPlacement()
	local v12 = if not GetFFlagMusicPlayerUseDynamicNavBarHeight() then AppSystemBar.Constants.BOTTOM_BAR_SIZE else useNavBarSize()

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y anchor-bottom-left",
		Position = if v11 ~= AppNavBar.Placement.Bottom then UDim2.fromScale(0, 1) else UDim2.new(0, 0, 1, -v12)
	}, {
		PersistentMusicPlayer = React.createElement(PersistentMusicPlayer)
	})
end

return React.memo(AppMusicPlayer2)

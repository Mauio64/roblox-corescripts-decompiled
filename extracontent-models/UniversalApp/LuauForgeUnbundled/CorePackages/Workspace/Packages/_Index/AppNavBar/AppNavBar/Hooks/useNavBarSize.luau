local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UIBlox").Core.Style.useStyle

local FFlagIncreaseAppNavbarWidth = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Flags/FFlagIncreaseAppNavbarWidth")

local function useNavBarSize()
	local tokens = useStyle().Tokens

	if FFlagIncreaseAppNavbarWidth then
		return tokens.Size.Size_1800
	end

	return tokens.Size.Size_1600
end

return useNavBarSize

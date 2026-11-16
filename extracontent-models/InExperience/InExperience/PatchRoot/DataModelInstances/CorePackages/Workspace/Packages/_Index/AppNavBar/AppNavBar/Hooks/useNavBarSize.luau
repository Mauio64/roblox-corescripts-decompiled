local parent = script.Parent.Parent
local parent2 = parent.Parent

local UIBlox = require(parent2.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

local FFlagIncreaseAppNavbarWidth = require(parent.Flags.FFlagIncreaseAppNavbarWidth)

local function useNavBarSize()
	local tokens = useStyle().Tokens

	if FFlagIncreaseAppNavbarWidth then
		return tokens.Size.Size_1800
	end

	return tokens.Size.Size_1600
end

return useNavBarSize

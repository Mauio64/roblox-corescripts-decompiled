local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)
local TextService = Wrappers.Services.TextService
local noYield = require(Foundation.Utility.noYield)

local function getTextSizeOffset()
	return noYield(function(value, p)
		local v = value or 0
		local v2 = p or Font.fromEnum(Enum.Font.BuilderSans)

		local success, result = pcall(function()
			return TextService:GetTextSizeOffsetAsync(v, v2)
		end)
		return if success then result else nil
	end)
end

return getTextSizeOffset

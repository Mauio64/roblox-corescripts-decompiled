local Foundation = script:FindFirstAncestor("Foundation")
local TextService = require(Foundation.Utility.Wrappers).Services.TextService
local noYield = require(Foundation.Utility.noYield)

local function getTextSizeOffset() -- line: 5
	-- upvalues: noYield (copy), TextService (copy)
	return noYield(function(p1, p2) -- line: 6
		-- upvalues: TextService (copy)
		local u7 = p1 or 0
		local u8 = p2 or Font.fromEnum(Enum.Font.BuilderSans)
		local ok, result = pcall(function() -- line: 10
			-- upvalues: TextService (copy), u7 (ref), u8 (ref)
			return TextService:GetTextSizeOffsetAsync(u7, u8)
		end)

		if not ok then
			return nil
		end

		return result
	end)
end

return getTextSizeOffset

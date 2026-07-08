local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent.Parent
local Logger = require(ParentParent.Logger)
local vector2 = Vector2.new(2, 2)

local function getTextSize(s1: string, n1: number, p1, vector2_2: Vector2, b1: boolean?) -- line: 12
	-- upvalues: TextService (copy), vector2 (copy), Logger (copy)
	local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

	GetTextBoundsParams.Font = Font.fromEnum(p1)
	GetTextBoundsParams.Size = n1
	GetTextBoundsParams.Text = s1
	GetTextBoundsParams.Width = vector2_2.X
	GetTextBoundsParams.RichText = b1 or false

	local ok, result = pcall(function() -- line: 21
		-- upvalues: TextService (copy), GetTextBoundsParams (copy)
		return TextService:GetTextBoundsAsync(GetTextBoundsParams)
	end)

	if ok then
		return Vector2.new(result.X, (math.min(result.Y, vector2_2.Y))) + vector2
	end

	Logger:warning("GetTextBoundsAsync call failed, falling back to frame size. Error: ", result)

	return vector2_2
end

return getTextSize

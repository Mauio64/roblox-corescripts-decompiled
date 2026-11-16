local TextService = game:GetService("TextService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Logger = require(parent.Logger)
local GetLegacyFont = require(script.Parent.GetLegacyFont)

local vector2 = Vector2.new(2, 2)

local function getTextSize(text: string, size: number, p, vector2_2: Vector2, flag: boolean?)
	local success, result, v = pcall(function()
		if flag then
			local getTextBoundsParams = Instance.new("GetTextBoundsParams")
			getTextBoundsParams.Font = normalizeFontFace(p)
			getTextBoundsParams.Size = size
			getTextBoundsParams.Text = text
			getTextBoundsParams.Width = vector2_2.X
			getTextBoundsParams.RichText = flag or false

			return TextService:GetTextBoundsAsync(getTextBoundsParams), false
		else
			local v, v2 = GetLegacyFont(p)

			if v == nil then
				return nil, v2
			end

			local v3 = v2 and v == Enum.Font.Cartoon

			local v4 = vector2_2.X
			local v5

			if v4 > 0 then
				v5 = v4 < 1e999
			else
				v5 = false
			end

			if v5 then
				if v3 then
					v4 /= 1.01
				end
			else
				v4 = 1e999
			end

			return TextService:GetTextSize(text, size, v, (Vector2.new(v4, 1e999))), v3
		end
	end)

	if success and result then
		local vector2_3 = Vector2.new(result.X, (math.min(result.Y, vector2_2.Y)))

		if not v then
			return vector2_3 + vector2
		end

		local v2 = math.ceil(vector2_3.X * 1.01)

		if vector2_2.X > 0 and vector2_2.X < 1e999 then
			v2 = math.min(v2, vector2_2.X)
		end

		vector2_3 = Vector2.new(v2, vector2_3.Y)

		return vector2_3 + vector2
	end

	if success then
		Logger:warning("Font cannot be measured, falling back to frame size")
	else
		Logger:warning(`Text measurement failed, falling back to frame size. Error: {result}`)
	end

	return vector2_2
end

return getTextSize

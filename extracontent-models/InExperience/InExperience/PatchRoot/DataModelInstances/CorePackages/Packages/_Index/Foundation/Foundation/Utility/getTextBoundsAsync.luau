local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local Services = require(Foundation.Utility.Wrappers.Services)
local TextService = Services.TextService

local function getTextBoundsAsync(text: string, p, size: number, value: number?)
	local fontFace = normalizeFontFace(p)

	if typeof(fontFace) ~= "Font" then
		return nil
	end

	local getTextBoundsParams = Instance.new("GetTextBoundsParams")
	getTextBoundsParams.Text = text
	getTextBoundsParams.Font = fontFace
	getTextBoundsParams.Size = size
	getTextBoundsParams.Width = value or 1e999

	local success, result = pcall(function()
		return TextService:GetTextBoundsAsync(getTextBoundsParams)
	end)

	getTextBoundsParams:Destroy()
	return if success then result else nil
end

return getTextBoundsAsync

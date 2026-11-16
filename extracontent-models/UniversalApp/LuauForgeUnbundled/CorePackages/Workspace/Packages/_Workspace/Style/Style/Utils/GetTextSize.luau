local TextService = game:GetService("TextService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local getTextSize = UIBlox.Core.Text.GetTextSize

local vector2 = Vector2.new(2, 2)

local function getTextSize2(p2, p3, p4, p5, p6)
	if not foundationFontFaceMigration then
		return TextService:GetTextSize(p2, p3, p4, p5) + vector2
	end

	local textSize = getTextSize(p2, p3, p4, p5)

	if p6 == nil or p6.addTemporaryPadding ~= false then
		return textSize
	end

	return textSize - vector2
end

return getTextSize2

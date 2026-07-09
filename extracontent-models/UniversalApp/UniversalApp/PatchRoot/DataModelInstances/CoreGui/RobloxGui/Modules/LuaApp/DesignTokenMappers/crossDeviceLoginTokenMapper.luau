local CorePackages = game:GetService("CorePackages")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

return function(p1, p2) -- line: 12
	-- upvalues: AppFonts (copy), UiMode (copy)
	local Size_400 = p2.Size.Size_400
	local Size_2000 = p2.Size.Size_2000
	local Size_500 = p2.Size.Size_500
	local Size_2400 = p2.Size.Size_2400
	local t1 = {
		FontSize = 24,
		Font = AppFonts.default:getMedium()
	}
	local t2 = {
		FontSize = 24,
		Font = AppFonts.default:getMedium()
	}
	local t3 = {
		FontSize = 19,
		Font = AppFonts.default:getDefault()
	}
	local Emphasis = p2.Color.Content.Emphasis
	local Emphasis2 = p2.Color.Content.Emphasis
	local Emphasis3 = p2.Color.Content.Emphasis
	local t4 = {
		FontSize = 14,
		Font = AppFonts.default:getDefault()
	}
	local Alert = p2.Color.System.Alert
	local n1 = 0
	local Bottom = Enum.VerticalAlignment.Bottom
	local n2 = 1

	if p1.uiMode == UiMode.TenFoot then
		Size_400 = p2.Size.Size_1600
		Size_2000 = p2.Size.Size_1600
		Size_500 = p2.Size.Size_600 + p2.Size.Size_400
		Size_2400 = p2.Size.Size_1600 * 2
		t2 = p2.Typography.HeadingSmall
		t1 = p2.Typography.TitleLarge
		t3 = p2.Typography.BodyLarge
		Emphasis3 = p2.Color.Content.Default
		t4 = p2.Typography.BodySmall
		n1 = p2.Size.Size_200
		Bottom = Enum.VerticalAlignment.Center
		n2 = 0.5
	end

	return {
		verticalPadding = Size_500,
		iconSize = Size_2400,
		layoutHeaderFont = t2,
		headerFont = t1,
		bodyFont = t3,
		layoutTextColor = Emphasis,
		headerTextColor = Emphasis2,
		bodyTextColor = Emphasis3,
		textAlertFont = t4,
		textAlertColor = Alert,
		headerPadding = n1,
		warningTextVerticalAlignment = Bottom,
		buttonFrameWidth = n2,
		getDevicePadding = function(p3) -- line: 70
			-- upvalues: Size_2000 (ref), Size_400 (ref)
			if p3 then
				return Size_2000
			end

			return Size_400
		end
	}
end

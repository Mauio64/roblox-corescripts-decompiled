local supportPaneMode = require("@luauforge/bundled/dGL").Enums.SupportPaneMode

local function getThemeBackgroundSplitPaneClip(p2, p3)
	if p2 == supportPaneMode.Expanded then
		return { isHidden = true, clipRight = nil }
	end

	if p2 == supportPaneMode.Normal and p3 then
		return { isHidden = false, clipRight = p3.Max.X }
	end

	return { isHidden = false, clipRight = nil }
end

return getThemeBackgroundSplitPaneClip

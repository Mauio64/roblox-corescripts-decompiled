local function getUIScaleFromTokens(p2)
	if p2 and p2.Config and p2.Config.UI and p2.Config.UI.Scale then
		return p2.Config.UI.Scale
	end

	return 1
end

return getUIScaleFromTokens

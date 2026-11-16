local function getUIScaleFromTokens(p)
	if p and p.Config and p.Config.UI and p.Config.UI.Scale then
		return p.Config.UI.Scale
	end

	return 1
end

return getUIScaleFromTokens

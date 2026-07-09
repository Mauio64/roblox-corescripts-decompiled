local function getUIScaleFromTokens(p1) -- line: 6
	if p1 and (p1.Config and p1.Config.UI and p1.Config.UI.Scale) then
		return p1.Config.UI.Scale
	end

	return 1
end

return getUIScaleFromTokens

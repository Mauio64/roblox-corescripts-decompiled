local v1 = game:DefineFastFlag("RemoveDeprecatedGuiObjectApisIsElementContentful", false)
local t1 = {
	ImageLabel = true,
	ImageButton = true,
	TextLabel = true,
	TextBox = true,
	TextButton = true,
	VideoFrame = true,
	ViewportFrame = true
}

function isElementContentful(p1) -- line: 14
	-- upvalues: v1 (copy), t1 (copy)
	if v1 then
		if not p1.Visible or p1.BackgroundTransparency == 1 then
			return false
		end
	elseif not p1.Visible or p1.Transparency == 1 then
		return false
	end

	return t1[p1.ClassName]
end

return isElementContentful

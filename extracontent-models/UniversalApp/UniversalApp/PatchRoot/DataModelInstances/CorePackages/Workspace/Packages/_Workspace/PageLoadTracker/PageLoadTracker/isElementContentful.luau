local t1 = {
	ImageLabel = true,
	ImageButton = true,
	TextLabel = true,
	TextBox = true,
	TextButton = true,
	VideoFrame = true,
	ViewportFrame = true
}

function isElementContentful(p1) -- line: 11
	-- upvalues: t1 (copy)
	if not p1.Visible or p1.Transparency == 1 then
		return false
	end

	return t1[p1.ClassName]
end

return isElementContentful

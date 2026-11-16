local function getGuiObjectBackgroundTransparency(object)
	local success, result = pcall(function()
		return object:GetStyled("BackgroundTransparency")
	end)

	if success and type(result) == "number" then
		return result
	end

	return object.BackgroundTransparency
end

return getGuiObjectBackgroundTransparency

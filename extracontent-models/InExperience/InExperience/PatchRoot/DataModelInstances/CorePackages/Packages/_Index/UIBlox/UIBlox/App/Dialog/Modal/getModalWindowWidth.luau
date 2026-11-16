local function getModalWindowWidth(p: number)
	return p < 540 and p or 540
end

return getModalWindowWidth

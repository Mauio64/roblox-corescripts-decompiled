local function getRectCenter(rect: Rect)
	return (rect.Min + rect.Max) / 2
end

return getRectCenter

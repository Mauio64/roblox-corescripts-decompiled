local function getRectCenter(rect: Rect) -- line: 2
	return (rect.Min + rect.Max) / 2
end

return getRectCenter

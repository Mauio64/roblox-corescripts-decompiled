local Rect = {}

function Rect.rectangle(p, p2)
	return { top = p2, bottom = p2, left = p, right = p }
end

function Rect.square(p)
	return { top = p, bottom = p, left = p, right = p }
end

function Rect.quad(top, right, bottom, left)
	return { top = top, bottom = bottom, left = left, right = right }
end

return Rect

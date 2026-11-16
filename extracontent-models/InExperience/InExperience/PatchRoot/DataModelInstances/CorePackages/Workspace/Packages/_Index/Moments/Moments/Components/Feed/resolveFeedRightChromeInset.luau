local function resolveFeedRightChromeInset(p, p2: number?, p3: number)
	if p2 == nil then
		return (math.max(p.right, p3))
	end

	return (math.max(p.right, p2))
end

return resolveFeedRightChromeInset

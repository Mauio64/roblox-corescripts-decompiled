local function resolveFeedRightChromeInset(p2, p3, p4)
	if p3 == nil then
		return (math.max(p2.right, p4))
	end

	return (math.max(p2.right, p3))
end

return resolveFeedRightChromeInset

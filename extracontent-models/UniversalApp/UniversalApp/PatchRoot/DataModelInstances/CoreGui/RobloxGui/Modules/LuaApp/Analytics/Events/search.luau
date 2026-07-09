local LocalizationService = game:GetService("LocalizationService")

return function(p1, p2, p3, p4, b1: boolean?, s1: string?) -- line: 13
	-- upvalues: LocalizationService (copy)
	assert(type(p2) == "string", "Expected eventContext to be a string")
	assert(type(p3) == "string", "Expected act to be a string")

	if p4 then
		assert(type(p4) == "string", "Expected keyword to be a string")
	end

	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	p1:setRBXEventStream(p2, "search", {
		act = p3,
		kwd = p4,
		locale = RobloxLocaleId,
		isAutoSearchType = b1 or false,
		currentPage = s1
	})
end

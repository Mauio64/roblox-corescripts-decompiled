local LocalizationService = game:GetService("LocalizationService")

return function(object, value, value2, value3, p2, p3)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected act to be a string")

	if value3 then
		assert(type(value3) == "string", "Expected keyword to be a string")
	end

	object:setRBXEventStream(value, "search", {
		act = value2,
		kwd = value3,
		locale = LocalizationService.RobloxLocaleId,
		isAutoSearchType = p2 or false,
		currentPage = p3
	})
end

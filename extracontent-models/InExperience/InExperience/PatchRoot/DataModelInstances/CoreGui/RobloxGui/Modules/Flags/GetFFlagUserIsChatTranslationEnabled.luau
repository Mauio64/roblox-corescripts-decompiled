local ok, result = pcall(function() -- line: 1
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

return function() -- line: 5
	-- upvalues: ok (copy), result (copy)
	return ok and result
end

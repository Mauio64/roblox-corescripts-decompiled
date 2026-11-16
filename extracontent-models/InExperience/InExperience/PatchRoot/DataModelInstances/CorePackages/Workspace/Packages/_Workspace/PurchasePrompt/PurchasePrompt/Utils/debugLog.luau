local defineFastFlag = game:DefineFastFlag("PPDebugLogging", false)

return function(callback)
	if defineFastFlag and callback then
		print("[PurchasePrompt]" .. callback())
	end
end

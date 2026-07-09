local v1 = game:DefineFastFlag("PPDebugLogging", false)

return function(p1) -- line: 3
	-- upvalues: v1 (copy)
	if not v1 or not p1 then
		return
	end

	print("[PurchasePrompt]" .. p1())
end

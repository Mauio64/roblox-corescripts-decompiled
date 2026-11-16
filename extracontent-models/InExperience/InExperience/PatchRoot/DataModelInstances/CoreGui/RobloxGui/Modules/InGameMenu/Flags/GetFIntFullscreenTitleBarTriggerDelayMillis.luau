game:DefineFastInt("FullscreenTitleBarTriggerDelayMillis", 0)

return function()
	local fastInt = game:GetFastInt("FullscreenTitleBarTriggerDelayMillis")
	return fastInt < 0 and 0 or fastInt
end

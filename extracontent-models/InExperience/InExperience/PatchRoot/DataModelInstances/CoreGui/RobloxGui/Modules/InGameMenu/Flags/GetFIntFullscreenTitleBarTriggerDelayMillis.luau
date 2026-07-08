game:DefineFastInt("FullscreenTitleBarTriggerDelayMillis", 0)

return function() -- line: 5
	local FastInt = game:GetFastInt("FullscreenTitleBarTriggerDelayMillis")

	if FastInt < 0 then
		FastInt = 0
	end

	return FastInt
end

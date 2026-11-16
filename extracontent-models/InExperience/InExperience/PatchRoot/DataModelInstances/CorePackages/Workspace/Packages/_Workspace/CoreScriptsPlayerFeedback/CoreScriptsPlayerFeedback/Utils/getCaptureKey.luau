local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
require(CoreScriptsPlayerFeedback.CaptureTypes)

return function(p)
	if p.CaptureTime ~= nil then
		return `{p.LocalId}_{p.CaptureTime.UnixTimestampMillis}`
	end

	if p.LocalId == nil then
		return (tostring(p))
	end

	return (tostring(p.LocalId))
end

local ParentParent = script.Parent.Parent
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)
local v3 = game:DefineFastFlag("ClientErrorAdditionalArgs", false)

return function(s1: string, s2: string, s3: string?, s4: string?) -- line: 5
	-- upvalues: v3 (copy), checkAndSendEvent (copy)
	local t1 = {}

	if s2 then
		t1.state = s2
	end

	if v3 and s3 then
		t1.url = s3
	end

	if v3 and s4 then
		t1.origin = s4
	end

	checkAndSendEvent(s1, "authClientError", t1)
end

local ParentParent = script.Parent.Parent
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)

return function(s1: string, s2: string?, s3: string?, s4: string?, p1) -- line: 4
	-- upvalues: checkAndSendEvent (copy)
	local t1 = {}

	if s2 then
		t1.field = s2
	end

	if s3 then
		t1.state = s3
	end

	if s4 then
		t1.origin = s4
	end

	if p1 ~= nil then
		t1.entered = tostring(p1)
	end

	checkAndSendEvent(s1, "authFormInteraction", t1)
end

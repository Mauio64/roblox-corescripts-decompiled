local ParentParent = script.Parent.Parent
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)

return function(s1: string, s2: string, s3: string?, s4: string?, b1: boolean?, s5: string?, s6: string?) -- line: 4
	-- upvalues: checkAndSendEvent (copy)
	local t1 = {}

	if s2 then
		t1.btn = s2
	end

	if s3 then
		t1.state = s3
	end

	if s4 then
		t1.url = s4
	end

	if b1 ~= nil then
		t1.is_alt_attempt = b1
	end

	if s5 then
		t1.origin = s5
	end

	if s6 then
		t1.ctype = s6
	end

	checkAndSendEvent(s1, "authButtonClick", t1)
end

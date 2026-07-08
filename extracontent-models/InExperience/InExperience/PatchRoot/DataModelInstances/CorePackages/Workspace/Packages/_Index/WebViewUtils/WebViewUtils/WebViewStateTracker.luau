local t1 = {}
local u2 = nil
local u3 = nil
local u4 = false
local u5 = nil

local function defaultClock() -- line: 17
	return os.clock()
end

local u7 = defaultClock

function t1._setClockForTesting(p1: ((...any) -> ...any)) -- line: 24
	-- upvalues: u7 (ref)
	u7 = p1
end
function t1.markClosed() -- line: 31
	-- upvalues: u4 (ref), u2 (ref), u7 (ref), u5 (ref)
	if u4 or u2 == nil then
		u2 = u7()
	end

	u4 = false
	u5 = nil
end
function t1.updateMetadata(s1: string, s2: string?, b1: boolean?, b2: boolean?) -- line: 46
	-- upvalues: u5 (ref)
	u5 = {
		url = s1,
		title = s2,
		isVisible = b1,
		hasBackButton = b2
	}
end
function t1.markOpen(s3: string, s4: string?, b3: boolean?, b4: boolean?) -- line: 67
	-- upvalues: u4 (ref), u3 (ref), u7 (ref), t1 (copy)
	if not u4 or u3 == nil then
		u3 = u7()
	end

	u4 = true
	t1.updateMetadata(s3, s4, b3, b4)
end
function t1.isOpen() -- line: 79
	-- upvalues: u4 (ref)
	return u4
end
function t1.wasLastClosed() -- line: 87
	-- upvalues: u2 (ref), u7 (ref)
	if u2 == nil then
		return -1
	end

	return u7() - u2
end
function t1.getOpenDuration() -- line: 99
	-- upvalues: u3 (ref), u7 (ref)
	if u3 == nil then
		return -1
	end

	return u7() - u3
end
function t1.wasClosedWithin(n1: number) -- line: 112
	-- upvalues: u2 (ref), u7 (ref)
	if u2 == nil then
		return false
	end

	return n1 >= u7() - u2
end
function t1.isOpenNoLongerThan(b5: boolean, n2: number) -- line: 127
	-- upvalues: u4 (ref), u3 (ref), u7 (ref)
	if not b5 then
		return u4
	end

	if u3 == nil or u4 and n2 <= u7() - u3 then
		return false
	end

	return u4
end
function t1.getWebViewMetadata() -- line: 143
	-- upvalues: u5 (ref)
	return u5
end

return t1

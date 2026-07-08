local Parent = script:FindFirstAncestor("Utils").Parent
local TextSplitBy = require(Parent.Enums.TextSplitBy)

local function isWhitespace(s1: string) -- line: 9
	return s1:match("%s") ~= nil
end
local function codepointEnd(s2: string, n1: number) -- line: 14
	local v12 = utf8.offset(s2, n1 + 1)

	if v12 ~= nil then
		return v12 - 1
	end

	return #s2
end

local t1 = {}

t1.__index = t1

function t1.new(s3: string, n2: number, n3: number, n4: number) -- line: 32
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self._text = s3
	self._initialGuess = self:_guessInitialBreak(n2, n3, n4)
	self._index = self._initialGuess
	self:setDirection(1)

	return self
end
function t1._guessInitialBreak(t2: {[any]: any}, _: number, n6: number, n7: number) -- line: 44
	return (math.max(math.floor(#t2._text * n7 / n6), 1))
end
function t1.findPossibleBreak(p1) -- line: 48
	local _index = p1._index

	while p1.direction == 1 and _index <= #p1._text or p1.direction == -1 and _index > 0 do
		if p1._text:sub(_index, _index):match("%s") ~= nil then
			p1._index = _index + p1._step

			return _index - 1
		end

		_index += p1._step
	end

	return _index
end
function t1.setDirection(t3: {[any]: any}, n8: number) -- line: 63
	t3.direction = n8

	if n8 ~= 1 then
		t3._index = t3._initialGuess
	end

	t3._step = n8 ~= 1 and -1 or 1
end

local t4 = {}

t4.__index = t4

function t4.new(s4: string, n9: number, n10: number, n11: number) -- line: 75
	-- upvalues: t4 (copy)
	local self = setmetatable({}, t4)

	self._text = s4
	self._initialGuess = self:_guessInitialBreak(n9, n10, n11)
	self._codepointIndex = self._initialGuess
	self._step = 0

	return self
end
function t4._guessInitialBreak(_: {[any]: any}, n12: number, n13: number, n14: number) -- line: 84
	return (math.max(math.floor(n12 * n14 / n13), 1))
end
function t4.findPossibleBreak(p2) -- line: 88
	p2._codepointIndex = p2._codepointIndex + p2._step

	local _text = p2._text
	local _codepointIndex = p2._codepointIndex
	local v38 = utf8.offset(_text, _codepointIndex + 1)

	if v38 ~= nil then
		return v38 - 1
	end

	return #_text
end
function t4.setDirection(p3, p4) -- line: 93
	p3.direction = p4
	p3._step = p4 ~= 1 and -1 or 1
end

local function splitWith(t6: {[any]: any}, p5: ((...any) -> ...any), s5: string, n15: number, n16: number, n17: number) -- line: 98
	local v47 = t6.new(s5, n15, n16, n17)
	local v48 = v47:findPossibleBreak()
	local v49 = s5:sub(1, v48)
	local v50 = not (n17 < p5(v49)) and 1 or -1
	local v51 = v48

	v47:setDirection(v50)

	local n18 = 0

	while n18 < n15 do
		v48 = v47:findPossibleBreak()
		v49 = s5:sub(1, v48)

		local v53 = not (n17 < p5(v49)) and 1 or -1

		if v50 ~= v53 then
			if v50 ~= 1 then
				return v49, v48
			end

			return s5:sub(1, v51), v51
		end

		v50 = v53
		v51 = v48
		n18 += 1
	end

	return v49, v48
end
local function split(p6, p7: ((...any) -> ...any), s6: string, n19: number) -- line: 174
	-- upvalues: TextSplitBy (copy), t1 (copy), t4 (copy), splitWith (copy)
	local v58 = utf8.len(s6)

	if v58 == nil then
		warn("Failed to get string length, it is probably malformed or non utf8")

		return s6
	end

	local v59 = p7(s6)

	if v59 <= n19 then
		return s6
	end

	local v60 = if p6 ~= TextSplitBy.Word then t4 else t1
	local v61, v62 = splitWith(v60, p7, s6, v58, v59, n19)

	if v62 == 0 or v62 == #s6 then
		return s6
	end

	return v61, (s6:sub(v62 + 1))
end

return split

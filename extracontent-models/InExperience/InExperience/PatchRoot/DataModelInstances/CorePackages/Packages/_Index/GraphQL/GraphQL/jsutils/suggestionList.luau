local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local naturalCompare = require(script.Parent.naturalCompare).naturalCompare
local t1 = {}
local stringToArray = nil

t1.__index = t1

function t1.new(s1: string) -- line: 78
	-- upvalues: t1 (copy), stringToArray (ref)
	local self = setmetatable({}, t1)

	self._input = s1
	self._inputLowerCase = s1:lower()
	self._inputArray = stringToArray(self._inputLowerCase)

	local v17 = s1:len()

	self._rows = {
		table.create(v17 + 1, 0),
		table.create(v17 + 1, 0),
		table.create(v17 + 1, 0)
	}

	return self
end
function t1.measure(t2: {[any]: any}, s2: string, n1: number) -- line: 93
	-- upvalues: stringToArray (ref)
	if s2 == t2._input then
		return 0
	end

	local v21 = s2:lower()

	if v21 == t2._inputLowerCase then
		return 1
	end

	local v22 = stringToArray(v21)
	local _inputArray = t2._inputArray

	if #v22 < #_inputArray then
		local v24 = _inputArray

		_inputArray = v22
		v22 = v24
	end

	local v25 = #v22
	local v26 = #_inputArray

	if n1 < v25 - v26 then
		return nil
	end

	local _rows = t2._rows

	for i = 0, v26 do
		_rows[1][i + 1] = i
	end

	for i = 1, v25 do
		local v30 = _rows[(i - 1) % 3 + 1]
		local v31 = _rows[i % 3 + 1]

		v31[1] = i

		local v32 = i

		for j = 1, v26 do
			local v34 = v22[i] ~= _inputArray[j] and 1 or 0
			local v35 = math.min(v30[j + 1] + 1, v31[j] + 1, v30[j] + v34)

			if i > 1 and j > 1 and v22[i] == _inputArray[j - 1] and v22[i - 1] == _inputArray[j] then
				v35 = math.min(v35, _rows[(i - 2) % 3 + 1][j - 1] + 1)
			end

			if v35 < v32 then
				v32 = v35
			end

			v31[j + 1] = v35
		end

		if n1 < v32 then
			return nil
		end
	end

	local v36 = _rows[v25 % 3 + 1][v26 + 1]

	if v36 <= n1 then
		return v36
	end

	return nil
end
function stringToArray(s3: string) -- line: 168
	local t3 = {}

	for i = 1, s3:len() do
		t3[i] = s3:byte(i)
	end

	return t3
end

return {
	suggestionList = function(s4: string, p1) -- line: 34
		-- upvalues: t1 (copy), Object (copy), naturalCompare (copy)
		local t4 = {}
		local v9 = t1.new(s4)
		local v10 = math.floor(s4:len() * 0.4) + 1

		for i = 1, #p1 do
			local v12 = p1[i]
			local v13 = v9:measure(v12, v10)

			if v13 ~= nil then
				t4[v12] = v13
			end
		end

		local v14 = Object.keys(t4)

		table.sort(v14, function(p2, p3) -- line: 49
			-- upvalues: t4 (copy), naturalCompare (copy)
			local v42 = t4[p2] - t4[p3]

			if v42 ~= 0 then
				return v42 < 0
			end

			return naturalCompare(p2, p3) < 0
		end)

		return v14
	end
}

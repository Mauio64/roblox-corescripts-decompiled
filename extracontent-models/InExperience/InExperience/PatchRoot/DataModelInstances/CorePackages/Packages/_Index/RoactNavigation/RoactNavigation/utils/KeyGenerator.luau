local v = "id-" .. tostring(math.random(100000, 1000000))
local count = 0
local KeyGenerator = {}

function KeyGenerator._TESTING_ONLY_normalize_keys()
	v = "id-"
	count = 0
end

function KeyGenerator.generateKey()
	local key = v .. tostring(count)
	count += 1
	return key
end

return KeyGenerator

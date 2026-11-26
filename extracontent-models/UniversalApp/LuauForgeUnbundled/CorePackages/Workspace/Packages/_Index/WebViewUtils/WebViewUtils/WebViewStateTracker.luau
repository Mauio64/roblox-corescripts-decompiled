local v5 = {}

local v6 = nil
local v7 = nil

local v8 = false

local webViewMetadata = nil

local function defaultClock()
	return os.clock()
end

local v9 = defaultClock

function v5._setClockForTesting(p2)
	v9 = p2
end

function v5.markClosed()
	if v8 or v6 == nil then
		v6 = v9()
	end

	v8 = false
	webViewMetadata = nil
end

function v5.updateMetadata(p2, p3, p4, p5)
	webViewMetadata = { url = p2, title = p3, isVisible = p4, hasBackButton = p5 }
end

function v5.markOpen(p2, p3, p4, p5)
	if not v8 or v7 == nil then
		v7 = v9()
	end

	v8 = true
	v5.updateMetadata(p2, p3, p4, p5)
end

function v5.isOpen()
	return v8
end

function v5.wasLastClosed()
	if v6 == nil then
		return -1
	end

	return v9() - v6
end

function v5.getOpenDuration()
	if v7 == nil then
		return -1
	end

	return v9() - v7
end

function v5.wasClosedWithin(p2): boolean
	if v6 == nil then
		return false
	end

	return v9() - v6 <= p2
end

function v5.isOpenNoLongerThan(p2, p3)
	if not p2 then
		return v8
	end

	if v7 == nil or v8 and p3 <= v9() - v7 then
		return false
	end

	return v8
end

function v5.getWebViewMetadata()
	return webViewMetadata
end

return v5

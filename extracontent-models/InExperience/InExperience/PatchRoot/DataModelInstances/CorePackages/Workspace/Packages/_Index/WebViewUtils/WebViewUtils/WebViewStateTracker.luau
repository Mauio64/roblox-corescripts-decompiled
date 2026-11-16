local WebViewStateTracker = {}

local v = nil
local v2 = nil

local v3 = false

local webViewMetadata = nil

local function defaultClock()
	return os.clock()
end

local v4 = defaultClock

function WebViewStateTracker._setClockForTesting(callback)
	v4 = callback
end

function WebViewStateTracker.markClosed()
	if v3 or v == nil then
		v = v4()
	end

	v3 = false
	webViewMetadata = nil
end

function WebViewStateTracker.updateMetadata(url: string, title: string?, isVisible: boolean?, hasBackButton: boolean?)
	webViewMetadata = {
		url = url,
		title = title,
		isVisible = isVisible,
		hasBackButton = hasBackButton
	}
end

function WebViewStateTracker.markOpen(p: string, p2: string?, flag: boolean?, flag2: boolean?)
	if not v3 or v2 == nil then
		v2 = v4()
	end

	v3 = true
	WebViewStateTracker.updateMetadata(p, p2, flag, flag2)
end

function WebViewStateTracker.isOpen()
	return v3
end

function WebViewStateTracker.wasLastClosed()
	if v == nil then
		return -1
	end

	return v4() - v
end

function WebViewStateTracker.getOpenDuration()
	if v2 == nil then
		return -1
	end

	return v4() - v2
end

function WebViewStateTracker.wasClosedWithin(p: number): boolean
	return v ~= nil and v4() - v <= p
end

function WebViewStateTracker.isOpenNoLongerThan(flag: boolean, p: number)
	if not flag then
		return v3
	end

	return v2 ~= nil and not (v3 and p <= v4() - v2) and v3
end

function WebViewStateTracker.getWebViewMetadata()
	return webViewMetadata
end

return WebViewStateTracker

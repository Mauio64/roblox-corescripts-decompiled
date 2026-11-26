local module = require("@luauforge/bundled/egs")

local postAuthDeepLinkAvailableSignal = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.PostAuthDeepLinkAvailableSignal

local module2 = require("@luauforge/bundled/fHY")
local module3 = require("@luauforge/bundled/fHX")

local function followNavigationCallback(p2, p3): boolean
	if not module3(p2, p3) then
		return false
	end

	local success, result = pcall(function()
		return module2.new(p2):resolve(p3, {})
	end)

	if not success or module.is(result) or type(result) ~= "table" or next(result) == nil then
		return false
	end

	postAuthDeepLinkAvailableSignal:fire({
		url = p3,
		isInAppReturn = true,
		resolvedHistory = result
	})

	return true
end

return followNavigationCallback

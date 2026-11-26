local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/egs")

local postAuthDeepLinkAvailableSignal = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.PostAuthDeepLinkAvailableSignal

local module3 = require("@luauforge/bundled/fHX")

local function resolvedRoute(value)
	local module4 = require("@luauforge/bundled/fHY")
	local module5 = require("@luauforge/bundled/fIb")
	local success, result = pcall(function()
		return module4.new(module5):resolve(value, {})
	end)

	if success and not module2.is(result) and type(result) == "table" and next(result) ~= nil then
		return result
	end

	return nil
end

local function run(callback): boolean
	if typeof(callback) ~= "string" or not module3(require("@luauforge/bundled/fIb"), callback) then
		return false
	end

	local v5 = resolvedRoute(callback)

	if v5 == nil then
		return false
	end

	postAuthDeepLinkAvailableSignal:fire({
		url = callback,
		isInAppReturn = true,
		resolvedHistory = v5
	})

	return true
end

return {
	run = run,
	runOnHardwareBack = function(p2)
		if p2.name ~= module.Accessibility or typeof(p2.extraProps) ~= "table" then
			return false
		end

		local callback = p2.extraProps.callback

		if typeof(callback) == "string" then
			return run(callback)
		end

		return false
	end
}

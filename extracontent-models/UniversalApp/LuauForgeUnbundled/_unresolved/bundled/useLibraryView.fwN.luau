local module = require("@luauforge/bundled/fwD")
local module2 = require("@luauforge/bundled/fwF")
local module3 = require("@luauforge/bundled/fwM")
local module4 = require("@luauforge/bundled/fwG")

local module5 = require("@luauforge/bundled/fwJ")
local module6 = require("@luauforge/bundled/fwO")

local getSduiClientPageScope = module2.getSduiClientPageScope
local usePageScopeRef = module2.usePageScopeRef

local view = module3.apppageplatform.userlibrary.user_library_page.View

local function isView(value): boolean
	if typeof(value) ~= "string" then
		return false
	end

	local v5 = view.fromName(value)
	return v5 ~= nil and v5 ~= "VIEW_INVALID"
end

local function useLibraryView(p2, p3)
	local configKey = module5.getConfigKey(p3, p2, "VIEW_ALL")

	local v5 = usePageScopeRef(configKey)

	module.useMemo(function()
		v5.set(module5.ViewScopeField, "VIEW_ALL")
	end, { v5 })

	local v6 = module4.useSignalState(v5.getSignal(module5.ViewScopeField))
	local v7

	if typeof(v6) == "string" then
		local v8 = view.fromName(v6)
		v7 = not (v8 == nil) and v8 ~= "VIEW_INVALID"
	else
		v7 = false
	end

	local v8 = not v7 and "VIEW_ALL" or v6
	local v9 = module6(p2, v8, p3.surfaceKey)

	return {
		view = v8,
		overviewConfigKey = configKey,
		configKey = module5.getConfigKey(p3, p2, v8),
		listPageTimer = v9
	}
end

return useLibraryView

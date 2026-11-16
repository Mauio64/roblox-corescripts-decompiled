local parent = script.Parent.Parent
local SafeFlags = require(parent.SafeFlags)

if not SafeFlags.createGetFFlag("ReactIsolatedGlobalsEnabled")() then
	return _G
end

local function loadFromGlobal(p: string, p2) -- 17 equivalent calls inferred from this helper
	local v = _G[p]
	return if v == nil then p2 else v
end

return {
	__DEV__ = loadFromGlobal("__DEV__", false), -- inferred equivalent call
	__PROFILE__ = loadFromGlobal("__PROFILE__", false), -- inferred equivalent call
	__EXPERIMENTAL__ = loadFromGlobal("__EXPERIMENTAL__", false), -- inferred equivalent call
	__DEBUG__ = loadFromGlobal("__DEBUG__", false), -- inferred equivalent call
	__YOLO__ = loadFromGlobal("__YOLO__", false), -- inferred equivalent call
	__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = loadFromGlobal( -- inferred equivalent call
		"__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__",
		false
	),
	__REACT_DEVTOOLS_GLOBAL_HOOK__ = loadFromGlobal("__REACT_DEVTOOLS_GLOBAL_HOOK__"), -- inferred equivalent call
	__REACT_DEVTOOLS_ATTACH__ = loadFromGlobal("__REACT_DEVTOOLS_ATTACH__"), -- inferred equivalent call
	__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = loadFromGlobal("__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__", false), -- inferred equivalent call
	__REACT_DEVTOOLS_BREAK_ON_CONSOLE_ERRORS__ = loadFromGlobal("__REACT_DEVTOOLS_BREAK_ON_CONSOLE_ERRORS__", false), -- inferred equivalent call
	__REACT_DEVTOOLS_COMPONENT_FILTERS__ = loadFromGlobal("__REACT_DEVTOOLS_COMPONENT_FILTERS__"), -- inferred equivalent call
	__LOCALSTORAGE__ = loadFromGlobal("__LOCALSTORAGE__"), -- inferred equivalent call
	__SESSIONSTORAGE__ = loadFromGlobal("__SESSIONSTORAGE__"), -- inferred equivalent call
	__COMPAT_WARNINGS__ = loadFromGlobal("__COMPAT_WARNINGS__", false), -- inferred equivalent call
	__TESTEZ_RUNNING_TEST__ = loadFromGlobal("__TESTEZ_RUNNING_TEST__", false), -- inferred equivalent call
	__ROACT_17_MOCK_SCHEDULER__ = loadFromGlobal("__ROACT_17_MOCK_SCHEDULER__", false), -- inferred equivalent call
	__ROACT_17_INLINE_ACT__ = loadFromGlobal("__ROACT_17_INLINE_ACT__", false) -- inferred equivalent call
}

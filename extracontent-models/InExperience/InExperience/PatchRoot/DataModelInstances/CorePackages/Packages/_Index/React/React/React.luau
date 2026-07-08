local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ReactGlobals = require(scriptParentParent.ReactGlobals)

require(scriptParentParent.LuauPolyfill)

local ReactMutableSource = require(scriptParent.ReactMutableSource)
local ReactSharedInternals = require(scriptParentParent.Shared).ReactSharedInternals
local ReactBaseClasses = require(scriptParent.ReactBaseClasses)
local ReactChildren = require(scriptParent.ReactChildren)
local ReactElementValidator = require(scriptParent.ReactElementValidator)
local ReactElement = require(scriptParent.ReactElement)
local ReactCreateRef = require(scriptParent.ReactCreateRef)
local ReactForwardRef = require(scriptParent.ReactForwardRef)
local ReactHooks = require(scriptParent.ReactHooks)
local ReactMemo = require(scriptParent.ReactMemo)
local ReactContext = require(scriptParent.ReactContext)
local ReactLazy = require(scriptParent.ReactLazy)
local lib = require(scriptParent["ReactBinding.roblox"])
local lib2 = require(scriptParent["None.roblox"])
local ReactSymbols = require(scriptParentParent.Shared).ReactSymbols
local v19 = ReactGlobals.__DEV__ or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__

require(scriptParentParent.Shared)

local v20 = if not v19 then ReactElement.createElement else ReactElementValidator.createElementWithValidation
local v21 = if not v19 then ReactElement.cloneElement else ReactElementValidator.cloneElementWithValidation

return {
	Children = ReactChildren,
	createMutableSource = ReactMutableSource,
	createRef = ReactCreateRef.createRef,
	Component = ReactBaseClasses.Component,
	PureComponent = ReactBaseClasses.PureComponent,
	createContext = ReactContext.createContext,
	forwardRef = ReactForwardRef.forwardRef,
	lazy = ReactLazy.lazy,
	memo = ReactMemo.memo,
	useCallback = ReactHooks.useCallback,
	useContext = ReactHooks.useContext,
	useEffect = ReactHooks.useEffect,
	useImperativeHandle = ReactHooks.useImperativeHandle,
	useDebugValue = ReactHooks.useDebugValue,
	useLayoutEffect = ReactHooks.useLayoutEffect,
	useMemo = ReactHooks.useMemo,
	useMutableSource = ReactHooks.useMutableSource,
	useReducer = ReactHooks.useReducer,
	useRef = ReactHooks.useRef,
	useBinding = ReactHooks.useBinding,
	useState = ReactHooks.useState,
	Fragment = ReactSymbols.REACT_FRAGMENT_TYPE,
	Profiler = ReactSymbols.REACT_PROFILER_TYPE,
	StrictMode = ReactSymbols.REACT_STRICT_MODE_TYPE,
	unstable_DebugTracingMode = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE,
	Suspense = ReactSymbols.REACT_SUSPENSE_TYPE,
	createElement = v20,
	cloneElement = v21,
	isValidElement = ReactElement.isValidElement,
	__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = ReactSharedInternals,
	unstable_LegacyHidden = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE,
	createBinding = lib.create,
	joinBindings = lib.join,
	None = lib2,
	__subscribeToBinding = lib.subscribe,
	Event = require(scriptParentParent.Shared).Event,
	Change = require(scriptParentParent.Shared).Change,
	Tag = require(scriptParentParent.Shared).Tag,
	unstable_parseReactError = require(scriptParentParent.Shared).parseReactError
}

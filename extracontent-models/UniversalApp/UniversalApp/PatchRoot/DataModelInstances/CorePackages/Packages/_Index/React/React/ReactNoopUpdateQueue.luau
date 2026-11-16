local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local set = {}

local function warnNoop(p, p2: string) -- 3 equivalent calls inferred from this helper
	if ReactGlobals.__DEV__ then
		local __componentName = p.__componentName or "ReactClass"
		local v = __componentName .. "." .. p2

		if set[v] then
			return
		end

		console.error(
			"Can't call %s on a component that is not yet mounted. This is a no-op, but it might indicate a bug in your application. Instead, assign to `self.state` directly with the desired state in the %s component's `init` method.",
			p2,
			__componentName
		)

		set[v] = true
	end
end

local ReactNoopUpdateQueue = {}

function ReactNoopUpdateQueue.isMounted(_): boolean
	return false
end

function ReactNoopUpdateQueue.enqueueForceUpdate(p, _, _)
	warnNoop(p, "forceUpdate") -- inferred equivalent call
end

function ReactNoopUpdateQueue.enqueueReplaceState(p, _, _, _)
	warnNoop(p, "replaceState") -- inferred equivalent call
end

function ReactNoopUpdateQueue.enqueueSetState(p, _, _, _)
	warnNoop(p, "setState") -- inferred equivalent call
end

return ReactNoopUpdateQueue

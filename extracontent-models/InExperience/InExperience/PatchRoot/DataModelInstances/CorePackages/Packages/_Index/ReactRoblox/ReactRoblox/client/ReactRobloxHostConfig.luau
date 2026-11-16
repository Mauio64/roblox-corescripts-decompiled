local function unimplemented(p: string) -- 11 equivalent calls inferred from this helper
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(p))
	error("FIXME (roblox): " .. p .. " is unimplemented", 2)
end

local CollectionService = game:GetService("CollectionService")
local parent = script.Parent.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local Shared = require(parent.Shared)
local console = Shared.console
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

require(script.Parent["ReactRobloxHostTypes.roblox"])

local ReactRobloxComponentTree = require(script.Parent.ReactRobloxComponentTree)
local precacheFiberNode = ReactRobloxComponentTree.precacheFiberNode
local uncacheFiberNode = ReactRobloxComponentTree.uncacheFiberNode
local updateFiberProps = ReactRobloxComponentTree.updateFiberProps

local ReactRobloxComponent = require(script.Parent.ReactRobloxComponent)

local setInitialProperties = ReactRobloxComponent.setInitialProperties
local diffProperties = ReactRobloxComponent.diffProperties
local updateProperties = ReactRobloxComponent.updateProperties
local cleanupHostComponent = ReactRobloxComponent.cleanupHostComponent

local Shared2 = require(parent.Shared)
local enableCreateEventHandleAPI = Shared2.ReactFeatureFlags.enableCreateEventHandleAPI

local function recursivelyUncacheFiberNode(folder) -- 1 equivalent call inferred from this helper
	if typeof(folder) ~= "Instance" then
		return
	end

	uncacheFiberNode(folder)

	for _, descendant in folder:GetDescendants() do
		uncacheFiberNode(descendant)
	end
end

local ReactRobloxHostConfig = {}
local assign = Object.assign
local Shared3 = require(parent.Shared)
assign(ReactRobloxHostConfig, Shared3.ReactFiberHostConfig.WithNoPersistence)

function ReactRobloxHostConfig.getRootHostContext(instance)
	return instance.ClassName
end

function ReactRobloxHostConfig.getChildHostContext(p, _: string, _)
	return p
end

function ReactRobloxHostConfig.getPublicInstance(p)
	return p
end

function ReactRobloxHostConfig.prepareForCommit(_): nil
	if enableCreateEventHandleAPI then
		unimplemented("enableCreateEventHandleAPI") -- inferred equivalent call
	end

	return nil
end

function ReactRobloxHostConfig.beforeActiveInstanceBlur()
	if enableCreateEventHandleAPI then
		unimplemented("enableCreateEventHandleAPI") -- inferred equivalent call
	end
end

function ReactRobloxHostConfig.afterActiveInstanceBlur()
	if enableCreateEventHandleAPI then
		unimplemented("enableCreateEventHandleAPI") -- inferred equivalent call
	end
end

function ReactRobloxHostConfig.resetAfterCommit(_) end

function ReactRobloxHostConfig.createInstance(className: string, p, _, _, p2)
	local instance = Instance.new(className)

	if p2.key then
		instance.Name = p2.key
	else
		local return_ = p2.return_

		while return_ do
			if return_.key then
				instance.Name = return_.key
				break
			end

			return_ = return_.return_
		end
	end

	precacheFiberNode(p2, instance)
	updateFiberProps(instance, p)

	return instance
end

function ReactRobloxHostConfig.appendInitialChild(parent2, p)
	p.Parent = parent2
end

function ReactRobloxHostConfig.finalizeInitialChildren(p, p2: string, p3, p4, _): boolean
	setInitialProperties(p, p2, p3, p4)
	return false
end

function ReactRobloxHostConfig.prepareUpdate(p, p2: string, p3, p4, p5, _)
	return diffProperties(p, p2, p3, p4, p5)
end

function ReactRobloxHostConfig.shouldSetTextContent(_: string, _): boolean
	return false
end

function ReactRobloxHostConfig.createTextInstance(_: string, _, _, _): nil
	unimplemented("createTextInstance") -- inferred equivalent call
	return nil
end

ReactRobloxHostConfig.isPrimaryRenderer = true
ReactRobloxHostConfig.warnsIfNotActing = true

ReactRobloxHostConfig.scheduleTimeout = setTimeout
ReactRobloxHostConfig.cancelTimeout = clearTimeout
ReactRobloxHostConfig.noTimeout = -1

ReactRobloxHostConfig.supportsMutation = true

ReactRobloxHostConfig.supportsChildOrdering = false

function ReactRobloxHostConfig.commitMount(_, _: string, _, _)
	unimplemented("commitMount") -- inferred equivalent call
end

function ReactRobloxHostConfig.commitUpdate(p, p2, _: string, p3, p4, _)
	updateFiberProps(p, p4)

	updateProperties(p, p2, p3)
end

local function checkTags(instance)
	if typeof(instance) ~= "Instance" then
		console.warn("Could not check tags on non-instance %s.", inspect(instance))
	elseif not instance:IsDescendantOf(game) and #CollectionService:GetTags(instance) > 0 then
		console.warn(
			"Tags applied to orphaned %s \"%s\" cannot be accessed via CollectionService:GetTagged. If you're relying on tag behavior in a unit test, consider mounting your test root into the DataModel.",
			instance.ClassName,
			instance.Name
		)
	end
end

function ReactRobloxHostConfig.appendChild(parent2, p)
	p.Parent = parent2

	if ReactGlobals.__DEV__ then
		checkTags(p)
	end
end

function ReactRobloxHostConfig.appendChildToContainer(p, p2)
	ReactRobloxHostConfig.appendChild(p, p2)
end

function ReactRobloxHostConfig.insertBefore(parent2, p, _)
	p.Parent = parent2

	if ReactGlobals.__DEV__ then
		checkTags(p)
	end
end

function ReactRobloxHostConfig.insertInContainerBefore(p, p2, p3)
	ReactRobloxHostConfig.insertBefore(p, p2, p3)
end

function ReactRobloxHostConfig.removeChild(_, instance)
	recursivelyUncacheFiberNode(instance) -- inferred equivalent call
	cleanupHostComponent(instance)

	instance.Parent = nil

	instance:Destroy()
end

function ReactRobloxHostConfig.removeChildFromContainer(p, p2)
	ReactRobloxHostConfig.removeChild(p, p2)
end

function ReactRobloxHostConfig.clearSuspenseBoundary(_, _)
	unimplemented("clearSuspenseBoundary") -- inferred equivalent call
end

function ReactRobloxHostConfig.clearSuspenseBoundaryFromContainer(_, _)
	unimplemented("clearSuspenseBoundaryFromContainer") -- inferred equivalent call
end

function ReactRobloxHostConfig.hideInstance(_)
	unimplemented("hideInstance") -- inferred equivalent call
end

function ReactRobloxHostConfig.hideTextInstance(_)
	unimplemented("hideTextInstance") -- inferred equivalent call
end

function ReactRobloxHostConfig.unhideInstance(_, _)
	unimplemented("unhideInstance") -- inferred equivalent call
end

function ReactRobloxHostConfig.unhideTextInstance(_, _: string)
	unimplemented("unhideTextInstance") -- inferred equivalent call
end

function ReactRobloxHostConfig.clearContainer(instance)
	for _, child in instance:GetChildren() do
		ReactRobloxHostConfig.removeChild(instance, child)
	end
end

function ReactRobloxHostConfig.preparePortalMount(_) end

return ReactRobloxHostConfig

local function unimplemented(s1: string) -- line: 13
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring(s1))
	error("FIXME (roblox): " .. s1 .. " is unimplemented", 2)
end

local CollectionService = game:GetService("CollectionService")
local ParentParent = script.Parent.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local console = require(ParentParent.Shared).console
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
local enableCreateEventHandleAPI = require(ParentParent.Shared).ReactFeatureFlags.enableCreateEventHandleAPI

local function recursivelyUncacheFiberNode(p1) -- line: 206
	-- upvalues: uncacheFiberNode (copy)
	if typeof(p1) ~= "Instance" then
		return
	end

	uncacheFiberNode(p1)

	for _, descendant in p1:GetDescendants() do
		uncacheFiberNode(descendant)
	end
end

local t1 = {}

Object.assign(t1, require(ParentParent.Shared).ReactFiberHostConfig.WithNoPersistence)

function t1.getRootHostContext(p2) -- line: 224
	return p2.ClassName
end
function t1.getChildHostContext(p3, _: string, _) -- line: 262
	return p3
end
function t1.getPublicInstance(p5) -- line: 283
	return p5
end
function t1.prepareForCommit(_) -- line: 287
	-- upvalues: enableCreateEventHandleAPI (copy)
	if enableCreateEventHandleAPI then
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("enableCreateEventHandleAPI"))
		error("FIXME (roblox): enableCreateEventHandleAPI is unimplemented", 2)
	end

	return nil
end
function t1.beforeActiveInstanceBlur() -- line: 302
	-- upvalues: enableCreateEventHandleAPI (copy)
	if enableCreateEventHandleAPI then
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("enableCreateEventHandleAPI"))
		error("FIXME (roblox): enableCreateEventHandleAPI is unimplemented", 2)
	end
end
function t1.afterActiveInstanceBlur() -- line: 311
	-- upvalues: enableCreateEventHandleAPI (copy)
	if enableCreateEventHandleAPI then
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		print("UNIMPLEMENTED ERROR: " .. tostring("enableCreateEventHandleAPI"))
		error("FIXME (roblox): enableCreateEventHandleAPI is unimplemented", 2)
	end
end
function t1.resetAfterCommit(_) -- line: 320
end
function t1.createInstance(s3: string, p8, _, _, t2: {[any]: any}) -- line: 328
	-- upvalues: precacheFiberNode (copy), updateFiberProps (copy)
	local v40 = Instance.new(s3)

	if t2.key then
		v40.Name = t2.key
	else
		local return_ = t2.return_

		while return_ do
			if return_.key then
				v40.Name = return_.key

				break
			end

			return_ = return_.return_
		end
	end

	precacheFiberNode(t2, v40)
	updateFiberProps(v40, p8)

	return v40
end
function t1.appendInitialChild(p11, p12) -- line: 395
	p12.Parent = p11
end
function t1.finalizeInitialChildren(p13, s4: string, p14, p15, _) -- line: 400
	-- upvalues: setInitialProperties (copy)
	setInitialProperties(p13, s4, p14, p15)

	return false
end
function t1.prepareUpdate(p17, s5: string, p18, p19, p20, _) -- line: 412
	-- upvalues: diffProperties (copy)
	return diffProperties(p17, s5, p18, p19, p20)
end
function t1.shouldSetTextContent(_: string, _) -- line: 439
	return false
end
function t1.createTextInstance(_: string, _, _, _: {[any]: any}) -- line: 455
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("createTextInstance"))
	error("FIXME (roblox): createTextInstance is unimplemented", 2)

	return nil
end

t1.isPrimaryRenderer = true
t1.warnsIfNotActing = true
t1.scheduleTimeout = setTimeout
t1.cancelTimeout = clearTimeout
t1.noTimeout = -1
t1.supportsMutation = true

function t1.commitMount(_, _: string, _, _: {[any]: any}) -- line: 481
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("commitMount"))
	error("FIXME (roblox): commitMount is unimplemented", 2)
end
function t1.commitUpdate(p27, t5: {[any]: any}, _: string, p28, p29, _: {[any]: any}) -- line: 503
	-- upvalues: updateFiberProps (copy), updateProperties (copy)
	updateFiberProps(p27, p29)
	updateProperties(p27, t5, p28)
end

local function checkTags(p30) -- line: 532
	-- upvalues: console (copy), inspect (copy), CollectionService (copy)
	if typeof(p30) ~= "Instance" then
		console.warn("Could not check tags on non-instance %s.", inspect(p30))

		return
	end

	if not p30:IsDescendantOf(game) and #CollectionService:GetTags(p30) > 0 then
		console.warn("Tags applied to orphaned %s \"%s\" cannot be accessed via CollectionService:GetTagged. If you're relying on tag behavior in a unit test, consider mounting your test root into the DataModel.", p30.ClassName, p30.Name)
	end
end

function t1.appendChild(p31, p32) -- line: 551
	-- upvalues: ReactGlobals (copy), checkTags (copy)
	p32.Parent = p31

	if ReactGlobals.__DEV__ then
		checkTags(p32)
	end
end
function t1.appendChildToContainer(p33, p34) -- line: 560
	-- upvalues: t1 (copy)
	t1.appendChild(p33, p34)
end
function t1.insertBefore(p35, p36, _) -- line: 589
	-- upvalues: ReactGlobals (copy), checkTags (copy)
	p36.Parent = p35

	if ReactGlobals.__DEV__ then
		checkTags(p36)
	end
end
function t1.insertInContainerBefore(p38, p39, p40) -- line: 602
	-- upvalues: t1 (copy)
	t1.insertBefore(p38, p39, p40)
end
function t1.removeChild(_, p42) -- line: 644
	-- upvalues: uncacheFiberNode (copy), cleanupHostComponent (copy)
	if typeof(p42) == "Instance" then
		uncacheFiberNode(p42)

		for _, descendant in p42:GetDescendants() do
			uncacheFiberNode(descendant)
		end
	end

	cleanupHostComponent(p42)
	p42.Parent = nil
	p42:Destroy()
end
function t1.removeChildFromContainer(p43, p44) -- line: 656
	-- upvalues: t1 (copy)
	t1.removeChild(p43, p44)
end
function t1.clearSuspenseBoundary(_, _) -- line: 667
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("clearSuspenseBoundary"))
	error("FIXME (roblox): clearSuspenseBoundary is unimplemented", 2)
end
function t1.clearSuspenseBoundaryFromContainer(_, _) -- line: 707
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("clearSuspenseBoundaryFromContainer"))
	error("FIXME (roblox): clearSuspenseBoundaryFromContainer is unimplemented", 2)
end
function t1.hideInstance(_) -- line: 724
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("hideInstance"))
	error("FIXME (roblox): hideInstance is unimplemented", 2)
end
function t1.hideTextInstance(_) -- line: 738
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("hideTextInstance"))
	error("FIXME (roblox): hideTextInstance is unimplemented", 2)
end
function t1.unhideInstance(_, _) -- line: 743
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("unhideInstance"))
	error("FIXME (roblox): unhideInstance is unimplemented", 2)
end
function t1.unhideTextInstance(_, _: string) -- line: 757
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. tostring("unhideTextInstance"))
	error("FIXME (roblox): unhideTextInstance is unimplemented", 2)
end
function t1.clearContainer(p54) -- line: 762
	-- upvalues: t1 (copy)
	for _, child in p54:GetChildren() do
		t1.removeChild(p54, child)
	end
end
function t1.preparePortalMount(_) -- line: 1205
end

return t1

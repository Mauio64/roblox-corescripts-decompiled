local CollectionService = game:GetService("CollectionService")
local parent = script.Parent.Parent.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local inspect = LuauPolyfill.util.inspect

local __DEV__ = ReactGlobals.__DEV__

local Shared = require(parent.Shared)
local console = Shared.console

local React = require(parent.React)
local Shared2 = require(parent.Shared)
local ReactSymbols = Shared2.ReactSymbols
local SingleEventManager = require(script.Parent.SingleEventManager)

local Shared3 = require(parent.Shared)
local Type = Shared3.Type
local getDefaultInstanceProperty = require(script.Parent.getDefaultInstanceProperty)
require(script.Parent.Parent["ReactRobloxHostTypes.roblox"])

local React2 = require(parent.React)
local Tag = React2.Tag

local instanceToEventManager = {}
local instanceToBindings = {}

local function identity(...)
	return ...
end

local function setRobloxInstanceProperty(instance, p, p2)
	if p2 == nil then
		local success, _ = pcall(instance.ResetPropertyToDefault, instance, p)

		if success then
			return
		end

		local v
		v, p2 = getDefaultInstanceProperty(instance.ClassName, p)
	end

	instance[p] = p2
end

local function removeBinding(instance, p) -- 1 equivalent call inferred from this helper
	local v = instanceToBindings[instance]

	if v ~= nil then
		v[p]()
		v[p] = nil
	end
end

local function attachBinding(instance, p, object)
	local function updateBoundProperty(p2)
		local success, result = xpcall(setRobloxInstanceProperty, identity, instance, p, p2)

		if not success then
			local source = object._source or "<enable DEV mode for stack>"
			local v = string.format(
				"Error updating binding or ref assigned to key %s of '%s' (%s).\n\nUpdated value:\n  %s\n\nError:\n  %s\n\n%s\n",
				p,
				instance.Name,
				instance.ClassName,
				tostring(p2),
				result,
				source
			)

			console.error(v)

			error(v, 0)
		end
	end

	if instanceToBindings[instance] == nil then
		instanceToBindings[instance] = {}
	end

	instanceToBindings[instance][p] = React.__subscribeToBinding(object, updateBoundProperty)

	updateBoundProperty(object:getValue())
end

local function applyTags(instance, value: string?, value2: string?)
	if __DEV__ and value2 ~= nil and typeof(value2) ~= "string" then
		console.error(
			"Type provided for ReactRoblox.Tag is invalid - tags should be specified as a single string, with individual tags delimited by spaces. Instead received:\n%s",
			inspect(value2)
		)

		return
	end

	local set = {}

	for k in string.gmatch(value or "", "%S+") do
		set[k] = true
	end

	local set2 = {}

	for k in string.gmatch(value2 or "", "%S+") do
		set2[k] = true
	end

	for tag, _ in set do
		if not set2[tag] then
			CollectionService:RemoveTag(instance, tag)
		end
	end

	for tag, _ in set2 do
		if not set[tag] then
			CollectionService:AddTag(instance, tag)
		end
	end
end

local function removeAllTags(folder) -- 2 equivalent calls inferred from this helper
	for _, tag in CollectionService:GetTags(folder) do
		CollectionService:RemoveTag(folder, tag)
	end
end

local function applyProp(instance, p, item, p2)
	local v = Type.of(p)

	if v == Type.HostEvent or v == Type.HostChangeEvent then
		local v2 = instanceToEventManager[instance]

		if v2 == nil then
			v2 = SingleEventManager.new(instance)
			instanceToEventManager[instance] = v2
		end

		local name = p.name

		if v == Type.HostChangeEvent then
			v2:connectPropertyChange(name, item)
		else
			v2:connectEvent(name, item)
		end
	else
		local v2

		if typeof(item) == "table" then
			v2 = item["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE
		else
			v2 = false
		end

		local v3

		if p2 == nil or typeof(p2) ~= "table" then
			v3 = false
		else
			v3 = p2["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE
		end

		if v3 then
			removeBinding(instance, p) -- inferred equivalent call
		end

		if v2 then
			attachBinding(instance, p, item)
			return
		end

		if p == Tag then
			applyTags(instance, p2, item)
			return
		end

		if item == nil then
			local success, _ = pcall(instance.ResetPropertyToDefault, instance, p)

			if success then
				return
			end

			local v4
			v4, item = getDefaultInstanceProperty(instance.ClassName, p)
		end

		instance[p] = item
	end
end

local function applyProps(p, items)
	for k, item in items do
		if k ~= "ref" and k ~= "children" then
			applyProp(p, k, item)
		end
	end
end

local function safelyApplyProperties(p, list, p2)
	for i = 1, #list, 2 do
		local item = list[i]
		local item2 = list[i + 1]

		if item2 == Object.None then
			item2 = nil
		end

		if item ~= "ref" and item ~= "children" then
			applyProp(p, item, item2, p2[item])
		end
	end
end

local _, result = xpcall(function()
	return game:DefineFastFlag("ReactFixBindingMemoryLeak", false)
end, function(): boolean
	return true
end)

local function cleanupBindings(p) -- 2 equivalent calls inferred from this helper
	local v = instanceToBindings[p]

	if v ~= nil then
		for _, v2 in v do
			v2()
		end

		instanceToBindings[p] = nil
	end
end

local RobloxComponentProps = {}

function RobloxComponentProps.setInitialProperties(instance, _: string, p, _)
	local success, result2 = xpcall(applyProps, identity, instance, p)

	if not success then
		local v = string.format(
			"Error applying initial props to Roblox Instance '%s' (%s):\n  %s\n",
			instance.Name,
			instance.ClassName,
			(tostring(result2))
		)

		console.error(v)

		error(v, 0)
	end

	if instanceToEventManager[instance] ~= nil then
		instanceToEventManager[instance]:resume()
	end
end

function RobloxComponentProps.updateProperties(instance, p, p2)
	if instanceToEventManager[instance] ~= nil then
		instanceToEventManager[instance]:suspend()
	end

	local success, result2 = xpcall(safelyApplyProperties, identity, instance, p, p2)

	if not success then
		local v = string.format(
			"Error updating props on Roblox Instance '%s' (%s):\n  %s\n",
			instance.Name,
			instance.ClassName,
			result2
		)

		console.error(v)

		error(v, 0)
	end

	if instanceToEventManager[instance] ~= nil then
		instanceToEventManager[instance]:resume()
	end
end

function RobloxComponentProps.cleanupHostComponent(folder)
	if instanceToEventManager[folder] ~= nil then
		instanceToEventManager[folder] = nil
	end

	if result then
		cleanupBindings(folder) -- inferred equivalent call
	elseif instanceToBindings[folder] ~= nil then
		instanceToBindings[folder] = nil
	end

	if typeof(folder) ~= "Instance" then
		return
	end

	removeAllTags(folder) -- inferred equivalent call

	for _, descendant in folder:GetDescendants() do
		if instanceToEventManager[descendant] ~= nil then
			instanceToEventManager[descendant] = nil
		end

		if result then
			cleanupBindings(descendant) -- inferred equivalent call
		elseif instanceToBindings[descendant] ~= nil then
			instanceToBindings[descendant] = nil
		end

		removeAllTags(folder) -- inferred equivalent call
	end
end

RobloxComponentProps._instanceToEventManager = instanceToEventManager
RobloxComponentProps._instanceToBindings = instanceToBindings
return RobloxComponentProps

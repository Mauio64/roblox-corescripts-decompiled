local CollectionService = game:GetService("CollectionService")
local ParentParent = script.Parent.Parent.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local inspect = LuauPolyfill.util.inspect
local __DEV__ = ReactGlobals.__DEV__
local console = require(ParentParent.Shared).console
local React = require(ParentParent.React)
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local SingleEventManager = require(script.Parent.SingleEventManager)
local Type = require(ParentParent.Shared).Type
local getDefaultInstanceProperty = require(script.Parent.getDefaultInstanceProperty)

require(script.Parent.Parent["ReactRobloxHostTypes.roblox"])

local Tag = require(ParentParent.React).Tag
local t1 = {}
local t2 = {}

local function identity(...) -- line: 72
	return ...
end
local function setRobloxInstanceProperty(p1, p2, p3) -- line: 76
	-- upvalues: getDefaultInstanceProperty (copy)
	if p3 == nil then
		local ok, _ = pcall(p1.ResetPropertyToDefault, p1, p2)

		if ok then
			return
		end

		local ClassName = p1.ClassName
		local v35

		v35, p3 = getDefaultInstanceProperty(ClassName, p2)
	end

	p1[p2] = p3
end
local function removeBinding(p4, p5) -- line: 92
	-- upvalues: t2 (copy)
	local v38 = t2[p4]

	if v38 ~= nil then
		v38[p5]()
		v38[p5] = nil
	end
end
local function attachBinding(p6, p7, p8) -- line: 101
	-- upvalues: setRobloxInstanceProperty (copy), identity (copy), console (copy), t2 (copy), React (copy)
	local function updateBoundProperty(p9) -- line: 102
		-- upvalues: setRobloxInstanceProperty (copy), identity (copy), p6 (copy), p7 (copy), p8 (copy), console (copy)
		local ok, result = xpcall(setRobloxInstanceProperty, identity, p6, p7, p9)

		if not ok then
			local v113 = p8._source or "<enable DEV mode for stack>"
			local v114 = string.format("Error updating binding or ref assigned to key %s of '%s' (%s).\n\nUpdated value:\n  %s\n\nError:\n  %s\n\n%s\n", p7, p6.Name, p6.ClassName, tostring(p9), result, v113)

			console.error(v114)
			error(v114, 0)
		end
	end

	if t2[p6] == nil then
		t2[p6] = {}
	end

	t2[p6][p7] = React.__subscribeToBinding(p8, updateBoundProperty)
	updateBoundProperty(p8:getValue())
end
local function applyTags(p10, s1: string?, s2: string?) -- line: 134
	-- upvalues: __DEV__ (copy), console (copy), inspect (copy), CollectionService (copy)
	if __DEV__ and (s2 ~= nil and typeof(s2) ~= "string") then
		console.error("Type provided for ReactRoblox.Tag is invalid - tags should be specified as a single string, with individual tags delimited by spaces. Instead received:\n%s", inspect(s2))

		return
	end

	local t3 = {}

	for match in string.gmatch(s1 or "", "%S+") do
		t3[match] = true
	end

	local t4 = {}

	for match in string.gmatch(s2 or "", "%S+") do
		t4[match] = true
	end

	for v50, _ in t3 do
		if not t4[v50] then
			CollectionService:RemoveTag(p10, v50)
		end
	end

	for v52, _ in t4 do
		if not t3[v52] then
			CollectionService:AddTag(p10, v52)
		end
	end
end
local function removeAllTags(p11) -- line: 168
	-- upvalues: CollectionService (copy)
	for _, tag in CollectionService:GetTags(p11) do
		CollectionService:RemoveTag(p11, tag)
	end
end
local function applyProp(p12, p13, p14, p15) -- line: 174
	-- upvalues: Type (copy), t1 (copy), SingleEventManager (copy), ReactSymbols (copy), t2 (copy), attachBinding (copy), Tag (copy), applyTags (copy), getDefaultInstanceProperty (copy)
	local v61 = Type.of(p13)

	if v61 == Type.HostEvent or v61 == Type.HostChangeEvent then
		local v62 = t1[p12]

		if v62 == nil then
			v62 = SingleEventManager.new(p12)
			t1[p12] = v62
		end

		local name = p13.name

		if v61 == Type.HostChangeEvent then
			v62:connectPropertyChange(name, p14)

			return
		end

		v62:connectEvent(name, p14)

		return
	end

	local v64 = typeof(p14) == "table" and p14["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE

	if p15 ~= nil and (typeof(p15) == "table" and p15["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE) then
		local v65 = t2[p12]

		if v65 ~= nil then
			v65[p13]()
			v65[p13] = nil
		end
	end

	if v64 then
		attachBinding(p12, p13, p14)

		return
	end

	if p13 == Tag then
		applyTags(p12, p15, p14)

		return
	end

	if p14 == nil then
		local ok, _ = pcall(p12.ResetPropertyToDefault, p12, p13)

		if ok then
			return
		end

		local ClassName = p12.ClassName
		local v69

		v69, p14 = getDefaultInstanceProperty(ClassName, p13)
	end

	p12[p13] = p14
end
local function applyProps(p16, t5: {[any]: any}) -- line: 219
	-- upvalues: applyProp (copy)
	for v72, v73 in t5 do
		if v72 ~= "ref" and v72 ~= "children" then
			applyProp(p16, v72, v73)
		end
	end
end
local function safelyApplyProperties(p17, t6: {[any]: any}, t7: {[any]: any}) -- line: 259
	-- upvalues: Object (copy), applyProp (copy)
	for i = 1, #t6, 2 do
		local v85 = t6[i]
		local v86 = t6[i + 1]

		if v86 == Object.None then
			v86 = nil
		end

		if v85 ~= "ref" and v85 ~= "children" then
			applyProp(p17, v85, v86, t7[v85])
		end
	end
end

local _, result = xpcall(function() -- line: 312
	return game:DefineFastFlag("ReactFixBindingMemoryLeak", false)
end, function() -- line: 314
	return true
end)

local function cleanupBindings(p18) -- line: 318
	-- upvalues: t2 (copy)
	local v94 = t2[p18]

	if v94 ~= nil then
		for _, v96 in v94 do
			v96()
		end

		t2[p18] = nil
	end
end

return {
	setInitialProperties = function(p19, _: string, t8: {[any]: any}, _) -- line: 230
		-- upvalues: applyProps (copy), identity (copy), console (copy), t1 (copy)
		local ok, result2 = xpcall(applyProps, identity, p19, t8)

		if not ok then
			local v80 = string.format("Error applying initial props to Roblox Instance '%s' (%s):\n  %s\n", p19.Name, p19.ClassName, (tostring(result2)))

			console.error(v80)
			error(v80, 0)
		end

		if t1[p19] ~= nil then
			t1[p19]:resume()
		end
	end,
	updateProperties = function(p21, t9: {[any]: any}, t10: {[any]: any}) -- line: 278
		-- upvalues: t1 (copy), safelyApplyProperties (copy), identity (copy), console (copy)
		if t1[p21] ~= nil then
			t1[p21]:suspend()
		end

		local ok, result3 = xpcall(safelyApplyProperties, identity, p21, t9, t10)

		if not ok then
			local v92 = string.format("Error updating props on Roblox Instance '%s' (%s):\n  %s\n", p21.Name, p21.ClassName, result3)

			console.error(v92)
			error(v92, 0)
		end

		if t1[p21] ~= nil then
			t1[p21]:resume()
		end
	end,
	cleanupHostComponent = function(p22) -- line: 331
		-- upvalues: t1 (copy), result (copy), t2 (copy), CollectionService (copy)
		if t1[p22] ~= nil then
			t1[p22] = nil
		end

		if result then
			local v98 = t2[p22]

			if v98 ~= nil then
				for _, v100 in v98 do
					v100()
				end

				t2[p22] = nil
			end
		elseif t2[p22] ~= nil then
			t2[p22] = nil
		end

		if typeof(p22) ~= "Instance" then
			return
		end

		for _, tag in CollectionService:GetTags(p22) do
			CollectionService:RemoveTag(p22, tag)
		end

		for _, descendant in p22:GetDescendants() do
			if t1[descendant] ~= nil then
				t1[descendant] = nil
			end

			if result then
				local v105 = t2[descendant]

				if v105 ~= nil then
					for _, v107 in v105 do
						v107()
					end

					t2[descendant] = nil
				end
			elseif t2[descendant] ~= nil then
				t2[descendant] = nil
			end

			for _, tag in CollectionService:GetTags(p22) do
				CollectionService:RemoveTag(p22, tag)
			end
		end
	end,
	_instanceToEventManager = t1,
	_instanceToBindings = t2
}

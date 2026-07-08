local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local useFocusGuiObject = require(Parent.ReactFocusNavigation).useFocusGuiObject
local t6 = {
	registered = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 31
		local v10 = t1[t2.name] or {}

		for _, v12 in v10 do
			if v12 == t2.guiObject then
				return t1
			end
		end

		local v13 = table.clone(t1)
		local v14 = table.clone(v10)

		table.insert(v14, t2.guiObject)
		v13[t2.name] = v14

		return v13
	end,
	deRegistered = function(t3: {[any]: any}, t4: {[any]: any}) -- line: 46
		local v17 = t3[t4.name]

		if not v17 or #v17 == 0 then
			return t3
		end

		local t5 = {}

		for _, v20 in v17 do
			if v20 ~= t4.guiObject then
				table.insert(t5, v20)
			end
		end

		local v21 = table.clone(t3)

		if #t5 == 0 then
			v21[t4.name] = nil

			return v21
		end

		v21[t4.name] = t5

		return v21
	end
}

local function registryReducer(t7: {[any]: any}, p1) -- line: 70
	-- upvalues: t6 (copy)
	local v24 = t6[p1.type]

	if v24 then
		return v24(t7, p1.payload)
	end

	error("Unknown action: " .. p1.type)
end

local v6 = React.createContext(nil)

local function FocusNavigableSurfaceRegistryProvider(t8: {[any]: any}) -- line: 80
	-- upvalues: React (copy), registryReducer (copy), v6 (copy)
	local v26, v27 = React.useReducer(registryReducer, {})

	return React.createElement(v6.Provider, {
		value = {
			state = v26,
			dispatch = v27
		}
	}, t8.children)
end

return {
	Provider = FocusNavigableSurfaceRegistryProvider,
	registryContext = v6,
	useRegisterFocusNavigableSurface = function() -- line: 105
		-- upvalues: React (copy), v6 (copy)
		local v31 = React.useContext(v6)
		local v32 = if not v31 then nil else v31.dispatch

		return React.useCallback(function(s1: string, p2) -- line: 108
			-- upvalues: v32 (copy)
			if v32 then
				v32({
					type = "registered",
					payload = {
						name = s1,
						guiObject = p2
					}
				})
			end
		end, { v32 })
	end,
	useDeRegisterFocusNavigableSurface = function() -- line: 121
		-- upvalues: React (copy), v6 (copy)
		local v33 = React.useContext(v6)
		local v34 = if not v33 then nil else v33.dispatch

		return React.useCallback(function(s2: string, p3) -- line: 124
			-- upvalues: v34 (copy)
			if v34 then
				v34({
					type = "deRegistered",
					payload = {
						name = s2,
						guiObject = p3
					}
				})
			end
		end, { v34 })
	end,
	useRegistryEntry = function(s3: string) -- line: 87
		-- upvalues: React (copy), v6 (copy)
		local v29 = React.useContext(v6)

		if v29 == nil then
			return nil
		end

		local v30 = v29.state[s3]

		if v30 == nil or #v30 == 0 then
			return nil
		end

		return v30[#v30]
	end,
	useFocusRegistryEntry = function(s4: string) -- line: 137
		-- upvalues: useFocusGuiObject (copy), React (copy), v6 (copy)
		local v36 = useFocusGuiObject()
		local v37 = React.useContext(v6)
		local v38

		if v37 == nil then
			v38 = nil
		else
			local v39 = v37.state[s4]

			v38 = if v39 ~= nil and #v39 ~= 0 then v39[#v39] else nil
		end

		local v40 = v38

		return React.useCallback(function() -- line: 140
			-- upvalues: v40 (copy), v36 (copy)
			if v40 then
				v36(v40)
			end
		end, {
			v36,
			v40
		})
	end
}

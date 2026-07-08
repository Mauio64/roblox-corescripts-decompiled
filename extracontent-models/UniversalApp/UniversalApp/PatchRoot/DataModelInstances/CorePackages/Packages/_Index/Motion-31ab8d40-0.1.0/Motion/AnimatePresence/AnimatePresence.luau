local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local PresenceChild = require(script.Parent.PresenceChild)
local PresenceState = require(ParentParent.Enums.PresenceState)

local function getCompositeKey(s1: string, p1) -- line: 55
	if typeof(p1) == "table" and (p1.props and p1.props.presenceId) then
		return string.format("%s:%s", s1, (tostring(p1.props.presenceId)))
	end

	return s1
end
local function AnimatePresence(t1: {[any]: any}) -- line: 63
	-- upvalues: React (copy), PresenceState (copy), PresenceChild (copy)
	local children = t1.children
	local v12 = if t1.childData == nil then nil else t1.childData
	local v13 = if t1.onExitComplete == nil then nil else t1.onExitComplete
	local v14, v15 = React.useState({})
	local v16 = React.useRef({})

	React.useEffect(function() -- line: 73
		-- upvalues: children (copy), PresenceState (copy), v14 (copy), v15 (copy), v16 (copy)
		local t2 = {}

		if children ~= nil and typeof(children) == "table" then
			for k, v in pairs(children) do
				if typeof(v) == "table" and v.type ~= nil then
					t2[if typeof(v) ~= "table" or (not v.props or not v.props.presenceId) then k else string.format("%s:%s", k, (tostring(v.props.presenceId)))] = {
						type = PresenceState.Entering,
						component = v,
						dictionaryKey = k
					}
				end
			end
		end

		for k, v in pairs(v14) do
			local v26 = false

			if children ~= nil and typeof(children) == "table" then
				for k2, v2 in pairs(children) do
					if typeof(v2) == "table" and v2.type ~= nil and k == if typeof(v2) ~= "table" or (not v2.props or not v2.props.presenceId) then k2 else string.format("%s:%s", k2, (tostring(v2.props.presenceId))) then
						v26 = true

						break
					end
				end
			end

			if not v26 and v.isPresent then
				t2[k] = {
					type = PresenceState.Exiting,
					component = v.component,
					dictionaryKey = v.dictionaryKey
				}
			end
		end

		if next(t2) ~= nil then
			v15(function(p2) -- line: 120
				-- upvalues: t2 (copy), PresenceState (copy), v16 (copy)
				local v35 = table.clone(p2)

				for k, v in pairs(t2) do
					if v.type == PresenceState.Entering then
						v35[k] = {
							isPresent = true,
							safeToRemove = false,
							component = v.component,
							dictionaryKey = v.dictionaryKey
						}
					elseif v.type == PresenceState.Exiting and v35[k] and v35[k].isPresent then
						v35[k] = {
							isPresent = false,
							safeToRemove = false,
							component = v.component,
							dictionaryKey = v.dictionaryKey
						}
						v16.current[k] = true
					end
				end

				return v35
			end)
		end
	end, { children })

	local v17 = React.useCallback(function(p3) -- line: 150
		-- upvalues: v16 (copy), v15 (copy)
		if v16.current[p3] then
			v16.current[p3] = nil
			v15(function(p4) -- line: 154
				-- upvalues: p3 (copy)
				local v39 = table.clone(p4)

				if v39[p3] then
					v39[p3] = {
						isPresent = false,
						safeToRemove = true,
						component = v39[p3].component,
						dictionaryKey = v39[p3].dictionaryKey
					}
				end

				return v39
			end)
		end
	end, {})

	React.useEffect(function() -- line: 170
		-- upvalues: v14 (copy), v15 (copy), v13 (copy)
		local t3 = {}
		local v31 = false

		for k, v in pairs(v14) do
			if v.safeToRemove then
				v31 = true
				t3[k] = true
			end
		end

		if v31 then
			v15(function(p5) -- line: 182
				-- upvalues: t3 (copy), v13 (copy)
				local t4 = {}

				for k, v in pairs(p5) do
					if not t3[k] then
						t4[k] = v
					elseif v13 then
						v13(k)
					end
				end

				return t4
			end)
		end
	end, { v14 })

	local t5 = {}

	for k, v in pairs(v14) do
		if not v.safeToRemove then
			table.insert(t5, React.createElement(PresenceChild, {
				key = k,
				presenceId = k,
				isPresent = v.isPresent,
				onExitComplete = function() -- line: 208
					-- upvalues: v17 (copy), k (copy)
					v17(k)
				end,
				childData = v12,
				children = v.component
			}, v.component))
		end
	end

	return React.createElement(React.Fragment, {}, t5)
end

return AnimatePresence

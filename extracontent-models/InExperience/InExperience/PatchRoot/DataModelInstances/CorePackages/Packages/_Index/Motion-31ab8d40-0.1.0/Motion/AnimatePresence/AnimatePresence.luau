local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local PresenceChild = require(script.Parent.PresenceChild)
local PresenceState = require(parent.Enums.PresenceState)

local function getCompositeKey(k: string, child) -- 2 equivalent calls inferred from this helper
	if typeof(child) == "table" and child.props and child.props.presenceId then
		return string.format("%s:%s", k, (tostring(child.props.presenceId)))
	end

	return k
end

local function AnimatePresence(props)
	local children = props.children
	local childData

	if props.childData ~= nil then
		childData = props.childData
	end

	local onExitComplete

	if props.onExitComplete == nil then
		onExitComplete = nil
	else
		onExitComplete = props.onExitComplete
	end

	local state, setState = React.useState({})
	local ref = React.useRef({})

	React.useEffect(function()
		local dictionaryEntries = {}

		if children ~= nil and typeof(children) == "table" then
			for k, child in pairs(children) do
				if not (typeof(child) == "table" and child.type ~= nil) then
					continue
				end

				local compositeKey = getCompositeKey(k, child) -- inferred equivalent call
				dictionaryEntries[compositeKey] = {
					type = PresenceState.Entering,
					component = child,
					dictionaryKey = k
				}
			end
		end

		for k, v in pairs(state) do
			local v2 = false

			if children ~= nil and typeof(children) == "table" then
				for k2, child in pairs(children) do
					if not (typeof(child) == "table" and child.type ~= nil) then
						continue
					end

					k2 = getCompositeKey(k2, child) -- inferred equivalent call

					if k2 == k then
						v2 = true
						break
					end
				end
			end

			if v2 or not v.isPresent then
				continue
			end

			dictionaryEntries[k] = {
				type = PresenceState.Exiting,
				component = v.component,
				dictionaryKey = v.dictionaryKey
			}
		end

		if next(dictionaryEntries) ~= nil then
			setState(function(p)
				local clone = table.clone(p)

				for k, v in pairs(dictionaryEntries) do
					if v.type == PresenceState.Entering then
						clone[k] = {
							isPresent = true,
							component = v.component,
							safeToRemove = false,
							dictionaryKey = v.dictionaryKey
						}
					elseif v.type == PresenceState.Exiting and clone[k] and clone[k].isPresent then
						clone[k] = {
							isPresent = false,
							component = v.component,
							safeToRemove = false,
							dictionaryKey = v.dictionaryKey
						}

						ref.current[k] = true
					end
				end

				return clone
			end)
		end
	end, { children })

	local v = React.useCallback(function(p)
		if ref.current[p] then
			ref.current[p] = nil

			setState(function(p2)
				local clone = table.clone(p2)

				if clone[p] then
					clone[p] = {
						isPresent = false,
						component = clone[p].component,
						safeToRemove = true,
						dictionaryKey = clone[p].dictionaryKey
					}
				end

				return clone
			end)
		end
	end, {})

	React.useEffect(function()
		local set = {}
		local flag = false

		for k, v2 in pairs(state) do
			if not v2.safeToRemove then
				continue
			end

			set[k] = true
			flag = true
		end

		if flag then
			setState(function(items)
				local result = {}

				for k, item in pairs(items) do
					if set[k] then
						if onExitComplete then
							onExitComplete(k)
						end
					else
						result[k] = item
					end
				end

				return result
			end)
		end
	end, { state })

	local children2 = {}

	for k, v2 in pairs(state) do
		if not v2.safeToRemove then
			table.insert(children2, React.createElement(PresenceChild, {
				key = k,
				presenceId = k,
				isPresent = v2.isPresent,
				onExitComplete = function()
					v(k)
				end,
				childData = childData,
				children = v2.component
			}, v2.component))
		end
	end

	return React.createElement(React.Fragment, {}, children2)
end

return AnimatePresence

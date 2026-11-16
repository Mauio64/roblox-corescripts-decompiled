local ChangeHistoryService = game:GetService("ChangeHistoryService")

local ReactUtils = script:FindFirstAncestor("ReactUtils")

local parent = ReactUtils.Parent
local React = require(parent.React)

local LUAU_ANALYZE_ERROR = require(ReactUtils.LUAU_ANALYZE_ERROR)

local function useHistory(p, callback, p2)
	local ref = React.useRef(p)
	local ref2 = React.useRef({})
	local ref3 = React.useRef({})

	React.useEffect(function()
		local onUndoConnection = ChangeHistoryService.OnUndo:Connect(function(p3)
			local current = ref2.current
			local current2 = ref3.current

			assert(current ~= nil, LUAU_ANALYZE_ERROR)
			assert(current2 ~= nil, LUAU_ANALYZE_ERROR)

			if not current[p3] or #current[p3] == 0 then
				return
			end

			if not current2[p3] then
				current2[p3] = {}
			end

			local count = #current[p3]
			local current3 = current[p3][count]

			table.insert(current2[p3], ref.current)
			table.remove(current[p3], count)

			ref.current = current3
			callback(current3)

			ref2.current = current
			ref3.current = current2
		end)

		local onRedoConnection = ChangeHistoryService.OnRedo:Connect(function(p3)
			local current = ref2.current
			local current2 = ref3.current

			assert(current ~= nil, LUAU_ANALYZE_ERROR)
			assert(current2 ~= nil, LUAU_ANALYZE_ERROR)

			if not current2[p3] or #current2[p3] == 0 then
				return
			end

			local count = #current2[p3]
			local current3 = current2[p3][count]

			table.insert(current[p3], ref.current)
			table.remove(current2[p3], count)

			assert(current3 ~= nil, LUAU_ANALYZE_ERROR)

			ref.current = current3
			callback(current3)

			ref2.current = current
			ref3.current = current2
		end)

		return function()
			onUndoConnection:Disconnect()
			onRedoConnection:Disconnect()
		end
	end, p2)

	React.useEffect(function()
		ref2.current = {}
		ref3.current = {}
	end, p2)

	return (React.useCallback(function(p3: string, current)
		local current2 = ref2.current

		assert(current2 ~= nil, LUAU_ANALYZE_ERROR)

		if not current2[p3] then
			current2[p3] = {}
		end

		ref3.current = {}

		ChangeHistoryService:SetWaypoint(p3)

		if typeof(ref.current) == "table" then
			table.insert(current2[p3], table.clone(ref.current))
		else
			table.insert(current2[p3], ref.current)
		end

		ref.current = current
		ref2.current = current2
	end, p2))
end

return useHistory

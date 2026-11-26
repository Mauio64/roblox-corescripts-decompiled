local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")

local function useBatchedImpressions(data)
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef({})
	local ref4 = React.useRef({})
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(data.onFlush)
	ref6.current = data.onFlush

	local v5 = React.useCallback(function()
		if #ref.current == 0 then
			return
		end

		local current = ref6.current

		if current then
			local v6 = {}

			for k, v7 in ref.current do
				ref3.current[v7.key] = true
				table.insert(v6, v7.item)
			end

			if #v6 > 0 then
				ref5.current += 1
				current(v6, ref5.current)
			end

			ref.current = {}
			ref4.current = {}
		else
			ref.current = {}
			ref4.current = {}
		end
	end, {})

	local v6 = React.useCallback(function(p2, p3, p4)
		if not p2 or not p3 or ref3.current[p2] or ref4.current[p2] then
			return
		end

		local mapItem = data.mapItem(p2, p3, p4)

		if not mapItem then
			return
		end

		ref4.current[p2] = true
		table.insert(ref.current, { key = p2, item = mapItem })

		if ref2.current then
			pcall(task.cancel, ref2.current)
		end

		ref2.current = task.delay(data.batchTimeMs * 0.001, v5)
	end, { data.batchTimeMs, data.mapItem, v5 })

	React.useEffect(function()
		return function()
			if ref2.current then
				pcall(task.cancel, ref2.current)
			end

			ref2.current = nil
			v5()
		end
	end, { v5 })

	return React.useMemo(function()
		return { addImpression = v6 }
	end, { v6 })
end

return useBatchedImpressions

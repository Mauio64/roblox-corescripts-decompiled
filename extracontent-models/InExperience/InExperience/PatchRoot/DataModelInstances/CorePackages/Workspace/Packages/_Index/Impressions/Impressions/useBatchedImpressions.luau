local parent = script:FindFirstAncestor("Impressions").Parent

local React = require(parent.React)

local function useBatchedImpressions(data)
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef({})
	local ref4 = React.useRef({})
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(data.onFlush)
	ref6.current = data.onFlush

	local v = React.useCallback(function()
		if #ref.current == 0 then
			return
		end

		local current = ref6.current

		if current then
			local v = {}

			for _, v2 in ref.current do
				ref3.current[v2.key] = true
				table.insert(v, v2.item)
			end

			if #v > 0 then
				ref5.current += 1
				current(v, ref5.current)
			end

			ref.current = {}
			ref4.current = {}
		else
			ref.current = {}
			ref4.current = {}
		end
	end, {})

	local addImpression = React.useCallback(function(p: string, p2: number, p3)
		if not p or not p2 or ref3.current[p] or ref4.current[p] then
			return
		end

		local mapItem = data.mapItem(p, p2, p3)

		if not mapItem then
			return
		end

		ref4.current[p] = true
		table.insert(ref.current, { key = p, item = mapItem })

		if ref2.current then
			pcall(task.cancel, ref2.current)
		end

		ref2.current = task.delay(data.batchTimeMs * 0.001, v)
	end, { data.batchTimeMs, data.mapItem, v })

	React.useEffect(function()
		return function()
			if ref2.current then
				pcall(task.cancel, ref2.current)
			end

			ref2.current = nil
			v()
		end
	end, { v })

	return React.useMemo(function()
		return { addImpression = addImpression }
	end, { addImpression })
end

return useBatchedImpressions

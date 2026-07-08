local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")
local React = require(RoactAppExperiment.Parent.React)
local usePrevious = require(script.Parent.usePrevious)
local useIXPService = require(RoactAppExperiment.useIXPService)

local function getLayerNamesKey(p1) -- line: 21
	local s1 = ""

	for i, v in ipairs(p1) do
		if i > 1 then
			s1 ..= ","
		end

		s1 ..= v
	end

	return s1
end
local function makeUseExperiment(p2, p3, p4, p5, p6) -- line: 35
	-- upvalues: useIXPService (copy), React (copy), usePrevious (copy)
	return function(t1: {[any]: any}, p7: ((...any) -> ...any), b1: boolean?) -- line: 45
		-- upvalues: useIXPService (copy), p4 (copy), p3 (copy), React (copy), p2 (copy), usePrevious (copy), p6 (copy), p5 (copy)
		if b1 == nil then
			b1 = true
		end

		local v20 = useIXPService()

		assert(type(t1) == "table", "useExperiment expects layerNames to be a list of layers")
		assert(type(p7) == "function", "useExperiment expects mapLayers to be a function")

		local function getNewLayerToVariables() -- line: 59
			-- upvalues: t1 (copy), v20 (copy), p4 (copy)
			local t2 = {}

			for _, v in ipairs(t1) do
				t2[v] = v20[p4](v20, v)

				if t2[v] and not next(t2[v]) then
					t2[v] = nil
				end
			end

			return t2
		end
		local function getLoadingStatus() -- line: 75
			-- upvalues: v20 (copy), p3 (copy)
			return v20[p3](v20)
		end

		local v23, v24 = React.useState(getNewLayerToVariables)
		local v25, v26 = React.useState(getLoadingStatus)
		local s2 = ""

		for i, v in ipairs(t1) do
			if i > 1 then
				s2 ..= ","
			end

			s2 ..= v
		end

		React.useEffect(function() -- line: 86
			-- upvalues: v20 (copy), p3 (copy), getNewLayerToVariables (copy), v24 (copy), v26 (copy), p2 (copy)
			if v20 == nil then
				return function() -- line: 88
				end
			end

			local function updateStateLayerData() -- line: 91
				-- upvalues: v20 (copy), p3 (copy), getNewLayerToVariables (copy), v24 (copy), v26 (copy)
				local v40 = v20[p3](v20)
				local v41 = getNewLayerToVariables()

				v24(function(p8) -- line: 95
					-- upvalues: v41 (copy)
					local v48 = next(p8)

					if not next(v41) ~= not v48 then
						return v41
					end

					return p8
				end)
				v26(v40)
			end

			local connection = v20[p2]:Connect(function(_) -- line: 106
				-- upvalues: v20 (copy), p3 (copy), getNewLayerToVariables (copy), v24 (copy), v26 (copy)
				local v43 = v20[p3](v20)
				local v44 = getNewLayerToVariables()

				v24(function(p10) -- line: 95
					-- upvalues: v44 (copy)
					local v50 = next(p10)

					if not next(v44) ~= not v50 then
						return v44
					end

					return p10
				end)
				v26(v43)
			end)
			local v36 = v20[p3](v20)
			local v37 = getNewLayerToVariables()

			v24(function(p11) -- line: 95
				-- upvalues: v37 (copy)
				local v46 = next(p11)

				if not next(v37) ~= not v46 then
					return v37
				end

				return p11
			end)
			v26(v36)

			return function() -- line: 117
				-- upvalues: connection (copy)
				if connection ~= nil then
					connection:Disconnect()
				end
			end
		end, {
			v20,
			s2
		})

		local v30 = usePrevious(v25) or Enum.IXPLoadingStatus.None

		React.useEffect(function() -- line: 127
			-- upvalues: b1 (ref), v20 (copy), v25 (copy), v30 (copy), t1 (copy), p6 (copy), p5 (copy)
			if b1 and (v20 ~= nil and v25 == Enum.IXPLoadingStatus.Initialized and v30 ~= Enum.IXPLoadingStatus.Initialized) then
				for _, v in ipairs(t1) do
					if v20[p6](v20, v) == Enum.IXPLoadingStatus.Initialized then
						v20[p5](v20, v)
					end
				end
			end
		end, {
			v20,
			s2,
			b1,
			v25,
			v30
		})

		return p7(v23)
	end
end

return makeUseExperiment

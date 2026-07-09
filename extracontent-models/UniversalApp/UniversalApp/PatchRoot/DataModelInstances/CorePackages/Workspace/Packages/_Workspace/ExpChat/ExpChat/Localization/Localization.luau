local Parent = script:FindFirstAncestor("ExpChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Dictionary = require(Parent.llama).Dictionary

local function mapStringToBeLocalized(p1, p2) -- line: 9
	if type(p2) == "table" then
		local ok, result = pcall(function() -- line: 11
			-- upvalues: p1 (copy), p2 (copy)
			return p1:FormatByKey(p2[1], p2[2])
		end)

		if ok then
			return result
		end

		return ""
	end

	if type(p2) == "string" then
		local ok, result = pcall(function() -- line: 21
			-- upvalues: p1 (copy), p2 (copy)
			return p1:FormatByKey(p2)
		end)

		if ok then
			return result
		end

		return ""
	end

	return ""
end
local function getConnect(p3) -- line: 35
	-- upvalues: Dictionary (copy), mapStringToBeLocalized (copy), Roact (copy)
	return function(p4) -- line: 36
		-- upvalues: Dictionary (copy), mapStringToBeLocalized (copy), Roact (copy), p3 (copy)
		local function transformedMapper(p5, p6) -- line: 37
			-- upvalues: Dictionary (copy), p4 (copy), mapStringToBeLocalized (copy)
			return Dictionary.map(p4(p6), function(p7, _) -- line: 38
				-- upvalues: mapStringToBeLocalized (copy), p5 (copy)
				return (mapStringToBeLocalized(p5, p7))
			end)
		end

		return function(p9) -- line: 43
			-- upvalues: Roact (copy), p3 (copy), Dictionary (copy), transformedMapper (copy)
			local v29 = Roact.Component:extend("Connected-" .. tostring(p9))

			function v29.render(p10) -- line: 46
				-- upvalues: Roact (copy), p3 (copy), p9 (copy), Dictionary (copy), transformedMapper (copy)
				return Roact.createElement(p3.Consumer, {
					render = function(p11) -- line: 48
						-- upvalues: Roact (copy), p9 (copy), Dictionary (copy), p10 (copy), transformedMapper (copy)
						return Roact.createElement(p9, Dictionary.join(p10.props, transformedMapper(p11, p10.props)))
					end
				})
			end

			return v29
		end
	end
end
local function getUseLocalization(p12) -- line: 62
	-- upvalues: React (copy), Dictionary (copy), mapStringToBeLocalized (copy)
	return function(t1: {[any]: any}) -- line: 63
		-- upvalues: React (copy), p12 (copy), Dictionary (copy), mapStringToBeLocalized (copy)
		local v21 = React.useContext(p12)

		return Dictionary.map(t1, function(p13, _) -- line: 65
			-- upvalues: mapStringToBeLocalized (copy), v21 (copy)
			return (mapStringToBeLocalized(v21, p13))
		end)
	end
end

return function(p15) -- line: 71
	-- upvalues: Roact (copy), Dictionary (copy), mapStringToBeLocalized (copy), React (copy)
	local v17 = Roact.createContext(p15)

	return {
		Consumer = v17.Consumer,
		Provider = v17.Provider,
		connect = function(p16) -- line: 36
			-- upvalues: Dictionary (copy), mapStringToBeLocalized (copy), Roact (copy), v17 (copy)
			local function transformedMapper(p17, p18) -- line: 37
				-- upvalues: Dictionary (copy), p16 (copy), mapStringToBeLocalized (copy)
				return Dictionary.map(p16(p18), function(p19, _) -- line: 38
					-- upvalues: mapStringToBeLocalized (copy), p17 (copy)
					return (mapStringToBeLocalized(p17, p19))
				end)
			end

			return function(p21) -- line: 43
				-- upvalues: Roact (copy), v17 (copy), Dictionary (copy), transformedMapper (copy)
				local v35 = Roact.Component:extend("Connected-" .. tostring(p21))

				function v35.render(p22) -- line: 46
					-- upvalues: Roact (copy), v17 (copy), p21 (copy), Dictionary (copy), transformedMapper (copy)
					return Roact.createElement(v17.Consumer, {
						render = function(p23) -- line: 48
							-- upvalues: Roact (copy), p21 (copy), Dictionary (copy), p22 (copy), transformedMapper (copy)
							return Roact.createElement(p21, Dictionary.join(p22.props, transformedMapper(p23, p22.props)))
						end
					})
				end

				return v35
			end
		end,
		useLocalization = function(t2: {[any]: any}) -- line: 63
			-- upvalues: React (copy), v17 (copy), Dictionary (copy), mapStringToBeLocalized (copy)
			local v25 = React.useContext(v17)

			return Dictionary.map(t2, function(p24, _) -- line: 65
				-- upvalues: mapStringToBeLocalized (copy), v25 (copy)
				return (mapStringToBeLocalized(v25, p24))
			end)
		end
	}
end

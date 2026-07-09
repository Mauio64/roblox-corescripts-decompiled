local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local Dictionary = require(Parent.llama).Dictionary

local function getConnect(p1) -- line: 6
	-- upvalues: Dictionary (copy), React (copy)
	return function(p2) -- line: 7
		-- upvalues: Dictionary (copy), React (copy), p1 (copy)
		local function transformedMapper(p3, p4) -- line: 8
			-- upvalues: Dictionary (copy), p2 (copy)
			return Dictionary.map(p2(p4), function(s1: string, _) -- line: 9
				-- upvalues: p3 (copy)
				local ok, result = pcall(function() -- line: 10
					-- upvalues: p3 (copy), s1 (copy)
					return p3:TranslateGameText(game, s1)
				end)

				if ok then
					return result
				end

				return ""
			end)
		end

		return function(p6) -- line: 22
			-- upvalues: React (copy), p1 (copy), Dictionary (copy), transformedMapper (copy)
			local v15 = React.Component:extend("Connected-" .. tostring(p6))

			function v15.render(p7) -- line: 25
				-- upvalues: React (copy), p1 (copy), p6 (copy), Dictionary (copy), transformedMapper (copy)
				return React.createElement(p1.Consumer, {
					render = function(p8) -- line: 27
						-- upvalues: React (copy), p6 (copy), Dictionary (copy), p7 (copy), transformedMapper (copy)
						return React.createElement(p6, Dictionary.join(p7.props, transformedMapper(p8, p7.props)))
					end
				})
			end

			return v15
		end
	end
end

return function(p9) -- line: 41
	-- upvalues: React (copy), Dictionary (copy)
	local v7 = React.createContext(p9)

	return {
		Consumer = v7.Consumer,
		Provider = v7.Provider,
		connect = function(p10) -- line: 7
			-- upvalues: Dictionary (copy), React (copy), v7 (copy)
			local function transformedMapper(p11, p12) -- line: 8
				-- upvalues: Dictionary (copy), p10 (copy)
				return Dictionary.map(p10(p12), function(s2: string, _) -- line: 9
					-- upvalues: p11 (copy)
					local ok, result = pcall(function() -- line: 10
						-- upvalues: p11 (copy), s2 (copy)
						return p11:TranslateGameText(game, s2)
					end)

					if ok then
						return result
					end

					return ""
				end)
			end

			return function(p14) -- line: 22
				-- upvalues: React (copy), v7 (copy), Dictionary (copy), transformedMapper (copy)
				local v19 = React.Component:extend("Connected-" .. tostring(p14))

				function v19.render(p15) -- line: 25
					-- upvalues: React (copy), v7 (copy), p14 (copy), Dictionary (copy), transformedMapper (copy)
					return React.createElement(v7.Consumer, {
						render = function(p16) -- line: 27
							-- upvalues: React (copy), p14 (copy), Dictionary (copy), p15 (copy), transformedMapper (copy)
							return React.createElement(p14, Dictionary.join(p15.props, transformedMapper(p16, p15.props)))
						end
					})
				end

				return v19
			end
		end
	}
end

local parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(parent.React)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local function getConnect(context) -- 1 equivalent call inferred from this helper
	return function(callback)
		local function transformedMapper(object, props)
			return dictionary.map(callback(props), function(p: string, _)
				local success, result = pcall(function()
					return object:TranslateGameText(game, p)
				end)
				return if success then result else ""
			end)
		end

		return function(p)
			local extended = React.Component:extend("Connected-" .. tostring(p))

			function extended.render(p2)
				return React.createElement(context.Consumer, {
					render = function(p3)
						return React.createElement(p, dictionary.join(p2.props, transformedMapper(p3, p2.props)))
					end
				})
			end

			return extended
		end
	end
end

return function(p)
	local context = React.createContext(p)

	return {
		Consumer = context.Consumer,
		Provider = context.Provider,
		connect = getConnect(context) -- inferred equivalent call
	}
end

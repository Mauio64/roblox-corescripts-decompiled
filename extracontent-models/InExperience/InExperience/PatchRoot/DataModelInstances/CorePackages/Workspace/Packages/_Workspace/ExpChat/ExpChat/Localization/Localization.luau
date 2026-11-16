local parent = script:FindFirstAncestor("ExpChat").Parent
local Roact = require(parent.Roact)
local React = require(parent.React)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local function mapStringToBeLocalized(object, value)
	if type(value) == "table" then
		local success, result = pcall(function()
			return object:FormatByKey(value[1], value[2])
		end)
		return if success then result else ""
	else
		if type(value) ~= "string" then
			return ""
		end

		local success, result = pcall(function()
			return object:FormatByKey(value)
		end)
		return if success then result else ""
	end
end

local function getConnect(context) -- 1 equivalent call inferred from this helper
	return function(callback)
		local function transformedMapper(p, props)
			return dictionary.map(callback(props), function(p2, _)
				return mapStringToBeLocalized(p, p2)
			end)
		end

		return function(p)
			local extended = Roact.Component:extend("Connected-" .. tostring(p))

			function extended.render(p2)
				return Roact.createElement(context.Consumer, {
					render = function(p3)
						return Roact.createElement(p, dictionary.join(p2.props, transformedMapper(p3, p2.props)))
					end
				})
			end

			return extended
		end
	end
end

local function getUseLocalization(context) -- 1 equivalent call inferred from this helper
	return function(p)
		local v = React.useContext(context)
		return dictionary.map(p, function(p2, _)
			return mapStringToBeLocalized(v, p2)
		end)
	end
end

return function(p)
	local context = Roact.createContext(p)

	return {
		Consumer = context.Consumer,
		Provider = context.Provider,
		connect = getConnect(context), -- inferred equivalent call
		useLocalization = getUseLocalization(context) -- inferred equivalent call
	}
end

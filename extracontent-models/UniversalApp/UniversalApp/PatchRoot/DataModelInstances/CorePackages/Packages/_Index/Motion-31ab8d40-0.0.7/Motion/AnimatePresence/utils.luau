local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local Utils = {}

function Utils.getChildKey(p)
	if not (p ~= nil and type(p) == "table") then
		return nil
	end

	if p.key ~= nil then
		return p.key
	end

	return if p.props and p.props.key ~= nil then p.props.key else nil
end

function Utils.onlyElements(p)
	local v = {}

	React.Children.forEach(p, function(p2)
		if React.isValidElement(p2) then
			table.insert(v, p2)
		end
	end)

	return v
end

function Utils.useIdFallback()
	local v = tostring(math.random(1000000))

	if v == nil then
		return "id-" .. nil
	end

	return v
end

return Utils

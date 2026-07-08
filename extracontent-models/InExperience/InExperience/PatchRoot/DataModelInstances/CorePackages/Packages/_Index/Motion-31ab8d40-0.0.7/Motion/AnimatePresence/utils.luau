local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

return {
	getChildKey = function(p1) -- line: 28
		if p1 == nil then
			return nil
		end

		if type(p1) ~= "table" then
			return nil
		end

		if p1.key ~= nil then
			return p1.key
		end

		if p1.props and p1.props.key ~= nil then
			return p1.props.key
		end

		return nil
	end,
	onlyElements = function(p2) -- line: 65
		-- upvalues: React (copy)
		local t1 = {}

		React.Children.forEach(p2, function(p3) -- line: 68
			-- upvalues: React (copy), t1 (copy)
			if React.isValidElement(p3) then
				table.insert(t1, p3)
			end
		end)

		return t1
	end,
	useIdFallback = function() -- line: 53
		local str = tostring(math.random(1000000))

		if str == nil then
			return "id-" .. str
		end

		return str
	end
}

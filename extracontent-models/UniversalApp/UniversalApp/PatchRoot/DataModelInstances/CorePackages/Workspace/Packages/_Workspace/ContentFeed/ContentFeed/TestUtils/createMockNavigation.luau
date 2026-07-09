local ParentParent = script.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)
local t1 = {
	addListener = function() -- line: 7
	end,
	dispatch = function() -- line: 8
	end,
	getParam = function() -- line: 9
	end,
	goBack = function() -- line: 10
	end,
	isFocused = function() -- line: 11
	end,
	setParams = function() -- line: 12
	end,
	state = {
		key = "id-1234567",
		name = "ContentFeed",
		params = {
			extraProps = {
				postId = "asdf",
				userId = "1234"
			}
		}
	}
}

return function(t2: {[any]: any}?) -- line: 20
	-- upvalues: Dash (copy), t1 (copy)
	local v5 = Dash.joinDeep(t1, t2 or {})

	function v5.getParam(p1, p2) -- line: 22
		-- upvalues: v5 (copy)
		return v5.state.params[p1] or p2
	end

	return v5
end

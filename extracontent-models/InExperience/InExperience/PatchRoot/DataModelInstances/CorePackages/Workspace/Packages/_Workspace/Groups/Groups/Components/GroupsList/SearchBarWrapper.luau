local Parent = script:FindFirstAncestor("Groups").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local TextInput = Foundation.TextInput
local IconName = Foundation.Enums.IconName

local function SearchBar(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), TextInput (copy), IconName (copy)
	local v8, v9 = React.useState("")
	local v10 = React.useRef(nil)
	local v11 = React.useCallback(function() -- line: 28
		-- upvalues: v10 (copy)
		if v10.current then
			task.cancel(v10.current)
			v10.current = nil
		end
	end, {})
	local v12 = React.useCallback(function(s1: string) -- line: 35
		-- upvalues: v9 (copy), v11 (copy), v10 (copy), t1 (copy)
		v9(s1)
		v11()
		v10.current = task.delay(0.4, function() -- line: 39
			-- upvalues: t1 (copy), s1 (copy)
			if t1.onTextChanged then
				t1.onTextChanged(s1)
			end
		end)
	end, {
		t1.onTextChanged,
		v11
	})

	React.useEffect(function() -- line: 46
		-- upvalues: v11 (copy)
		return v11
	end, {})

	local v13 = React.useCallback(function() -- line: 50
		-- upvalues: v11 (copy), v9 (copy), t1 (copy)
		v11()
		v9("")

		if t1.onTextChanged then
			t1.onTextChanged("")
		end
	end, {
		t1.onTextChanged,
		v11
	})

	return React.createElement(TextInput, {
		label = "",
		leadingIcon = "icons/common/search",
		text = v8,
		width = UDim.new(1, 0),
		placeholder = t1.placeholderText or "",
		onChanged = v12,
		iconTrailing = if v8 == "" then nil else {
			name = IconName.CircleX,
			onActivated = v13
		}
	})
end

return SearchBar

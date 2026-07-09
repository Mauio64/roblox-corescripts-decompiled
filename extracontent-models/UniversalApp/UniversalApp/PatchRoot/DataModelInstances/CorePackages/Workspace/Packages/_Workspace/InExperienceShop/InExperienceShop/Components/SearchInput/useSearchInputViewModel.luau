local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)

require(script.Parent.SearchInputView)

local function useSearchInputViewModel(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)
	local v6 = React.useRef(false)

	React.useEffect(function() -- line: 21
		-- upvalues: v5 (copy)
		if v5.current then
			v5.current:CaptureFocus()
		end
	end, {})

	local v7 = React.useRef(t1.onTextChanged)

	v7.current = t1.onTextChanged

	local v8 = React.useCallback(function(p1) -- line: 33
		-- upvalues: v6 (copy), v7 (copy)
		if not v6.current then
			v7.current(p1.Text)
		end
	end, {})
	local v9 = React.useCallback(function(p2, b1: boolean) -- line: 39
		-- upvalues: t1 (copy)
		if b1 then
			t1.onSearchSubmit(p2.Text or "")
		end
	end, { t1.onSearchSubmit })
	local v10 = React.useCallback(function() -- line: 45
		-- upvalues: v6 (copy), v5 (copy), t1 (copy)
		v6.current = true

		if v5.current then
			v5.current:ReleaseFocus()
		end

		task.defer(t1.onBack)
	end, { t1.onBack })
	local v11 = React.useCallback(function() -- line: 55
		-- upvalues: t1 (copy), v5 (copy)
		t1.onTextChanged("")

		if v5.current then
			v5.current:CaptureFocus()
		end
	end, { t1.onTextChanged })

	return {
		onBack = v10,
		onClear = v11,
		onTextChanged = v8,
		onFocusLost = v9,
		text = t1.text,
		textBoxRef = v5
	}
end

return useSearchInputViewModel

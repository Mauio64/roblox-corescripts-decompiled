local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)

require(script.Parent.SearchInputView)

local function useSearchInputViewModel(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if ref.current then
			ref.current:CaptureFocus()
		end
	end, {})

	local ref3 = React.useRef(data.onTextChanged)
	ref3.current = data.onTextChanged

	local onTextChanged = React.useCallback(function(p)
		if not ref2.current then
			ref3.current(p.Text)
		end
	end, {})

	local onFocusLost = React.useCallback(function(p, flag: boolean)
		if flag then
			data.onSearchSubmit(p.Text or "")
		end
	end, { data.onSearchSubmit })

	return {
		onBack = React.useCallback(function()
			ref2.current = true

			if ref.current then
				ref.current:ReleaseFocus()
			end

			task.defer(data.onBack)
		end, { data.onBack }),
		onClear = React.useCallback(function()
			data.onTextChanged("")

			if ref.current then
				ref.current:CaptureFocus()
			end
		end, { data.onTextChanged }),
		onTextChanged = onTextChanged,
		onFocusLost = onFocusLost,
		text = data.text,
		textBoxRef = ref
	}
end

return useSearchInputViewModel

local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.SearchBarView)

local function useSearchBarViewModel(data)
	local clear = data.clear
	local onDismiss = data.onDismiss
	local setQuery = data.setQuery
	local onFocusGained = data.onFocusGained
	local onFocusLost = data.onFocusLost
	local shouldFocus = data.shouldFocus
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if shouldFocus and ref.current then
			ref.current.focus()
		end
	end, { shouldFocus })

	local onFocusGained2 = React.useCallback(function()
		ref2.current = true

		if onFocusGained then
			onFocusGained()
		end
	end, { onFocusGained })

	local onFocusLost2 = React.useCallback(function(p)
		ref2.current = false

		if onFocusLost then
			onFocusLost(p)
		end
	end, { onFocusLost })

	local onChanged = React.useCallback(function(p: string)
		if p == "" then
			clear()

			if not ref2.current and onDismiss then
				onDismiss()
			end
		else
			setQuery(p)
		end
	end, { clear, onDismiss, setQuery })

	return {
		LayoutOrder = data.LayoutOrder,
		onChanged = onChanged,
		onFocusGained = onFocusGained2,
		onFocusLost = onFocusLost2,
		placeholder = data.placeholder,
		query = data.query,
		textInputRef = ref
	}
end

return useSearchBarViewModel

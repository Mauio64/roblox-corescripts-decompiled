require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarView")

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

	local v5 = React.useCallback(function()
		ref2.current = true

		if onFocusGained then
			onFocusGained()
		end
	end, { onFocusGained })

	local v6 = React.useCallback(function(p2)
		ref2.current = false

		if onFocusLost then
			onFocusLost(p2)
		end
	end, { onFocusLost })

	local v7 = React.useCallback(function(p2)
		if p2 == "" then
			clear()

			if not ref2.current and onDismiss then
				onDismiss()
			end
		else
			setQuery(p2)
		end
	end, { clear, onDismiss, setQuery })

	return {
		LayoutOrder = data.LayoutOrder,
		onChanged = v7,
		onFocusGained = v5,
		onFocusLost = v6,
		placeholder = data.placeholder,
		query = data.query,
		textInputRef = ref
	}
end

return useSearchBarViewModel

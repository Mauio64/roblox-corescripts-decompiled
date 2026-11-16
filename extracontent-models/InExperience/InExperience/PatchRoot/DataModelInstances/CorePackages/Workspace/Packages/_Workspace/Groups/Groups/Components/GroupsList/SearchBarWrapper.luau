local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local TextInput = Foundation.TextInput
local IconName = Foundation.Enums.IconName

local function SearchBar(p)
	local state, setState = React.useState("")
	local ref = React.useRef(nil)

	local v = React.useCallback(function()
		if ref.current then
			task.cancel(ref.current)
			ref.current = nil
		end
	end, {})

	local onChanged = React.useCallback(function(p2: string)
		setState(p2)
		v()

		ref.current = task.delay(0.4, function()
			if p.onTextChanged then
				p.onTextChanged(p2)
			end
		end)
	end, { p.onTextChanged, v })

	React.useEffect(function()
		return v
	end, {})

	local onActivated = React.useCallback(function()
		v()
		setState("")

		if p.onTextChanged then
			p.onTextChanged("")
		end
	end, { p.onTextChanged, v })

	return React.createElement(TextInput, {
		label = "",
		text = state,
		width = UDim.new(1, 0),
		placeholder = p.placeholderText or "",
		leadingIcon = "icons/common/search",
		onChanged = onChanged,
		iconTrailing = state ~= "" and { name = IconName.CircleX, onActivated = onActivated } or nil
	})
end

return SearchBar

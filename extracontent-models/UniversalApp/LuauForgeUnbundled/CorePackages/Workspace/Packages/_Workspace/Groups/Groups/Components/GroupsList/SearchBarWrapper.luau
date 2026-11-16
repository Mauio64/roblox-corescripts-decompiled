local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")

local textInput = Foundation.TextInput
local iconName = Foundation.Enums.IconName

local function SearchBar(p2)
	local state, setState = React.useState("")
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		if ref.current then
			task.cancel(ref.current)
			ref.current = nil
		end
	end, {})

	local v6 = React.useCallback(function(p3)
		setState(p3)
		v5()

		ref.current = task.delay(0.4, function()
			if p2.onTextChanged then
				p2.onTextChanged(p3)
			end
		end)
	end, { p2.onTextChanged, v5 })

	React.useEffect(function()
		return v5
	end, {})

	local v7 = React.useCallback(function()
		v5()
		setState("")

		if p2.onTextChanged then
			p2.onTextChanged("")
		end
	end, { p2.onTextChanged, v5 })

	return React.createElement(textInput, {
		label = "",
		text = state,
		width = UDim.new(1, 0),
		placeholder = p2.placeholderText or "",
		leadingIcon = "icons/common/search",
		onChanged = v6,
		iconTrailing = state ~= "" and { name = iconName.CircleX, onActivated = v7 } or nil
	})
end

return SearchBar

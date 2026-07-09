local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("TenFootUiShell").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)

local function useHideMouseCursorEffect() -- line: 7
	-- upvalues: Responsive (copy), React (copy), UserInputService (copy)
	local v6 = Responsive.useLastInput() == Responsive.Input.Pointer

	React.useEffect(function() -- line: 10
		-- upvalues: UserInputService (copy), v6 (copy)
		UserInputService.MouseIconEnabled = v6
	end, { v6 })
end

return useHideMouseCursorEffect

local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

local function useComposerFocusLock(flag: boolean, items)
	React.useEffect(function()
		for _, item in items do
			local current = item.current

			if current == nil then
				continue
			end

			if flag then
				current.TextEditable = false
				current.Active = false
				current:ReleaseFocus()
			else
				current.TextEditable = true
				current.Active = true
			end
		end
	end, { flag })
end

return useComposerFocusLock

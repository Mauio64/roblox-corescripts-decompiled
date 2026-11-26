local CorePackages = game:GetService("CorePackages")
local parent = CorePackages.Packages._Index.Foundation.Foundation.Parent

local React = require(parent.React)

local function useComposerFocusLock(p2, items)
	React.useEffect(function()
		for k, item in items do
			local current = item.current

			if current == nil then
				continue
			end

			if p2 then
				current.TextEditable = false
				current.Active = false
				current:ReleaseFocus()
			else
				current.TextEditable = true
				current.Active = true
			end
		end
	end, { p2 })
end

return useComposerFocusLock

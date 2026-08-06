local FoundationParent = game:GetService("CorePackages").Packages._Index.Foundation.Foundation.Parent
local React = require(FoundationParent.React)

local function useComposerFocusLock(b1: boolean, t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 17
		-- upvalues: t1 (copy), b1 (copy)
		for _, v7 in t1 do
			local current = v7.current

			if current ~= nil then
				if b1 then
					current.TextEditable = false
					current.Active = false
					current:ReleaseFocus()
				else
					current.TextEditable = true
					current.Active = true
				end
			end
		end
	end, { b1 })
end

return useComposerFocusLock

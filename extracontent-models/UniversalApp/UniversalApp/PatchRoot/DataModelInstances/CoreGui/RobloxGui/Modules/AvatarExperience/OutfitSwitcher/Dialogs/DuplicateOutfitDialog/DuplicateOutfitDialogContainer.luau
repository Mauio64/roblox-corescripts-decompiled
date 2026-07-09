local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BaseDialog = require(script.Parent.Parent.Shared.BaseDialog)
local useDuplicateOutfitDialogProps = require(script.Parent.useDuplicateOutfitDialogProps)

local function DuplicateOutfitDialogContainer() -- line: 8
	-- upvalues: useDuplicateOutfitDialogProps (copy), React (copy), BaseDialog (copy)
	local v6 = useDuplicateOutfitDialogProps()

	return React.createElement(BaseDialog, v6)
end

return DuplicateOutfitDialogContainer

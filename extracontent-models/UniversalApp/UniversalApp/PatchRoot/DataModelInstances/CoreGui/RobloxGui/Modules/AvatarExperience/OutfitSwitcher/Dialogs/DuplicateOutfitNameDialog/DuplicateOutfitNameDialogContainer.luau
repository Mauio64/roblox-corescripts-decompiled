local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BaseDialog = require(script.Parent.Parent.Shared.BaseDialog)
local useDuplicateOutfitNameDialogProps = require(script.Parent.useDuplicateOutfitNameDialogProps)

local function DuplicateOutfitNameDialogContainer() -- line: 8
	-- upvalues: useDuplicateOutfitNameDialogProps (copy), React (copy), BaseDialog (copy)
	local v6 = useDuplicateOutfitNameDialogProps()

	return React.createElement(BaseDialog, v6)
end

return DuplicateOutfitNameDialogContainer

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local BaseDialogWithTextbox = require(script.Parent.Parent.Shared.BaseDialogWithTextbox)
local useAddOutfitDialogProps = require(script.Parent.useAddOutfitDialogProps)

local function AddOutfitDialogContainer() -- line: 8
	-- upvalues: useAddOutfitDialogProps (copy), React (copy), BaseDialogWithTextbox (copy)
	local v6 = useAddOutfitDialogProps()

	return React.createElement(BaseDialogWithTextbox, v6)
end

return AddOutfitDialogContainer

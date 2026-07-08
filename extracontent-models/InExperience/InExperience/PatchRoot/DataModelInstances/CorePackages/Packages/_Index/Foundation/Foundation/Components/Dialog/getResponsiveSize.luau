local Foundation = script:FindFirstAncestor("Foundation")
local DialogSize = require(Foundation.Enums.DialogSize)

require(Foundation.Providers.Style.Tokens)

local DIALOG_SIZES = require(script.Parent.useDialogVariants).DIALOG_SIZES

local function getResponsiveSize(n1: number, p1, p2) -- line: 11
	-- upvalues: DialogSize (copy), DIALOG_SIZES (copy)
	local v8 = ({
		[DialogSize.Small] = p2.Padding.Large,
		[DialogSize.Medium] = p2.Padding.XLarge,
		[DialogSize.Large] = p2.Padding.XLarge
	})[p1] * 2
	local UIScale = p2.Config.UI.Scale

	if n1 <= DIALOG_SIZES[DialogSize.Medium] * UIScale + v8 and p1 ~= DialogSize.Small then
		return DialogSize.Small
	end

	if n1 <= DIALOG_SIZES[DialogSize.Large] * UIScale + v8 and p1 == DialogSize.Large then
		return DialogSize.Medium
	end

	return p1
end

return getResponsiveSize

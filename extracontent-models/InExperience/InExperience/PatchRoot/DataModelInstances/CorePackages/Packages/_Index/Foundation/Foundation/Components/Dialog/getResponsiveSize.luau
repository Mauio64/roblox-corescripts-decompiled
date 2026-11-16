local Foundation = script:FindFirstAncestor("Foundation")

local DialogSize = require(Foundation.Enums.DialogSize)

require(Foundation.Providers.Style.Tokens)

local useDialogVariants = require(script.Parent.useDialogVariants)
local DIALOG_SIZES = useDialogVariants.DIALOG_SIZES

local function getResponsiveSize(p: number, p2, p3)
	local v = ({
		[DialogSize.Small] = p3.Padding.Large,
		[DialogSize.Medium] = p3.Padding.XLarge,
		[DialogSize.Large] = p3.Padding.XLarge
	})[p2] * 2
	local scale = p3.Config.UI.Scale

	if p <= DIALOG_SIZES[DialogSize.Medium] * scale + v and p2 ~= DialogSize.Small then
		return DialogSize.Small
	end

	if p <= DIALOG_SIZES[DialogSize.Large] * scale + v and p2 == DialogSize.Large then
		return DialogSize.Medium
	end

	return p2
end

return getResponsiveSize

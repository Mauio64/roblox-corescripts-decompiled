local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local DialogSize = require(Foundation.Enums.DialogSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local useTokens = require(Foundation.Providers.Style.useTokens)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local useDialog = require(script.Parent.useDialog)
local t1 = {
	[DialogSize.Small] = 320,
	[DialogSize.Medium] = 480,
	[DialogSize.Large] = 640
}

local function variantsFactory(p1) -- line: 43
	-- upvalues: DialogSize (copy), t1 (copy)
	local t2 = {
		backdrop = {
			backgroundStyle = p1.Color.Common.Backdrop
		},
		shadow = {
			tag = "auto-xy",
			imageStyle = p1.Color.Extended.Black.Black_15
		},
		container = {
			tag = "col align-x-center align-y-center size-full-full"
		},
		inner = {
			tag = "shrink-1 size-full-0 auto-y clip bg-surface-100"
		},
		body = {
			tag = "col size-full auto-y padding-bottom-xlarge"
		},
		heroMediaWrapper = {
			tag = "shrink position-top-center size-full-full auto-y"
		},
		title = {
			tag = "size-full-0 auto-y"
		},
		titleText = {
			tag = "size-full-0 auto-y text-wrap text-align-x-left content-emphasis"
		},
		content = {
			tag = "fill size-full auto-y"
		},
		contentText = {
			tag = "size-full-0 auto-y text-wrap text-align-x-left text-align-y-top"
		},
		actionsLabel = {
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left text-align-y-top"
		}
	}
	local t3 = {
		[DialogSize.Small] = {
			shadow = {
				tag = "padding-large"
			},
			inner = {
				tag = "radius-medium",
				maxWidth = t1[DialogSize.Small]
			},
			body = {
				tag = "gap-large padding-x-large"
			},
			closeAffordance = {
				offset = p1.Size.Size_300
			},
			heroMedia = {
				tag = "radius-medium",
				offsetX = p1.Padding.Large
			},
			titleText = {
				tag = "text-heading-small"
			},
			contentText = {
				tag = "text-body-medium"
			},
			actionsLabel = {
				tag = "padding-top-large"
			}
		},
		[DialogSize.Medium] = {
			shadow = {
				tag = "padding-xlarge"
			},
			inner = {
				tag = "radius-large",
				maxWidth = t1[DialogSize.Medium]
			},
			body = {
				tag = "gap-xlarge padding-x-xlarge"
			},
			closeAffordance = {
				offset = p1.Size.Size_400
			},
			heroMedia = {
				tag = "radius-large",
				offsetX = p1.Padding.XLarge
			},
			titleText = {
				tag = "text-heading-medium"
			},
			contentText = {
				tag = "text-body-medium"
			},
			actionsLabel = {
				tag = "padding-top-xlarge"
			}
		},
		[DialogSize.Large] = {
			shadow = {
				tag = "padding-xlarge"
			},
			inner = {
				tag = "radius-large",
				maxWidth = t1[DialogSize.Large]
			},
			body = {
				tag = "gap-xlarge padding-x-xlarge"
			},
			closeAffordance = {
				offset = p1.Size.Size_400
			},
			heroMedia = {
				tag = "radius-large",
				offsetX = p1.Padding.XLarge
			},
			titleText = {
				tag = "text-heading-large"
			},
			contentText = {
				tag = "text-body-large"
			},
			actionsLabel = {
				tag = "padding-top-xlarge"
			}
		}
	}

	return {
		common = t2,
		size = t3
	}
end

function useDialogVariants() -- line: 175
	-- upvalues: useTokens (copy), VariantsContext (copy), variantsFactory (copy), useDialog (copy), composeStyleVariant (copy)
	local v12 = useTokens()
	local v13 = VariantsContext.useVariants("Dialog", variantsFactory, v12)
	local v14 = useDialog()

	return composeStyleVariant(v13.common, v13.size[v14.responsiveSize])
end

return {
	useDialogVariants = useDialogVariants,
	DIALOG_SIZES = t1
}

local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local DialogSize = require(Foundation.Enums.DialogSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local useTokens = require(Foundation.Providers.Style.useTokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local useDialog = require(script.Parent.useDialog)

local v = { [DialogSize.Small] = 320, [DialogSize.Medium] = 480, [DialogSize.Large] = 640 }

local function variantsFactory(data)
	return {
		common = {
			backdrop = { backgroundStyle = data.Color.Common.Backdrop },
			shadow = { tag = "auto-xy", imageStyle = data.Color.Extended.Black.Black_15 },
			container = { tag = "col align-x-center align-y-center size-full-full" },
			inner = { tag = "shrink-1 size-full-0 auto-y clip bg-surface-100 stroke-default" },
			body = { tag = "col size-full auto-y padding-bottom-xlarge" },
			heroMediaWrapper = { tag = "position-top-center size-full-full auto-y" },
			title = { tag = "size-full-0 auto-y" },
			titleText = { tag = "size-full-0 auto-y text-wrap text-align-x-left content-emphasis" },
			content = { tag = "fill size-full auto-y" },
			contentText = {
				tag = "size-full-0 auto-y text-wrap text-align-x-left text-align-y-top"
			},
			actionsLabel = {
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left text-align-y-top"
			}
		},
		size = {
			[DialogSize.Small] = {
				shadow = { tag = "padding-large" },
				inner = { maxWidth = v[DialogSize.Small], tag = "radius-large" },
				body = { tag = "gap-large padding-x-large" },
				closeAffordance = { offset = data.Size.Size_300 },
				heroMedia = { tag = "radius-top-large", offsetX = data.Padding.Large },
				titleText = { tag = "text-heading-small" },
				contentText = { tag = "text-body-medium" },
				actionsLabel = { tag = "padding-top-large" }
			},
			[DialogSize.Medium] = {
				shadow = { tag = "padding-xlarge" },
				inner = { maxWidth = v[DialogSize.Medium], tag = "radius-large" },
				body = { tag = "gap-xlarge padding-x-xlarge" },
				closeAffordance = { offset = data.Size.Size_400 },
				heroMedia = { tag = "radius-top-large", offsetX = data.Padding.XLarge },
				titleText = { tag = "text-heading-medium" },
				contentText = { tag = "text-body-medium" },
				actionsLabel = { tag = "padding-top-xlarge" }
			},
			[DialogSize.Large] = {
				shadow = { tag = "padding-xlarge" },
				inner = { maxWidth = v[DialogSize.Large], tag = "radius-large" },
				body = { tag = "gap-xlarge padding-x-xlarge" },
				closeAffordance = { offset = data.Size.Size_400 },
				heroMedia = { tag = "radius-top-large", offsetX = data.Padding.XLarge },
				titleText = { tag = "text-heading-large" },
				contentText = { tag = "text-body-large" },
				actionsLabel = { tag = "padding-top-xlarge" }
			}
		}
	}
end

function useDialogVariants()
	local v2 = useTokens()
	local v3 = VariantsContext.useVariants("Dialog", variantsFactory, v2)
	local v4 = useDialog()

	return composeStyleVariant(v3.common, v3.size[v4.responsiveSize])
end

return { useDialogVariants = useDialogVariants, DIALOG_SIZES = v }

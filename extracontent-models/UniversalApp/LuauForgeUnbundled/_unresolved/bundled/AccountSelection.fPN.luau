local module = require("@luauforge/bundled/fPo")
local react = module.React
local uiBlox = module.UIBlox

local cell = uiBlox.App.Table.Cell
local loadableImage = uiBlox.App.Loading.LoadableImage
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local useStyle = uiBlox.Core.Style.useStyle
local getStandardSizeAvatarHeadShotRbxthumb = module.UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local useState = react.useState
local useDesignTokens = module.Style.useDesignTokens
local module2 = require("@luauforge/bundled/fPO")

local defineFastFlag = game:DefineFastFlag("ShouldUseSelectionRowInAccountSelectionRelease1", false)

local function AccountSelection(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local state, setState = useState(false)

	local function handleAccountSelection()
		if not (props.isDisabled or props.user.isUnselectable) then
			setState(true)
			props.onAccountSelection(props.user.id)
		end
	end

	if defineFastFlag then
		local function renderImage()
			local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(props.user.id)))
			return react.createElement(loadableImage, {
				Size = UDim2.new(0, 48, 0, 48),
				Image = standardSizeAvatarHeadShotRbxthumb,
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			})
		end

		return react.createElement(module2, {
			titleContent = props.user.displayName,
			subtitleContent = "@" .. (props.user.name or ""),
			renderImage = renderImage,
			iconKey = props.user.iconKey,
			onAccountSelection = handleAccountSelection,
			userInteractionEnabled = not props.user.isUnselectable
		})
	end

	local function renderAvatarImage()
		local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(props.user.id)))
		return react.createElement(loadableImage, {
			Size = UDim2.new(0, 48, 0, 48),
			Image = standardSizeAvatarHeadShotRbxthumb,
			useShimmerAnimationWhileLoading = true,
			cornerRadius = UDim.new(0.5, 0),
			shouldHandleReloads = true
		})
	end

	local function renderNames()
		return react.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			VerticalLayout = react.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			DisplayName = react.createElement(styledTextLabel, {
				text = props.user.displayName,
				fontStyle = v5.Font.Header2,
				colorStyle = v5.Theme.TextEmphasis,
				layoutOrder = 0
			}),
			UserName = react.createElement(styledTextLabel, {
				text = "@" .. props.user.name,
				fontStyle = v5.Font.Body,
				colorStyle = v5.Theme.TextDefault,
				layoutOrder = 1
			})
		})
	end

	local function renderCellHead()
		return react.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Layout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v6.Size.Size_200)
			}),
			AvatarThumbnail = renderAvatarImage(),
			Names = renderNames()
		})
	end

	local function renderCellBackground()
		return react.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v5.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = v5.Theme.BackgroundUIDefault.BackgroundTransparency,
			BorderColor3 = v5.Theme.BackgroundUIDefault.Color
		})
	end

	local element = react.createElement(imageSetLabel, {
		Size = UDim2.fromOffset(28, 28),
		Image = images["icons/status/success_large"],
		ImageColor3 = v5.Theme.Success.Color,
		BackgroundTransparency = 1
	})

	return react.createElement(cell, {
		onActivated = handleAccountSelection,
		isSelected = state,
		head = renderCellHead(),
		tail = state and element or react.createElement("Frame"),
		background = renderCellBackground(),
		size = UDim2.new(1, 0, 0, v6.Size.Size_1600)
	})
end

return AccountSelection

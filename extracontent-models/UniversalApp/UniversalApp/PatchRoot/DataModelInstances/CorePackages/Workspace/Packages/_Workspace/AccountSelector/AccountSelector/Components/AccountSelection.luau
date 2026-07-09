local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Cell = UIBlox.App.Table.Cell
local LoadableImage = UIBlox.App.Loading.LoadableImage
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local getStandardSizeAvatarHeadShotRbxthumb = dependencies.UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local useState = React.useState
local useDesignTokens = dependencies.Style.useDesignTokens
local SelectionRow = require(script.Parent.SelectionRow)
local v15 = game:DefineFastFlag("ShouldUseSelectionRowInAccountSelectionRelease1", false)

local function AccountSelection(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), useDesignTokens (copy), useState (copy), v15 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), React (copy), LoadableImage (copy), SelectionRow (copy), StyledTextLabel (copy), ImageSetLabel (copy), Images (copy), Cell (copy)
	local v18 = useStyle()
	local v19 = useDesignTokens()
	local v20, v21 = useState(false)

	local function handleAccountSelection() -- line: 42
		-- upvalues: t1 (copy), v21 (copy)
		if not t1.isDisabled and not t1.user.isUnselectable then
			v21(true)
			t1.onAccountSelection(t1.user.id)
		end
	end

	if v15 then
		return React.createElement(SelectionRow, {
			titleContent = t1.user.displayName,
			subtitleContent = "@" .. (t1.user.name or ""),
			renderImage = function() -- line: 50
				-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy), t1 (copy), React (copy), LoadableImage (copy)
				local v28 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.user.id)))

				return React.createElement(LoadableImage, {
					useShimmerAnimationWhileLoading = true,
					shouldHandleReloads = true,
					Size = UDim2.new(0, 48, 0, 48),
					Image = v28,
					cornerRadius = UDim.new(0.5, 0)
				})
			end,
			iconKey = t1.user.iconKey,
			onAccountSelection = handleAccountSelection,
			userInteractionEnabled = not t1.user.isUnselectable
		})
	end

	local function renderAvatarImage() -- line: 71
		-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy), t1 (copy), React (copy), LoadableImage (copy)
		local v29 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.user.id)))

		return React.createElement(LoadableImage, {
			useShimmerAnimationWhileLoading = true,
			shouldHandleReloads = true,
			Size = UDim2.new(0, 48, 0, 48),
			Image = v29,
			cornerRadius = UDim.new(0.5, 0)
		})
	end
	local function renderNames() -- line: 82
		-- upvalues: React (copy), StyledTextLabel (copy), t1 (copy), v18 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			VerticalLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			DisplayName = React.createElement(StyledTextLabel, {
				layoutOrder = 0,
				text = t1.user.displayName,
				fontStyle = v18.Font.Header2,
				colorStyle = v18.Theme.TextEmphasis
			}),
			UserName = React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = "@" .. t1.user.name,
				fontStyle = v18.Font.Body,
				colorStyle = v18.Theme.TextDefault
			})
		})
	end
	local function renderCellHead() -- line: 107
		-- upvalues: React (copy), v19 (copy), renderAvatarImage (copy), renderNames (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v19.Size.Size_200)
			}),
			AvatarThumbnail = renderAvatarImage(),
			Names = renderNames()
		})
	end
	local function renderCellBackground() -- line: 122
		-- upvalues: React (copy), v18 (copy)
		return React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v18.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = v18.Theme.BackgroundUIDefault.BackgroundTransparency,
			BorderColor3 = v18.Theme.BackgroundUIDefault.Color
		})
	end

	local v27 = React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(28, 28),
		Image = Images["icons/status/success_large"],
		ImageColor3 = v18.Theme.Success.Color
	})

	return React.createElement(Cell, {
		onActivated = handleAccountSelection,
		isSelected = v20,
		head = renderCellHead(),
		tail = v20 and v27 or React.createElement("Frame"),
		background = renderCellBackground(),
		size = UDim2.new(1, 0, 0, v19.Size.Size_1600)
	})
end

return AccountSelection

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/fTi")
local useStyle = UIBlox.Core.Style.useStyle

local module2 = require("@luauforge/bundled/dTM")
local module3 = require("@luauforge/deferred/gfc")
local module4 = require("@luauforge/bundled/dCp")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local linkButton = UIBlox.App.Button.LinkButton
local buttonType = UIBlox.App.Button.Enum.ButtonType
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize

local iconsstatusimageunavailable = images["icons/status/imageunavailable"]

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function OpenExperienceTraversalPrompt(p2)
	local params = p2.navigation.state.params

	local v5 = module({
		title = "Feature.Catalog.Heading.GoToExperience",
		body = {
			"Feature.Catalog.Description.AttributionAlertBody",
			experienceName = p2.navigation.state.params.gameName or ""
		},
		confirmButtonText = "CommonUI.Features.Action.Go",
		cancelButtonText = "CommonUI.Controls.Action.Cancel",
		viewDetailsButtonText = "Feature.Catalog.Action.ViewExperienceDetails"
	})

	local v6 = useSelector(function(p3)
		return p3.ScreenSize
	end, getUseSelectorDeepEquals())

	local v7 = React.useCallback(function()
		module2.closeOverlay(p2.navigation)
	end, { p2.navigation })

	local v8 = React.useCallback(function()
		module2.closeOverlay(p2.navigation)
		params.onPlayButtonActivated()
	end, { p2.navigation })

	local v9 = React.useCallback(function()
		local gameDetail = module4.GameDetail
		module2.navigateFromOverlay(p2.navigation, gameDetail, {
			detail = params.gameUniverseId,
			extraProps = { mountAsFullView = true }
		})
	end, { p2.navigation })

	local v10 = useStyle()
	local theme = v10.Theme
	local font = v10.Font

	local v11 = if params.thumbnailUrl then params.thumbnailUrl else iconsstatusimageunavailable
	local udim

	if params.thumbnailUrl then
		udim = UDim2.fromOffset(150, 150)
	else
		udim = UDim2.fromOffset(iconSize.Large, iconSize.Large)
	end

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	local v12 = GameHydrationReact.useGameIcon(params.gameUniverseId)

	React.useEffect(function()
		if not params.thumbnailUrl and v12 then
			setState(v12)
			setState2(UDim2.fromOffset(150, 150))
		end
	end, { v12 })
	local v13

	if params.hideConfirmationButton then
		v13 = {
			{
				props = {
					onActivated = v7,
					text = v5.cancelButtonText,
					layoutOrder = 0
				},
				isDefaultChild = true
			}
		}
	end

	local createElement = React.createElement
	local v16 = if params.overrideTitle then params.overrideTitle else v5.title
	local v15 = {
		title = v16,
		middleContent = function()
			local createElement2 = React.createElement
			local v18 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local children = {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				}),
				ExperienceThumbnailFrame = React.createElement("Frame", {
					Size = UDim2.fromOffset(150, 150),
					BackgroundColor3 = theme.BackgroundContrast.Color,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					ClipsDescendants = true
				}, {
					ExperienceThumbnail = React.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Image = if state then state else v11,
						Size = if state2 then state2 else udim,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					}, {
						RoundCorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}),
					RoundCorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				BodyText = 0,
				DetailsButton = 0
			}

			local createElement5 = React.createElement
			local v27 = if params.overrideBody then params.overrideBody else v5.body
			children.BodyText = createElement5(styledTextLabel, {
				text = v27,
				fontStyle = font.Body,
				colorStyle = theme.TextDefault,
				layoutOrder = 2,
				automaticSize = Enum.AutomaticSize.Y,
				size = UDim2.fromScale(1, 0),
				textXAlignment = Enum.TextXAlignment.Center,
				lineHeight = 1
			})

			children.DetailsButton = React.createElement(linkButton, {
				text = v5.viewDetailsButtonText,
				onActivated = v9,
				layoutOrder = 3,
				selectionCursorKind = cursorKind.RoundedRectNoInset
			})
			return createElement2("Frame", v18, children)
		end,
		buttonStackInfo = 0,
		screenSize = 0,
		defaultChildRef = 0,
		isMiddleContentFocusable = true
	}

	if not v13 then
		v13 = {
			{
				props = {
					onActivated = v7,
					text = v5.cancelButtonText,
					layoutOrder = 0
				},
				isDefaultChild = true
			},
			{
				buttonType = buttonType.PrimaryContextual,
				props = {
					onActivated = v8,
					text = v5.confirmButtonText,
					layoutOrder = 2
				},
				isDefaultChild = false
			}
		}
	end

	v15.buttonStackInfo = { buttons = v13 }

	v15.screenSize = v6
	v15.defaultChildRef = p2.defaultChildRef
	return createElement(interactiveAlert, v15)
end

return module3(OpenExperienceTraversalPrompt)

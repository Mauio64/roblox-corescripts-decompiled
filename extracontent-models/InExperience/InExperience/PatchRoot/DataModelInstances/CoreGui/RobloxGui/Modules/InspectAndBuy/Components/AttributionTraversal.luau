local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local UIBlox = require(CorePackages.Packages.UIBlox)

local React = require(CorePackages.Packages.React)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local useScreenSize = require(CoreGui.RobloxGui.Modules.Common.Hooks.useScreenSize)
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService)
local experienceService = ExperienceService.ExperienceService

local parent = script.Parent.Parent
local CloseOverlay = require(parent.Actions.CloseOverlay)

local function AttributionTraversal(props)
	local v = useDispatch()
	local screenSize = useScreenSize()
	local v2 = useStyle()

	local onActivated = React.useCallback(function()
		v(CloseOverlay())
	end, { v })

	local onActivated2 = React.useCallback(function()
		experienceService:LaunchExperience({ placeId = props.rootPlaceId })
		v(CloseOverlay())
	end, { v, props.rootPlaceId })

	local v3 = useSelector(function(p)
		return p.locale
	end)

	local theme = v2.Theme
	local font = v2.Font
	local name = props.name or ""

	return React.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Attribution.GoToExperience", v3),
		middleContent = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v2.Tokens.Size.Size_300)
					}),
					ExperienceThumbnailFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(150, 150),
						BackgroundColor3 = theme.BackgroundContrast.Color,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						ClipsDescendants = true
					}, {
						ExperienceThumbnail = React.createElement(ImageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Image = string.format(
								"rbxthumb://type=GameIcon&id=%s&w=%d&h=%d",
								tostring(props.universeId),
								150,
								150
							),
							Size = UDim2.fromScale(1, 1),
							BorderSizePixel = 0,
							BackgroundTransparency = 1
						}, {
							RoundCorner = React.createElement("UICorner", {
								CornerRadius = UDim.new(0, v2.Tokens.Radius.Medium)
							})
						})
					}),
					BodyText = React.createElement(StyledTextLabel, {
						text = RobloxTranslator:FormatByKeyForLocale(
							"InGame.InspectMenu.Attribution.GoToDescription",
							v3,
							{ EXPERIENCE_NAME = name }
						),
						fontStyle = font.Body,
						colorStyle = theme.TextDefault,
						layoutOrder = 2,
						automaticSize = Enum.AutomaticSize.Y,
						size = UDim2.fromScale(1, 0),
						textXAlignment = Enum.TextXAlignment.Center,
						lineHeight = 1
					})
				}
			)
		end,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = onActivated,
						text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.Cancel", v3),
						layoutOrder = 0
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = onActivated2,
						text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.Go", v3),
						layoutOrder = 2
					},
					isDefaultChild = false
				}
			}
		},
		isMiddleContentFocusable = false,
		screenSize = screenSize
	})
end

return AttributionTraversal

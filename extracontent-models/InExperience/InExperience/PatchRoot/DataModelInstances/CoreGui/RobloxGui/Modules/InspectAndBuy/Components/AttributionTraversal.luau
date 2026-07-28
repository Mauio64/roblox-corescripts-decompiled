local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local useScreenSize = require(CoreGui.RobloxGui.Modules.Common.Hooks.useScreenSize)
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
local ParentParent = script.Parent.Parent
local CloseOverlay = require(ParentParent.Actions.CloseOverlay)

local function AttributionTraversal(p1) -- line: 32
	-- upvalues: useDispatch (copy), useScreenSize (copy), useStyle (copy), React (copy), CloseOverlay (copy), ExperienceService (copy), useSelector (copy), InteractiveAlert (copy), RobloxTranslator (copy), ImageSetLabel (copy), StyledTextLabel (copy), ButtonType (copy)
	local v19 = useDispatch()
	local v20 = useScreenSize()
	local v21 = useStyle()
	local v22 = React.useCallback(function() -- line: 37
		-- upvalues: v19 (copy), CloseOverlay (copy)
		v19(CloseOverlay())
	end, { v19 })
	local v23 = React.useCallback(function() -- line: 41
		-- upvalues: p1 (copy), ExperienceService (copy), v19 (copy), CloseOverlay (copy)
		local t1 = {
			placeId = p1.rootPlaceId
		}

		ExperienceService:LaunchExperience(t1)
		v19(CloseOverlay())
	end, {
		v19,
		p1.rootPlaceId
	})
	local v24 = useSelector(function(p2) -- line: 50
		return p2.locale
	end)
	local Theme = v21.Theme
	local Font = v21.Font
	local v27 = p1.name or ""

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		title = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Attribution.GoToExperience", v24),
		middleContent = function() -- line: 60
			-- upvalues: React (copy), v21 (copy), Theme (copy), ImageSetLabel (copy), p1 (copy), StyledTextLabel (copy), RobloxTranslator (copy), v24 (copy), v27 (copy), Font (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v21.Tokens.Size.Size_300)
				}),
				ExperienceThumbnailFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					ClipsDescendants = true,
					Size = UDim2.fromOffset(150, 150),
					BackgroundColor3 = Theme.BackgroundContrast.Color
				}, {
					ExperienceThumbnail = React.createElement(ImageSetLabel, {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Image = string.format("rbxthumb://type=GameIcon&id=%s&w=%d&h=%d", tostring(p1.universeId), 150, 150),
						Size = UDim2.fromScale(1, 1)
					}, {
						RoundCorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v21.Tokens.Radius.Medium)
						})
					})
				}),
				BodyText = React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					lineHeight = 1,
					text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Attribution.GoToDescription", v24, {
						EXPERIENCE_NAME = v27
					}),
					fontStyle = Font.Body,
					colorStyle = Theme.TextDefault,
					automaticSize = Enum.AutomaticSize.Y,
					size = UDim2.fromScale(1, 0),
					textXAlignment = Enum.TextXAlignment.Center
				})
			})
		end,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						layoutOrder = 0,
						onActivated = v22,
						text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.Cancel", v24)
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimaryContextual,
					props = {
						layoutOrder = 2,
						onActivated = v23,
						text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.Go", v24)
					}
				}
			}
		},
		screenSize = v20
	})
end

return AttributionTraversal

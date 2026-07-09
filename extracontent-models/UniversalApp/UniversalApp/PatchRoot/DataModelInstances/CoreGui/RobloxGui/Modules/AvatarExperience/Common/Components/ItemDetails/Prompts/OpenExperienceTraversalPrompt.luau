local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useStyle = UIBlox.Core.Style.useStyle
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local AppPage = require(Modules.LuaApp.AppPage)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local LinkButton = UIBlox.App.Button.LinkButton
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local v20 = Images["icons/status/imageunavailable"]
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function OpenExperienceTraversalPrompt(t1: {[any]: any}) -- line: 73
	-- upvalues: useLocalization (copy), useSelector (copy), getUseSelectorDeepEquals (copy), React (copy), NavigationUtils (copy), AppPage (copy), useStyle (copy), v20 (copy), IconSize (copy), GameIconReducer (copy), InteractiveAlert (copy), ImageSetLabel (copy), StyledTextLabel (copy), LinkButton (copy), CursorKind (copy), ButtonType (copy)
	local params = t1.navigation.state.params
	local v25 = useLocalization({
		title = "Feature.Catalog.Heading.GoToExperience",
		confirmButtonText = "CommonUI.Features.Action.Go",
		cancelButtonText = "CommonUI.Controls.Action.Cancel",
		viewDetailsButtonText = "Feature.Catalog.Action.ViewExperienceDetails",
		body = {
			"Feature.Catalog.Description.AttributionAlertBody",
			experienceName = t1.navigation.state.params.gameName or ""
		}
	})
	local v26 = useSelector(function(p1) -- line: 88
		return p1.ScreenSize
	end, getUseSelectorDeepEquals())
	local v27 = React.useCallback(function() -- line: 92
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeOverlay(t1.navigation)
	end, { t1.navigation })
	local v28 = React.useCallback(function() -- line: 96
		-- upvalues: NavigationUtils (copy), t1 (copy), params (copy)
		NavigationUtils.closeOverlay(t1.navigation)
		params.onPlayButtonActivated()
	end, { t1.navigation })
	local v29 = React.useCallback(function() -- line: 101
		-- upvalues: AppPage (copy), NavigationUtils (copy), t1 (copy), params (copy)
		local GameDetail = AppPage.GameDetail

		NavigationUtils.navigateFromOverlay(t1.navigation, GameDetail, {
			detail = params.gameUniverseId,
			extraProps = {
				mountAsFullView = true
			}
		})
	end, { t1.navigation })
	local v30 = useStyle()
	local Theme = v30.Theme
	local Font = v30.Font
	local v33 = if not params.thumbnailUrl then v20 else params.thumbnailUrl
	local v34 = if not params.thumbnailUrl then UDim2.fromOffset(IconSize.Large, IconSize.Large) else UDim2.fromOffset(150, 150)
	local v35, v36 = React.useState(nil)
	local v37, v38 = React.useState(nil)
	local t2 = nil
	local v40 = useSelector(function(p2) -- line: 128
		-- upvalues: GameIconReducer (copy)
		return p2[GameIconReducer.key]
	end)

	React.useEffect(function() -- line: 132
		-- upvalues: params (copy), v40 (copy), v36 (copy), v38 (copy)
		if not params.thumbnailUrl then
			local v44 = v40[params.gameUniverseId]

			if v44 then
				v36(v44.url)
				v38(UDim2.fromOffset(150, 150))
			end
		end
	end, { v40 })

	if params.hideConfirmationButton then
		t2 = {{
			isDefaultChild = true,
			props = {
				layoutOrder = 0,
				onActivated = v27,
				text = v25.cancelButtonText
			}
		}}
	end

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = true,
		title = if not params.overrideTitle then v25.title else params.overrideTitle,
		middleContent = function() -- line: 158
			-- upvalues: React (copy), Theme (copy), ImageSetLabel (copy), v35 (copy), v33 (copy), v37 (copy), v34 (copy), StyledTextLabel (copy), params (copy), v25 (copy), Font (copy), LinkButton (copy), v29 (copy), CursorKind (copy)
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
					Padding = UDim.new(0, 12)
				}),
				ExperienceThumbnailFrame = React.createElement("Frame", {
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
						Image = if not v35 then v33 else v35,
						Size = if not v37 then v34 else v37
					}, {
						RoundCorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}),
					RoundCorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				BodyText = React.createElement(StyledTextLabel, {
					layoutOrder = 2,
					lineHeight = 1,
					text = if not params.overrideBody then v25.body else params.overrideBody,
					fontStyle = Font.Body,
					colorStyle = Theme.TextDefault,
					automaticSize = Enum.AutomaticSize.Y,
					size = UDim2.fromScale(1, 0),
					textXAlignment = Enum.TextXAlignment.Center
				}),
				DetailsButton = React.createElement(LinkButton, {
					layoutOrder = 3,
					text = v25.viewDetailsButtonText,
					onActivated = v29,
					selectionCursorKind = CursorKind.RoundedRectNoInset
				})
			})
		end,
		buttonStackInfo = {
			buttons = t2 or {
				{
					isDefaultChild = true,
					props = {
						layoutOrder = 0,
						onActivated = v27,
						text = v25.cancelButtonText
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimaryContextual,
					props = {
						layoutOrder = 2,
						onActivated = v28,
						text = v25.confirmButtonText
					}
				}
			}
		},
		screenSize = v26,
		defaultChildRef = t1.defaultChildRef
	})
end

return withOverlayFocusHandling(OpenExperienceTraversalPrompt)

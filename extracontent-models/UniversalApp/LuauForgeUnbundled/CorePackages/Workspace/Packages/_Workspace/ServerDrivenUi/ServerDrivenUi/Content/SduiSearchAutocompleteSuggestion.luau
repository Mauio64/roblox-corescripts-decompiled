local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").Hooks.useLocalization

local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local loadableImage = UIBlox.App.Loading.LoadableImage
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTokens = Foundation.Hooks.useTokens

local function SduiSearchAutocompleteSuggestion(data)
	local v5 = useTokens()
	local isRich = data.isRich == true
	local v6 = (data.layoutOrder or 1) > 1
	local v7 = if isRich then v5.Size.Size_1600 else v5.Size.Size_1400
	local size_1100 = v5.Size.Size_1100
	local size_900 = v5.Size.Size_900
	local size_600 = v5.Size.Size_600
	local state, setState = React.useState(false)
	local v8 = useLocalization({ category = "Feature.GameBadges.Label.Experience" })

	React.useEffect(function()
		if not state then
			return
		end

		local inputEndedConnection = UserInputService.InputEnded:Connect(function()
			setState(false)
		end)
		return function()
			inputEndedConnection:Disconnect()
		end
	end, { state })

	local function onInputBegan(p2, p3)
		if
			(p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
			and p3.UserInputState == Enum.UserInputState.Begin
		then
			setState(true)
		end
	end

	return withSelectionCursorProvider(function(callback)
		return withStyle(function(props)
			local createElement = React.createElement

			local v11 = if state then props.Theme.BackgroundOnPress.Color else props.Theme.BackgroundDefault.Color
			local v10 = {
				Image = "",
				BackgroundColor3 = v11,
				BackgroundTransparency = not state and 1 or props.Theme.BackgroundOnPress.Transparency,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Size = UDim2.new(1, 0, 0, v7),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = data.layoutOrder,
				Selectable = true,
				Active = true,
				SelectionImageObject = callback(cursorKind.RoundedRectNoInset),
				[React.Event.Activated] = function()
					if data.onActivated then
						data.onActivated()
					end
				end,
				[React.Event.InputBegan] = onInputBegan,
				[React.Event.InputEnded] = function()
					setState(false)
				end,
				[React.Tag] = "data-testid=--sdui-autocomplete-suggestion"
			}
			local v13

			if v6 then
				v13 = React.createElement("Frame", {
					BackgroundColor3 = props.Theme.Divider.Color,
					BackgroundTransparency = props.Theme.Divider.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v5.Stroke.Standard),
					[React.Tag] = "data-testid=--sdui-autocomplete-divider"
				})
			end

			local createElement2 = React.createElement
			local v16 = if v6 then UDim2.fromOffset(0, v5.Stroke.Standard) else nil
			local v15 = {
				Position = v16,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Tag] = "data-testid=--sdui-autocomplete-container"
			}
			local v17 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 9)
				}),
				LeftSpacing = React.createElement("Frame", {
					Size = UDim2.new(0, 0, 0, v7),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1
				}),
				SearchIcon = React.createElement(Foundation.Icon, {
					name = "magnifying-glass",
					size = size_600,
					style = {
						Color3 = props.Theme.IconDefault.Color,
						Transparency = props.Theme.IconDefault.Transparency
					},
					LayoutOrder = 2,
					testId = "--sdui-autocomplete-search-icon"
				}),
				Content = 0,
				RichIcon = 0
			}

			local createElement3 = React.createElement
			local v19 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -(size_600 + size_1100 + 36 + v5.Padding.Small), 1, 0),
				LayoutOrder = 3
			}

			local v20 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 5)
				}),
				Title = 0,
				Category = 0
			}

			local createElement4 = React.createElement
			local v22 = {}
			v22.BackgroundTransparency = 1
			v22.BorderSizePixel = 0
			v22.LayoutOrder = 1
			v22.Size = UDim2.new(1, 0, 0, 0)
			v22.AutomaticSize = Enum.AutomaticSize.Y
			v22.Text = data.title
			local v23 = if not foundationFontFaceMigration then props.Font.Body.Font else nil
			v22.Font = v23

			local v24 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
			v22.FontFace = v24

			v22.TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize
			v22.TextColor3 = props.Theme.TextDefault.Color
			v22.TextTransparency = props.Theme.TextDefault.Transparency
			v22.TextXAlignment = Enum.TextXAlignment.Left
			v22.TextYAlignment = Enum.TextYAlignment.Top
			v22.TextWrapped = true
			v22[React.Tag] = "data-testid=--sdui-autocomplete-title"
			v20.Title = createElement4("TextLabel", v22)
			local v25

			if isRich then
				local createElement5 = React.createElement
				local v27 = {}
				v27.BackgroundTransparency = 1
				v27.BorderSizePixel = 0
				v27.LayoutOrder = 2
				v27.Size = UDim2.new(1, 0, 0, 0)
				v27.AutomaticSize = Enum.AutomaticSize.Y
				v27.Text = v8.category
				local v28 = if not foundationFontFaceMigration then props.Font.CaptionBody.Font else nil
				v27.Font = v28

				local v29 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
				v27.FontFace = v29

				v27.TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
				v27.TextColor3 = props.Theme.TextMuted.Color
				v27.TextTransparency = props.Theme.TextMuted.Transparency
				v27.TextXAlignment = Enum.TextXAlignment.Left
				v27.TextYAlignment = Enum.TextYAlignment.Top
				v27.TextWrapped = true
				v27[React.Tag] = "data-testid=--sdui-autocomplete-category"
				v25 = createElement5("TextLabel", v27)
			end

			v20.Category = v25
			v17.Content = createElement3("Frame", v19, v20)
			local v26

			if isRich and data.richIcon ~= nil then
				v26 = React.createElement("Frame", {
					Size = UDim2.fromOffset(size_1100, size_1100),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 4,
					[React.Tag] = "data-testid=--sdui-autocomplete-rich-icon-container"
				}, {
					Shadow = React.createElement("Frame", {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(v5.Size.Size_200, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = props.Theme.BackgroundOnHover.Color,
						BackgroundTransparency = props.Theme.BackgroundOnHover.Transparency,
						ZIndex = 10
					}),
					Border = React.createElement("Frame", {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(v5.Size.Size_50, v5.Size.Size_150),
						BorderSizePixel = 0,
						BackgroundColor3 = props.Theme.BackgroundDefault.Color,
						BackgroundTransparency = props.Theme.BackgroundDefault.Transparency,
						ZIndex = 11
					}),
					GameIcon = React.createElement(loadableImage, {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(0, v5.Size.Size_200),
						BackgroundTransparency = 1,
						Image = data.richIcon,
						useShimmerAnimationWhileLoading = true,
						ZIndex = 12
					})
				})
			end

			v17.RichIcon = v26
			return createElement("ImageButton", v10, {
				Divider = v13,
				Container = createElement2("Frame", v15, v17)
			})
		end)
	end)
end

return React.memo(SduiSearchAutocompleteSuggestion)

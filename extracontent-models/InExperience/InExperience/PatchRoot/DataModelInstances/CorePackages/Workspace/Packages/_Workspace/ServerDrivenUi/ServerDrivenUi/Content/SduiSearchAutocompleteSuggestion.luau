local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local LoadableImage = UIBlox.App.Loading.LoadableImage
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTokens = Foundation.Hooks.useTokens

local function SduiSearchAutocompleteSuggestion(data)
	local v = useTokens()
	local isRich = data.isRich == true
	local v2 = (data.layoutOrder or 1) > 1
	local v3

	if isRich then
		v3 = v.Size.Size_1600
	else
		v3 = v.Size.Size_1400
	end

	local size_1100 = v.Size.Size_1100
	local size_900 = v.Size.Size_900
	local size_600 = v.Size.Size_600
	local state, setState = React.useState(false)
	local v4 = useLocalization({ category = "Feature.GameBadges.Label.Experience" })

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

	local function onInputBegan(_, p)
		if
			(p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1)
			and p.UserInputState == Enum.UserInputState.Begin
		then
			setState(true)
		end
	end

	return withSelectionCursorProvider(function(callback)
		return withStyle(function(props)
			local createElement = React.createElement
			local backgroundColor

			if state then
				backgroundColor = props.Theme.BackgroundOnPress.Color
			else
				backgroundColor = props.Theme.BackgroundDefault.Color
			end

			local v5 = {
				Image = "",
				BackgroundColor3 = backgroundColor,
				BackgroundTransparency = not state and 1 or props.Theme.BackgroundOnPress.Transparency,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Size = UDim2.new(1, 0, 0, v3),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = data.layoutOrder,
				Selectable = true,
				Active = true,
				SelectionImageObject = callback(CursorKind.RoundedRectNoInset),
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
			local divider

			if v2 then
				divider = React.createElement("Frame", {
					BackgroundColor3 = props.Theme.Divider.Color,
					BackgroundTransparency = props.Theme.Divider.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v.Stroke.Standard),
					[React.Tag] = "data-testid=--sdui-autocomplete-divider"
				})
			end

			local createElement2 = React.createElement
			local position

			if v2 then
				position = UDim2.fromOffset(0, v.Stroke.Standard)
			end

			local v6 = {
				Position = position,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Tag] = "data-testid=--sdui-autocomplete-container"
			}
			local v7 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 9)
				}),
				LeftSpacing = React.createElement("Frame", {
					Size = UDim2.new(0, 0, 0, v3),
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
			local v8 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -(size_600 + size_1100 + 36 + v.Padding.Small), 1, 0),
				LayoutOrder = 3
			}

			local v9 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 5)
				}),
				Title = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = data.title,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize,
					TextColor3 = props.Theme.TextDefault.Color,
					TextTransparency = props.Theme.TextDefault.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					[React.Tag] = "data-testid=--sdui-autocomplete-title"
				}),
				Category = 0
			}
			local category

			if isRich then
				category = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = v4.category,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize,
					TextColor3 = props.Theme.TextMuted.Color,
					TextTransparency = props.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					[React.Tag] = "data-testid=--sdui-autocomplete-category"
				})
			end

			v9.Category = category
			v7.Content = createElement3("Frame", v8, v9)
			local richIcon

			if isRich and data.richIcon ~= nil then
				richIcon = React.createElement("Frame", {
					Size = UDim2.fromOffset(size_1100, size_1100),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 4,
					[React.Tag] = "data-testid=--sdui-autocomplete-rich-icon-container"
				}, {
					Shadow = React.createElement("Frame", {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(v.Size.Size_200, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = props.Theme.BackgroundOnHover.Color,
						BackgroundTransparency = props.Theme.BackgroundOnHover.Transparency,
						ZIndex = 10
					}),
					Border = React.createElement("Frame", {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(v.Size.Size_50, v.Size.Size_150),
						BorderSizePixel = 0,
						BackgroundColor3 = props.Theme.BackgroundDefault.Color,
						BackgroundTransparency = props.Theme.BackgroundDefault.Transparency,
						ZIndex = 11
					}),
					GameIcon = React.createElement(LoadableImage, {
						Size = UDim2.fromOffset(size_900, size_900),
						Position = UDim2.fromOffset(0, v.Size.Size_200),
						BackgroundTransparency = 1,
						Image = data.richIcon,
						useShimmerAnimationWhileLoading = true,
						ZIndex = 12
					})
				})
			end

			v7.RichIcon = richIcon
			return createElement("ImageButton", v5, {
				Divider = divider,
				Container = createElement2("Frame", v6, v7)
			})
		end)
	end)
end

return React.memo(SduiSearchAutocompleteSuggestion)

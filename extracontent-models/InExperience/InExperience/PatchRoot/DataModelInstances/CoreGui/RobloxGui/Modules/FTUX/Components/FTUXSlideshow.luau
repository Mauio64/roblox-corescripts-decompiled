local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local parent = script.Parent.Parent
local FTUXSlideshowData = require(parent.Resources.FTUXSlideshowData)
local FTUXConstants = require(parent.Resources.FTUXConstants)

require(parent.Enums.PlatformEnum)

local Header = require(parent.Components.Slideshow.Header)
local Stepper = require(parent.Components.Slideshow.Stepper)
local Title = require(parent.Components.Slideshow.Title)
local Description = require(parent.Components.Slideshow.Description)
local EndItem = require(parent.Components.Slideshow.EndItem)

local EventHandler = require(parent.Events.EventHandler)

local function FTUXSlideshow(p)
	local state, setState = React.useState(1)

	local platform = p.platform
	local v = FTUXSlideshowData[platform]
	local panelConstants = FTUXConstants[platform].PanelConstants
	local v2 = v[state]

	local CONTENT_HEIGHT_RATIO = panelConstants.CONTENT_HEIGHT_RATIO
	local FOOTER_HEIGHT_RATIO = panelConstants.FOOTER_HEIGHT_RATIO
	local v3 = panelConstants.CONTENT_PADDING / panelConstants.SLIDESHOW_FRAME_WIDTH
	local v4 = 1 - 2 * v3

	local increaseCurrentIndex = React.useCallback(function()
		setState(state + 1)
	end, { state })

	React.useEffect(function()
		EventHandler.StartEvents(platform, state, increaseCurrentIndex)

		return function()
			EventHandler.StopEvents(platform, state)
		end
	end, { state })

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		},
		{
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.05, 0) }),
			SlideshowLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0.05, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Header = React.createElement(Header, { platform = platform }),
			ContentFrame = React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, CONTENT_HEIGHT_RATIO, 0),
					Position = UDim2.new(0, 0, 0, 0)
				},
				{
					Content = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(v4, 0, 1, 0),
							Position = UDim2.new(v3, 0, 0, 0)
						},
						{
							ContentLayout = React.createElement("UIListLayout", {
								Padding = UDim.new(0.05, 0),
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Title = React.createElement(Title, {
								platform = platform,
								currentIndex = state
							}),
							Description = React.createElement(Description, {
								platform = platform,
								currentIndex = state
							}),
							ImageFrame = React.createElement(
								"Frame",
								{
									LayoutOrder = 3,
									BackgroundTransparency = 1,
									Size = UDim2.new(1.2, 0, 0.4, 0),
									Position = UDim2.new(0, 0, 0, 0)
								},
								{
									Image = React.createElement("ImageLabel", {
										Image = v2.image,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 1, 0),
										LayoutOrder = 3,
										ScaleType = Enum.ScaleType.Fit
									})
								}
							)
						}
					)
				}
			),
			FooterFrame = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, FOOTER_HEIGHT_RATIO, 0),
					Position = UDim2.new(0, 0, 0, 0)
				},
				{
					Footer = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(v4, 0, 1, 0),
							Position = UDim2.new(v3, 0, 0, 0)
						},
						{
							ContentLayout = React.createElement("UIListLayout", {
								Padding = state ~= #v and UDim.new(0.2, 0) or UDim.new(0, 0),
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Stepper = React.createElement(Stepper, {
								layoutOrder = 1,
								numberActivated = state,
								numberOfSteps = #v
							}, {}),
							EndItem = React.createElement(EndItem, {
								platform = platform,
								currentIndex = state,
								increaseCurrentIndex = increaseCurrentIndex
							})
						}
					)
				}
			)
		}
	)
end

return FTUXSlideshow

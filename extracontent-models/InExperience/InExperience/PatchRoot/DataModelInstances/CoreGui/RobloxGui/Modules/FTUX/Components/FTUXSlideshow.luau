local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ParentParent = script.Parent.Parent
local FTUXSlideshowData = require(ParentParent.Resources.FTUXSlideshowData)
local FTUXConstants = require(ParentParent.Resources.FTUXConstants)

require(ParentParent.Enums.PlatformEnum)

local Header = require(ParentParent.Components.Slideshow.Header)
local Stepper = require(ParentParent.Components.Slideshow.Stepper)
local Title = require(ParentParent.Components.Slideshow.Title)
local Description = require(ParentParent.Components.Slideshow.Description)
local EndItem = require(ParentParent.Components.Slideshow.EndItem)
local EventHandler = require(ParentParent.Events.EventHandler)

local function FTUXSlideshow(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), FTUXSlideshowData (copy), FTUXConstants (copy), EventHandler (copy), Header (copy), Title (copy), Description (copy), Stepper (copy), EndItem (copy)
	local v14, v15 = React.useState(1)
	local platform = t1.platform
	local v17 = FTUXSlideshowData[platform]
	local PanelConstants = FTUXConstants[platform].PanelConstants
	local v19 = v17[v14]
	local CONTENT_HEIGHT_RATIO = PanelConstants.CONTENT_HEIGHT_RATIO
	local FOOTER_HEIGHT_RATIO = PanelConstants.FOOTER_HEIGHT_RATIO
	local v22 = PanelConstants.CONTENT_PADDING / PanelConstants.SLIDESHOW_FRAME_WIDTH
	local v23 = 1 - 2 * v22
	local v24 = React.useCallback(function() -- line: 37
		-- upvalues: v15 (copy), v14 (copy)
		v15(v14 + 1)
	end, { v14 })

	React.useEffect(function() -- line: 41
		-- upvalues: EventHandler (copy), platform (copy), v14 (copy), v24 (copy)
		EventHandler.StartEvents(platform, v14, v24)

		return function() -- line: 44
			-- upvalues: EventHandler (copy), platform (copy), v14 (copy)
			EventHandler.StopEvents(platform, v14)
		end
	end, { v14 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.05, 0)
		}),
		SlideshowLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0.05, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = React.createElement(Header, {
			platform = platform
		}),
		ContentFrame = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, CONTENT_HEIGHT_RATIO, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}, {
			Content = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(v23, 0, 1, 0),
				Position = UDim2.new(v22, 0, 0, 0)
			}, {
				ContentLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0.05, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Title = React.createElement(Title, {
					platform = platform,
					currentIndex = v14
				}),
				Description = React.createElement(Description, {
					platform = platform,
					currentIndex = v14
				}),
				ImageFrame = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1.2, 0, 0.4, 0),
					Position = UDim2.new(0, 0, 0, 0)
				}, {
					Image = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Image = v19.image,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Fit
					})
				})
			})
		}),
		FooterFrame = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, FOOTER_HEIGHT_RATIO, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}, {
			Footer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(v23, 0, 1, 0),
				Position = UDim2.new(v22, 0, 0, 0)
			}, {
				ContentLayout = React.createElement("UIListLayout", {
					Padding = v14 ~= #v17 and UDim.new(0.2, 0) or UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Stepper = React.createElement(Stepper, {
					layoutOrder = 1,
					numberActivated = v14,
					numberOfSteps = #v17
				}, {}),
				EndItem = React.createElement(EndItem, {
					platform = platform,
					currentIndex = v14,
					increaseCurrentIndex = v24
				})
			})
		})
	})
end

return FTUXSlideshow

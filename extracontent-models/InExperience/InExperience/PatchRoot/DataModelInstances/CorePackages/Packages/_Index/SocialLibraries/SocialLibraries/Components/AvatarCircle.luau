local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact
local imageSetLabel = dependencies.UIBlox.Core.ImageSet.ImageSetLabel

local extended = roact.PureComponent:extend("AvatarCircle")

extended.PresetSize = { Size36x36 = "Size36x36", Size48x48 = "Size48x48" }

local v = {
	[extended.PresetSize.Size36x36] = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-36x36.png",
	[extended.PresetSize.Size48x48] = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-48x48.png"
}

extended.defaultProps = {
	thumbnails = {},
	onActivated = nil,
	circleColor3 = Color3.new(0.9, 0.9, 0.9),
	circleTransparency = 0,
	circleInteriorBackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
	circleInteriorBackgroundTransparency = 0,
	circleDividerColor3 = Color3.new(0.7, 0.7, 0.7),
	circleDividerTransparency = 0,
	overlaySize = extended.PresetSize.Size48x48,
	presenceImage = nil,
	presenceIndicatorSize = 14
}

local function createAlignedContainerElement(horizontalAlignment)
	return {
		layout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = horizontalAlignment,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
end

function extended:generateThumbnails(list)
	local count = #list
	local halfCount = count / 2
	local v2 = count % 2 == 0 and halfCount or math.floor(halfCount)
	local v3 = count - v2
	local presenceIndicator

	if count == 1 then
		if self.props.showNewPresenceImage then
			presenceIndicator = roact.createElement(imageSetLabel, {
				Size = UDim2.new(0, self.props.presenceIndicatorSize, 0, self.props.presenceIndicatorSize),
				BackgroundTransparency = 1,
				Image = self.props.presenceImage,
				ImageColor3 = self.props.presenceImageColor3,
				ImageTransparency = self.props.presenceImageTransparency
			})
		else
			presenceIndicator = roact.createElement("ImageLabel", {
				Size = UDim2.new(0, self.props.presenceIndicatorSize, 0, self.props.presenceIndicatorSize),
				BackgroundTransparency = 1,
				Image = self.props.presenceImage
			})
		end
	end

	local alignedContainerElement = createAlignedContainerElement(Enum.HorizontalAlignment.Right)
	local alignedContainerElement2 = createAlignedContainerElement(Enum.HorizontalAlignment.Left)
	local alignedContainerElement3 = createAlignedContainerElement(Enum.HorizontalAlignment.Center)

	for i, item in ipairs(list) do
		local v4 = 0

		local borderObject = nil
		local udim, children

		if count == 1 then
			udim = UDim2.new(1, 0, 1, 0)
			children = alignedContainerElement3
		elseif i <= v2 then
			udim = UDim2.new(1 / v2, 0, 1 / v2, 0)

			v4 = count == 3 and 0.125 or count == 2 and 0.125 or v4

			borderObject = roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 },
				{
					border = roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 2),
						Position = UDim2.new(0, 0, 1, -1),
						BorderSizePixel = 0,
						BackgroundColor3 = self.props.circleDividerColor3,
						BackgroundTransparency = self.props.circleDividerTransparency
					}),
					borderVertical = roact.createElement("Frame", {
						Size = UDim2.new(0, 2, 1, 0),
						Position = UDim2.new(0, -1, 0, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = self.props.circleDividerColor3,
						BackgroundTransparency = self.props.circleDividerTransparency
					})
				}
			)
			children = alignedContainerElement
		else
			udim = UDim2.new(1 / v3, 0, 1 / v3, 0)

			v4 = count == 2 and -0.125 or v4

			borderObject = roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 },
				{
					border = roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 2),
						Position = UDim2.new(0, 0, 0, -1),
						BorderSizePixel = 0,
						BackgroundColor3 = self.props.circleDividerColor3,
						BackgroundTransparency = self.props.circleDividerTransparency
					}),
					borderVertical = roact.createElement("Frame", {
						Size = UDim2.new(0, 2, 1, 0),
						Position = UDim2.new(0, -1, 0, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = self.props.circleDividerColor3,
						BackgroundTransparency = self.props.circleDividerTransparency
					})
				}
			)
			children = alignedContainerElement2
		end

		children["thumbnail-" .. tostring(i + 1)] = roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = udim,
			ClipsDescendants = true,
			LayoutOrder = #children + 1
		}, {
			headshotContainer = roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(v4, 0, 0, 0),
					BackgroundTransparency = 1
				},
				{
					headshot = roact.createElement("ImageLabel", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = item
					})
				}
			),
			borderObject = borderObject
		})
	end

	return {
		rightElements = alignedContainerElement2,
		leftElements = alignedContainerElement,
		centerElements = alignedContainerElement3,
		presenceIndicator = presenceIndicator
	}
end

function extended:render()
	local thumbnails = self.props.thumbnails
	local image = v[self.props.overlaySize]

	local thumbnails2 = self:generateThumbnails(thumbnails)

	return roact.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = self.props.circleInteriorBackgroundColor3,
		BackgroundTransparency = self.props.circleInteriorBackgroundTransparency,
		BorderSizePixel = 0,
		Image = "",
		AutoButtonColor = false,
		ClipsDescendants = true,
		[roact.Event.Activated] = self.props.onActivated
	}, {
		imageMask = roact.createElement("ImageLabel", {
			Image = image,
			ImageColor3 = self.props.circleColor3,
			ImageTransparency = self.props.circleTransparency,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, {
			presenceFrame = roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				layout = roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Bottom
				}),
				presenceIndicator = thumbnails2.presenceIndicator
			})
		}),
		center = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			elementContainer = roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				thumbnails2.centerElements
			)
		}),
		left = roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, -1, 1, 0),
				Position = UDim2.new(-0.5, 0, 0, 0),
				BackgroundTransparency = 1
			},
			{
				elementContainer = roact.createElement(
					"Frame",
					{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
					thumbnails2.leftElements
				)
			}
		),
		right = roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, -1, 1, 0),
				Position = UDim2.new(0.5, -2, 0, 0),
				BackgroundTransparency = 1
			},
			{
				elementContainer = roact.createElement(
					"Frame",
					{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
					thumbnails2.rightElements
				)
			}
		)
	})
end

return extended

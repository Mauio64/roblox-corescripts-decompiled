local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local ImageSetLabel = dependencies.UIBlox.Core.ImageSet.ImageSetLabel
local v5 = Roact.PureComponent:extend("AvatarCircle")

v5.PresetSize = {
	Size36x36 = "Size36x36",
	Size48x48 = "Size48x48"
}

local t1 = {
	[v5.PresetSize.Size36x36] = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-36x36.png",
	[v5.PresetSize.Size48x48] = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-48x48.png"
}

v5.defaultProps = {
	onActivated = nil,
	circleTransparency = 0,
	circleInteriorBackgroundTransparency = 0,
	circleDividerTransparency = 0,
	presenceImage = nil,
	presenceIndicatorSize = 14,
	thumbnails = {},
	circleColor3 = Color3.new(0.9, 0.9, 0.9),
	circleInteriorBackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
	circleDividerColor3 = Color3.new(0.7, 0.7, 0.7),
	overlaySize = v5.PresetSize.Size48x48
}

local function createAlignedContainerElement(p1) -- line: 43
	-- upvalues: Roact (copy)
	return {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = p1,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
end

function v5.generateThumbnails(p2, p3) -- line: 54
	-- upvalues: Roact (copy), ImageSetLabel (copy), createAlignedContainerElement (copy)
	local v11 = #p3
	local v12 = v11 / 2
	local v13 = v11 % 2 == 0 and v12 or math.floor(v12)
	local v14 = v11 - v13
	local v15 = nil

	if v11 == 1 then
		v15 = if not p2.props.showNewPresenceImage then Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p2.props.presenceIndicatorSize, 0, p2.props.presenceIndicatorSize),
			Image = p2.props.presenceImage
		}) else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p2.props.presenceIndicatorSize, 0, p2.props.presenceIndicatorSize),
			Image = p2.props.presenceImage,
			ImageColor3 = p2.props.presenceImageColor3,
			ImageTransparency = p2.props.presenceImageTransparency
		})
	end

	local v16 = createAlignedContainerElement(Enum.HorizontalAlignment.Right)
	local v17 = createAlignedContainerElement(Enum.HorizontalAlignment.Left)
	local v18 = createAlignedContainerElement(Enum.HorizontalAlignment.Center)

	for i, v in ipairs(p3) do
		local n1 = 0
		local v22 = nil
		local uDim2, v24

		if v11 == 1 then
			uDim2 = UDim2.new(1, 0, 1, 0)
			v24 = v18
		elseif i <= v13 then
			uDim2 = UDim2.new(1 / v13, 0, 1 / v13, 0)
			v24 = v16

			if v11 == 3 then
				n1 = 0.125
			elseif v11 == 2 then
				n1 = 0.125
			end

			v22 = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				border = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = p2.props.circleDividerColor3,
					BackgroundTransparency = p2.props.circleDividerTransparency
				}),
				borderVertical = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = p2.props.circleDividerColor3,
					BackgroundTransparency = p2.props.circleDividerTransparency
				})
			})
		else
			uDim2 = UDim2.new(1 / v14, 0, 1 / v14, 0)
			v24 = v17

			if v11 == 2 then
				n1 = -0.125
			end

			v22 = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				border = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 0, -1),
					BackgroundColor3 = p2.props.circleDividerColor3,
					BackgroundTransparency = p2.props.circleDividerTransparency
				}),
				borderVertical = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = p2.props.circleDividerColor3,
					BackgroundTransparency = p2.props.circleDividerTransparency
				})
			})
		end

		v24["thumbnail-" .. tostring(i + 1)] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = uDim2,
			LayoutOrder = #v24 + 1
		}, {
			headshotContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(n1, 0, 0, 0)
			}, {
				headshot = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Image = v
				})
			}),
			borderObject = v22
		})
	end

	return {
		rightElements = v17,
		leftElements = v16,
		centerElements = v18,
		presenceIndicator = v15
	}
end
function v5.render(p4) -- line: 195
	-- upvalues: t1 (copy), Roact (copy)
	local thumbnails = p4.props.thumbnails
	local v27 = t1[p4.props.overlaySize]
	local v28 = p4:generateThumbnails(thumbnails)

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = p4.props.circleInteriorBackgroundColor3,
		BackgroundTransparency = p4.props.circleInteriorBackgroundTransparency,
		BorderSizePixel = 0,
		Image = "",
		AutoButtonColor = false,
		ClipsDescendants = true,
		[Roact.Event.Activated] = p4.props.onActivated
	}, {
		imageMask = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = v27,
			ImageColor3 = p4.props.circleColor3,
			ImageTransparency = p4.props.circleTransparency,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			presenceFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Bottom
				}),
				presenceIndicator = v28.presenceIndicator
			})
		}),
		center = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			elementContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, v28.centerElements)
		}),
		left = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.new(-0.5, 0, 0, 0)
		}, {
			elementContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, v28.leftElements)
		}),
		right = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.new(0.5, -2, 0, 0)
		}, {
			elementContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, v28.rightElements)
		})
	})
end

return v5

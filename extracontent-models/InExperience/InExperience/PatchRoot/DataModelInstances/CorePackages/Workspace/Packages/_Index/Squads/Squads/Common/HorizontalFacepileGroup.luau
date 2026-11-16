local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local Cryo = require(parent.Cryo)

local dependencies = require(Squads.dependencies)

local foundation = dependencies.Foundation
local react = dependencies.React

local useTokens = foundation.Hooks.useTokens
local image = foundation.Image
local view = foundation.View

function HorizontalFacepileGroup(p)
	local v = useTokens()

	local v2 = {
		avatarSize = 0,
		images = {},
		layoutOrder = 1,
		imageBackgroundStyle = nil,
		imageBorderStyle = {
			Color = v.Color.Extended.Green.Green_800.Color3,
			Transparency = v.Color.Extended.Green.Green_800.Transparency
		}
	}

	local union = Cryo.Dictionary.union(v2, p)

	local v3 = react.useMemo(function()
		local count = #union.images

		if count <= 0 then
			return 0
		end

		local avatarSize = union.avatarSize

		for _ = 2, count do
			avatarSize += union.avatarSize - 4
		end

		return avatarSize
	end, { #union.images, union.avatarSize })

	local v4 = react.useMemo(function()
		local v4 = #union.images
		local children = {}

		for i, image2 in ipairs(union.images) do
			local v5 = i == 1 and 0 or 4

			local createElement = react.createElement
			local backgroundStyle

			if union.imageBackgroundStyle then
				backgroundStyle = union.imageBackgroundStyle
			end

			local v6 = {
				Image = image2,
				backgroundStyle = backgroundStyle,
				Size = UDim2.fromOffset(union.avatarSize, union.avatarSize),
				Position = UDim2.new(0, union.avatarSize * (i - 1) - v5 * (i - 1), 0.5, 0),
				tag = "anchor-center-left bg-surface-100 radius-circle",
				ZIndex = v4 - i + 1,
				testId = 0
			}
			local testId

			if union.testId then
				testId = `{union.testId}--image-{i}`
			end

			v6.testId = testId

			local createElement2 = react.createElement
			local color

			if union.imageBorderStyle then
				color = union.imageBorderStyle.Color
			else
				color = v.Color.Extended.Green.Green_800.Color3
			end

			local transparency

			if union.imageBorderStyle then
				transparency = union.imageBorderStyle.Transparency
			else
				transparency = v.Color.Extended.Green.Green_800.Transparency
			end

			local children2 = {
				UIStroke = createElement2("UIStroke", {
					Color = color,
					Transparency = transparency,
					Thickness = v.Stroke.Thick
				})
			}
			table.insert(children, createElement(image, v6, children2))
		end

		return children
	end, {
		union.avatarSize,
		union.images,
		union.imageBackgroundStyle,
		union.imageBorderStyle,
		union.testId
	})

	local createElement = react.createElement
	local v5 = {
		Size = UDim2.fromOffset(v3, union.avatarSize),
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		testId = 0
	}
	local layoutOrder

	if union.layoutOrder then
		layoutOrder = union.layoutOrder
	end

	v5.LayoutOrder = layoutOrder
	v5.testId = union.testId
	return createElement(view, v5, { v4 })
end

return HorizontalFacepileGroup

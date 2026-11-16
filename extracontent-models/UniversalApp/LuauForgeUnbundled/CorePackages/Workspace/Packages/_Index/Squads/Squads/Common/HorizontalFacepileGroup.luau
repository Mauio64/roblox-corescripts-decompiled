local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local foundation = dependencies.Foundation
local react = dependencies.React

local useTokens = foundation.Hooks.useTokens
local image = foundation.Image
local view = foundation.View

function LUAUFORGE_MODULE_GLOBALS_hjt_HorizontalFacepileGroup(p2)
	local v5 = useTokens()

	local v6 = {
		avatarSize = 0,
		images = {},
		layoutOrder = 1,
		imageBackgroundStyle = nil,
		imageBorderStyle = {
			Color = v5.Color.Extended.Green.Green_800.Color3,
			Transparency = v5.Color.Extended.Green.Green_800.Transparency
		}
	}

	local union = Cryo.Dictionary.union(v6, p2)

	local v7 = react.useMemo(function()
		local count = #union.images

		if count <= 0 then
			return 0
		end

		local avatarSize = union.avatarSize

		for i = 2, count do
			avatarSize += union.avatarSize - 4
		end

		return avatarSize
	end, { #union.images, union.avatarSize })

	local v8 = react.useMemo(function()
		local v9 = #union.images
		local children = {}

		for i, image2 in ipairs(union.images) do
			local v10 = i == 1 and 0 or 4

			local createElement = react.createElement

			local v13 = if union.imageBackgroundStyle then union.imageBackgroundStyle else nil
			local v12 = {
				Image = image2,
				backgroundStyle = v13,
				Size = UDim2.fromOffset(union.avatarSize, union.avatarSize),
				Position = UDim2.new(0, union.avatarSize * (i - 1) - v10 * (i - 1), 0.5, 0),
				tag = "anchor-center-left bg-surface-100 radius-circle",
				ZIndex = v9 - i + 1,
				testId = 0
			}
			local v14 = if union.testId then `{union.testId}--image-{i}` else nil
			v12.testId = v14

			local createElement2 = react.createElement
			local v17 = if union.imageBorderStyle then union.imageBorderStyle.Color else v5.Color.Extended.Green.Green_800.Color3
			local v18 = if union.imageBorderStyle then union.imageBorderStyle.Transparency else v5.Color.Extended.Green.Green_800.Transparency
			local children2 = {
				UIStroke = createElement2("UIStroke", {
					Color = v17,
					Transparency = v18,
					Thickness = v5.Stroke.Thick
				})
			}
			table.insert(children, createElement(image, v12, children2))
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
	local v10 = {
		Size = UDim2.fromOffset(v7, union.avatarSize),
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		testId = 0
	}

	local v11 = if union.layoutOrder then union.layoutOrder else nil
	v10.LayoutOrder = v11
	v10.testId = union.testId
	return createElement(view, v10, { v8 })
end

return LUAUFORGE_MODULE_GLOBALS_hjt_HorizontalFacepileGroup

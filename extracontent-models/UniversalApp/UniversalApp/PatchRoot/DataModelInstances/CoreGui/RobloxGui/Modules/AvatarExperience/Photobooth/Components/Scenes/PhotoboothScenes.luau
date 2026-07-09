local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Grid = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).GridComponents.Grid
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(Modules.AvatarExperience.Photobooth.Components.Scenes.usePhotoboothScenesProps)

local function PhotoboothScenes(p1) -- line: 14
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy), Grid (copy)
	local v9 = useLocalization({
		Scenes = "Feature.Avatar.Label.Scenes"
	})
	local v10 = React.useMemo(function() -- line: 19
		-- upvalues: p1 (copy)
		local t1 = {}

		for _, v13 in p1.scenes do
			table.insert(t1, v13)
		end

		table.sort(t1, function(p2, p3) -- line: 24
			return p2.order < p3.order
		end)

		return t1
	end, { p1.scenes })

	return React.createElement(Foundation.View, {
		tag = "col gap-small",
		backgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = p1.position,
		onAbsoluteSizeChanged = p1.onContainerSizeChanged
	}, {
		Heading = React.createElement(Foundation.Text, {
			tag = "text-color-primary text-heading-medium text-align-x-left text-align-y-top auto-xy",
			LayoutOrder = 1,
			Text = v9.Scenes
		}),
		ScrollViewContainer = React.createElement(Foundation.View, {
			tag = "grow-1 size-full-0",
			LayoutOrder = 2
		}, {
			ScenesScrollContainer = React.createElement("ScrollingFrame", {
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			}, {
				ScenesGrid = React.createElement(Grid, {
					Size = UDim2.new(1, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					items = v10,
					itemsPerRow = p1.itemsPerRow,
					renderItem = p1.renderSceneItem,
					getItemId = p1.getSceneId,
					gapVertical = p1.tokens.Gap.Medium,
					gapHorizontal = p1.tokens.Gap.Medium
				})
			})
		})
	})
end

return PhotoboothScenes

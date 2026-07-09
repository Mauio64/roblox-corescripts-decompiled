local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local photoboothCategories = require(Modules.AvatarExperience.Photobooth.photoboothCategories)
local PhotoboothCategories = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).Enums.PhotoboothCategories
local CustomPill = require(Modules.AvatarExperience.Photobooth.Components.Animations.CustomPill)
local t1 = {
	PhotoboothCategories.All,
	PhotoboothCategories.Emotes,
	PhotoboothCategories.Idle,
	PhotoboothCategories.Walk,
	PhotoboothCategories.Run,
	PhotoboothCategories.Jump,
	PhotoboothCategories.Fall,
	PhotoboothCategories.Climb,
	PhotoboothCategories.Swim
}

local function PhotoboothAnimationsPillBar(t2: {[any]: any}) -- line: 32
	-- upvalues: t1 (copy), photoboothCategories (copy), useLocalization (copy), React (copy), CustomPill (copy)
	local animationFilter = t2.animationFilter
	local onAnimationFilterChanged = t2.onAnimationFilterChanged
	local t3 = {}

	for _, v15 in t1 do
		local v16 = photoboothCategories[v15]

		if v16 then
			t3[v16.NavigationKey] = v16.Title
		end
	end

	local v17 = useLocalization(t3)
	local v18 = React.useMemo(function() -- line: 47
		-- upvalues: React (copy), t2 (copy), t1 (copy), photoboothCategories (copy), CustomPill (copy), v17 (copy), animationFilter (copy), onAnimationFilterChanged (copy)
		local t4 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, t2.tokens.Padding.Small)
			})
		}

		for v20, v21 in t1 do
			local v22 = photoboothCategories[v21]

			if v22 then
				t4[`Chip{ v21 }`] = React.createElement(CustomPill, {
					text = v17[v22.NavigationKey],
					isChecked = animationFilter == v22.NavigationKey,
					onActivated = function() -- line: 63
						-- upvalues: onAnimationFilterChanged (copy), v22 (copy)
						onAnimationFilterChanged(v22.NavigationKey)
					end,
					LayoutOrder = v20
				})
			end
		end

		return t4
	end, {
		animationFilter,
		v17,
		t2.tokens
	})

	return React.createElement("ScrollingFrame", {
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ScrollingDirection = Enum.ScrollingDirection.X,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		VerticalScrollBarInset = Enum.ScrollBarInset.None
	}, v18)
end

return PhotoboothAnimationsPillBar

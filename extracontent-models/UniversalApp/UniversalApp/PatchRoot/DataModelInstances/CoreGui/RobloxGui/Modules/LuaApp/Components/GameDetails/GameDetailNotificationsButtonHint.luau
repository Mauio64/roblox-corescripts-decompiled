local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local withTooltip = require(CorePackages.Packages.UIBlox).App.Dialog.TooltipV2.withTooltip
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: useLocalization (copy), CoreGui (copy), withTooltip (copy), React (copy)
	local isActive = t1.isActive
	local preferredOrientation = t1.preferredOrientation
	local v9 = useLocalization({
		TooltipText = "Feature.GameFollows.TooltipNotificationsButtonDescription"
	})
	local t2 = {
		DisplayOrder = 1,
		active = isActive,
		guiTarget = CoreGui,
		preferredOrientation = preferredOrientation
	}
	local t3 = {
		useLargeDropShadow = false,
		bodyText = v9.TooltipText,
		textAlignment = Enum.TextXAlignment.Left
	}

	return withTooltip(t3, t2, function(p1) -- line: 36
		-- upvalues: t1 (copy), React (copy)
		local function v13(p2) -- line: 37
			-- upvalues: t1 (copy), p1 (copy)
			if t1.onPositionChanged then
				t1.onPositionChanged(p2)
			end

			p1(p2)
		end

		return React.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsolutePosition] = v13,
			[React.Change.AbsoluteSize] = v13
		})
	end)
end

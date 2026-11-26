local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

return function(data)
	local v6 = {
		active = data.isActive,
		guiTarget = CoreGui,
		DisplayOrder = 1,
		preferredOrientation = data.preferredOrientation
	}
	return withTooltip({
		bodyText = useLocalization({
			TooltipText = "Feature.GameFollows.TooltipNotificationsButtonDescription"
		}).TooltipText,
		textAlignment = Enum.TextXAlignment.Left,
		useLargeDropShadow = false
	}, v6, function(callback)
		local function fn(p2)
			if data.onPositionChanged then
				data.onPositionChanged(p2)
			end

			callback(p2)
		end

		return React.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsolutePosition] = fn,
			[React.Change.AbsoluteSize] = fn
		})
	end)
end

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Localization = require(CorePackages.Workspace.Packages.Localization)

local parent = script.Parent.Parent
local shouldShowMoreSettingsBanner = require(parent.shouldShowMoreSettingsBanner)

local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View

local function MoreSettingsBanner(p)
	local isPioneerLaunch = p.isPioneerLaunch
	local getAvailability = p.getAvailability
	local state, setState = React.useState(false)
	local v = useLocalization({ text = "CoreScripts.InGameMenu.GameSettings.MoreSettingsAvailable" })

	local v2 = useTokens()

	React.useEffect(function()
		local v3 = false

		task.spawn(function()
			local v4 = shouldShowMoreSettingsBanner(isPioneerLaunch, getAvailability)

			if not v3 and v4 then
				setState(true)
			end
		end)

		return function()
			v3 = true
		end
	end, { isPioneerLaunch, getAvailability })

	if state and v.text ~= "" then
		return React.createElement(View, {
			tag = "size-full-0 auto-y",
			padding = {
				left = UDim.new(0, 10),
				right = UDim.new(0, 10),
				bottom = UDim.new(0, v2.Padding.Large)
			}
		}, {
			Banner = React.createElement(
				View,
				{
					tag = "row align-y-center gap-small size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium",
					testId = "MoreSettingsBanner"
				},
				{
					Icon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.CircleI,
						size = IconSize.Small
					}),
					Label = React.createElement(Text, {
						LayoutOrder = 2,
						Text = v.text,
						tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-default",
						testId = "MoreSettingsAvailableText"
					})
				}
			)
		})
	end

	return nil
end

return MoreSettingsBanner

local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = ColorMode.Dark

local Promise = require(CorePackages.Packages.Promise)

local SelfViewTooltipFTUX = require(script.Parent.SelfViewTooltipFTUX)

return function(props)
	local selfViewTooltipOnOpenGui = Instance.new("ScreenGui")
	selfViewTooltipOnOpenGui.Name = "SelfViewTooltipOnOpenGui"
	selfViewTooltipOnOpenGui.DisplayOrder = -1
	selfViewTooltipOnOpenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	selfViewTooltipOnOpenGui.Parent = CoreGui

	local element = Roact.createElement(AppStyleProvider, {
		style = { themeName = Dark }
	}, {
		frame = Roact.createElement("Frame", {
			Position = props.position,
			Size = props.size,
			BackgroundTransparency = 0,
			AnchorPoint = props.anchorPoint,
			Visible = false
		}, {
			aspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = props.aspectRatio,
				AspectType = "ScaleWithParentSize",
				DominantAxis = "Width"
			}),
			sizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = props.maxSize,
				MinSize = props.minSize
			}),
			bottomButtonsMock = Roact.createElement(
				"Frame",
				{
					Position = props.bottomButtonsFramePosition,
					Size = props.bottomButtonsFrameSize,
					Visible = false,
					BackgroundTransparency = 0
				},
				{
					tooltip = Roact.createElement(SelfViewTooltipFTUX, {
						fallbackText = props.fallbackText,
						translationKey = props.translationKey,
						tooltipLifetime = props.tooltipLifetime
					})
				}
			)
		})
	})

	local instance = Roact.mount(element, selfViewTooltipOnOpenGui, "SelfViewTooltipOnOpenGui")

	local function fn() -- 1 equivalent call inferred from this helper
		pcall(function()
			Roact.unmount(instance)
		end)
	end
	Promise.delay(props.tooltipLifetime + 5):andThen(function()
		fn() -- inferred equivalent call
	end)

	return { instance = instance, unmount = fn }
end

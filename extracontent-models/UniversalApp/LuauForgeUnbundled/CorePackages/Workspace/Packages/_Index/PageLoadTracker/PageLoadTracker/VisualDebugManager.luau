local TweenService = game:GetService("TweenService")
local PageLoadConfig = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadConfig")

local class = {}
class.__index = class

local function getRandomHighlightColor()
	local v5 = math.random() * 0.6 + 0.4
	local v6 = math.random() * 0.6 + 0.4
	local v7 = math.random() * 0.6 + 0.4
	return Color3.new(v5, v6, v7)
end

function class.new()
	local v5 = { originalProperties = {} }

	setmetatable(v5, class)
	return v5
end

function class:highlightComponent(instance)
	if
		self.originalProperties[instance]
		or instance.BackgroundColor3 == PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_COLOR
	then
		return
	end

	local backgroundColor3 = instance.BackgroundColor3
	local backgroundTransparency = instance.BackgroundTransparency
	local borderColor3 = instance.BorderColor3
	local borderSizePixel = instance.BorderSizePixel

	self.originalProperties[instance] = {
		backgroundColor = backgroundColor3,
		backgroundTransparency = backgroundTransparency,
		borderColor = borderColor3,
		borderSize = borderSizePixel
	}

	instance.BackgroundColor3 = PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_COLOR or getRandomHighlightColor()

	if backgroundTransparency >= 0.95 then
		instance.BackgroundTransparency = 0.5
	else
		instance.BackgroundTransparency = math.max(
			0.3,
			backgroundTransparency - PageLoadConfig.VISUAL_DEBUG.TRANSPARENCY_REDUCTION
		)
	end

	instance.BorderColor3 = PageLoadConfig.VISUAL_DEBUG.BORDER_COLOR
	instance.BorderSizePixel = math.max(PageLoadConfig.VISUAL_DEBUG.MIN_BORDER_SIZE, borderSizePixel)

	task.delay(PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_DURATION, function()
		if instance.Parent and self.originalProperties[instance] then
			local originalProperty = self.originalProperties[instance]

			local tween = TweenService:Create(
				instance,
				TweenInfo.new(
					PageLoadConfig.VISUAL_DEBUG.FADE_DURATION,
					Enum.EasingStyle.Quart,
					Enum.EasingDirection.Out
				),
				{
					BackgroundColor3 = PageLoadConfig.VISUAL_DEBUG.END_COLOR,
					BackgroundTransparency = originalProperty.backgroundTransparency * 0.9,
					BorderSizePixel = originalProperty.borderSize
				}
			)

			tween.Completed:Connect(function()
				self.originalProperties[instance] = nil
			end)

			tween:Play()
		end
	end)
end

function class:clearAllHighlights()
	for k, originalProperty in self.originalProperties do
		if not k.Parent then
			continue
		end

		k.BackgroundColor3 = originalProperty.backgroundColor
		k.BackgroundTransparency = originalProperty.backgroundTransparency
		k.BorderColor3 = originalProperty.borderColor
		k.BorderSizePixel = originalProperty.borderSize
	end

	self.originalProperties = {}
end

function class:destroy()
	self:clearAllHighlights()
end

return class

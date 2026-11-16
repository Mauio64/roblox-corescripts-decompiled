local TweenService = game:GetService("TweenService")
local PageLoadConfig = require(script.Parent.PageLoadConfig)

local VisualDebugManager = {}
VisualDebugManager.__index = VisualDebugManager

local function getRandomHighlightColor()
	local v = math.random() * 0.6 + 0.4
	local v2 = math.random() * 0.6 + 0.4
	local v3 = math.random() * 0.6 + 0.4
	return Color3.new(v, v2, v3)
end

function VisualDebugManager.new()
	local v = { originalProperties = {} }

	setmetatable(v, VisualDebugManager)
	return v
end

function VisualDebugManager.highlightComponent(p, instance)
	if p.originalProperties[instance] or instance.BackgroundColor3 == PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_COLOR then
		return
	end

	local backgroundColor3 = instance.BackgroundColor3
	local backgroundTransparency = instance.BackgroundTransparency
	local borderColor3 = instance.BorderColor3
	local borderSizePixel = instance.BorderSizePixel

	p.originalProperties[instance] = {
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
		if instance.Parent and p.originalProperties[instance] then
			local originalProperty = p.originalProperties[instance]

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
				p.originalProperties[instance] = nil
			end)

			tween:Play()
		end
	end)
end

function VisualDebugManager:clearAllHighlights()
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

function VisualDebugManager:destroy()
	self:clearAllHighlights()
end

return VisualDebugManager

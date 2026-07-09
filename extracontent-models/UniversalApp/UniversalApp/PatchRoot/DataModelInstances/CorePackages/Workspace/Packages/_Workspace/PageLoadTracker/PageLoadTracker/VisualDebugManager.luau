local TweenService = game:GetService("TweenService")
local PageLoadConfig = require(script.Parent.PageLoadConfig)
local t1 = {}

t1.__index = t1

local function getRandomHighlightColor() -- line: 8
	local v5 = math.random() * 0.6 + 0.4
	local v6 = math.random() * 0.6 + 0.4
	local v7 = math.random() * 0.6 + 0.4

	return Color3.new(v5, v6, v7)
end

function t1.new() -- line: 15
	-- upvalues: t1 (copy)
	local t2 = {
		originalProperties = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.highlightComponent(t3: {[any]: any}, p1) -- line: 30
	-- upvalues: PageLoadConfig (copy), getRandomHighlightColor (copy), TweenService (copy)
	if t3.originalProperties[p1] then
		return
	end

	if p1.BackgroundColor3 == PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_COLOR then
		return
	end

	local p1BackgroundColor3 = p1.BackgroundColor3
	local p1BackgroundTransparency = p1.BackgroundTransparency
	local p1BorderColor3 = p1.BorderColor3
	local BorderSizePixel = p1.BorderSizePixel

	t3.originalProperties[p1] = {
		backgroundColor = p1BackgroundColor3,
		backgroundTransparency = p1BackgroundTransparency,
		borderColor = p1BorderColor3,
		borderSize = BorderSizePixel
	}
	p1.BackgroundColor3 = PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_COLOR or getRandomHighlightColor()

	if p1BackgroundTransparency >= 0.95 then
		p1.BackgroundTransparency = 0.5
	else
		p1.BackgroundTransparency = math.max(0.3, p1BackgroundTransparency - PageLoadConfig.VISUAL_DEBUG.TRANSPARENCY_REDUCTION)
	end

	p1.BorderColor3 = PageLoadConfig.VISUAL_DEBUG.BORDER_COLOR
	p1.BorderSizePixel = math.max(PageLoadConfig.VISUAL_DEBUG.MIN_BORDER_SIZE, BorderSizePixel)
	task.delay(PageLoadConfig.VISUAL_DEBUG.HIGHLIGHT_DURATION, function() -- line: 61
		-- upvalues: p1 (copy), t3 (copy), PageLoadConfig (copy), TweenService (copy)
		if p1.Parent and t3.originalProperties[p1] then
			local v19 = t3.originalProperties[p1]
			local tweenInfo = TweenInfo.new(PageLoadConfig.VISUAL_DEBUG.FADE_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local tween = TweenService:Create(p1, tweenInfo, {
				BackgroundColor3 = PageLoadConfig.VISUAL_DEBUG.END_COLOR,
				BackgroundTransparency = v19.backgroundTransparency * 0.9,
				BorderSizePixel = v19.borderSize
			})

			tween.Completed:Connect(function() -- line: 76
				-- upvalues: t3 (copy), p1 (copy)
				t3.originalProperties[p1] = nil
			end)
			tween:Play()
		end
	end)
end
function t1.clearAllHighlights(p2) -- line: 85
	for v16, v17 in p2.originalProperties do
		if v16.Parent then
			v16.BackgroundColor3 = v17.backgroundColor
			v16.BackgroundTransparency = v17.backgroundTransparency
			v16.BorderColor3 = v17.borderColor
			v16.BorderSizePixel = v17.borderSize
		end
	end

	p2.originalProperties = {}
end
function t1.destroy(p3) -- line: 97
	p3:clearAllHighlights()
end

return t1

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local TweenService = game:GetService("TweenService")
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
local t1 = {}

t1.__index = t1

local t2 = {
	PrimaryButton = function(p1) -- line: 16
		-- upvalues: Create (copy), Constants (copy)
		return Create("ImageLabel")({
			Name = "ShimmerFrame",
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			Visible = false,
			Parent = p1,
			ZIndex = 8,
			Create("ImageLabel")({
				Name = "Shimmer",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 8,
				Size = UDim2.new(1, 0, 2, 0),
				Position = UDim2.new(-1, 0, 0, 0),
				Image = Constants.SHIMMER_TEXTURE
			}),
			Create("ImageLabel")({
				Name = "ShimmerOverlay",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 9,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				ImageColor3 = Constants.COLORS.FLINT,
				Image = Constants.OVERLAY_TEXTURE,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end
}

function t1.new(p2, p3) -- line: 51
	-- upvalues: t2 (copy), t1 (copy), TweenService (copy), tweenInfo (copy)
	if not p3 or not t2[p3] then
		return
	end

	local self = setmetatable({}, t1)

	self._shimmer = t2[p3](p2)
	self._shimmerAnimation = TweenService:Create(self._shimmer.Shimmer, tweenInfo, {
		Position = UDim2.new(1, 0, 0, 0)
	})

	return self
end
function t1.play(p4) -- line: 61
	p4._shimmer.Visible = true
	p4._shimmerAnimation:Play()
end
function t1.stop(p5) -- line: 66
	p5._shimmerAnimation:Cancel()
	p5._shimmer.Visible = false
end

return t1

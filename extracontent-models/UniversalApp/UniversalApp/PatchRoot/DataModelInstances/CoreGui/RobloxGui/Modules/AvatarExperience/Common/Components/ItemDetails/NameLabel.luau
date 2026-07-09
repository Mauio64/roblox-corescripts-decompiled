local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local v15 = Images["icons/status/premium_small"]

local function NameLabel(t1: {[any]: any}) -- line: 37
	-- upvalues: useStyle (copy), React (copy), IconSize (copy), Roact (copy), FitFrameVertical (copy), IsVRAppBuild (copy), FitTextLabel (copy), ImageSetLabel (copy), v15 (copy), Skeleton (copy)
	local v18 = useStyle()
	local Theme = v18.Theme
	local Font = v18.Font
	local v21, v22 = React.createBinding(false)
	local Small = IconSize.Small
	local v24 = t1.name or ""
	local Header1Font = Font.Header1.Font
	local v26 = Font.BaseSize * Font.Header1.RelativeSize
	local showPremiumBenefits = t1.showPremiumBenefits

	return Roact.createElement(FitFrameVertical, {
		width = UDim.new(1, 0),
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		[Roact.Change.AbsolutePosition] = function(p1) -- line: 49
			-- upvalues: t1 (copy), v22 (copy)
			if not t1.actionBarHeaderRef then
				return
			end

			local current = t1.actionBarHeaderRef.current

			if not current then
				return
			end

			local v30 = current.AbsolutePosition.Y > p1.AbsolutePosition.Y

			current.Visible = not v30
			v22(v30)
		end
	}, {
		TextLabel = if not IsVRAppBuild() then if not v24 then Roact.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v26)
		}) else Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			width = UDim.new(1, 0),
			Visible = v21,
			Font = Header1Font,
			Text = v24,
			TextSize = v26,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextEmphasis.Color
		}, {
			PremiumIcon = if not showPremiumBenefits then nil else Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 5),
				Size = UDim2.new(0, Small, 0, Small),
				ScaleType = Enum.ScaleType.Fit,
				Image = v15,
				ImageColor3 = Theme.IconEmphasis.Color,
				ImageTransparency = Theme.IconEmphasis.Transparency
			})
		}) else nil,
		RefUpdater = Roact.createElement("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			[Roact.Ref] = function(p2) -- line: 125
				-- upvalues: t1 (copy), v22 (copy)
				if p2 and p2.Parent then
					local p2Parent = p2.Parent

					if not t1.actionBarHeaderRef then
						return
					end

					local current = t1.actionBarHeaderRef.current

					if not current then
						return
					end

					local v34 = current.AbsolutePosition.Y > p2Parent.AbsolutePosition.Y

					current.Visible = not v34
					v22(v34)
				end
			end
		})
	})
end

return NameLabel

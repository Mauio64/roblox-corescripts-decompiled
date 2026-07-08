local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = UIBlox.App.Style.Constants.ThemeName.Dark
local Promise = require(CorePackages.Packages.Promise)
local SelfViewTooltipFTUX = require(script.Parent.SelfViewTooltipFTUX)

return function(p1) -- line: 13
	-- upvalues: CoreGui (copy), Roact (copy), AppStyleProvider (copy), Dark (copy), SelfViewTooltipFTUX (copy), Promise (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "SelfViewTooltipOnOpenGui"
	ScreenGui.DisplayOrder = -1
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v11 = Roact.createElement(AppStyleProvider, {
		style = {
			themeName = Dark
		}
	}, {
		frame = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			Visible = false,
			Position = p1.position,
			Size = p1.size,
			AnchorPoint = p1.anchorPoint
		}, {
			aspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectType = "ScaleWithParentSize",
				DominantAxis = "Width",
				AspectRatio = p1.aspectRatio
			}),
			sizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = p1.maxSize,
				MinSize = p1.minSize
			}),
			bottomButtonsMock = Roact.createElement("Frame", {
				Visible = false,
				BackgroundTransparency = 0,
				Position = p1.bottomButtonsFramePosition,
				Size = p1.bottomButtonsFrameSize
			}, {
				tooltip = Roact.createElement(SelfViewTooltipFTUX, {
					fallbackText = p1.fallbackText,
					translationKey = p1.translationKey,
					tooltipLifetime = p1.tooltipLifetime
				})
			})
		})
	})
	local v12 = Roact.mount(v11, ScreenGui, "SelfViewTooltipOnOpenGui")

	Promise.delay(p1.tooltipLifetime + 5):andThen(function() -- line: 62
		-- upvalues: Roact (copy), v12 (copy)
		pcall(function() -- line: 58
			-- upvalues: Roact (copy), v12 (copy)
			Roact.unmount(v12)
		end)
	end)

	return {
		instance = v12,
		unmount = function() -- line: 57
			-- upvalues: Roact (copy), v12 (copy)
			pcall(function() -- line: 58
				-- upvalues: Roact (copy), v12 (copy)
				Roact.unmount(v12)
			end)
		end
	}
end

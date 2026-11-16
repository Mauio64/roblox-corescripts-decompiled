local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local view = Foundation.View

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local useChromeRatio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useChromeRatio")

local FFlagMomentsImmersiveHeaderFadeOut = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsImmersiveHeaderFadeOut")

local function ImmersiveHeaderChrome(p2)
	local v5 = useChromeRatio()

	local v6 = FFlagMomentsImmersiveHeaderFadeOut

	local state, setState = React.useState(function()
		return v6 and v5:getValue() < 1
	end)

	React.useEffect(function()
		if not v6 then
			return
		end

		local function applyRatio(p3)
			local v8 = p3 < 1
			setState(function(p4)
				if p4 == v8 then
					return p4
				end

				return v8
			end)
		end

		local v8 = v5:getValue() < 1
		setState(function(p3)
			if p3 == v8 then
				return p3
			end

			return v8
		end)

		return React.__subscribeToBinding(v5, applyRatio)
	end, { v5, v6 })

	local v8, v9 = React.useBinding(0)
	local v10 = React.useCallback(function(p3)
		v9(p3.AbsoluteSize.Y)
	end, {})

	local mapped = React.joinBindings({ ratio = v5, height = v8 }):map(function(p3)
		return UDim2.new(0, 0, 0, (p3.ratio - 1) * p3.height)
	end)

	local v11 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p2.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Interactable = v5:map(function(p3): boolean
			return p3 > 0.01
		end),
		ZIndex = Constants.DisplayOrder.FeedTopBar,
		[React.Tag] = "data-testid=--moments-immersive-header-chrome"
	}

	if not FFlagMomentsImmersiveHeaderFadeOut then
		v11.Position = mapped
		v11[React.Change.AbsoluteSize] = v10
	end

	local v12

	if v6 and state then
		v11.GroupTransparency = v5:map(function(p3)
			return 1 - p3
		end)
		v12 = "CanvasGroup"
	else
		v12 = "Frame"
	end

	return React.createElement(v12, v11, {
		Header = React.createElement(view, { tag = "size-full-0 auto-y" }, p2.children)
	})
end

return ImmersiveHeaderChrome

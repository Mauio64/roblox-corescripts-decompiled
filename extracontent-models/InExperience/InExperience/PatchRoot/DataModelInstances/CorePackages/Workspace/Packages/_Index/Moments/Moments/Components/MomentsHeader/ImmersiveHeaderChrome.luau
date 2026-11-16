local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local Constants = require(Moments.Constants)
local useChromeRatio = require(Moments.Hooks.useChromeRatio)

local FFlagMomentsImmersiveHeaderFadeOut = require(Moments.Flags.FFlagMomentsImmersiveHeaderFadeOut)

local function ImmersiveHeaderChrome(p)
	local ratio = useChromeRatio()

	local v = FFlagMomentsImmersiveHeaderFadeOut

	local state, setState = React.useState(function()
		return v and ratio:getValue() < 1
	end)

	React.useEffect(function()
		if not v then
			return
		end

		local function applyRatio(p2: number) -- 1 equivalent call inferred from this helper
			local v2 = p2 < 1
			setState(function(flag: boolean)
				return if flag == v2 then flag else v2
			end)
		end

		applyRatio(ratio:getValue()) -- inferred equivalent call
		return React.__subscribeToBinding(ratio, applyRatio)
	end, { ratio, v })

	local height, v2 = React.useBinding(0)
	local v3 = React.useCallback(function(p2)
		v2(p2.AbsoluteSize.Y)
	end, {})

	local mapped = React.joinBindings({ ratio = ratio, height = height }):map(function(p2)
		return UDim2.new(0, 0, 0, (p2.ratio - 1) * p2.height)
	end)

	local v4 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Interactable = ratio:map(function(p2: number): boolean
			return p2 > 0.01
		end),
		ZIndex = Constants.DisplayOrder.FeedTopBar,
		[React.Tag] = "data-testid=--moments-immersive-header-chrome"
	}

	if not FFlagMomentsImmersiveHeaderFadeOut then
		v4.Position = mapped
		v4[React.Change.AbsoluteSize] = v3
	end

	local v5

	if v and state then
		v4.GroupTransparency = ratio:map(function(p2: number)
			return 1 - p2
		end)
		v5 = "CanvasGroup"
	else
		v5 = "Frame"
	end

	return React.createElement(v5, v4, {
		Header = React.createElement(View, { tag = "size-full-0 auto-y" }, p.children)
	})
end

return ImmersiveHeaderChrome

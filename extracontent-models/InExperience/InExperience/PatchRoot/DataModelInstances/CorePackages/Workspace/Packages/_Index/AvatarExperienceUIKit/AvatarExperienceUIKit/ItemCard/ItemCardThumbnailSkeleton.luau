local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local usePulseBinding = Foundation.Hooks.usePulseBinding
local useTokens = Foundation.Hooks.useTokens
local withCommonProps = Foundation.Utility.withCommonProps
local withDefaults = Foundation.Utility.withDefaults

local function lerp(n1: number, n2: number, n3: number) -- line: 28
	return (1 - n3) * n1 + n2 * n3
end

local t1 = {
	testId = "--foundation-skeleton",
	radius = EnumsRadius.None,
	Size = UDim2.fromScale(1, 1)
}

local function ItemCardThumbnailSkeleton(p1, p2) -- line: 43
	-- upvalues: withDefaults (copy), t1 (copy), usePulseBinding (copy), useTokens (copy), EnumsRadius (copy), React (copy), View (copy), withCommonProps (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = usePulseBinding(2)
	local v20 = useTokens()
	local v21 = if v18.radius == EnumsRadius.None then nil else UDim.new(0, v20.Radius[v18.radius])

	return React.createElement(View, withCommonProps(v18, {
		cornerRadius = v21,
		backgroundStyle = v19:map(function(n4: number) -- line: 54
			-- upvalues: v20 (copy)
			local t2 = {
				Color3 = v20.Color.Shift.Shift_300.Color3
			}
			local White_10Transparency = v20.Color.Extended.White.White_10.Transparency
			local v25 = v20.Color.Extended.White.White_10.Transparency - 0.1

			t2.Transparency = (1 - n4) * White_10Transparency + v25 * n4

			return t2
		end),
		Size = v18.Size,
		ref = p2
	}))
end

return React.memo(React.forwardRef(ItemCardThumbnailSkeleton))
